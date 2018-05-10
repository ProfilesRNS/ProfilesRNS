using System;
using System.Collections.Generic;
using System.Xml;
using Profiles.Framework.Utilities;

namespace Profiles.Profile.Modules.CustomViewResearcherRole
{
    public partial class CustomViewResearcherRole : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.FillResearchGrid(false);


        }


        public CustomViewResearcherRole() : base() { }
        public CustomViewResearcherRole(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {


            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));

        }
        protected void FillResearchGrid(bool refresh)
        {
            Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();

            //Need RDF data for the links.           

            List<Profiles.Edit.Utilities.FundingState> fundingstate = data.GetFunding(data.GetPersonID(this.SubjectID));
            if (fundingstate.Count > 0)
            {

                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                int last = 0;

                sb.Append("<div class='basicInfo'><table width='590px' border='0' cellpadding='5px' cellspacing='3px'>");
                foreach (Profiles.Edit.Utilities.FundingState fs in fundingstate)
                {
                    last += 1;
                    AddRow(fs, ref sb);
                    if (last < fundingstate.Count)
                        AddLine(ref sb);
                }
                sb.Append("</table></div>");
                litHTML.Text = sb.ToString();
            }

        }
        private void AddLine(ref System.Text.StringBuilder sb)
        {
            sb.Append("<tr><td colspan='2'><hr/></td></tr>");
        }
        private void AddRow(Profiles.Edit.Utilities.FundingState fs, ref System.Text.StringBuilder sb)
        {
            string pi = string.Empty;
            string date = string.Empty;

            if(fs.PrincipalInvestigatorName!= string.Empty)
                pi = "(" + fs.PrincipalInvestigatorName + ")";

            if (fs.StartDate != "?")
                date = fs.StartDate;

            if (fs.EndDate != "?")
            {
                if (date != string.Empty)
                    date += "&nbsp;-&nbsp;" + fs.EndDate;
                else
                    date = fs.EndDate;
            }
            else if (fs.StartDate == "?" && fs.EndDate == "?")
                date = string.Empty;

            sb.Append("<tr><td>");
            if (!(fs.FullFundingID == string.Empty && pi == string.Empty && date == string.Empty))
                sb.Append("<div><span style='float:left'>" + fs.FullFundingID + "</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + pi + "<span style='float:right'>" + date + "</span></div>");

            if (fs.GrantAwardedBy != string.Empty)
                sb.Append(fs.GrantAwardedBy);
            if (fs.AgreementLabel != string.Empty)
                sb.Append("<br/>" + fs.AgreementLabel);
            if (fs.RoleDescription != string.Empty)
                sb.Append("<br/>Role Description: " + fs.RoleDescription);
            if (fs.RoleLabel != string.Empty)
                sb.Append("<br/>Role: " + fs.RoleLabel);


            sb.Append("</td></tr>");

            litHTML.Text = sb.ToString();




        }

        private Int64 SubjectID { get; set; }
    }
}