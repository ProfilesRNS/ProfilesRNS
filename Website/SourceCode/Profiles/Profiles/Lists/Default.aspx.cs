using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace Profiles.Lists
{
    public partial class Default : System.Web.UI.Page
    {
        Profiles.Framework.Template masterpage;
        Framework.Utilities.SessionManagement sm;

        protected void Page_Load(object sender, EventArgs e)
        {
            sm = new Framework.Utilities.SessionManagement();

            if (sm.Session().UserID < 0 || sm.Session().UserID == 0)
                Response.Redirect(Framework.Utilities.Root.Domain);

            masterpage = (Framework.Template)base.Master;

            LoadPresentationXML();
        }


        public void LoadPresentationXML()
        {

            this.PresentationXML = new XmlDocument();

            this.PresentationXML.LoadXml(System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/Lists/PresentationXML/MyLists.xml"));            
            masterpage.PresentationXML = this.PresentationXML;
        }


        [System.Web.Services.WebMethod]
        public static string AddPersonToList(string ownernodeid, string listid, string personid)
        {

            if (listid == "0")
                listid = Lists.Utilities.DataIO.CreateList(ownernodeid, "List");

            return Lists.Utilities.DataIO.AddRemovePerson(listid, personid);


        }

        [System.Web.Services.WebMethod]
        public static string DeleteSingle(string listid, string personid)
        {

            Lists.Utilities.DataIO.AddRemovePerson(listid, personid,true);
            return Lists.Utilities.DataIO.GetListCount();
        }
        [System.Web.Services.WebMethod]
        public static string DeleteSelected(string listid, string personids)
        {

            Lists.Utilities.DataIO.DeleteSelected(listid, personids);
            return Lists.Utilities.DataIO.GetListCount();
        }
        [System.Web.Services.WebMethod]
        public static void ClearList(string ListID)
        {
            Profiles.Lists.Utilities.DataIO.DeleteFildered(ListID, null,null);
        }
        public XmlDocument PresentationXML { get; set; }

    }
}