using System;
using System.Web;
using Profiles.Framework.Utilities;

namespace Profiles.Framework.Modules.MainMenu
{
    public partial class MyLists : System.Web.UI.UserControl
    {
        SessionManagement sm;     

        protected void Page_Load(object sender, EventArgs e)
        {
            sm = new SessionManagement();
 /*          
            if (sm.Session().UserID > 0)
            {
                int count = GetCount();

                if (count > 0)
                {
                    hlRemoveAllFromList.Attributes.Add("onClick",string.Format("ClearList('{0}')",sm.Session().ListID));
                    
                    litJS.Text = string.Format("<script type='text/javascript'>jQuery('#list-count').html('{0}');</script>", count.ToString());
                }
                else
                    litJS.Text = string.Format("<script type='text/javascript'>{0}</script>", "jQuery('#view-list-reports').remove();jQuery('#remove-all-people-from-list').remove();");

                if (!string.IsNullOrEmpty((string)HttpContext.Current.Session["PERSON-SEARCH-ADD"]))
                {
                    hlAddToList.NavigateUrl = String.Format("{0}/lists/default.aspx?type=search", Root.Domain);
                    hlAddToList.Text = "Add matching people to my list";
                    hlAddToList.Attributes.Add("style", "width:255px;");

                    if (count > 0)
                        hlRemoveFromList.NavigateUrl = string.Format("{0}/lists/default.aspx?type=removefromsearch", Root.Domain);
                    else { litJS.Text += string.Format("<script type='text/javascript'>{0}</script>", "jQuery('#remove-people-from-list').remove();"); }


                    pnlPersonScript.Visible = false;
                }
                else if (Root.AbsolutePath.ToLower().Contains("/person/"))
                {
                    Profiles.Edit.Utilities.DataIO dataio = new Edit.Utilities.DataIO();
                    string personid = dataio.GetPersonID(Convert.ToInt64(Request.QueryString["subject"])).ToString();
                    if (Profiles.Lists.Utilities.DataIO.PersonExists(personlistid, personid) == "0")
                    {
                        hlAddToList.NavigateUrl = "javascript:void(0);";
                        hlAddToList.Attributes.Add("onclick", string.Format("AddPerson({0},{1},{2})", OwnerNodeID, personlistid, personid));
                        hlAddToList.Text = "Add this person to my list";
                        hlAddToList.Attributes.Add("alt-text", "Remove person from list");
                        hlAddToList.Attributes.Add("alt-onclick", string.Format("RemovePerson({0},{1})", personlistid, personid));

                        pnlPersonScript.Visible = true;
                    }
                    else
                    {
                        hlAddToList.NavigateUrl = "javascript:void(0);";
                        hlAddToList.Attributes.Add("onclick", string.Format("RemovePerson({0},{1})", personlistid, personid));
                        hlAddToList.Text = "Remove person from list";
                        hlAddToList.Attributes.Add("alt-text", "Add person to my list");
                        hlAddToList.Attributes.Add("alt-onclick", string.Format("AddPerson({0},{1},{2})", OwnerNodeID, personlistid, personid));
                        pnlPersonScript.Visible = true;
                    }
                    litJS.Text += string.Format("<script type='text/javascript'>{0}</script>", "jQuery('#remove-people-from-list').remove();");
                }
                else
                {
                    litJS.Text += string.Format("<script type='text/javascript'>{0}</script>", "jQuery('#add-people-to-list').remove();jQuery('#remove-people-from-list').remove();");

                }
            }
*/
        }
/*
        public int GetCount()
        {
            return Convert.ToInt16(Lists.Utilities.DataIO.GetListCount());
        }

        private string personlistid
        {
            get
            {

               return Lists.Utilities.DataIO.GetList();

            }
        }
        private string OwnerNodeID
        {
            get
            {
                return sm.Session().UserID.ToString();
            }
        }

*/
    }
    
}