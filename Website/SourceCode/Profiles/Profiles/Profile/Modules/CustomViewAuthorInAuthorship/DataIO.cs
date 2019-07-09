/*  
 
    Copyright (c) 2008-2011 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Collections;
using System.Data;
using System.Web;
using System.Net;
using System.IO;
using System.Text;

using System.Data.SqlClient;
using System.Xml;
using System.Configuration;


using Profiles.Framework.Utilities;

namespace Profiles.Profile.Modules.CustomViewAuthorInAuthorship
{
    public class DataIO : Profiles.Profile.Utilities.DataIO
    {
        public string GetJournalHeadingsForProfileJSON(RDFTriple request)
        {
            string str = string.Empty;


            if (Framework.Utilities.Cache.FetchObject(request.Key + "GetJournalHeadingsForProfile") == null)
            {
                try
                {
                    string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                    SqlConnection dbconnection = new SqlConnection(connstr);
                    SqlCommand dbcommand = new SqlCommand("[Profile.Module].[CustomViewAuthorInAuthorship.GetJournalHeadings]");

                    SqlDataReader dbreader;
                    dbconnection.Open();
                    dbcommand.CommandType = CommandType.StoredProcedure;
                    dbcommand.CommandTimeout = base.GetCommandTimeout();
                    dbcommand.Parameters.Add(new SqlParameter("@nodeid", request.Subject));
                    dbcommand.Parameters.Add(new SqlParameter("@sessionid", request.Session.SessionID));

                    dbcommand.Connection = dbconnection;
                    dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                    while (dbreader.Read())
                        str += dbreader[0].ToString();

                    Framework.Utilities.DebugLogging.Log(str);

                    if (!dbreader.IsClosed)
                        dbreader.Close();

                    Framework.Utilities.Cache.Set(request.Key + "GetJournalHeadingsForProfile", str);
                }
                catch (Exception ex)
                {
                    Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
                }
            }
            else
            {
                str = (string)Framework.Utilities.Cache.FetchObject(request.Key + "GetJournalHeadingsForProfile");
            }

            return str;
        }

        public string GetJournalHeadingsForProfile(RDFTriple request)
        {
            string str = string.Empty;
            str = "{ " +
                    "\"cols\": [ " +
                    "  {\"id\":\"\",\"label\":\"BroadJournalHeading\",\"pattern\":\"\",\"type\":\"string\"}, " +
                    "  {\"id\":\"\",\"label\":\"Count\",\"pattern\":\"\",\"type\":\"number\"} " +
                    " ], " +
                    "\"rows\": [ ";


            if (Framework.Utilities.Cache.FetchObject(request.Key + "GetJournalHeadingsForProfile") == null)
            {
                try
                {
                    string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                    SqlConnection dbconnection = new SqlConnection(connstr);
                    SqlCommand dbcommand = new SqlCommand("[Profile.Module].[CustomViewAuthorInAuthorship.GetJournalHeadings]");

                    SqlDataReader dbreader;
                    dbconnection.Open();
                    dbcommand.CommandType = CommandType.StoredProcedure;
                    dbcommand.CommandTimeout = base.GetCommandTimeout();
                    dbcommand.Parameters.Add(new SqlParameter("@nodeid", request.Subject));
                    dbcommand.Parameters.Add(new SqlParameter("@sessionid", request.Session.SessionID));

                    dbcommand.Connection = dbconnection;
                    dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
                    bool first = true;
                    //string colours = "\"p\":{  \"colors\": [";
                    string colours = "\"colors\": \"[";
                    string table = "\"altTxtTable\": \"<table><tr><th>Field</th><th>Publications</th><th>Weight</th></tr>";
                    while (dbreader.Read())
                    {
                        if (!first) { str += ","; colours += ","; }
                        first = false;
                        //str += "{ \"c\":[{\"v\":\"" + dbreader["BroadJournalHeading"].ToString() + " (" + dbreader["Count"].ToString() + " publications, " + string.Format("{0:0.#}", 10.0 * (double)dbreader["Weight"]) + "%)" + "\"},{\"v\":" + dbreader["Weight"].ToString() + "}]} ";
                        str += "{ \"c\":[{\"v\":\"" + dbreader["BroadJournalHeading"].ToString() + "\"},{\"v\":" + dbreader["Weight"].ToString() + "}]} ";
                        //colours += "\"#" + dbreader["Color"].ToString() + "\"";
                        colours += "#" + dbreader["Color"].ToString();
                        table += "<tr><td>" + dbreader["BroadJournalHeading"].ToString() + "</td><td>" + dbreader["Count"].ToString() + "</td><td>" + string.Format("{0:0.#}", 100.0 * (double)dbreader["Weight"]) + "%</td></tr>";
                    }


                    str += "]," + colours + "]\"," + table + "</table>\" }";

                    Framework.Utilities.DebugLogging.Log(str);

                    if (!dbreader.IsClosed)
                        dbreader.Close();

                    Framework.Utilities.Cache.Set(request.Key + "GetJournalHeadingsForProfile", str, request.Subject, request.Session.SessionID);
                }
                catch (Exception ex)
                {
                    Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
                }
            }
            else
            {
                str = (string)Framework.Utilities.Cache.FetchObject(request.Key + "GetJournalHeadingsForProfile");
            }

            return str;
        }

        public string GetPublicationByPMID(int pmid)
        {
            string str = string.Empty;


            //           if (Framework.Utilities.Cache.FetchObject(request.Key + "GetPublicationByPMID") == null)
            //          {
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);
                SqlCommand dbcommand = new SqlCommand("[Profile.Module].[CustomViewAuthorInAuthorship.GetPub]");

                SqlDataReader dbreader;
                dbconnection.Open();
                dbcommand.CommandType = CommandType.StoredProcedure;
                dbcommand.CommandTimeout = base.GetCommandTimeout();
                dbcommand.Parameters.Add(new SqlParameter("@pmid", pmid));

                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                while (dbreader.Read())
                    str += dbreader[0].ToString();

                Framework.Utilities.DebugLogging.Log(str);

                if (!dbreader.IsClosed)
                    dbreader.Close();

                //                   Framework.Utilities.Cache.Set(request.Key + "GetJournalHeadingsForProfile", str);
            }
            catch (Exception ex)
            {
                Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
            }
            //           }
            //           else
            //           {
            //               str = (string)Framework.Utilities.Cache.FetchObject(request.Key + "GetJournalHeadingsForProfile");
            //           }

            return str;
        }
    }
}
