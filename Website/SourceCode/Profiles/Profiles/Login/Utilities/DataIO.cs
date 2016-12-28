/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using Profiles.Framework.Utilities;
using Profiles.Login.Objects;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Profiles.Login.Utilities
{
    public class DataIO : Framework.Utilities.DataIO
    {

        #region "USER MANAGEMENT"

        /// <summary>
        /// For User Authentication 
        /// </summary>
        /// <param name="user"></param>
        /// <param name="session"></param>
        public bool UserLogin(ref User user)
        {
            bool loginsuccess = false;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlParameter[] param = new SqlParameter[4];

                dbconnection.Open();

                param[0] = new SqlParameter("@UserName", user.UserName);
                param[1] = new SqlParameter("@Password", user.Password);


                param[2] = new SqlParameter("@UserID", null);
                param[2].DbType = DbType.Int32;
                param[2].Direction = ParameterDirection.Output;

                param[3] = new SqlParameter("@PersonID", null);
                param[3].DbType = DbType.Int32;
                param[3].Direction = ParameterDirection.Output;


                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[User.Account].[Authenticate]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                try
                {
                    user.UserID = Convert.ToInt32(param[2].Value.ToString());

                    if (param[3].Value != DBNull.Value)
                        user.PersonID = Convert.ToInt32(param[3].Value.ToString());
                }
                catch { }
                if (user.UserID != 0)
                {
                    loginsuccess = true;
                    sm.Session().UserID = user.UserID;
                    sm.Session().PersonID = user.PersonID;
                    sm.Session().LoginDate = DateTime.Now;
                    Session session = sm.Session();
                    SessionUpdate(ref session);
                    SessionActivityLog();
                }

            }
            catch (Exception ex)
            {

                throw ex;
            }

            return loginsuccess;

        }


        public bool UserLoginExternal(ref User user)
        {
            bool loginsuccess = false;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlParameter[] param = new SqlParameter[3];

                dbconnection.Open();

                param[0] = new SqlParameter("@UserName", user.UserName);

                param[1] = new SqlParameter("@UserID", null);
                param[1].DbType = DbType.Int32;
                param[1].Direction = ParameterDirection.Output;

                param[2] = new SqlParameter("@PersonID", null);
                param[2].DbType = DbType.Int32;
                param[2].Direction = ParameterDirection.Output;


                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[User.Account].[AuthenticateExternal]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                try
                {
                    user.UserID = Convert.ToInt32(param[1].Value.ToString());

                    if (param[2].Value != DBNull.Value)
                        user.PersonID = Convert.ToInt32(param[2].Value.ToString());
                }
                catch { }
                if (user.UserID != 0)
                {
                    loginsuccess = true;
                    sm.Session().UserID = user.UserID;
                    sm.Session().PersonID = user.PersonID;
                    sm.Session().LoginDate = DateTime.Now;
                    Session session = sm.Session();
                    SessionUpdate(ref session);
                    SessionActivityLog();
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return loginsuccess;
        }

        public bool CreatePasswordResetRequest(PasswordResetRequest passwordResetRequest)
        {
            bool createRequestSuccess = false;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlParameter[] param = new SqlParameter[5];

                dbconnection.Open();

                /* Input Parameters */
                param[0] = new SqlParameter("@EmailAddr", passwordResetRequest.EmailAddr);
                param[1] = new SqlParameter("@ResetToken", passwordResetRequest.ResetToken);
                param[2] = new SqlParameter("@RequestExpireDate", passwordResetRequest.RequestExpireDate); 
                param[3] = new SqlParameter("@ResendRequestsRemaining", passwordResetRequest.ResendRequestsRemaining);

                /* Output Parameters */
                param[4] = new SqlParameter("@CreateRequestSuccess", null);
                param[4].DbType = DbType.Int16;
                param[4].Direction = ParameterDirection.Output;

                /* For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value. */
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[User.Account].[CreatePasswordResetRequest]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                int createRequestSuccessInt = Convert.ToInt32(param[4].Value.ToString());

                createRequestSuccess = (createRequestSuccessInt == 1);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return createRequestSuccess;
        }

        public PasswordResetRequest GetPasswordResetRequestByEmail(string emailAddr)
        {
            PasswordResetRequest passwordResetRequest = null;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlParameter[] param = new SqlParameter[7];

                dbconnection.Open();

                /* Input Parameters */
                param[0] = new SqlParameter("@EmailAddr", emailAddr);

                /* Output Parameters */
                param[1] = new SqlParameter("@PasswordResetRequestID", null);
                param[1].DbType = DbType.Int32;
                param[1].Direction = ParameterDirection.Output;

                param[2] = new SqlParameter("@ResetToken", null);
                param[2].DbType = DbType.String;
                param[2].Size = 255;
                param[2].Direction = ParameterDirection.Output;

                param[3] = new SqlParameter("@CreateDate", null);
                param[3].DbType = DbType.DateTime;
                param[3].Direction = ParameterDirection.Output;

                param[4] = new SqlParameter("@RequestExpireDate", null);
                param[4].DbType = DbType.DateTime;
                param[4].Direction = ParameterDirection.Output;

                param[5] = new SqlParameter("@ResendRequestsRemaining", null);
                param[5].DbType = DbType.Int32;
                param[5].Direction = ParameterDirection.Output;

                param[6] = new SqlParameter("@ResetDate", null);
                param[6].DbType = DbType.DateTime;
                param[6].Direction = ParameterDirection.Output;

                /* For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value. */
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[User.Account].[GetPasswordResetRequestByEmail]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                if (param[1].Value != DBNull.Value)
                {
                    passwordResetRequest = new PasswordResetRequest();
                    passwordResetRequest.EmailAddr = emailAddr;
                    passwordResetRequest.PasswordResetRequestID = Convert.ToInt32(param[1].Value.ToString());
                    passwordResetRequest.ResetToken = param[2].Value.ToString();
                    passwordResetRequest.CreateDate = Convert.ToDateTime(param[3].Value.ToString());
                    passwordResetRequest.RequestExpireDate = Convert.ToDateTime(param[4].Value.ToString());
                    passwordResetRequest.ResendRequestsRemaining = Convert.ToInt32(param[5].Value.ToString());
                    if (param[6].Value != DBNull.Value)
                    {
                        passwordResetRequest.ResetDate = Convert.ToDateTime(param[6].Value.ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return passwordResetRequest;
        }

        public PasswordResetRequest GetPasswordResetRequestByToken(string resetToken)
        {
            PasswordResetRequest passwordResetRequest = null;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlParameter[] param = new SqlParameter[7];

                dbconnection.Open();

                /* Input Parameters */
                param[0] = new SqlParameter("@ResetToken", resetToken);

                /* Output Parameters */
                param[1] = new SqlParameter("@PasswordResetRequestID", null);
                param[1].DbType = DbType.Int32;
                param[1].Direction = ParameterDirection.Output;

                param[2] = new SqlParameter("@EmailAddr", null);
                param[2].DbType = DbType.String;
                param[2].Size = 255;
                param[2].Direction = ParameterDirection.Output;

                param[3] = new SqlParameter("@CreateDate", null);
                param[3].DbType = DbType.DateTime;
                param[3].Direction = ParameterDirection.Output;

                param[4] = new SqlParameter("@RequestExpireDate", null);
                param[4].DbType = DbType.DateTime;
                param[4].Direction = ParameterDirection.Output;

                param[5] = new SqlParameter("@ResendRequestsRemaining", null);
                param[5].DbType = DbType.Int32;
                param[5].Direction = ParameterDirection.Output;

                param[6] = new SqlParameter("@ResetDate", null);
                param[6].DbType = DbType.DateTime;
                param[6].Direction = ParameterDirection.Output;

                /* For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value. */
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[User.Account].[GetPasswordResetRequestByToken]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                if (param[1].Value != DBNull.Value)
                {
                    passwordResetRequest = new PasswordResetRequest();
                    passwordResetRequest.ResetToken = resetToken;
                    passwordResetRequest.PasswordResetRequestID = Convert.ToInt32(param[1].Value.ToString());
                    passwordResetRequest.EmailAddr = param[2].Value.ToString();
                    passwordResetRequest.CreateDate = Convert.ToDateTime(param[3].Value.ToString());
                    passwordResetRequest.RequestExpireDate = Convert.ToDateTime(param[4].Value.ToString());
                    passwordResetRequest.ResendRequestsRemaining = Convert.ToInt32(param[5].Value.ToString());
                    if (param[6].Value != DBNull.Value)
                    {
                        passwordResetRequest.ResetDate = Convert.ToDateTime(param[6].Value.ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return passwordResetRequest;
        }

        public bool UpdatePasswordResetRequest(string resetToken, DateTime resetDate)
        {
            bool updateSuccess = false;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlParameter[] param = new SqlParameter[3];

                dbconnection.Open();

                /* Input Parameters */
                param[0] = new SqlParameter("@ResetToken", resetToken);
                param[1] = new SqlParameter("@ResetDate", resetDate);

                /* Output Parameters */
                param[2] = new SqlParameter("@ResetRequestSuccess", null);
                param[2].DbType = DbType.Int16;
                param[2].Direction = ParameterDirection.Output;

                /* For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value. */
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[User.Account].[UpdatePasswordResetRequestResetDate]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                int updateResetRequestResendsRemainingSuccessInt = Convert.ToInt32(param[3].Value.ToString());

                updateSuccess = (updateResetRequestResendsRemainingSuccessInt == 1);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return updateSuccess;
        }

        public bool UpdatePasswordResetRequest(string resetToken, int resendRequestsRemaining)
        {
            bool updateSuccess = false;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlParameter[] param = new SqlParameter[3];

                dbconnection.Open();

                /* Input Parameters */
                param[0] = new SqlParameter("@ResetToken", resetToken);
                param[1] = new SqlParameter("@ResendRequestsRemaining", resendRequestsRemaining);

                /* Output Parameters */
                param[2] = new SqlParameter("@ResetRequestSuccess", null);
                param[2].DbType = DbType.Int16;
                param[2].Direction = ParameterDirection.Output;

                /* For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value. */
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[User.Account].[UpdatePasswordResetRequestRequestsRemaining]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                int updateResetRequestResendsRemainingSuccessInt = Convert.ToInt32(param[2].Value.ToString());

                updateSuccess = (updateResetRequestResendsRemainingSuccessInt == 1);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return updateSuccess;
        }

        public bool ResetPassword(string resetToken, string newPassword)
        {
            bool resetSuccess = false;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlParameter[] param = new SqlParameter[3];

                dbconnection.Open();

                /* Input Parameters */
                param[0] = new SqlParameter("@ResetToken", resetToken);
                param[1] = new SqlParameter("@NewPassword", newPassword);

                /* Output Parameters */
                param[2] = new SqlParameter("@ResetSuccess", null);
                param[2].DbType = DbType.Int16;
                param[2].Direction = ParameterDirection.Output;

                /* For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value. */
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[User.Account].[ResetPassword]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                int resetSuccessInt = Convert.ToInt32(param[2].Value.ToString());

                resetSuccess = (resetSuccessInt == 1);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return resetSuccess;
        }

        /// <summary>
        /// For User Authentication 
        /// </summary>
        /// <param name="user"></param>
        /// <param name="session"></param>
        public void UserLogout()
        {

            SessionManagement sm = new SessionManagement();
            sm.SessionLogout();

        }





        #endregion

    }
}
