
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Xml;

using Profiles.Framework.Utilities;
namespace Profiles.Framework.Modules.MainMenu
{
    public partial class MainMenu : BaseModule
    {

        System.Text.StringBuilder menulist;
        SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            menulist = new System.Text.StringBuilder();
            sm = new SessionManagement();

            DrawProfilesModule();

        }
        protected void Page_Init(object sender, EventArgs e)
        {

        }
        protected override void OnInit(EventArgs e)
        {


        }
        public MainMenu() : base() { }

        public MainMenu(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
          

        }

        private void DrawProfilesModule()
        {
            Int64 subject = 0;

            HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            HttpContext.Current.Response.Cache.SetExpires(DateTime.Now);
            HttpContext.Current.Response.Cache.SetNoServerCaching();
            HttpContext.Current.Response.Cache.SetNoStore();

            if (Request.QueryString["subject"] != null)
                subject = Convert.ToInt64(Request.QueryString["subject"]);

            Utilities.DataIO data = new Profiles.Framework.Utilities.DataIO();

            litSearchOptions.Text = "<li class='first'><a class='search-drop' href='" + Root.Domain + "/search'>Find People</a></li><li class='last'><a class='search-drop' style='border-bottom:1px solid #383737;' href='" + Root.Domain + "/search/all'>Find Everything</a></li>";
            litJs.Text = "";
            if (sm.Session().NodeID > 0)
            {
                litViewMyProfile.Text = "<li><a href='" + sm.Session().PersonURI + "'>View My Profile</a></li>";
            }


            litEditThisProfile.Text = "<li><a href='" + Root.Domain + "/login/default.aspx?pin=send&method=login&edit=true'>Edit My Profile</a></li>";

            if (base.MasterPage.CanEdit)
                litEditThisProfile.Text += "<li><div class=\"divider\"></div></li><li><a href='" + Root.Domain + "/edit/default.aspx?subject=" + subject.ToString() + "'>Edit This Profile</a></li>";

            if (sm.Session().UserID > 0)
            {
                litProxy.Text = "<li>Manage Proxies</li>";
                litProxy.Text = "<li><a href='" + Root.Domain + "/proxy/default.aspx?subject=" + sm.Session().NodeID.ToString() + "'>Manage Proxies</a></li>";
            }

            if (base.BaseData.SelectSingleNode(".").OuterXml != string.Empty && !Root.AbsolutePath.ToLower().Contains("/search"))
            {
                if (base.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description/@rdf:about", base.Namespaces) != null && !Root.AbsolutePath.ToLower().Contains("proxy"))
                {
                    string uri = this.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description/@rdf:about", base.Namespaces).Value;

                    string file = string.Empty;
                    string spostring = string.Empty;
                    string[] spoarray;

                    spostring = uri.ToLower().Replace(Root.Domain.ToLower() + "/profile/", "");
                    spoarray = spostring.Split('/');

                    for (int i = 0; i < spoarray.Length; i++)
                    {
                        file = file + spoarray[i] + "_";
                    }

                    file = file.Substring(0, file.Length - 1);

                    //litExportRDF.Text = "<li ><a style='border-bottom:1px solid #383737;border-left:1px solid #383737;border-right:1px solid  #383737;width:200px !important' href=\"" + uri + "/" + file + ".rdf\" target=\"_blank\">" + "Export This Page as RDF" + "</a></li>";

                    if (base.MasterPage != null)
                    {
                        System.Web.UI.HtmlControls.HtmlContainerControl Head1;
                        Head1 = (System.Web.UI.HtmlControls.HtmlContainerControl)base.MasterPage.FindControl("Head1");
                        //If a masterpage exists, you need to to create an ASP.Net Literal object and pass it to the masterpage so it can process the link in the Head block.
                        string link = "<link rel=\"alternate\" type=\"application/rdf+xml\" href=\"" + uri + "/" + file + ".rdf\" />";
                        Head1.Controls.Add(new LiteralControl(link));
                        litJs.Text += "<script type='text/javascript'>$('#useourdata').css('border-bottom','');</script>";
                    }
                }
            }
            //else
            //  litExportRDF.Visible = false;

            if (sm.Session().UserID > 0)
            {
                if (data.IsGroupAdmin(sm.Session().UserID))
                {
                    litGroups.Text = "<li><a href='" + Root.Domain + "/groupAdmin/default.aspx'>Manage Groups</a></li>";
                    groupListDivider.Visible = true;
                }
            }

            string loginclass = string.Empty;
            if (sm.Session().UserID == 0)
            {
                if (!Root.AbsolutePath.Contains("login"))
                {
                    litLogin.Text = "<a href='" + Root.Domain + "/login/default.aspx?method=login&redirectto=" + Root.Domain + Root.AbsolutePath + "'>Login</a> to edit your profile (add a photo, awards, links to other websites, etc.)";
                    loginclass = "pub";
                }
            }
            else
            {
                litLogOut.Text = "<li><a href='" + Root.Domain + "/login/default.aspx?method=logout&redirectto=" + Root.Domain + "/search'>Logout</a></li>";
                loginclass = "user";
            }

            if (sm.Session().UserID > 0)
            {
                // litDashboard.Text = "<a href ='" + ResolveUrl("~/dashboard/default.aspx?subject=" + sm.Session().NodeID.ToString()) + "'>My Dashboard </a>";
            }

            litJs.Text += "<script type='text/javascript'> var NAME = document.getElementById('prns-usrnav'); NAME.className = '" + loginclass + "';";

          
            if (sm.Session().UserID > 0 )
            {                
              
                //Change this to show two drop down items based on the count.
                MyLists.Visible = true;
            }
            else if (sm.Session().UserID == 0)
            {
                MyLists.Visible = false;
                litJs.Text += " $('#navMyLists').remove(); $('#ListDivider').remove();";
            }


            litJs.Text += "</script>";
            UserHistory uh = new UserHistory();

            ProfileHistory.RDFData = base.BaseData;
            ProfileHistory.PresentationXML = base.MasterPage.PresentationXML;
            ProfileHistory.Namespaces = base.Namespaces;

        }
    }
}