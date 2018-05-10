/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

using Profiles.Framework.Utilities;

namespace Profiles.GroupAdmin.Utilities
{
    public class DataIO : Profiles.Framework.Utilities.DataIO
    {

        public void AddGroup(string groupName, string endDate)
        {
            SessionManagement sm = new SessionManagement();

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Profile.Data].[Group.AddUpdateGroup]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@GroupName", groupName));
                if (endDate.Trim().Length > 0) dbcommand.Parameters.Add(new SqlParameter("@EndDate", endDate));
                //if (visibility != -50) dbcommand.Parameters.Add(new SqlParameter("@ViewSecurityGroup", visibility));

                SqlParameter error = new SqlParameter("@error", null);
                error.DbType = DbType.Boolean;
                error.Direction = ParameterDirection.Output;
                dbcommand.Parameters.Add(error);

                SqlParameter nodeid = new SqlParameter("@NodeID", null);
                nodeid.DbType = DbType.Int64;
                nodeid.Direction = ParameterDirection.Output;
                dbcommand.Parameters.Add(nodeid);

                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }


        }

        public void UpdateGroup(int groupID, long groupNodeID, string groupName, string endDate)
        {
            SessionManagement sm = new SessionManagement();
            Cache.AlterDependency(groupNodeID.ToString());

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Profile.Data].[Group.AddUpdateGroup]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@ExistingGroupID", groupID));
                dbcommand.Parameters.Add(new SqlParameter("@GroupName", groupName));
                dbcommand.Parameters.Add(new SqlParameter("@EndDate", endDate));
                //dbcommand.Parameters.Add(new SqlParameter("@ViewSecurityGroup", visibility));

                SqlParameter error = new SqlParameter("@error", null);
                error.DbType = DbType.Boolean;
                error.Direction = ParameterDirection.Output;
                dbcommand.Parameters.Add(error);

                SqlParameter nodeid = new SqlParameter("@NodeID", null);
                nodeid.DbType = DbType.Int64;
                nodeid.Direction = ParameterDirection.Output;
                dbcommand.Parameters.Add(nodeid);

                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }


        }

        public SqlDataReader GetActiveGroups()
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

                dbcommand.CommandText = "[Profile.Data].[Group.GetGroups]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return dbreader;
        }

        public SqlDataReader GetDeletedGroups()
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

                dbcommand.CommandText = "[Profile.Data].[Group.GetGroups]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@ShowDeletedGroups", 1));

                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return dbreader;
        }

        public void DeleteGroup(int groupID, long groupNodeID)
        {
            SessionManagement sm = new SessionManagement();
            Cache.AlterDependency(groupNodeID.ToString());

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Profile.Data].[Group.DeleteRestoreGroup]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@GroupID", groupID));

                SqlParameter error = new SqlParameter("@error", null);
                error.DbType = DbType.Boolean;
                error.Direction = ParameterDirection.Output;
                dbcommand.Parameters.Add(error);

                SqlParameter nodeid = new SqlParameter("@NodeID", null);
                nodeid.DbType = DbType.Int64;
                nodeid.Direction = ParameterDirection.Output;
                dbcommand.Parameters.Add(nodeid);

                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }


        }


        public void RestoreGroup(int groupID)
        {
            SessionManagement sm = new SessionManagement();

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Profile.Data].[Group.DeleteRestoreGroup]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@GroupID", groupID));
                dbcommand.Parameters.Add(new SqlParameter("@RestoreGroup", 1));

                SqlParameter error = new SqlParameter("@error", null);
                error.DbType = DbType.Boolean;
                error.Direction = ParameterDirection.Output;
                dbcommand.Parameters.Add(error);

                SqlParameter nodeid = new SqlParameter("@NodeID", null);
                nodeid.DbType = DbType.Int64;
                nodeid.Direction = ParameterDirection.Output;
                dbcommand.Parameters.Add(nodeid);

                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }


        }

    }

}
