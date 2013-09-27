using System;
using System.Web;
using System.Web.Caching;
using System.Net;
using System.Configuration;
using System.IO;
using System.Collections.Generic;
using System.Diagnostics;


/*
 * HttpBL - implements Project Honeypot [1] web filtering to help rejecting
 *          request coming from "bad" IPs (comment spammers, harvesters...)
 *          to filter such requests the code uses the Http:BL API [2] which
 *          basically works like a regular DNS blacklist; if the requesting
 *          IP is listed, it's considered bad and the request is either dropped
 *          or redirected to a configurable URL
 * 
 * setup    to setup this module, see the "setup.txt" file included into the
 *          distribution file; basically you'll need to copy the DLL to your
 *          site "bin" folder and edit your web.config to add the needed entries
 *          note that to use the module you will NEED to obtain a VALID Http:BL
 *          key from project honeypot (it's free)
 *          
 * notes    kudos to Chris Crowther (aka "shad0w") for his Http:BL.NET [3] project
 *          which inspired me to put together this code; I used Chris code as some
 *          kind of foundation to rebuild my own version and (possibly) improve the
 *          code a little bit
 * 
 * [1] http://www.projecthoneypot.org/
 * [2] http://www.projecthoneypot.org/httpbl_api.php
 * [3] http://sourceforge.net/projects/httpbl-net/
 * 
 * Todo:    add regexp and/or CIDR support to the allow/deny lists
 * 
 */

namespace HttpBL
{
    // reference: System.Web
    public class HttpBL : IHttpModule
    {
        #region "privatedata"
        // constants
        private const string    _my_name = "HttpBL";
        private const string    _no_ip = "0.0.0.0";
        private const string    _black_ip = "127.1.255.255";
        private const string    _lookup_url = "http://www.projecthoneypot.org/ipr_";

        // various settings
        private Settings        _config = null;                 // web.config reader
        private HttpContext     _context = null;                // current HTTP context
        private string          _hostname = "*";                // hostheader (from request)
        private string          _client = _no_ip;               // client IP
        private string          _result = _no_ip;               // client IP lookup result
        private Cache           _cache = HttpRuntime.Cache;     // system cache
        private List<string>    _ipAllow = null;                // always allowed IP list
        private List<string>    _ipDeny = null;                 // always denied IP list
        private bool            _isDenied = false;              // true: IP denied by list
        private string          _logLine = null;                // bad IP log record

        // internal stuff
        private bool            _disposed = false;              // true - already disposed
        private string          _instance_ID = null;            // instance "ID"
        #endregion

        #region "instance"
        // instantiates the class
        public HttpBL()
        {
            initInstance();
        }

        // needed by the Http Module
        public void Dispose()
        {
            if (this._disposed) return;
            this._disposed = true;
            LogMisc(string.Format("{0} module disposed.", _my_name));

            //this._ipAllow = null;
            //this._ipDeny = null;
            //this._cache = null;
            //this._config = null;
            //this._context = null;
        }
        #endregion

        #region "IHttpModule"
        // links to the HTTP module to intercept requests
        // initializes the context
        public void Init(HttpApplication context)
        {
            context.BeginRequest += new EventHandler(context_BeginRequest);
        }

