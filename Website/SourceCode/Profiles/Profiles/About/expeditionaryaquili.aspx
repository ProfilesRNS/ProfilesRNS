<%@ Page Language="C#" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

//   PROJECT HONEY POT ADDRESS DISTRIBUTION SCRIPT
//   For more information visit: http://www.projecthoneypot.org/
//   Copyright (C) 2004-2013, Unspam Technologies, Inc.
//   
//   This program is free software; you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation; either version 2 of the License, or
//   (at your option) any later version.
//   
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//   
//   You should have received a copy of the GNU General Public License
//   along with this program; if not, write to the Free Software
//   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
//   02111-1307  USA
//   
//   If you choose to modify or redistribute the software, you must
//   completely disconnect it from the Project Honey Pot Service, as
//   specified under the Terms of Service Use. These terms are available
//   here:
//   
//   http://www.projecthoneypot.org/terms_of_service_use.php
//   
//   The required modification to disconnect the software from the
//   Project Honey Pot Service is explained in the comments below. To find the
//   instructions, search for:  *** DISCONNECT INSTRUCTIONS ***
//   
//   Generated On: Thu, 26 Sep 2013 19:16:40 -0700
//   For Domain: profiles.ucsf.edu
//   
//   

//   *** DISCONNECT INSTRUCTIONS ***
//   
//   You are free to modify or redistribute this software. However, if
//   you do so you must disconnect it from the Project Honey Pot Service.
//   To do this, you must delete the lines of code below located between the
//   *** START CUT HERE *** and *** FINISH CUT HERE *** comments. Under the
//   Terms of Service Use that you agreed to before downloading this software,
//   you may not recreate the deleted lines or modify this software to access
//   or otherwise connect to any Project Honey Pot server.
//   
//   *** START CUT HERE ***
//   
const string REQUEST_HOST       = "hpr9.projecthoneypot.org";
const string REQUEST_PORT       = "80";
const string REQUEST_SCRIPT     = "/cgi/serve.php";
//   
//   *** FINISH CUT HERE ***
//   

const string HPOT_TAG1          = "fe1c1c37f3d293eb2cf630f11438930f";
const string HPOT_TAG2          = "de45c555ae561cef3984306c84e1f15f";
const string HPOT_TAG3          = "834b8bcc86d7919811fdae827091ac89";

const string CLASS_STYLE_1      = "uucephu";
const string CLASS_STYLE_2      = "kafrowos";

const string DIV1               = "l8l96in4";

const string VANITY_L1          = "MEMBER OF PROJECT HONEY POT";
const string VANITY_L2          = "Spam Harvester Protection Network";
const string VANITY_L3          = "provided by Unspam";

