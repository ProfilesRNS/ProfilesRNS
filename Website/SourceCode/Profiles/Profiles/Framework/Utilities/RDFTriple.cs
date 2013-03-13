/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;




namespace Profiles.Framework.Utilities
{
    /// <summary>
    /// 
    /// S = SUBJECT
    /// P = PREDICATE
    /// O = OBJECT    
    /// 
    /// SPO (Triple)   requests are built and used to determine what data is being requested 
    /// based on the URI dereference from our Alias program
    /// 
    /// Other properties are used for the state of the transaction request.
    /// 
    /// </summary>
    public class RDFTriple
    {
        #region "PUBLIC METHODS"

        private string _uri;

        public RDFTriple(Int64 s)
        {
            this.Init();
            this.Subject = s;
        }
        public RDFTriple(Int64 s, Int64 p)
        {
            this.Init();
            this.Subject = s;
            this.Predicate = p;

        }
        public RDFTriple(Int64 s, Int64 p, Int64 o)
        {
            this.Init();
            this.Subject = s;
            this.Predicate = p;
            this.Object = o;

        }

        public RDFTriple(string uri)
        {
            this.Init();
            this.URI = uri;

        }

        private void Init()
        {
            this.Subject = 0;
            this.Predicate = 0;
            this.Object = 0;
            this.URI = string.Empty;
            this.Edit = false;
            this.Expand = false;
            this.ShowDetails = false;
            this.ExpandRDFList = string.Empty;
        }

        #endregion

        #region "PUBLIC PROPERTIES"

        public string Type
        {
            get
            {
                string rtnval = "";

                if (this.Subject > 0 && this.Predicate == 0 && this.Object == 0)
                    rtnval = "p";
                else if (this.Subject > 0 && this.Predicate != 0 && this.Object == 0)
                    rtnval = "n";
                else if (this.Subject != 0 && this.Predicate != 0 && this.Object != 0)
                    rtnval = "c";

                return rtnval;
            }
        }

        public Int64 Subject { get; set; }
        public Int64 Predicate { get; set; }
        public Int64 Object { get; set; }

        //This needs to be a string type, if its an Int64 it will default to zero and cause the offset to be zero when
        //no offset is requested.  Pass string.Empty; when not wanting to use an offset
        public string Offset { get; set; }

        //This needs to be a string type, if its an Int64 it will default to zero and cause the limit to be zero when
        //no limit is requested.  Pass string.Empty; when not wanting to use an limit
        public string Limit { get; set; }


        public string ExpandRDFList { get; set; }


        public bool Edit { get; set; }

        public Session Session
        {
            get
            {
                SessionManagement sm = new SessionManagement();
                Session session = sm.Session();
                return session;
            }
        }

        public bool Expand { get; set; }
        public bool ShowDetails { get; set; }
        public string URI
        {
            get
            {
                return _uri;

            }
            set { _uri = value; }
        }

        /// <summary>
        /// Internal calls will have a SPO request, external will have a URI request.
        /// </summary>
        public string Key
        {
            get
            {
                string rtn = string.Empty;

                if (this.URI == string.Empty)
                {

                    rtn = Root.Domain + "/" + this.Subject.ToString();

                    if (this.Predicate != 0)
                        rtn += "/" + this.Predicate;

                    if (this.Object != 0)
                        rtn += "/" + this.Object;
                }
                else
                    rtn = this.URI;

                if (ExpandRDFList == null)
                    ExpandRDFList = string.Empty;

                return rtn + "|" + this.Session.SessionID + "|" + this.Expand + "|" + this.ShowDetails + "|" + this.ExpandRDFList + "|" + this.Limit;

            }
        }
        #endregion
    }
}