        // handles the request
        void context_BeginRequest(object sender, EventArgs e)
        {
            // if filtering is disabled, just return
            if (!this._config.Enabled) return;

            try
            {
                // get a reference to app and context
                HttpApplication application = (HttpApplication)sender;
                this._context = application.Context;
                this._hostname = this._context.Request.ServerVariables["SERVER_NAME"];
                this._client = this._context.Request.UserHostAddress;

                // sets the request context used for path mapping
                this._config.iisContext = this._context;

                // is redirection enabled ?
                if ((this._config.RedirectOnHit) && (!String.IsNullOrEmpty(this._config.RedirectURL)))
                {
                    // if (0 == String.Compare(this._context.Request.FilePath, this._config.RedirectURL, true))
                    string[] urlComp = this._config.RedirectURL.Split('?');
                    if (this._context.Request.FilePath.Contains(urlComp[0]))
                    {
                        return;
                    }
                }

                // no redirection, check if the IP is blacklisted
                if (IsBlackListed(this._client))
                {
                    // now emit the HTTP response and terminate the request
                    EmitResponse();
                    this._context.Response.End();
                }
                else
                {
                    // just add our header to show we're running
                    AddModuleHeader();
                }
            }
            catch (System.Threading.ThreadAbortException)
            {
                // Response.End() creates a ThreadAbortException which we need to catch
                // and then do a Thread.ResetAbort().  No, I don't know why either.
                try
                {
                    //DbgWrite("BeginRequest::eThreadAbort (response.end): " + eThreadAbort.Message);
                    System.Threading.Thread.ResetAbort();
                }
                catch (Exception eX)
                {
                    LogMisc(string.Format("BeginRequest::Error: msg={0}, trace={1}", eX.Message, eX.StackTrace));
                }
            }
            catch (Exception ex)
            {
                LogMisc(string.Format("BeginRequest::Error: {0}", ex.Message));
            }

            // if the IP was listed, log it after the reject/redirect
            if (!String.IsNullOrEmpty(this._logLine))
                LogHit(this._logLine);
        }
        #endregion

        #region "privatecode"
        // adds an X-Header to the response to show that we're running
        private void AddModuleHeader()
        {
            try
            {
                string hdrName = string.Format("X-{0}", _my_name);
                string version = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString();
                string runtime = System.Reflection.Assembly.GetExecutingAssembly().ImageRuntimeVersion;
                string instID = this._instance_ID;
                string hdrValue = String.Format("{0}/{1} (NET {2}) ID=0x{3}", _my_name, version, runtime, instID);
                this._context.Response.AppendHeader(hdrName, hdrValue);
            }
            catch (Exception ex)
            {
                LogMisc(string.Format("AddModuleHeader::Error: {0}", ex.Message));
            }
        }

        // emits the HTTP response for a blacklisted host
        private void EmitResponse()
        {
            try
            {
                // out buffer
                string sResponse = "";

                // setup the response code and message
                this._context.Response.StatusCode = 403;
                this._context.Response.StatusDescription = "403.6 IP Address Rejected.";
                if (this._config.RedirectOnHit)
                {
                    // redirect the client as desired, start by filling up the
                    // optional parameters replacing the $IP and $RESULT macros
                    string sRedirURL = this._config.RedirectURL;
                    sRedirURL = sRedirURL.Replace("$IP", this._client);
                    sRedirURL = sRedirURL.Replace("$RESULT", this._result);
                    this._context.Response.AppendHeader("Refresh", "0; URL=" + sRedirURL);
                    sResponse = "<html><head></head><body></body></html>\n";
                }
                else
                {
                    // no redirect; emit the default "denied"  page
                    sResponse = "<html><head><title>403.6 IP Address Rejected.</title></head><body><center>" +
                                "<h1>403.6 IP Address Rejected.</h1><p>Access from " + this._client + 
                                " denied, IP is blacklisted due to bad behavior.</p>";
                                if (!this._isDenied) {
                                    // if not locally denied (deny list), add the reference URL
                                    sResponse = sResponse + "<p>See <a href='" + _lookup_url + reverseIP(this._client) + "'><b>HERE</b></a> for further information</p>";
                                }
                                sResponse = sResponse + "</center></body></html>\n";
                }
                // write response and flush the buffer
                this._context.Response.Write(sResponse);
                this._context.Response.Flush();
            }
            catch (Exception ex)
            {
                LogMisc(string.Format("EmitResponse::Error: {0}", ex.Message));
            }
        }
        