const string DOC_TYPE1          = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n";
const string HEAD1              = "<html>\n<head>\n";
const string HEAD2              = "<title>Yeomen Spatial</title>\n</head>\n";
const string ROBOT1             = "<meta name=\"robots\" content=\"noindex,noarchive,follow\">\n";
const string NOCOLLECT1         = "<meta name=\"no-email-collection\" content=\"/\">\n";
const string TOP1               = "<body>\n<div align=\"center\">\n";
const string EMAIL1A            = "<a href=\"mailto:";
const string EMAIL1B            = "\" style=\"display: none;\">";
const string EMAIL1C            = "</a>";
const string EMAIL2A            = "<a href=\"mailto:";
const string EMAIL2B            = "\" style=\"display:none;\">";
const string EMAIL2C            = "</a>";
const string EMAIL3A            = "<a style=\"display: none;\" href=\"mailto:";
const string EMAIL3B            = "\">";
const string EMAIL3C            = "</a>";
const string EMAIL4A            = "<a style=\"display:none;\" href=\"mailto:";
const string EMAIL4B            = "\">";
const string EMAIL4C            = "</a>";
const string EMAIL5A            = "<a href=\"mailto:";
const string EMAIL5B            = "\"></a>";
const string EMAIL5C            = "..";
const string EMAIL6A            = "<span style=\"display: none;\"><a href=\"mailto:";
const string EMAIL6B            = "\">";
const string EMAIL6C            = "</a></span>";
const string EMAIL7A            = "<span style=\"display:none;\"><a href=\"mailto:";
const string EMAIL7B            = "\">";
const string EMAIL7C            = "</a></span>";
const string EMAIL8A            = "<!-- <a href=\"mailto:";
const string EMAIL8B            = "\">";
const string EMAIL8C            = "</a> -->";
const string EMAIL9A            = "<div id=\""+DIV1+"\"><a href=\"mailto:";
const string EMAIL9B            = "\">";
const string EMAIL9C            = "</a></div><br><script language=\"JavaScript\" type=\"text/javascript\">document.getElementById('"+DIV1+"').innerHTML='';<"+"/script>";
const string EMAIL10A           = "<a href=\"mailto:";
const string EMAIL10B           = "\"><!-- ";
const string EMAIL10C           = " --></a>";
const string LEGAL1             = "";
const string LEGAL2             = "\n";
const string STYLE1             = "\n<style>a."+CLASS_STYLE_1+"{color:#FFF;font:bold 10px arial,sans-serif;text-decoration:none;}</style>";
const string VANITY1            = "<table cellspacing=\"0\"cellpadding=\"0\"border=\"0\"style=\"background:#999;width:230px;\"><tr><td valign=\"top\"style=\"padding: 1px 2px 5px 4px;border-right:solid 1px #CCC;\"><span style=\"font:bold 30px arial,sans-serif;color:#666;top:0px;position:relative;\">@</span></td><td valign=\"top\" align=\"left\" style=\"padding:3px 0 0 4px;\"><a href=\"http://www.projecthoneypot.org/\" class=\""+CLASS_STYLE_1+"\">"+VANITY_L1+"</a><br><a href=\"http://www.unspam.com\"class=\""+CLASS_STYLE_1+"\">"+VANITY_L2+"<br>"+VANITY_L3+"</a></td></tr></table>\n";
const string BOTTOM1            = "</div>\n</body>\n</html>\n";


