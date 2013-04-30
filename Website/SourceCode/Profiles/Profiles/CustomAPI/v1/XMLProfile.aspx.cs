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

public partial class XMLProfile : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string personId = Request["Person"];
            string EmployeeID = Request["EmployeeID"];
            string FNO = Request["FNO"];

            // get response text
            string xmlProfiles = "{}";
            try
            {
                if (personId != null && personId.Length > 0)
                {
                    xmlProfiles = GetXMLProfiles(Int32.Parse(personId));
                }
                else if (EmployeeID != null && EmployeeID.Length > 0)
                {
                    xmlProfiles = GetXMLProfilesFromEmployeeID(EmployeeID);
                }
                else if (FNO != null && FNO.Length > 0)
                {
                    xmlProfiles = GetXMLProfilesFromFNO(FNO);
                }
            }
            catch (Exception ex)
            {
                // do nothing
            }

            // return with proper content type
            if (xmlProfiles != null) 
            {
                {
                    Response.ContentType = "text/xml";
                    Response.Write(xmlProfiles);
                }
            }
        }
        catch (Exception ex)
        {
            Response.Write("ERROR" + Environment.NewLine + ex.Message + Environment.NewLine);
        }
    }

    private string GetXMLProfilesFromEmployeeID(string employeeID)
    {
        // lookup personid 
        int personId = new DataIO().GetPersonIdFromInternalUsername(employeeID);
        return GetXMLProfiles(personId);
    }

    private string GetXMLProfilesFromFNO(string FNO)
    {
        // lookup personid from FNO
        int personId = new DataIO().GetPersonIdFromFNO(FNO);
        return GetXMLProfiles(personId);
    }

    private string GetXMLProfiles(int personId)
    {
        PersonList personProfileList = new Connects.Profiles.Service.ServiceImplementation.ProfileServiceAdapter().GetPersonFromPersonId(personId);
        return XmlUtilities.SerializeObject(personProfileList);
    }

}