        // checks if a given IP is blacklisted or not
        private bool IsBlackListed(string sRemoteIP)
        {
            // init
            this._isDenied = false;

            // check if it's a regular IPv4 (we don't handle v6 - yet)
            if (!IsValidIP(sRemoteIP)) return false;
            
            // if it's a private IP, skip the check
            if (IsPrivateIP(sRemoteIP)) return false;

            // check if whitelisted (whitelist file)
            if (isIpListed(this._ipAllow, sRemoteIP)) return false;

            // check if blacklisted (blacklist file)
            if (isIpListed(this._ipDeny, sRemoteIP))
            {
                this._result = _black_ip;
                this._isDenied = true; // flag as "always denied"
                return false;
            }

            // check if cached
            string sResult = CacheGet(sRemoteIP);
            if (String.IsNullOrEmpty(sResult))
            {
                // not cached: run the DNS lookup
                sResult = DNSquery(sRemoteIP);
                if (String.IsNullOrEmpty(sResult))
                {
                    // if no result, set to "no address"
                    sResult = _no_ip;
                }
            }

            // save the result
            this._result = sResult;

            // check if the result indicates a "reject"
            bool bMustReject = MustReject(sResult);

            // IP is blacklisted, log it ?
            if ((bMustReject) && (this._config.LogHits))
                createIPrecord(sRemoteIP, sResult);

            // should the IP be cached ?
            if ((bMustReject) || (this._config.CacheWhite))
                CachePut(sRemoteIP, sResult);

            return bMustReject;
        }

        // returns true if the lookup result indicates
        // that the visiting IP must be rejected
        private bool MustReject(string sResult)
        {
            int nAge, nScore, nType;

            // no result ?
            if (string.IsNullOrEmpty(sResult)) return false;

            // parse the values
            try
            {
                // split the octets and check if all OK
                String[] octets = sResult.Split(new char[] { '.' }, 4);
                if (127 != int.Parse(octets[0])) return false;

                // decode the values
                nAge = int.Parse(octets[1]);
                nScore = int.Parse(octets[2]);
                nType = int.Parse(octets[3]);
            }
            catch (Exception ex)
            {
                // error !
                LogMisc(string.Format("MustReject::Error: {0}", ex.Message));
                nAge = nScore = nType = 0;
            }

            // checks if it's an harvester or a spammer, ignore the
            // search engine spiders and the suspicious only entries
            // willing to change the filtering logic, you'll need to
            // modify this portion of code
            if (((nType & 2) != 0) || ((nType & 4) != 0))
            {
                // now check the threat score and the entry age
                if ((nScore >= this._config.MaxScore) && (nAge <= this._config.MaxAge))
                    return true; // reject the IP
            }
            
            // don't reject
            return false;
        }

        // true is a valid IP (v4) address
        private bool IsValidIP(string sIpAddr)
        {
            IPAddress ip;

            if (string.IsNullOrEmpty(sIpAddr)) return false;
            if (!IPAddress.TryParse(sIpAddr, out ip)) return false;
            if (ip.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork) return true;
            return false;
        }

        // true if it is a private/reserved IP; for details, refer to
        // http://en.wikipedia.org/wiki/IPv4#Special-use_addresses
        private bool IsPrivateIP(string sIpAddr)
        {
            if (string.IsNullOrEmpty(sIpAddr)) return false;
            try
            {
                IPAddress ip = IPAddress.Parse(sIpAddr);
                byte[] addr = ip.GetAddressBytes();

                // 127.0.0.0/8 - localhost
                if (addr[0] == 127) return true;
                // 10.0.0.0/8 - RFC-1918
                if (addr[0] == 10) return true;
                // 192.0.2.0/24 RFC-5735
                if ((addr[0] == 192) && (addr[1] == 0) && (addr[2] == 2)) return true;
                // 192.168.0.0/16 - RFC-1918
                if ((addr[0] == 192) && (addr[1] == 168)) return true;
                // 169.254.0.0/16 - RFC-3927 (APIPA)
                if ((addr[0] == 169) && (addr[1] == 254)) return true;
                // 172.16.0.0/12 - RFC-1918
                if ((addr[0] == 172) && ((addr[1] > 15) && (addr[1] < 32))) return true;
            }
            catch (Exception ex)
            {
                LogMisc(string.Format("IsPrivateIP::Error: IP={0}, err={0}", sIpAddr, ex.Message));
            }

            // not a private IP
            return false;
        }
        
        // retrieves an IP from the cache
        private string CacheGet(string sIP)
        {
            if (0 == this._config.CacheTTL) return null;
            string sResult;
            try
            {
                sResult = (string)_cache[_my_name + "::" + sIP];
            }
            catch (Exception ex)
            {
                LogMisc(string.Format("CacheGet::Error: {0}", ex.Message));
                sResult = "";
            }
            return sResult;
        }