string getLegalContent() { return "<table cellpadding=\"0\" border=\"0\" cellspacing=\"0\">\n<tr>\n<td><font face=\"courier\"><b><font color=#FFFFFF>f</font></b>&nbsp;<b><font color=#FFFFFF>e</font></b>&nbsp;&nbsp; <b><font color=#FFFFFF>o</font></b>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; <br>&nbsp;<br>&#84;he webs&#105;te &#102;&#114;om<font color=#FFFFFF>p</font>&#119;&#104;&#105;<br>&#116;o you &#115;ubject to th<br>other terms governin<br>Webs&#105;te you<font color=#FFFFFF>f</font>accep<!-- truth fundamental -->t t<br>re&#97;d them c&#97;refully.<br>a&#103;e&#110;ts<font color=#FFFFFF>p</font>of the<font color=#FFFFFF>t</font>in&#100;ivi<br>&#116;hem. The access rig<br>&#110;on-trans&#102;er&#97;ble wit<br>Website.<br><br>&nbsp; &nbsp; &nbsp; &nbsp; <b><font color=#FFFFFF>o</font></b>&nbsp; &nbsp; &nbsp; <b>SPECI</b><br>&nbsp;<br>Spec&#105;al rest&#114;iction&#115;<br>Non-Huma&#110;<font color=#FFFFFF>s</font>Visitors. <br>spide&#114;s, bots,<font color=#FFFFFF>h</font>in&#100;ex<br>pr<!-- tiff -->&#111;grams desig&#110;e&#100; t&#111;<br>aut&#111;mat&#105;call&#121;.<br><br>Em&#97;il &#97;ddresses<font color=#FFFFFF>e</font>on<font color=#FFFFFF>k</font>t<br>&#73;t is recogni&#122;ed th&#97;<br>alone. You a&#99;knowle&#100;<br>&#104;as a val&#117;e no&#116;<font color=#FFFFFF>h</font>&#108;&#101;s&#115;<br>st&#111;r&#97;&#103;e, &#97;n&#100;/&#111;r &#100;ist<br>value of these addre<br>stor&#105;ng th<!-- birdseye embarrassment circular -->is We&#98;site<br>ag<!-- watchful hazard -->reement<font color=#FFFFFF>c</font>and expres<br><br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <b><font color=#FFFFFF>a</font></b>&nbsp;&nbsp; <br>&nbsp;<br>Each p&#97;rty a&#103;rees th<br>against the other in<br>(\"Judicial &#65;ctio&#110;\") <br>t&#104;&#101; reg&#105;ste&#114;ed &#65;dmin<br>such<!-- barrelchested desire -->&nbsp;laws &#97;re applie<br>an&#100; performed enti&#114;e<br>&#111;f fe&#100;eral &#97;nd state<br>an&#121; act&#105;on<font color=#FFFFFF>i</font>brought a<br>Service. You<font color=#FFFFFF>a</font>consent<br>the &#97;b&#111;ve agreem&#101;nt.<br><br>&nbsp; &nbsp;&nbsp; <b><font color=#FFFFFF>g</font></b>&nbsp; &nbsp; <b><font color=#FFFFFF>d</font></b>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; <br>&nbsp;<br>You conse&#110;t to h&#97;vin<br>&#109;ay ap&#112;e<!-- indoeuropean bearing -->a&#114;<font color=#FFFFFF>g</font>&#115;&#111;mewhere<br>ab&#117;se. The Id&#101;&#110;tifie<br>&#86;isitors ag&#114;&#101;e n&#111;t t<br><br>&#86;ISITORS AG&#82;&#69;E THAT <br>&#80;ARTY OR SEN&#68;IN&#71; &#65;NY<br>SUBSE&#81;UENT BRE&#65;&#67;H OF<br></font></td>\n<td><font face=\"courier\">&nbsp; &nbsp; &nbsp;&nbsp; <b>TERMS</b>&nbsp;<b>AN&#68;</b>&nbsp;<b>C<!-- slavish hummingbirds -->&#79;N</b><br><br>&#99;h you acces&#115;ed this<br>e &#102;ollowing &#99;ondi<!-- deductible greekletter winner heavy exposure -->tio<br>g a&#99;cess to t&#104;e &#87;eb&#115;<br>&#104;ese te&#114;ms an&#100; condi<br>&nbsp;&#65;ny Non-Huma&#110; &#86;isit<br>dual(&#115;) who controls<br>hts granted to yo&#117; u<br>&#104;ou&#116; the<font color=#FFFFFF>o</font>ex&#112;&#114;ess wri<br><br><br><b>AL</b>&nbsp;<b>LICEN&#83;E</b>&nbsp;<b>RESTRICT&#73;</b><br><br>&nbsp;&#111;n a<font color=#FFFFFF>c</font>visitor's<font color=#FFFFFF>s</font>lice<br>No<!-- funny occupation meeting pool skull -->n-Human Visi&#116;ors i<br>ers, &#114;o&#98;ots, c&#114;awler<br>&nbsp;access, &#114;&#101;ad,<font color=#FFFFFF>i</font>co&#109;pi<br><br><br>h&#105;s &#115;ite are &#99;onside<br>t<font color=#FFFFFF>o</font>th&#101;se em&#97;il addres<br>&#103;e and agre&#101; &#116;ha&#116; ea<br>&nbsp;t&#104;an U&#83; $50. Yo&#117;<font color=#FFFFFF>g</font>&#102;&#117;<br>ribution o&#102;<font color=#FFFFFF>h</font>&#116;hese ad<br>sses. In&#116;entio&#110;al c&#111;<br>'s email add&#114;esse&#115; i<br>sly prohibited.<br><br>&nbsp; &nbsp;&nbsp; <b>APP&#76;&#73;&#67;&#65;&#66;L&#69;</b>&nbsp;<b>&#76;AW</b>&nbsp;<br><br>a&#116; any<font color=#FFFFFF>e</font>suit, action <br>&nbsp;conn&#101;&#99;tion<font color=#FFFFFF>h</font>with or <br>shall &#98;e governed by<br>istrative &#67;ontact (&#116;<br>d to<!-- permission jet --><font color=#FFFFFF>d</font>agreement&#115;<font color=#FFFFFF>g</font>betw<br>ly within th&#101; Admin <br>&nbsp;courts within the<font color=#FFFFFF>f</font>A<br>g&#97;&#105;n&#115;t him i&#110; connec<br>&nbsp;to elect&#114;oni&#99; s&#101;rvi<br><br><br>&nbsp; &nbsp; <b>RECO&#82;DS<font color=#FFFFFF>c</font>OF</b>&nbsp;<b>VISI<!-- possessive socialist flaming impressed crisp -->T</b><br><br>g you&#114; In&#116;ernet Prot<br>&nbsp;on this &#112;&#97;ge (the \"<br>r is uniqu&#101;ly match&#101;<br>o &#117;se thi&#115; address f<br><br>HA&#82;VESTING, &#71;&#65;&#84;H&#69;RIN<br>&nbsp;MESSAGE(S) TO THE I<br>&nbsp;THESE &#84;ER&#77;S OF S&#69;RV<br></font></td>\n<td><font face=\"courier\"><b>DITIONS</b>&nbsp;<b>OF</b>&nbsp;<b>USE</b>&nbsp;<br><br>&nbsp;ag&#114;eement (\"&#116;he &#87;eb<br>ns. These ter&#109;s are <br>ite&#46;<font color=#FFFFFF>p</font>By<font color=#FFFFFF>a</font>vi&#115;iti&#110;g (in<br>tions (the \"Terms of<br>ors t&#111; the Webs&#105;te s<br>, a&#117;thors or<font color=#FFFFFF>k</font>o&#116;he<!-- computer -->rwi<br>nder t&#104;e Terms of S&#101;<br>tten per&#109;&#105;ssion of t<br><br><br><b>ON&#83;</b>&nbsp;<b>FOR</b>&nbsp;<b>NON-HU&#77;AN</b>&nbsp;<b>VI</b><br><br>ns&#101; to access the W&#101;<br>nclude, but<font color=#FFFFFF>g</font>&#97;re no&#116; <br>&#115;, harveste&#114;s, or an<br>le or gather cont&#101;&#110;t<br><br><br>red propriet&#97;&#114;y inte<br>&#115;es &#97;r&#101; pro&#118;ided &#102;or<br>ch email address &#116;he<br>r&#116;h&#101;r agre&#101; that the<br>dresses subst<!-- verdict horse invitation elegant evangelical -->an&#116;iall<br>&#108;lection&#44;<font color=#FFFFFF>a</font>harve&#115;ting<br>s recognized a&#115; a vi<br><br><br><b>AND</b>&nbsp;<b>&#74;URISDICTI<!-- dialogue primary sunshine perigynous -->ON</b>&nbsp;<br><br>or proc<!-- deltoid supplement halfway twelvetone -->eeding br&#111;ugh<br>arising from the Ter<br>&nbsp;&#116;he law o&#102; the s<!-- centenary iroquoian fisherman -->ta&#116;<br>he \"Admin State\") fo<br>een Adm<!-- workingclass -->i&#110;<font color=#FFFFFF>i</font>Sta&#116;e resi<br>Sta&#116;e. You c<!-- demandpull -->o<!-- talent zigzag pejorative villa hireling -->nsen&#116; &#116;<br>dmin State. You cons<br>tion with &#98;reaches &#111;<br>ce of process regard<br><br><br><b>OR<!-- shovelnosed garment --></b>&nbsp;<b>USE<font color=#FFFFFF>s</font>&#65;ND</b>&nbsp;<b>ABUSE</b>&nbsp;<br><br>oc&#111;l<font color=#FFFFFF>s</font>ad&#100;res<!-- ground amazing preliterate acoustic daily -->s recorde<br>&#73;dentifie&#114;\"<!-- itinerary cottage furred dad -->&#41; if we s<br>d to<font color=#FFFFFF>p</font>y<!-- distinctive equilibrium germane -->&#111;ur Internet P<br>or any reason.<br><br>G, STO&#82;ING, TRANSFER<br>&#68;E&#78;TIFI&#69;&#82; CO&#78;S&#84;ITUTE<br>IC&#69;.<br></font></td>\n<td><font face=\"courier\"><br><br>site\") is provide&#100;<br>&#105;n addition to &#97;&#110;y<br>&nbsp;any mann&#101;r) th<!-- orthodox posthypnotic earthbound tenuous -->e<br>&nbsp;Service\")&#46; P&#108;ea&#115;e<br>hall be considered<br>se m&#97;kes use of<br>rvice are<br>&#104;e &#111;wne&#114; &#111;f &#116;he<br><br><br><b>SITORS</b>&nbsp;<br><br>bsite appl&#121; t&#111;<br>&#108;imited to, web<br>&#121;<font color=#FFFFFF>d</font>other &#99;o&#109;&#112;&#117;ter<br><font color=#FFFFFF>f</font>&#102;rom the Website<br><br><br>lle&#99;&#116;ual p<!-- futuristic -->&#114;operty.<br>&nbsp;human visit&#111;rs<br><font color=#FFFFFF>i</font>We&#98;site contains<br>&nbsp;co&#109;p&#105;latio&#110;,<br>y<font color=#FFFFFF>k</font>diminishes the<br>, ga&#116;h&#101;r&#105;ng, and/o&#114;<br>olatio&#110;<font color=#FFFFFF>f</font>of thi&#115;<br><br><br><br><br>t by such part&#121;<br>&#109;s o&#102; Service<br>e of residence of<br>r the Website a&#115;<br>dents enter&#101;d<font color=#FFFFFF>s</font>into<br>o &#116;&#104;&#101; j&#117;r&#105;sd&#105;ction<br>en&#116; to<font color=#FFFFFF>c</font>the v&#101;nue in<br>f th&#101;s&#101; T<!-- field -->erms of<br>ing<font color=#FFFFFF>f</font>&#97;c&#116;io&#110;s<font color=#FFFFFF>i</font>u&#110;der<br><br><br><br><br>d. An em<!-- coated lab funny notebook -->ail &#97;ddress<br>u&#115;pect p&#111;tential<br>rotocol addr&#101;ss.<br><br><br>RING TO A &#84;HIRD<br>S AN &#65;CCEPTA&#78;CE AND<br><br></font></td>\n</tr>\n</table>\n<br>"; }




	protected string GetEmailHTML(string Method, string Email)
	{
	  switch (Method)
	  {
		  case "0":
			  return "";
		  case "1":
			  return EMAIL1A + Email + EMAIL1B + Email + EMAIL1C;
		  case "2":
			  return EMAIL2A + Email + EMAIL2B + Email + EMAIL2C;
		  case "3":
			  return EMAIL3A + Email + EMAIL3B + Email + EMAIL3C;
		  case "4":
			  return EMAIL4A + Email + EMAIL4B + Email + EMAIL4C;
		  case "5":
			  return EMAIL5A + Email + EMAIL5B + Email + EMAIL5C;
		  case "6":
			  return EMAIL6A + Email + EMAIL6B + Email + EMAIL6C;
		  case "7":
			  return EMAIL7A + Email + EMAIL7B + Email + EMAIL7C;
		  case "8":
			  return EMAIL8A + Email + EMAIL8B + Email + EMAIL8C;
		  case "9":
			  return EMAIL9A + Email + EMAIL9B + Email + EMAIL9C;
		  default:
			  return EMAIL10A + Email + EMAIL10B + Email + EMAIL10C;
	  }
	}

	protected void WriteIfSet(string key)
	{
		  if (Settings.ContainsKey(key))
		  {
			  Response.Write(Settings[key + "Msg"]);
		  }
	}

	protected void WriteIfOn(string key)
	{
		  string val;
		  if (Settings.TryGetValue(key + "On", out val) && !String.IsNullOrEmpty(val))
		  {
			  if (Settings.ContainsKey(key))
			  {
				  Response.Write(Settings[key]);
			  }
			  else
			  {
				  Response.Write(Settings[key + "Msg"]);
			  }
		  }
	}

  private string PerformRequest(string p)
  {
	  HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://" + REQUEST_HOST + REQUEST_SCRIPT);
	  request.Method = "POST";
	  request.Headers.Add("Cache-Control", "no-cache");
	  request.UserAgent = "PHPot " + HPOT_TAG2;
	  request.ContentType = "application/x-www-form-urlencoded";
	  request.KeepAlive = false;

	  byte[] bytes = Encoding.UTF8.GetBytes(p);

	  request.ContentLength = bytes.Length;
	  using (Stream requestStream = request.GetRequestStream())
	  {
		  requestStream.Write(bytes, 0, bytes.Length);

		  try
		  {
			  using (WebResponse response = request.GetResponse())
			  {
				  using (StreamReader reader = new StreamReader(response.GetResponseStream()))
				  {
					  return reader.ReadToEnd();
				  }
			  }
		  }
		  catch (WebException we)
		  {
			  StreamReader sr = new StreamReader(we.Response.GetResponseStream());
			  throw new Exception(sr.ReadToEnd(), we);
		  }
	  }
  }


	public Dictionary<string, string> PrepareRequest()
	{
		Dictionary<string, string> postvars = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
		postvars.Add("tag1", HPOT_TAG1);
		postvars.Add("tag2", HPOT_TAG2);
		postvars.Add("tag3", HPOT_TAG3);

		string md5 = "00000000000000000000000000000000";
		try
		{
			if (!String.IsNullOrEmpty(ForcedScriptFile ?? AppRelativeVirtualPath))
			{
				string scriptPath = ForcedScriptFile ?? Server.MapPath(AppRelativeVirtualPath);
				MD5 md5er = MD5CryptoServiceProvider.Create();
				byte[] hash = md5er.ComputeHash(System.Text.Encoding.ASCII.GetBytes(_Cleaner.Replace(File.ReadAllText(scriptPath),"")));
				System.Text.StringBuilder hashBuilder = new StringBuilder(32);
				foreach (byte b in hash)
				{
					hashBuilder.Append(b.ToString("x2"));
				}
				md5 = hashBuilder.ToString();
			}
		}
		catch (Exception)
		{
		}
		postvars.Add("tag4", md5);
		postvars.Add("ip", HttpUtility.UrlEncode(Request.ServerVariables["REMOTE_ADDR"]));
		postvars.Add("svrn", HttpUtility.UrlEncode(Request.ServerVariables["SERVER_NAME"]));
		postvars.Add("svp", HttpUtility.UrlEncode(Request.ServerVariables["SERVER_PORT"]));
        postvars.Add("svip", HttpUtility.UrlEncode(ForcedIP ?? Request.ServerVariables["SERVER_ADDR"]));
		postvars.Add("rquri", HttpUtility.UrlEncode(ForcedScriptUri ?? Request.ServerVariables["URL"]));
		postvars.Add("sn", HttpUtility.UrlEncode(ForcedScriptName ?? Request.ServerVariables["SCRIPT_NAME"]).Replace(" ", "%20"));
		postvars.Add("ref", HttpUtility.UrlEncode(Request.ServerVariables["HTTP_REFERER"]));
		postvars.Add("uagnt", HttpUtility.UrlEncode(Request.ServerVariables["HTTP_USER_AGENT"]));

        if (Request.HttpMethod == "POST" && Request.Form.Count > 0)
        {

              postvars.Add("has_post", ""+Request.Form.Count);

              foreach (string key in Request.Form.Keys)
              {
                    postvars["post|" + key] = Request.Form[key];
              }

        }

        if (Request.QueryString.Count > 0)
        {

              postvars.Add("has_get", ""+Request.QueryString.Count);

              foreach (string key in Request.QueryString.Keys)
              {
                    postvars["get|" + key] = Request.QueryString[key];
              }      

        }
		return postvars;
	}

  private Dictionary<string, string> TranscribeResponse(string response)
  {
	  Dictionary<string, string> settings = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
	  //string[] arr = HttpUtility.UrlDecode(response).Split((char)10);
      string[] arr = response.Split((char)10);
	  bool isParam = false;

	  for (int j = 0; j < arr.Length; j++)
	  {
		  if (arr[j] == "<END>")
		  {
			  isParam = false;
		  }

		  if (isParam)
		  {
			  string[] pieces = arr[j].Split(_splitChars, 2);
			  if (pieces.Length == 2)
			  {
				  settings.Add(pieces[0], HttpUtility.UrlDecode(pieces[1]));
			  }
		  }

		  if (arr[j] == "<BEGIN>")
		  {
			  isParam = true;
		  }
	  }
	  return settings;
  }

  protected string Directive(int index)
  {
	  if (Directives != null && Directives.Length > index)
	  {
		  return Directives[index];
	  }
	  return null;
  }

  protected override void Render(HtmlTextWriter writer)
  {
	  Dictionary<string, string> post = PrepareRequest();

	  StringBuilder RequestText = new StringBuilder();
	  foreach (KeyValuePair<string, string> kv in post)
	  {
		  if (RequestText.Length > 0)
		  {
			  RequestText.Append('&');
		  }
		  RequestText.Append(kv.Key).Append('=').Append(kv.Value);
	  }
	  string ResponseText = PerformRequest(RequestText.ToString());
	  Settings = TranscribeResponse(ResponseText);
	  if (Settings.ContainsKey("directives"))
	  {
		  Directives = Settings["directives"].Split(',');
	  }
      Response.Cache.SetCacheability(HttpCacheability.NoCache);
	  Response.Cache.AppendCacheExtension("no-store");
	  base.Render(writer);
  }

  static Regex _Cleaner = new Regex("[^0-9a-zA-Z]");
  static char[] _splitChars = new char[] { '=' };
  static string ForcedScriptFile = ConfigurationManager.AppSettings["ProjectHoneyPot.ScriptSource"];
  static string ForcedScriptName = ConfigurationManager.AppSettings["ProjectHoneyPot.ScriptName"];
  static string ForcedScriptUri = ConfigurationManager.AppSettings["ProjectHoneyPot.ScriptUri"];
  static string ForcedIP = ConfigurationManager.AppSettings["ProjectHoneyPot.MyIP"];
  string[] Directives;
  Dictionary<string, string> Settings;
  
  void WritePageContent()
  {
	  if (Directive(0) == "1") Response.Write(DOC_TYPE1);
	  WriteIfSet("injDocType");
	  if (Directive(1) == "1") Response.Write(HEAD1);
	  WriteIfSet("injHead1HTML");
	  if (Directive(8) == "1") Response.Write(ROBOT1);
	  WriteIfSet("injRobotHTML");
	  if (Directive(9) == "1") Response.Write(NOCOLLECT1);
	  WriteIfSet("injNoCollectHTML");
	  if (Directive(1) == "1") Response.Write(HEAD2);
	  WriteIfSet("injHead2HTML");
	  if (Directive(2) == "1") Response.Write(TOP1);
	  WriteIfSet("injTopHTML");
	  WriteIfOn("actMsg");
	  WriteIfOn("errMsg");
	  WriteIfOn("customMsg");
	  if (Directive(3) == "1") Response.Write(LEGAL1 + getLegalContent() + LEGAL2);
	  WriteIfSet("injLegalHTML");
	  WriteIfOn("altLegal");
	  if (Directive(4) == "1") Response.Write(GetEmailHTML(Settings["emailmethod"], Settings["email"]));
	  WriteIfSet("injEmailHTML");
	  if (Directive(5) == "1") Response.Write(STYLE1);
	  WriteIfSet("injStyleHTML");
	  if (Directive(6) == "1") Response.Write(VANITY1);
	  WriteIfSet("injVanityHTML");
	  WriteIfOn("altVanity");
	  if (Directive(7) == "1") Response.Write(BOTTOM1);
	  WriteIfSet("injBottomHTML");
  }
</script>
<% WritePageContent(); %>
