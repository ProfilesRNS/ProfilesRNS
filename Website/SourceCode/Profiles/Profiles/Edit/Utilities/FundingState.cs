using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.Edit.Utilities
{
    public class FundingState
    {
        private string _startdate;
        private string _enddate;

        public Guid FundingRoleID { get; set; }
        public int PersonID { get; set; }
        public string Source { get; set; }
        public string FundingID { get; set; }
        public string CoreProjectNum { get; set; }
        public string FullFundingID { get; set; }
        public string RoleLabel { get; set; }
        public string RoleDescription { get; set; }
        public string AgreementLabel { get; set; }
        public string SponsorAwardID { get; set; }
        public string GrantAwardedBy { get; set; }
        public string StartDate
        {
            get
            {
                DateTime dt;
                if (!DateTime.TryParse(_startdate, out dt))
                    return "?";
                if (dt == DateTime.Parse("1/1/1900"))
                    return "?";
                return _startdate;
            }
            set { _startdate = value; }
        }
        public string EndDate
        {
            get
            {
                DateTime dt;
                if (!DateTime.TryParse(_enddate, out dt))
                    return "?";
                if (dt == DateTime.Parse("1/1/1900"))
                    return "?";
                return _enddate;
            }
            set { _enddate = value; }
        }

        public string PrincipalInvestigatorName { get; set; }
        public string PIID { get; set; }
        public string Abstract { get; set; }
        public string SubProjectID { get; set; }
        public List<FundingState> SubFundingState { get; set; }

        public bool hasData
        {
            get
            {
                return (!String.IsNullOrEmpty(FundingID) || !String.IsNullOrEmpty(CoreProjectNum)
                    || !String.IsNullOrEmpty(FullFundingID) || !String.IsNullOrEmpty(RoleLabel)
                    || !String.IsNullOrEmpty(RoleDescription) || !String.IsNullOrEmpty(AgreementLabel)
                    || !String.IsNullOrEmpty(PrincipalInvestigatorName) || !String.IsNullOrEmpty(PIID)
                    || !String.IsNullOrEmpty(Abstract) || !String.IsNullOrEmpty(SubProjectID)
                    || !String.IsNullOrEmpty(SponsorAwardID) || !String.IsNullOrEmpty(GrantAwardedBy)
                    || SubFundingState != null);
            }
        }

    }


}