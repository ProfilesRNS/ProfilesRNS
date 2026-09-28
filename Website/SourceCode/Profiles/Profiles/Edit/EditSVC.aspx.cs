using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using Profiles.Framework.Utilities;
using System.Web.Caching;

namespace Profiles.Edit
{
    public partial class EditSVC : System.Web.UI.Page, System.Web.SessionState.IRequiresSessionState
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Profiles.Profile.Modules.CustomViewAuthorInAuthorship.DataIO data = new Profiles.Profile.Modules.CustomViewAuthorInAuthorship.DataIO();

            //Profiles.Framework.Utilities.RDFTriple request = new RDFTriple(Convert.ToInt32(Request.QueryString["p"]));
            string str = null;
            SessionManagement sessionManagement = new SessionManagement();
            Framework.Utilities.Session session = sessionManagement.Session();
            string function = string.Empty;
			string s = string.Empty;
            string p = string.Empty;
			string v = string.Empty;
			string status = "ERROR";
           
			if (Request.QueryString["function"] != null) function = Request.QueryString["function"].ToString();
			if (Request.QueryString["s"] != null) s = Request.QueryString["s"].ToString();
			if (Request.QueryString["p"] != null) p = Request.QueryString["p"].ToString();
            p = p.Replace('!', '#');
            if (Request.QueryString["v"] != null) v = Request.QueryString["v"].ToString();

			string sessionID = session.SessionID;
			if (session.UserID == 0) // Not logged in return unauthorized (unauthenticated) response
			{
				Response.StatusCode = 401;
				Response.End();
			}
			if (!hasOwnerVisibilty(Int64.Parse(s), session)) // Logged in, but cannot view this page return Forbidden response
			{
				Response.StatusCode = 403;
				Response.End();
			}

			string connstr;


