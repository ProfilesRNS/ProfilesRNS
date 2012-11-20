using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.Edit.Utilities
{
    public class PublicationState
    {

        public PublicationState(string rownum, string reference, Int32 pmid,
            string mpid, string category, string url, DateTime pubdate, bool frompubmed)
        {

            this.RowNum = rownum;
            this.Reference = reference;
            this.PMID = pmid;
            this.MPID = mpid;
            this.Category = category;
            this.URL = url;
            this.PubDate = pubdate;
            this.FromPubMed = frompubmed;

        }

        public PublicationState(string reference, int pmid,
            string mpid, string category, string url, DateTime pubdate, bool frompubmed)
        {

            this.Reference = reference;
            this.PMID = pmid;
            this.MPID = mpid;
            this.Category = category;
            this.URL = url;
            this.PubDate = pubdate;
            this.FromPubMed = frompubmed;
        }


        public string RowNum { get; set; }
        public string Reference { get; set; }
        public Int32 PMID { get; set; }
        public string MPID { get; set; }
        public string Category { get; set; }
        public string URL { get; set; }
        public DateTime PubDate { get; set; }
        public bool FromPubMed { get; set; }
        public bool Add { get; set; }
        public bool Edit { get; set; }
        public bool Delete { get; set; }
    }




    public static class Publication
    {
        public static PublicationState FindPub( List<PublicationState> ps,string rownum)
        {
            PublicationState pubstate;
            pubstate = ps.Find(delegate(PublicationState pub) { return pub.RowNum == rownum; });
            return pubstate;
        }
        //static bool UpdatePub(ref List<PublicationState> ps, PublicationState pub)
        //{
        //    PublicationState pubstate;
        //    bool rtnval = true;
        //    try
        //    {
        //        pubstate = FindPub(ps, pub.RowNum);

        //        ps.Remove(pubstate);
        //        ps.Add(pub);
        //    }
        //    catch (Exception ex) { rtnval = false; }

        //    return rtnval;
        //}

        //static bool DeletePub(ref List<PublicationState> ps, PublicationState pub)
        //{
        //    PublicationState pubstate;
        //    bool rtnval = true;
        //    try
        //    {
        //        pubstate = FindPub(ps, pub.RowNum);

        //        ps.Remove(pubstate);
        //        ps.Add(pub);
        //    }
        //    catch (Exception ex) { rtnval = false; }

        //    return rtnval;
        //}
    }

}
