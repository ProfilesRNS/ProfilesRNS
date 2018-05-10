using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Diagnostics;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public abstract class DALBOReader<BO> : DALBase where BO : DevelopmentBase.BaseClassBO
    {
        public int PersonID { get; private set; }
        public int LoggedInPersonID { get; private set; }
        public List<DevelopmentBase.BaseClassBO.ProjectRoles> Roles { get; private set; }
        public abstract BO PopulateFromRow(DataRow dr);
        public BO PopulateFromRow(DataTable dt, int rowNumber)
        {
            if ((dt.Rows.Count - 1) >= rowNumber)
            {
                return PopulateFromRow(dt.Rows[rowNumber]);
            }
            else
            {
                return GetNewBO();
            }
        }
        public virtual BO PopulateFromRowWithRelated(DataRow dr)
        {
            return PopulateFromRow(dr);
        }
        public BO PopulateFromRowWithRelated(DataTable dt, int rowNumber)
        {
            if ((dt.Rows.Count - 1) >= rowNumber)
            {
                return PopulateFromRowWithRelated(dt.Rows[rowNumber]);
            }
            else
            {
                return GetNewBO();
            }
        }
        protected BO GetNewBO()
        {
            return (BO)Activator.CreateInstance(typeof(BO));
        }
        public DALBOReader()
        {
            //SetInfo(appUser);
        }
        private void SetInfo(DevelopmentBase.AppUser appUser)
        {
            PersonID = appUser.PersonID;
            LoggedInPersonID = appUser.LoggedInPersonID;
            SetUserAndRoles(appUser.PersonID);
        }
        private void SetUserAndRoles()
        {
            //Roles = GetRoles(DevelopmentBase.Helpers.Authentication.PersonID);
        }
        private void SetUserAndRoles(int personID)
        {
            Roles = GetRoles(personID);
        }
        private List<DevelopmentBase.BaseClassBO.ProjectRoles> GetRoles(int personID)
        {
            List<DevelopmentBase.BaseClassBO.ProjectRoles> roles = new List<DevelopmentBase.BaseClassBO.ProjectRoles>();

            string friendlyMessage = "An error occurred while getting the users roles.";
            DataTable dataTable = new DataTable();

            DbConnection Conn = DbProviderFactories.GetFactory("System.Data.SqlClient").CreateConnection();
            Conn.ConnectionString = "Data Source=SQL;Initial Catalog=BUMC_Project;User ID=BUMC_Project_DAL;Password=kvcC0TjbUmQCruow;Max Pool Size=10000;Connection Timeout=120";
            DbCommand cmd = Conn.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "usp_GetProjectPersonRolesByPersonID";
            AddParam(ref cmd, "@PersonID", personID);
            using (Conn)
            {
                if ((Conn.State == ConnectionState.Closed))
                {
                    Conn.Open();
                }

                using (cmd)
                {
                    try
                    {
                        cmd.Connection = Conn;
                        DbDataReader rdr = cmd.ExecuteReader();
                        dataTable.Load(rdr, LoadOption.Upsert);
                        rdr.Close();
                    }
                    catch (InvalidOperationException ex)
                    {
                        foreach (DbParameter Param in cmd.Parameters)
                        {
                            if ((Param.Direction == ParameterDirection.Output) || (Param.Direction == ParameterDirection.InputOutput))
                            {
                                Exception iex = new Exception("Error occurred in FillTable() method. Possible reason: There is a command parameter with Value property not being set.", ex);
                                HandleError((new StackTrace().GetFrame(2).GetMethod().Name + (":" + cmd.CommandText)), friendlyMessage, iex);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        HandleError((new StackTrace().GetFrame(1).GetMethod().Name + (":" + cmd.CommandText)), friendlyMessage, ex);
                    }
                }
            }
            foreach (DataRow dr in dataTable.Rows)
            {
                if (!dr.IsNull("ProjectRoleID"))
                {
                    roles.Add((BaseClassBO.ProjectRoles)dr["ProjectRoleID"]);
                }
            }
            return roles;
        }
        public virtual bool HasRequiredRole(DevelopmentBase.BaseClassBO.ProjectRoles RequiredRole)
        {
            return HasRequiredRole(Roles, RequiredRole);
        }
        //public virtual bool IsUserInAnyRole(List<DevelopmentBase.BaseClassBO.ProjectRoles> RequiredRoles)
        //{
        //    return IsUserInAnyRole(Roles, RequiredRoles);
        //}
        public static bool HasRequiredRole(List<DevelopmentBase.BaseClassBO.ProjectRoles> roles, DevelopmentBase.BaseClassBO.ProjectRoles RequiredRole)
        {
            return roles.Contains(RequiredRole);
        }
        //public static bool IsUserInAnyRole(List<DevelopmentBase.BaseClassBO.ProjectRoles> roles, List<DevelopmentBase.BaseClassBO.ProjectRoles> RequiredRoles)
        //{
        //    if (roles.Contains(BaseClassBO.ProjectRoles.BUMC_Project_Super_User))
        //    {
        //        return true;
        //    }
        //    foreach (DevelopmentBase.BaseClassBO.ProjectRoles role in RequiredRoles)
        //    {
        //        if (roles.Contains(role))
        //        {
        //            return true;
        //        }
        //    }
        //    return false;
        //}
        protected List<BO> Gets(bool addBlank)
        {
            return PopulateCollectionObject(FillTable("[" + GetNewBO().TableSchemaName + "].[cg2_" + GetNewBO().Tablename + "sGet]"), addBlank);
        }
        protected System.Data.DataView Gets()
        {
            return FillTable("[" + GetNewBO().TableSchemaName + "].[cg2_" + GetNewBO().Tablename + "sGet]").DefaultView;
        }
        protected List<BO> PopulateCollectionObject(DataTable dt)
        {
            return PopulateCollectionObject(dt, false);
        }
        protected List<BO> PopulateCollectionObject(DataTable dt, bool blnAddBlank)
        {
            List<BO> myBOs = new List<BO>();
            if (blnAddBlank)
            {
                myBOs.Add(this.GetNewBO());
            }
            for (int intCounter = 0; intCounter < dt.Rows.Count; intCounter++)
            {
                myBOs.Add(PopulateFromRow(dt, intCounter));
            }
            return myBOs;
        }
        protected List<BO> PopulateCollectionObjectWithRelated(DataTable dt, bool blnAddBlank)
        {
            List<BO> myBOs = new List<BO>();
            if (blnAddBlank)
            {
                myBOs.Add(this.GetNewBO());
            }
            for (int intCounter = 0; intCounter < dt.Rows.Count; intCounter++)
            {
                myBOs.Add(PopulateFromRowWithRelated(dt.Rows[intCounter]));
            }
            return myBOs;
        }
    }
}