        // inserts an IP into the cache
        private void CachePut(string sIP, string sResult)
        {
            // check if cache enabled (TTL > 0)
            if (0 == this._config.CacheTTL) return;
            long lTTL = this._config.CacheTTL;
            
            // if TTL is "high enough" and IP isn't listed, set TTL=TTL/4
            // for "white" IPs, this avoids issuing too many requests to
            // the Http:BL for "regular" visitors and at the same time
            // to avoid filling up the cache with "good" IPs
            if ((sResult.Equals(_no_ip)) && (lTTL > 300))
                lTTL = (lTTL / 4);

            DbgWrite("Adding IP " + sIP + " with result " + sResult + " to cache (TTL=" + lTTL.ToString()+ ")");
            try
            {
                // note: the cache TTL is a dynamic one, this means that a given entry will
                // remain in cache for up to TTL seconds from the last time it was requested
                // this also means that an IP hammering the site will remain in cache for
                // quite a long time ... so sparing load to the Http:BL servers; for further
                // infos see http://msdn.microsoft.com/en-us/library/4y13wyk9.aspx
                _cache.Insert(_my_name + "::" + sIP, sResult, null, Cache.NoAbsoluteExpiration, TimeSpan.FromSeconds(lTTL));
            }
            catch (Exception ex)
            {
                LogMisc(string.Format("CachePut::Error: {0}", ex.Message));
            }
        }

        // runs the HttpBL DNS query and returs the resulting IP or null
        private string DNSquery(string sIP)
        {
            IPHostEntry entry = null;
            String hostQuery = this.BuildQuery(this._config.AccessKey, this.reverseIP(sIP), this._config.QueryDomain);

            try
            {
                entry = Dns.GetHostEntry(hostQuery);
            }
            catch
            {
                return null;
            }

            if ((null != entry) && (entry.AddressList.Length > 0))
            {
                // just consider the first entry
                return entry.AddressList[0].ToString();
            }
            return null;
        }

        // reverses an IPv4 address
        private String reverseIP(String dottedQuad)
        {
            try
            {
                String[] quads = dottedQuad.Split(".".ToCharArray(), 4);
                return this.BuildQuery(quads[3], quads[2], quads[1], quads[0]);
            }
            catch
            {
                return _no_ip;
            }
        }

        // builds a query string from components
        private String BuildQuery(params String[] args)
        {
            return String.Join(".", args);
        }

        // fills up a log record related to "bad IP"
        private void createIPrecord(string sIPaddr, string sResult)
        {
            try
            {
                string UA = this._context.Request.UserAgent;
                if (String.IsNullOrEmpty(UA)) UA = "none";
                string page = this._context.Request.Url.PathAndQuery;
                if (String.IsNullOrEmpty(page)) page = "none";
                string sBuff = string.Format("{0},{1},{2},{3}", sIPaddr, decodeResult(sResult), page, UA);
                this._logLine = sBuff;
                //LogMsg(sBuff); <-- log is written at end of "beginrequest"
            }
            catch (Exception ex)
            {
                LogMisc(string.Format("createIPrecord::Error: {0}", ex.Message));
            }
        }

        // decode the HttpBL result to a readable/parsable format
        private string decodeResult(string sResult)
        {
            int nAge, nScore, nType;
            string sType = "";

            // parse the values
            try
            {
                // split the octets
                String[] octets = sResult.Split(new char[] { '.' }, 4);

                nAge = int.Parse(octets[1]);        // days since last hit
                nScore = int.Parse(octets[2]);      // threat score
                nType = int.Parse(octets[3]);       // entry type (see below)
                
                if ((nType & 1) != 0) sType += "S"; // suspicious
                if ((nType & 2) != 0) sType += "H"; // harvester
                if ((nType & 4) != 0) sType += "C"; // comment spammer
                
                if (String.IsNullOrEmpty(sType)) sType = "none";
            }
            catch
            {
                nAge = nScore = nType = 0;
                sType = "none";
            }
            
            // returns a "combo" string containing age, score, type and type flags
            return nAge.ToString() + "," + nScore.ToString() + "," + nType.ToString() + "," + sType;
        }

