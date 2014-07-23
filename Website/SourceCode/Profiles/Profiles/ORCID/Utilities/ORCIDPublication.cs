using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.ORCID.Utilities
{
    [Serializable]
    public partial class ORCIDPublication
    {
        public DateTime PubDate { get; set; }
        public string PubID { get; set; }
        public int PMID { get; set; }
        public string PMIDDesc
        {
            get
            {
                if (PMID == 0)
                {
                    return string.Empty;
                }
                return PMID.ToString();
            }
        }
        public string DOI { get; set; }
        public string URL { get; set; }
        public string PubDateShortDate
        {
            get
            {
                if (!PubDate.Equals(DateTime.MinValue) && !PubDate.Equals(DateTime.Parse("1/1/1900")))
                {
                    return PubDate.ToShortDateString();
                }
                else
                {
                    return string.Empty;
                }
            }
        }
        public string PublicationReference { get; set; }
        public int ORCIDDecisionID { get; set; }
        public string ArticleTitle { get; set; }
    }
}