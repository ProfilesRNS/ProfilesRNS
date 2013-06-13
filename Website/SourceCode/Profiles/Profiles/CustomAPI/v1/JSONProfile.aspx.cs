using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Common;
using Connects.Profiles.Common;
using Connects.Profiles.Service.DataContracts;
using Connects.Profiles.Utility;
using System.Web.Script.Serialization;
using Profiles.CustomAPI.Utilities;

public partial class JSONProfile : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string personId = Request["Person"];
            string EmployeeID = Request["EmployeeID"];
            string FNO = Request["FNO"];
            string callback = Request["callback"];
            bool mobile = "on".Equals(Request["mobile"], StringComparison.CurrentCultureIgnoreCase) || "1".Equals(Request["mobile"]);
            bool showPublications = "full".Equals(Request["publications"], StringComparison.CurrentCultureIgnoreCase);

            // get response text
            string jsonProfiles = "{}";
            try
            {
                if (personId != null && personId.Length > 0)
                {
                    jsonProfiles = GetJSONProfiles(Int32.Parse(personId), showPublications, mobile);
                }
                else if (EmployeeID != null && EmployeeID.Length > 0)
                {
                    jsonProfiles = GetJSONProfilesFromEmployeeID(EmployeeID, showPublications, mobile);
                }
                else if (FNO != null && FNO.Length > 0)
                {
                    jsonProfiles = GetJSONProfilesFromFNO(FNO, showPublications, mobile);
                }
            }
            catch (Exception ex)
            {
                // do nothing
            }

            // return with proper content type
            if (jsonProfiles != null) 
            {
                if (callback != null && callback.Length > 0)
                {
                    Response.ContentType = "application/javascript";
                    Response.Write(callback + "(" + jsonProfiles + ");");
                }
                else
                {
                    Response.ContentType = "application/json";
                    Response.Write(jsonProfiles);
                }
            }
        }
        catch (Exception ex)
        {
            Response.Write("ERROR" + Environment.NewLine + ex.Message + Environment.NewLine);
        }
    }

    private string GetJSONProfilesFromEmployeeID(string employeeID, bool showPublications, bool mobile)
    {
        int personId = (int)Profiles.Framework.Utilities.UCSFIDSet.ByEmployeeID[employeeID].PersonId;
        return GetJSONProfiles(personId, showPublications, mobile);
    }

    private string GetJSONProfilesFromFNO(string FNO, bool showPublications, bool mobile)
    {
        int personId = (int)Profiles.Framework.Utilities.UCSFIDSet.ByFNO[FNO.ToLower()].PersonId;
        return GetJSONProfiles(personId, showPublications, mobile);
    }

    private string GetJSONProfiles(int personId, bool showPublications, bool mobile)
    {
        Dictionary<string, Object> personData = new Dictionary<string, Object>();
        List<Dictionary<string, Object>> personDataList = new List<Dictionary<string, object>>();
        Dictionary<string, Object> profileData = new Dictionary<string, Object>();

        if (!new DataIO().GetIsActive(personId))
        {
            // this will cause a safe {} to be returned 
            throw new Exception("Person does not have an active profile");
        }

        // get person data
        try
        {
            PersonList personProfileList = new Connects.Profiles.Service.ServiceImplementation.ProfileServiceAdapter().GetPersonFromPersonId(personId);
            if (personProfileList.Person.Count == 1)
            {
                Person person = personProfileList.Person[0];

                personData.Add("Name", person.Name.FullName);
                personData.Add("ProfilesURL", person.ProfileURL.Text);
                /*personData.Add("SampleHTML", "<a href=\"" + ConfigUtil.GetConfigItem("URLBase") + "ProfileDetails.aspx?Person=" + personId + 
                    "\" title=\"Go to UCSF Profiles, powered by CTSI\" rel=\"me\">View " + person.Name.FirstName + " " +
                    (person.Name.MiddleName != null && person.Name.MiddleName.Length > 0 ? person.Name.MiddleName + " " : "") + person.Name.LastName + "'s research profile</a>"); */

                if (person.EmailImageUrl != null && person.EmailImageUrl.Visible)
                {
                    personData.Add("Email", person.EmailImageUrl.Text);
                }

                personData.Add("Address", person.Address);
                List<String> titles = new List<string>();
                foreach (AffiliationPerson aff in person.AffiliationList.Affiliation)
                {
                    if (aff.Primary)
                    {
                        personData.Add("Department", aff.DepartmentName);
                        personData.Add("School", aff.InstitutionName);
                    }
                    titles.Add(aff.JobTitle);
                }
                personData.Add("Titles", titles);

                if (person.Narrative != null) 
                {
                    personData.Add("Narrative", person.Narrative.Text);
                }

                personData.Add("PhotoURL", person.PhotoUrl.Text);

                if (showPublications && person.PublicationList != null)
                {
                    List<Object> pubList = new List<object>();
                    foreach (Publication pub in person.PublicationList)
                    {
                        Dictionary<string, Object> pubData = new Dictionary<string, Object>();
                        pubData.Add("PublicationID", pub.PublicationID);
                        pubData.Add("PublicationTitle", pub.PublicationReference.Replace("&amp;", "&").Replace("&gt;", ">").Replace("&lt;", "<").Replace("&#37;", "%"));
                        //pubData.Add("PublicationAbstract", pub.PublicationDetails);

                        List<Object> pubSourceList = new List<object>();
                        foreach (PublicationSource pubSource in pub.PublicationSourceList)
                        {
                            Dictionary<string, Object> pubSourceData = new Dictionary<string, Object>();
                            pubSourceData.Add("PublicationSourceName", pubSource.Name);
                            pubSourceData.Add("PublicationSourceURL", (mobile ? pubSource.URL.Replace("/pubmed", "/m/pubmed") : pubSource.URL) );
                            pubSourceData.Add("PublicationAddedBy", new Profiles.CustomAPI.Utilities.DataIO().GetPublicationInclusionSource(personId, pubSource.ID));
                            pubSourceList.Add(pubSourceData);
                        }
                        pubData.Add("PublicationSource", pubSourceList);
                        pubList.Add(pubData);
                    }
                    personData.Add("Publications", pubList);
                }
                else
                {
                    personData.Add("PublicationCount", person.PublicationList == null ? 0 : person.PublicationList.Count());
                }

                // Co-authors
                List<int> coAuthors = new List<int>();
                if (person.PassiveNetworks.CoAuthorList != null && person.PassiveNetworks.CoAuthorList.CoAuthor != null)
                {
                    foreach (CoAuthor ca in person.PassiveNetworks.CoAuthorList.CoAuthor)
                    {
                        coAuthors.Add(Int32.Parse(ca.PersonID));
                    }
                }
                if (coAuthors.Count > 0)
                {
                    personData.Add("CoAuthors", coAuthors);
                }

                // Similiar People
                List<int> similarPeople = new List<int>();
                if (person.PassiveNetworks.SimilarPersonList != null && person.PassiveNetworks.SimilarPersonList.SimilarPerson != null)
                {
                    foreach (SimilarPerson sp in person.PassiveNetworks.SimilarPersonList.SimilarPerson)
                    {
                        similarPeople.Add(Int32.Parse(sp.PersonID));
                    }
                }
                if (similarPeople.Count > 0)
                {
                    personData.Add("SimilarPeople", similarPeople);
                }

                // Keywords
                List<string> keywords = new List<string>();
                //foreach (DataRow row in _userBL.GetUserMESHkeywords(personId, "True", ref Count).Rows)
                if (person.PassiveNetworks.KeywordList != null && person.PassiveNetworks.KeywordList.Keyword != null)
                {
                    foreach (Keyword2 kw in person.PassiveNetworks.KeywordList.Keyword)
                    {
                        keywords.Add(kw.Text);
                    }
                }
                if (keywords.Count > 0)
                {
                    personData.Add("Keywords", keywords);
                }
                
                // add person
                personDataList.Add(personData);
                profileData.Add("Profiles", personDataList);
            }

        }
        catch (Exception ex)
        {
            // do nothing
        }
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        return serializer.Serialize(profileData);
    }

}
