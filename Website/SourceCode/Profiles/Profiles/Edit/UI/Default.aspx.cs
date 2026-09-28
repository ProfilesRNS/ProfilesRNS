using AjaxControlToolkit.HTMLEditor.ToolbarButton;
using Profiles.Framework.Utilities;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Xml;

namespace Profiles.Edit.UI
{
    public partial class Default : System.Web.UI.Page
    {
       
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        override protected void OnInit(EventArgs e)
        {
            if (Request.QueryString["subject"] != null&& Request.QueryString["predicateuri"] !=null)
            {
                try
                {
                    this.Subject = Convert.ToInt64(Request.QueryString["subject"]);

                }
                catch (Exception ex)
                {
                    Framework.Utilities.DebugLogging.Log("Edit module with no subject ID " + ex.Message);
                    Response.Redirect(Root.Domain);
                }

                DisplayParams dp = new DisplayParams();
                SessionManagement sessionManagement = new SessionManagement();
                Framework.Utilities.Session session = sessionManagement.Session();

                string presentationType = "";
                string tab2 = "";
                bool redirect = false;
                string redirectURL = null;
                string dataURLs = null;
                bool validURL = true;
                bool canEdit = false;
                string str = string.Empty;
                bool botindex = true;
                string layoutData = "{}";
                string editPropertyParams = "{}";

                try
                {
                    string connstr = ConfigurationHelper.GetConnectionString(session);
                    SqlConnection dbconnection = new SqlConnection(connstr);
                    SqlCommand dbcommand = new SqlCommand("[Display.].[GetDataURLs]");
                    dbcommand.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["COMMANDTIMEOUT"]);

                    SqlDataReader dbreader;
                    dbconnection.Open();
                    dbcommand.CommandType = CommandType.StoredProcedure;
                    //dbcommand.CommandTimeout = base.GetCommandTimeout();
                    dbcommand.Parameters.Add(new SqlParameter("@subject", this.Subject));
                    dbcommand.Parameters.Add(new SqlParameter("@predicate", null));
                    dbcommand.Parameters.Add(new SqlParameter("@object", null));
                    dbcommand.Parameters.Add(new SqlParameter("@tab", null));
                    //if (session.UserID > 0) dbcommand.Parameters.Add(new SqlParameter("@SessionID", session.SessionID));
                    dbcommand.Parameters.Add(new SqlParameter("@SessionID", session.SessionID));

                    dbcommand.Connection = dbconnection;
                    dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                    while (dbreader.Read())
                    {
                        validURL = (dbreader["ValidURL"] as int? == 1) ? true : false;
                        presentationType = dbreader["PresentationType"].ToString();
                        tab2 = dbreader["tab"].ToString();
                        redirect = (dbreader["Redirect"] as int? == 1) ? true : false;
                        redirectURL = dbreader["RedirectURL"].ToString();
                        dataURLs = dbreader["dataURLs"].ToString();
                        canEdit = (dbreader["canEdit"] as int? == 1) ? true : false;
                        botindex = (dbreader["botIndex"] as int? == 1) ? true : false;
                        layoutData = dbreader["layoutData"].ToString();
                    }

                    if (!dbreader.IsClosed)
                        dbreader.Close();

                    SqlCommand dbcommand2 = new SqlCommand("[Edit.Module].[GetEditPropertyParams]");
                    dbcommand2.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["COMMANDTIMEOUT"]);

                    SqlDataReader dbreader2;
                    dbconnection.Open();
                    dbcommand2.CommandType = CommandType.StoredProcedure;
                    //dbcommand.CommandTimeout = base.GetCommandTimeout();
                    dbcommand2.Parameters.Add(new SqlParameter("@subject", this.Subject));
                    dbcommand2.Parameters.Add(new SqlParameter("@PropertyURI", Request.QueryString["predicateuri"].Replace('!', '#')));
                    //if (session.UserID > 0) dbcommand.Parameters.Add(new SqlParameter("@SessionID", session.SessionID));
                    dbcommand2.Parameters.Add(new SqlParameter("@SessionID", session.SessionID));

                    dbcommand2.Connection = dbconnection;
                    dbreader2 = dbcommand2.ExecuteReader(CommandBehavior.CloseConnection);

                    while (dbreader2.Read())
                    {
                        editPropertyParams = dbreader2["editPropertyParams"].ToString();
                    }

                    if (!dbreader2.IsClosed)
                        dbreader2.Close();

                }
                catch (Exception ex) { Framework.Utilities.DebugLogging.Log($"Edit/UI/Display.aspx.cs : {ex.Message}"); }

                string sessionInfo = ConfigurationHelper.GetSessionInfoJavascriptObject(session);
                string g = ConfigurationHelper.GlobalJavascriptVariablesProfilePage.Replace("{dataURLs}", dataURLs + "'; g.editPropertyParams='" + editPropertyParams).Replace("{tab}", "").Replace("{preLoad}", layoutData.Replace("'", "\\'"));
                Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();

                this.HtmlFileName = "EditProperty.html";

                dp.HTML = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/StaticFiles/html-templates/EditProperty.html");
                dp.HTML = dp.HTML.Replace("{profilesPath}", ConfigurationHelper.ProfilesRootRelativePath)
                    .Replace("{globalVariables}", g)
                    .Replace("{SessionInfo}", sessionInfo)
                    .Replace("{metaDescription}", metaDescription);



                //string propertyListJson = data.GetPropertyListJson(this.Subject);
                

                litText.Text = dp.HTML;
                //litText.Text += litText.Text = $"<script>var propertyList ={propertyListJson};</script>";




            }
            else { Response.Redirect(Root.Domain); }
        }

        private Int64 Subject { get; set; }
        private string HtmlFileName { get; set; }
        private string metaDescription { get; set; }
        private string pageScriptRefs { get; set; }
        private string pageLinkRefs { get; set; }
        private class DisplayParams
        {
            public bool Redirect { get; set; } = false;
            public string RedirectURL { get; set; } = string.Empty;
            public string DataURLs { get; set; } = string.Empty;
            public bool ValidURL { get; set; } = true;
            public string HTML { get; set; } = string.Empty;
            public string PropertList {  get; set; } = string.Empty;
        }
    }

}