            if (string.Equals("GetData",function))
			{
				connstr = ConfigurationHelper.GetConnectionString(session);
				SqlConnection dbconnection = new SqlConnection(connstr);
				SqlCommand dbcommand = new SqlCommand("[Edit.Module].GetData");
				dbcommand.CommandTimeout = Convert.ToInt16(ConfigurationManager.AppSettings["COMMANDTIMEOUT"]);

				SqlDataReader dbreader;
				dbconnection.Open();
				dbcommand.CommandType = CommandType.StoredProcedure;
				//dbcommand.CommandTimeout = base.GetCommandTimeout();
				dbcommand.Parameters.Add(new SqlParameter("@subject", Int64.Parse(s)));
				dbcommand.Parameters.Add(new SqlParameter("@PropertyURI", p));
				if (!"".Equals(sessionID)) dbcommand.Parameters.Add(new SqlParameter("@SessionID", sessionID));

				dbcommand.Connection = dbconnection;
				dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
				
				string json = string.Empty;
				while (dbreader.Read())
				{
					json = dbreader[0].ToString();
					status = dbreader[1].ToString();
				}
                if (!dbreader.IsClosed)
                    dbreader.Close();
				
				if (string.Equals(status, "FORBIDDEN"))
				{
					Response.StatusCode = 403;
					Response.End();
				}
				if (string.Equals(status, "ERROR"))
				{
					Response.StatusCode = 500;
					Response.End();
				}	
					
				Response.ContentType = "application/json; charset=utf-8";
				Response.AppendHeader("Access-Control-Allow-Origin", "*");
				Response.AppendHeader("cache-control", "no-store");
				Response.Write(json);				
			}
			else if(string.Equals("UpdateVisibility",function))
			{
				connstr = ConfigurationHelper.GetConnectionString(session);
				SqlConnection dbconnection = new SqlConnection(connstr);
				SqlCommand dbcommand = new SqlCommand("[Edit.Module].[SetVisibility]");
				dbcommand.CommandTimeout = Convert.ToInt16(ConfigurationManager.AppSettings["COMMANDTIMEOUT"]);

				SqlDataReader dbreader;
				dbconnection.Open();
				dbcommand.CommandType = CommandType.StoredProcedure;
				//dbcommand.CommandTimeout = base.GetCommandTimeout();
				dbcommand.Parameters.Add(new SqlParameter("@subject", Int64.Parse(s)));
				dbcommand.Parameters.Add(new SqlParameter("@PropertyURI", p));
				dbcommand.Parameters.Add(new SqlParameter("@ViewSecurityGroup", Int64.Parse(v)));
				if (!"".Equals(sessionID)) dbcommand.Parameters.Add(new SqlParameter("@SessionID", sessionID));

				dbcommand.Connection = dbconnection;
				dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
				
				while (dbreader.Read())
				{
					status = dbreader[0].ToString();
				}
                if (!dbreader.IsClosed)
                    dbreader.Close();
				
				if (string.Equals(status, "FORBIDDEN"))
				{
					Response.StatusCode = 403;
					Response.End();
				}
				if (string.Equals(status, "ERROR"))
				{
					Response.StatusCode = 500;
					Response.End();
				}	
					
				Response.ContentType = "application/json; charset=utf-8";
				Response.AppendHeader("Access-Control-Allow-Origin", "*");
				Response.AppendHeader("cache-control", "no-store");
				Response.Write("{\"status\":\"SUCCESS\"}");					
			}
			else if(string.Equals("AddUpdateProperty",function))
			{
				if (!string.Equals(Request.HttpMethod, "POST"))
				{
					Response.StatusCode = 405;
					Response.End();
				}
				string body = new System.IO.StreamReader(Request.InputStream).ReadToEnd();
				
				connstr = ConfigurationHelper.GetConnectionString(session);
				SqlConnection dbconnection = new SqlConnection(connstr);
				SqlCommand dbcommand = new SqlCommand("[Edit.Module].[AddUpdateData]");
				dbcommand.CommandTimeout = Convert.ToInt16(ConfigurationManager.AppSettings["COMMANDTIMEOUT"]);

				SqlDataReader dbreader;
				dbconnection.Open();
				dbcommand.CommandType = CommandType.StoredProcedure;
				//dbcommand.CommandTimeout = base.GetCommandTimeout();
				dbcommand.Parameters.Add(new SqlParameter("@subject", Int64.Parse(s)));
				dbcommand.Parameters.Add(new SqlParameter("@PropertyURI", p));
				dbcommand.Parameters.Add(new SqlParameter("@json", body));
				if (!"".Equals(sessionID)) dbcommand.Parameters.Add(new SqlParameter("@SessionID", sessionID));

				dbcommand.Connection = dbconnection;
				dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
				
				while (dbreader.Read())
				{
					status = dbreader[0].ToString();
				}
                if (!dbreader.IsClosed)
                    dbreader.Close();
				
				if (string.Equals(status, "FORBIDDEN"))
				{
					Response.StatusCode = 403;
					Response.End();
				}
				if (string.Equals(status, "ERROR"))
				{
					Response.StatusCode = 500;
					Response.End();
				}	
					
				Response.ContentType = "application/json; charset=utf-8";
				Response.AppendHeader("Access-Control-Allow-Origin", "*");
				Response.AppendHeader("cache-control", "no-store");
                Response.Write("{\"status\":\"SUCCESS\"}");
            }
        }



        public bool hasOwnerVisibilty(Int64 NodeID, Framework.Utilities.Session session)
        {

            string canEdit = "";
            //String sessionKey = "SecurityGroup:" + session.ViewSecurityGroup.ToString();
            //string key = "s" + NodeID + sessionKey;
            //canEdit = (string)Framework.Utilities.Cache.FetchObject(key + "|canEdit");

            try
            {
                string connstr = ConfigurationHelper.GetConnectionString(session);
                using (var dbconnection = new SqlConnection(connstr))
                {
                    SqlCommand dbcommand = new SqlCommand("[RDF.Security].[CanEditNode]");

                    SqlDataReader dbreader;
                    dbconnection.Open();
                    dbcommand.CommandType = CommandType.StoredProcedure;
                    dbcommand.CommandTimeout = Convert.ToInt16(ConfigurationManager.AppSettings["COMMANDTIMEOUT"]);
                    dbcommand.Parameters.Add(new SqlParameter("@NodeID", NodeID));
                    dbcommand.Parameters.Add(new SqlParameter("@SessionID", session.SessionID));

                    dbcommand.Connection = dbconnection;

                    dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
                    while (dbreader.Read())
                        canEdit = dbreader[0].ToString();

                    if (!dbreader.IsClosed)
                        dbreader.Close();

                    //Framework.Utilities.Cache.Set(key + "|canEdit", canEdit, request.Subject, request.Session.SessionID);
                }
            }
            catch (Exception ex) { Framework.Utilities.DebugLogging.Log($"Profile/ProfileJsonSVC.aspx.cs : {ex.Message}"); }
            return canEdit == "True";
        }


    }
}