        // logs misc messages
        private void LogMisc(string sMsg)
        {
            if (!this._config.Logging) return; 
            if (String.IsNullOrEmpty(this._config.LogPath)) return;
            string logName = this._config.LogPath + "\\" + _my_name + "-msgs-" + DateTime.UtcNow.ToString("MM") + ".log";
            // datetime,hostheader,instanceID,message
            string sBuff = string.Format("{0},{1}", this._instance_ID, sMsg);
            LogMsg(sBuff, logName);
        }

        // logs a blacklist hit
        private void LogHit(string sMsg)
        {
            if (!this._config.Logging) return;            
            if (String.IsNullOrEmpty(this._config.LogPath)) return;
            string logName = this._config.LogPath + "\\" + _my_name + "-hits-" + DateTime.UtcNow.ToString("MM") + ".log";
            // datetime,hostheader,IPaddress,age,score,type,flags,fullURL,UserAgent
            LogMsg(sMsg, logName);
        }

        /// <summary>
        /// logs a message to logfile and to debug; notice that the logfile
        /// is tagged with current month, so we'll have a max of 12 files
        /// at once; older (previous year) logfiles will be automatically
        /// deleted and overwritten as needed; this avoids the need to use
        /// a separate procedure to delete old files; such a procedure may
        /// still be needed in case we want to archive them; in such a case
        /// the procedure may be scheduled on the 1st of each month and
        /// archive the log from the previous month (on 1-1 it will archive
        /// the december log from previous year)
        /// </summary>
        /// <param name="sMsg">
        /// message to log
        /// </param>
        private void LogMsg(string sMsg, string logFileName)
        {
            // always logs to debug
            DbgWrite(sMsg);

            // check if logging is enabled
            if (!this._config.Logging) return;
            //if (String.IsNullOrEmpty(this._config.LogPath)) return;

            // builds the logfile name and check for file rotation
            string sLogFile = logFileName;
            if (string.IsNullOrEmpty(sLogFile)) return;
            rotateLog(sLogFile);
            
            // builds the log record buffer
            string sBuff = DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss.ffff") + "," + this._hostname;
            if (!string.IsNullOrEmpty(sMsg))
                sBuff = sBuff + "," + sMsg;
            else
                sBuff = sBuff + ",----";

            // writes to logfile (append)
            try
            {
                StreamWriter fp = new StreamWriter(sLogFile, true);
                fp.WriteLine(sBuff);
                fp.Flush();
                fp.Close();
            }
            catch (Exception ex)
            {
                DbgWrite("LogMsg::Error: file={0}, err={1}", sLogFile, ex.Message);
            }
        }

        // rotates (deletes) old logfiles; the code will check if the
        // given file is from "last year" and if so, will delete it so
        // that, writes will recreate it from scratch; notice that the
        // check is only performed on the 1st day of each month
        private void rotateLog(string pathName)
        {
            if (string.IsNullOrEmpty(pathName)) return;
            if (1 != DateTime.UtcNow.Day) return;
            try
            {
                if (File.Exists(pathName))
                {
                    FileInfo fi = new FileInfo(pathName);
                    if (fi.LastWriteTime.Year < DateTime.Now.Year)
                    {
                        // file is old, must be overwritten
                        File.Delete(pathName);
                    }
                }
            }
            catch (Exception ex)
            {
                DbgWrite("rotateLog::Error: file={0}, err={1}", pathName, ex.Message);
            }
        }

        // writes a line to the debug; to see this log from the compiled app
        // you may use the "DbgView" tool from SysInternals and configure it
        // to only intercept messages containing the "[HttpBL]" tag
        private void DbgWrite(string format, params object[] args)
        {
            // Debug.WriteLine("[" + _my_name + "]: " + sMsg);
            try
            {
                string msgBuff = string.Format(format, args);
                string outBuff = string.Format("[{0}]: {1}", _my_name, msgBuff);
                Trace.WriteLine(outBuff);
            }
            catch (Exception ex)
            {
                Trace.WriteLine(string.Format("DbgWrite::Error: {1}", ex.Message));
            }
        }

