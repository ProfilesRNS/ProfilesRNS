/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;

using Profiles.Framework.Utilities;

namespace Profiles.Proxy.Utilities
{
    public class DataIO : Profiles.Framework.Utilities.DataIO
    {


        public void DeleteProxy(string userid)
        {
            SessionManagement sm = new SessionManagement();

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[User.Account].[Proxy.DeleteDesignatedProxy]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@SessionID", sm.Session().SessionID));
                dbcommand.Parameters.Add(new SqlParameter("@UserID", userid));
                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }


        }


        public void InsertProxy(string userid)
        {
            SessionManagement sm = new SessionManagement();

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[User.Account].[Proxy.AddDesignatedProxy]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@SessionID", sm.Session().SessionID));
                dbcommand.Parameters.Add(new SqlParameter("@UserID", userid));
                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }


        }

        public SqlDataReader ManageProxies(string operation)
        {
            SqlDataReader dbreader = null;
            SessionManagement sm = new SessionManagement();

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;
                
                dbcommand.CommandText = "[User.Account].[Proxy.GetProxies]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();
                
                dbcommand.Parameters.Add(new SqlParameter("@SessionID", sm.Session().SessionID));
                dbcommand.Parameters.Add(new SqlParameter("@Operation", operation));
                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return dbreader;
        }
        public DataSet SearchProxies(string lastname, string firstname,
            string institution,string department, string division,int offset,int limit)
        {
            DataSet ds = new DataSet();
            SqlDataAdapter da;

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[user.account].[proxy.search]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@LastName",lastname));
                dbcommand.Parameters.Add(new SqlParameter("@FirstName", firstname));
                dbcommand.Parameters.Add(new SqlParameter("@Institution", institution));
                dbcommand.Parameters.Add(new SqlParameter("@Department", department));
                dbcommand.Parameters.Add(new SqlParameter("@Division", division));

                dbcommand.Parameters.Add(new SqlParameter("@offset", offset));
                dbcommand.Parameters.Add(new SqlParameter("@limit", limit));
                dbcommand.Connection = dbconnection;
                da = new SqlDataAdapter(dbcommand);
                da.Fill(ds, "Table");

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return ds;
        }

    }



}
