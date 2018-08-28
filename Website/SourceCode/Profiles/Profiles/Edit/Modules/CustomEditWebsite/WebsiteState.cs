using System;

namespace Profiles.Edit.Modules.CustomEditWebsite
{

    public class WebsiteState
    {

        public WebsiteState(string URLID, string URL, string WebPageTitle, string PublicationDate, int SortOrder)
        {
            this.URLID = URLID;
            this.URL = URL;
            this.WebPageTitle = WebPageTitle;
            this.PublicationDate = PublicationDate;
            this.SortOrder = SortOrder;
        }


        public string URLID { get; set; }
        public string URL { get; set; }
        public string WebPageTitle { get; set; }
        public string PublicationDate { get; set; }
        public int SortOrder { get; set; }
    }
}
