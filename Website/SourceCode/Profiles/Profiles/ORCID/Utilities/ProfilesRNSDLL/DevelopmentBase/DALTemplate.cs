using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.Common;
using System.Diagnostics;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{

    public abstract class DALTemplate<BO> : DALBOReader<BO> where BO : DevelopmentBase.BaseClassBO
    {
        # region Constructors
        public DALTemplate()
            : base()
        {
        }
        # endregion Constructors
        
        public abstract void GetIdentity(DbCommand cmd, BO bo);
        public abstract void GetParamsAll(ref DbCommand cmd, BO bo);
        public abstract void GetParamsPrimaryKey(ref DbCommand cmd, BO bo);
        public abstract void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, BO boBefore, BO bo, DbTransaction trans);
        public virtual void BizRules(BO bo, BO boBefore) { }
        public virtual void DBRulesCG(BO bo) { }

        protected abstract BO GetBOBefore(BO bo);

        protected virtual bool Add(BO bo)
        {
            return Add(bo, true);
        }
        protected bool Add(BO bo, bool checkBizRules)
        {
            return PerformDBAction(Add, bo, checkBizRules);
        }
        protected bool Add(BO bo, System.Data.Common.DbTransaction trans)
        {
            return Add(bo, trans, true);
        }
        protected bool Add(BO bo, System.Data.Common.DbTransaction trans, bool checkBizRules)
        {
            BO boBefore = GetNewBO();
            if (!CheckBizRules(bo, boBefore, checkBizRules))
            {
                return false;
            }
            try
            {
                DbCommand cmd = GetCommand("[" + bo.TableSchemaName + "].cg2_" + TableName + "Add");
                GetParamsAll(ref cmd, bo);
                cmd.Connection = trans.Connection;
                cmd.Transaction = trans;
                cmd.ExecuteNonQuery();
                GetIdentity(cmd, bo);
                LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Added, boBefore, bo, trans);
                bo.Message = "The record was added.";
                return true;
            }
            catch (Exception ex)
            {
                bo.Error += "An error occurred while adding the record.";
                HandleError(new StackTrace().GetFrame(1).GetMethod().Name, FriendlyExceptionMessage, ex);
                return false;
            }
        }
        protected bool Add(List<BO> bos)
        {
            bool hasError = false;
            DbConnection conn = Provider().CreateConnection();
            conn.ConnectionString = ConnectionStringEdit;

            using (conn)
            {
                if ((conn.State == ConnectionState.Closed))
                {
                    conn.Open();
                }
                using (DbTransaction trans = conn.BeginTransaction())
                {
                    try
                    {
                        foreach (BO bo in bos)
                        {
                            if (!Add(bo, trans, true))
                            {
                                hasError = true;
                            }
                        }
                        trans.Commit();
                        return !hasError;
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        foreach (BO bo in bos)
                        {
                            bo.Message = "An error occurred and the record was not added.";
                        }
                        HandleError(new StackTrace().GetFrame(1).GetMethod().Name, FriendlyExceptionMessage, ex);
                        return false;
                    }
                }
            }
        }
        protected bool Edit(BO bo)
        {
            // Default to checking the Business Rules (=param #2)
            return Edit(bo, true);
        }
        protected bool Edit(BO bo, bool checkBizRules)
        {
            return PerformDBAction(Edit, bo, checkBizRules);
        }
        protected bool Edit(BO bo, System.Data.Common.DbTransaction trans)
        {
            return Edit(bo, trans, true);
        }
        protected bool Edit(BO bo, System.Data.Common.DbTransaction trans, bool checkBizRules)
        {
            // get the values before the edit.
            BO boBefore = GetBOBefore(bo);
            if (!CheckBizRules(bo, boBefore, checkBizRules))
            {
                return false;
            }
            try
            {
                DbCommand cmd = GetCommand("[" + bo.TableSchemaName + "].cg2_" + TableName + "Edit");
                GetParamsAll(ref cmd, bo);
                cmd.Transaction = trans;
                cmd.Connection = trans.Connection;
                cmd.ExecuteNonQuery();
                LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Edited, boBefore, bo, trans);
                return true;
            }
            catch (Exception ex)
            {
                bo.Error += (new StackTrace().GetFrame(1).GetMethod().Name + (":" + cmds.ToString())) + ". " + ex.Message;
                return false;
            }

        }
        protected void Delete(BO bo)
        {
            PerformDBAction(Delete, bo, false);
        }
        protected bool Delete(BO bo, System.Data.Common.DbTransaction trans, bool checkBizRules)
        {
            // get the values before the delete.
            BO boNow = GetBOBefore(bo);
            BO boAfter = GetNewBO();
            try
            {
                DbCommand cmd = GetCommand("[" + bo.TableSchemaName + "].cg2_" + TableName + "Delete");
                GetParamsPrimaryKey(ref cmd, boNow);
                cmd.Transaction = trans;
                cmd.Connection = trans.Connection;
                cmd.ExecuteNonQuery();
                LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted, boNow, boAfter, trans);
                return true;
            }
            catch (Exception ex)
            {
                bo.Error += (new StackTrace().GetFrame(1).GetMethod().Name + (":" + cmds.ToString())) + ". " + ex.Message;
                return false;
            }

        }
        protected int AddRecordLevelAuditTrail(int tableID, Int64 rowIdentifier, DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, DbTransaction trans)
        {
            ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail bo = new ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail();
            DbCommand cmd = GetCommand("[ORCID.].cg2_RecordLevelAuditTrailAdd");
            cmd.Transaction = trans;
            cmd.Connection = trans.Connection;
            DbParameter ParamRecordLevelAuditTrailID = cmd.CreateParameter();
            ParamRecordLevelAuditTrailID.ParameterName = "@recordLevelAuditTrailID";
            ParamRecordLevelAuditTrailID.Direction = ParameterDirection.Output;
            ParamRecordLevelAuditTrailID.Size = 4;
            ParamRecordLevelAuditTrailID.DbType = DbType.Int32;
            cmd.Parameters.Add(ParamRecordLevelAuditTrailID);
            AddParam(ref cmd, "@metaTableID", tableID);
            AddParam(ref cmd, "@rowIdentifier", rowIdentifier);
            AddParam(ref cmd, "@RecordLevelAuditTypeID", (int)auditType);
            AddParam(ref cmd, "@createdDate", DateTime.Now);
            AddParam(ref cmd, "@createdBy", PersonID.ToString());
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                HandleError((new StackTrace().GetFrame(1).GetMethod().Name + (":" + cmd.CommandText)), FriendlyExceptionMessage, ex);
            }
            return int.Parse(cmd.Parameters["@recordLevelAuditTrailID"].Value.ToString());
        }
        protected string TableName
        {
            get
            {
                string className = typeof(BO).ToString();
                string tname = className.ToString().Split('.')[className.ToString().Split('.').Count() - 1];
                return tname;
            }
        }

        protected void LogIfChangedImage(int fieldID, DbCommand cmd, int recordLevelAuditTrailID, bool nowIsNull, bool beforeIsNull, string valueNow, string valueBefore)
        {
            // don't currently log changes to images.
        }
        protected void LogIfChanged(int recordLevelAuditTrailID, int fieldID, bool nowIsNull, bool beforeIsNull, object valueNow, object valueBefore, DbTransaction trans)
        {
            // check to see if the field value has changed.
            bool blnHasChanged = false;
            if (!nowIsNull || !beforeIsNull)
            {
                blnHasChanged = false;
                if (nowIsNull)
                {
                    blnHasChanged = true;
                }
                else if (beforeIsNull)
                {
                    blnHasChanged = true;
                }
                else if (valueNow.ToString() != valueBefore.ToString())
                {
                    blnHasChanged = true;
                }
                if (blnHasChanged)
                {
                    // Log that the field changed;
                    ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail bo = new ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail();
                    DbCommand cmd = GetCommand("[" + bo.TableSchemaName + "].cg2_FieldLevelAuditTrailAdd");
                    cmd.Connection = trans.Connection;
                    cmd.Transaction = trans;
                    AddParam(ref cmd, "@RecordLevelAuditTrailID", recordLevelAuditTrailID);
                    AddParam(ref cmd, "@MetaFieldID", fieldID);
                    if (!beforeIsNull)
                    {
                        AddParam(ref cmd, "@ValueBefore", valueBefore.ToString());
                    }
                    if (!nowIsNull)
                    {
                        AddParam(ref cmd, "@ValueAfter", valueNow.ToString());
                    }
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private bool CheckBizRules(BO bo, BO boBefore, bool checkBizRules)
        {
            if (checkBizRules)
            {
                BizRules(bo, boBefore);
            }
            DBRulesCG(bo);
            if (bo.HasError && (bo.Error == null || bo.Error.Equals(string.Empty)))
            {
                bo.Error += "Unable to save.  Please check the form for errors." + Environment.NewLine;
            }
            return !bo.HasError;
        }

        private bool PerformDBAction(DBActionDelegate method, BO bo, bool checkBizRules)
        {
            string methodname = method.Method.Name.ToLower();
            DbConnection conn = Provider().CreateConnection();
            conn.ConnectionString = ConnectionStringEdit;
            try
            {
                using (conn)
                {
                    if ((conn.State == ConnectionState.Closed))
                    {
                        conn.Open();
                    }
                    using (DbTransaction trans = conn.BeginTransaction())
                    {
                        try
                        {
                            if (method(bo, trans, checkBizRules))
                            {
                                trans.Commit();
                                bo.Message = "The record was " + methodname + "ed.";
                                return true;
                            }
                            else
                            {
                                trans.Rollback();
                                return false;
                            }
                        }
                        catch (Exception ex)
                        {
                            trans.Rollback();
                            bo.Error += "An error occurred and the record was not " + methodname + "ed." + Environment.NewLine;
                            HandleError(new StackTrace().GetFrame(1).GetMethod().Name, FriendlyExceptionMessage, ex);
                            return false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                bo.Error += "An error occurred and the record was not " + methodname + "ed." + Environment.NewLine;
                HandleError(new StackTrace().GetFrame(1).GetMethod().Name, FriendlyExceptionMessage, ex);
                return false;
            }
        }
         
        private delegate bool DBActionDelegate(BO bo, System.Data.Common.DbTransaction trans, bool checkBizRules);
    }
}
