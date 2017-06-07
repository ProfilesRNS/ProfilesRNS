using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.Edit.Utilities
{
    public class GroupMemberState
    {
        public GroupMemberState(int UserID, string PersonURI, string Title, string DisplayName, string InstitutionName)
        {
            this.UserID = UserID;
            this.PersonURI = PersonURI;
            this.Title = Title;
            this.DisplayName = DisplayName;
            this.InstitutionName = InstitutionName;
        }

        public int UserID { get; set; }
        public string PersonURI { get; set; }
        public string Title { get; set; }
        public string DisplayName { get; set; }
        public string InstitutionName { get; set; }
    }
}