        /// <summary>
        /// loads a given IP white/black list file (an IP on each row)
        /// </summary>
        /// <param name="fileName">
        /// pathname of the file containing the IP list
        /// </param>
        /// <returns>
        /// the list of loaded IPs
        /// </returns>
        private List<string> readList(string fileName)
        {
            List<string> records = new List<string>();
            string strLine, strBuff;

            // if the filename is empty or null
            if (string.IsNullOrEmpty(fileName))
            {
                return records;
            }

            // try reading the file and populating the list
            try
            {
                using (StreamReader sr = new StreamReader(fileName))
                {
                    while ((strLine = sr.ReadLine()) != null)
                    {
                        // cleanup the buffer, skip empty lines
                        strBuff = strLine.Trim().ToLower();
                        if (!string.IsNullOrEmpty(strBuff)) {
                            // skip comment lines
                            if (!strBuff.StartsWith("#"))
                            {
                                // check/add entries
                                records.Add(strBuff);
                                
                                //if (IsValidIP(strBuff) && !IsPrivateIP(strBuff))
                                //{
                                //    records.Add(strBuff);
                                //}
                                //else
                                //{
                                //    LogMisc(string.Format("Invalid IP \"{0}\" in {1}", strBuff, fileName));
                                //}
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogMisc(string.Format("readList::Error: file={0}, err={1}", fileName, ex.Message));
                records.Clear();
            }

            // return the list
            return records;
        }

        /// <summary>
        /// checks if a given (partial) IP is contained into a list; notice that
        /// the match may be a partial one, so, if we have a visitor with the IP
        /// 192.0.2.100 and the list contains 192.0.2. the IP will match the list
        /// entry; same goes in case we have 192.0.2.240 and the list contains
        /// an entry like 192.0.2 in such a case all the IPs containing 192.0.2
        /// will match (it's like 192.0.2*)
        /// </summary>
        /// <param name="ipList">
        /// list of IPs against which check the given address
        /// </param>
        /// <param name="ipAddr">
        /// IP address to check
        /// </param>
        /// <returns>
        /// true if listed
        /// </returns>
        private bool isIpListed(List<string> ipList, string ipAddr)
        {
            try
            {
                if (null == ipList) return false;
                if (string.IsNullOrEmpty(ipAddr)) return false;
                foreach (string ip in ipList)
                {
                    if (!IsValidIP(ip))
                        if (ipAddr.StartsWith(ip)) return true;     // partial match
                    else
                        if (ipAddr.Equals(ip)) return true;         // full match
                }
                return false;
            }
            catch (Exception ex)
            {
                LogMisc(string.Format("isIpListed::Error: {0}", ex.Message));
                return false;
            }
        }

        private void initInstance()
        {
            // link to the config section
            this._config = (Settings)ConfigurationManager.GetSection(_my_name);
            this._instance_ID = string.Format("0x{0}", DateTime.Now.Ticks.ToString("X")).GetHashCode().ToString("X");

            // log a message to show we were loaded
            LogMisc(string.Format("{0} module loaded.", _my_name));

            // reads the allow/deny lists (if any)
            this._ipAllow = readList(this._config.AlwaysAllow);
            this._ipDeny = readList(this._config.AlwaysDeny);

            // dump our defaults (also check if all ok)
            try
            {
                //LogMsg("=== loaded");
                DbgWrite("Enabled........: " + this._config.Enabled.ToString());
                DbgWrite("Always deny....: " + this._config.AlwaysDeny);
                DbgWrite("Always allow-..: " + this._config.AlwaysAllow);
                DbgWrite("AccessKey......: " + this._config.AccessKey);
                DbgWrite("Query domain...: " + this._config.QueryDomain);
                DbgWrite("Max age........: " + this._config.MaxAge.ToString());
                DbgWrite("Max score......: " + this._config.MaxScore.ToString());
                DbgWrite("Cache TTL......: " + this._config.CacheTTL.ToString());
                DbgWrite("Cache white....: " + this._config.CacheWhite.ToString());
                DbgWrite("Redirect.......: " + this._config.RedirectOnHit.ToString());
                DbgWrite("Redirect URL...: " + this._config.RedirectURL);
                DbgWrite("Logging........: " + this._config.Logging.ToString());
                DbgWrite("Log path.......: " + this._config.LogPath);
                DbgWrite("Log hits.......: " + this._config.LogHits.ToString());
            }
            catch (Exception ex)
            {
                LogMisc("DumpConfig::Error: " + ex.Message);
            }
        }
        #endregion
    }

}
