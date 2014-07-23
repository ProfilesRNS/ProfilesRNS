using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public class NavigationItem 
    {
        public NavigationItem()
        {
        }

        public NavigationItem(int navigationId, string groupName, string stepDesc, string link)
        {
            this.NavigationID = navigationId;
            this.StepDesc = stepDesc;
            this.GroupName = groupName;
            this.Link = link;
            this.IconPath = string.Empty;
            this.LinkColor = string.Empty;
        }

        public int NavigationID { get; set; }
        public string StepDesc { get; set; }
        public string GroupName { get; set; }
        public string Link { get; set; }
        public string IconPath { get; set; }
        public string LinkColor { get; set; }

        public virtual bool LinkCurrentPage
        {
            get
            {
                return Link.ToLower().Equals(DevelopmentBase.Common.WebFilePath.ToLower());
            }
        }
        public virtual string NavigateURL
        {
            get
            {
                return Link;
            }
        }
    }
}
