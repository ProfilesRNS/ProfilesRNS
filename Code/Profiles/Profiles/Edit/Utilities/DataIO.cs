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

namespace Profiles.Edit.Utilities
{
    public class DataIO : Framework.Utilities.DataIO
    {
        public int GetPersonID(Int64 nodeid)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlDataReader reader;
            int personid = 0;

            try
            {

                dbconnection.Open();


                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                reader = GetDBCommand(connstr, "select i.internalid from  [RDF.Stage].internalnodemap i with(nolock) where i.nodeid = " + nodeid.ToString(), CommandType.Text, CommandBehavior.CloseConnection, null).ExecuteReader();
                while (reader.Read())
                {
                    personid = Convert.ToInt32(reader[0]);
                }

                reader.Close();

                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return personid;
        }

        public bool CheckPublicationExists(string mpid)
        {

            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);

            SqlParameter[] param = new SqlParameter[2];

            bool exists = false;

            try
            {

                dbconnection.Open();

                param[0] = new SqlParameter("@pmid", mpid);

                param[1] = new SqlParameter("@exists", null);
                param[1].DbType = DbType.Boolean;
                param[1].Direction = ParameterDirection.Output;

                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[Profile.Data].[Publication.DoesPublicationExist]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                SqlConnection.ClearPool(dbconnection);
                exists = Convert.ToBoolean(param[1].Value);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return exists;

        }

        public void UpdateEntityOnePerson(int personid)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);

            SqlParameter[] param = new SqlParameter[1];

            try
            {
                dbconnection.Open();

                param[0] = new SqlParameter("@personid", personid);
                SqlCommand comm = GetDBCommand(ref dbconnection, "[Profile.Data].[Publication.Entity.UpdateEntityOnePerson]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param);

                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(comm);

                comm.Connection.Close();

                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();

                if (HttpContext.Current.Request.QueryString["subjectid"] != null)
                {
                    Framework.Utilities.Cache.Remove("Node Dependency " + HttpContext.Current.Request.QueryString["subjectid"].ToString());
                    Framework.Utilities.Cache.CreateDependency(HttpContext.Current.Request.QueryString["subjectid"].ToString());

                }


            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }
        }

        public void AddPublication(string mpid, string pubmedxml)
        {

            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);

            SqlParameter[] param = new SqlParameter[2];

            try
            {

                dbconnection.Open();

                param[0] = new SqlParameter("@pmid", mpid);

                param[1] = new SqlParameter("@pubmedxml", pubmedxml);


                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[Profile.Data].[Publication.Pubmed.AddPubMedXML]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                SqlConnection.ClearPool(dbconnection);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }


        }

        public void AddPublication(int userid, int pmid)
        {

            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);

            SqlParameter[] param = new SqlParameter[2];

            try
            {
                dbconnection.Open();

                param[0] = new SqlParameter("@userid", userid);

                param[1] = new SqlParameter("@pmid", pmid);


                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(GetDBCommand(dbconnection, "[Profile.Data].[Publication.Pubmed.AddPublication]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();


            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }


        }

        public void DeletePublications(int personid, bool deletePMID, bool deleteMPID)
        {
            string skey = string.Empty;
            string sparam = string.Empty;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlCommand comm = new SqlCommand();

                comm.Parameters.Add(new SqlParameter("PersonID", personid));
                comm.Parameters.Add(new SqlParameter("deletePMID", deletePMID));

                comm.Parameters.Add(new SqlParameter("deleteMPID", deleteMPID));
                comm.Connection = dbconnection;
                comm.Connection.Open();
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandText = "[Profile.Data].[Publication.DeleteAllPublications]";
                comm.ExecuteScalar();

                comm.Connection.Close();

                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();

                if (deleteMPID)
                    this.UpdateEntityOnePerson(personid);


            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }


        }

        public void DeleteOnePublication(int personid, string pubid)
        {
            string skey = string.Empty;
            string sparam = string.Empty;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlCommand comm = new SqlCommand();

                comm.Parameters.Add(new SqlParameter("PersonID", personid));
                comm.Parameters.Add(new SqlParameter("PubID", pubid));


                comm.Connection = dbconnection;
                comm.Connection.Open();
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandText = "[Profile.Data].[Publication.DeleteOnePublication]";
                comm.ExecuteScalar();

                comm.Connection.Close();

                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();

                this.UpdateEntityOnePerson(personid);


            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }


        }

        public void EditCustomPublication(Hashtable parameters)
        {
            string skey = string.Empty;
            string sparam = string.Empty;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlCommand comm = new SqlCommand();


                foreach (object key in parameters.Keys)
                {
                    skey = (string)key;
                    sparam = (string)parameters[skey].ToString();
                    comm.Parameters.Add(new SqlParameter(skey, sparam));
                }

                comm.Connection = dbconnection;
                comm.Connection.Open();
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandText = "[Profile.Data].[Publication.MyPub.UpdatePublication]";
                comm.ExecuteScalar();

                comm.Connection.Close();

                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }


        }

        public void AddCustomPublication(Hashtable parameters, int personid)
        {
            string skey = string.Empty;
            string sparam = string.Empty;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlCommand comm = new SqlCommand();

                string s = string.Empty;

                foreach (object key in parameters.Keys)
                {
                    skey = (string)key;
                    sparam = (string)parameters[skey].ToString();
                    comm.Parameters.Add(new SqlParameter(skey, sparam));

                    s = s + skey + "='" + sparam + "'";

                }

                comm.Connection = dbconnection;
                comm.Connection.Open();
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandText = "[Profile.Data].[Publication.MyPub.AddPublication]";
                comm.ExecuteScalar();

                comm.Connection.Close();

                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();

                this.UpdateEntityOnePerson(personid);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }


        }

        public List<PublicationState> GetPubs(int personid)
        {

            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlDataReader reader;

            SqlParameter[] param = null;
            List<PublicationState> pubs = new List<PublicationState>();
            string rownum = string.Empty;
            string reference = string.Empty;
            Int32 pmid = 0;
            string mpid = string.Empty;
            string category = string.Empty;
            string url = string.Empty;
            string pubdate = string.Empty;
            string frompubmed = string.Empty;



            try
            {

                dbconnection.Open();

                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                reader = GetDBCommand(dbconnection, "exec [Profile.Data].[Publication.GetPersonPublications] " + personid.ToString(), CommandType.Text, CommandBehavior.CloseConnection, param).ExecuteReader();


                while (reader.Read())
                {
                    rownum = reader["rownum"].ToString();
                    reference = reader["reference"].ToString();
                    if (reader["pmid"] != DBNull.Value)
                        pmid = Convert.ToInt32(reader["pmid"].ToString());

                    if (reader["pmid"] != DBNull.Value)
                        mpid = reader["mpid"].ToString();

                    if (reader["category"] != DBNull.Value)
                        category = reader["category"].ToString();

                    url = reader["url"].ToString();
                    pubdate = reader["pubdate"].ToString();
                    frompubmed = reader["frompubmed"].ToString();

                    pubs.Add(new PublicationState(rownum,
                        reference,
                        pmid,
                        mpid,
                        category,
                        url,
                        Convert.ToDateTime(pubdate),
                       Convert.ToBoolean(frompubmed)));
                }

                if (!reader.IsClosed)
                    reader.Close();

                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return pubs;


        }

        public SqlDataReader GetCustomPub(string mpid)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlDataReader reader;

            SqlParameter[] param = null;

            try
            {
                dbconnection.Open();

                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                reader = GetDBCommand(dbconnection, "exec [Profile.Data].[Publication.MyPub.GetPublication]  '" + mpid.ToString() + "'", CommandType.Text, CommandBehavior.CloseConnection, param).ExecuteReader();
            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return reader;

        }



        public bool SaveImage(Int32 personid, byte[] image)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            image = this.ResizeImageFile(image, 150);

            SqlConnection dbconnection = new SqlConnection(connstr);

            SqlCommand comm = new SqlCommand();
            try
            {
                dbconnection.Open();
                comm.Connection = dbconnection;
                comm.CommandType = CommandType.Text;

                //Save this chestnut for when we edit 
                using (SqlCommand cmd = new SqlCommand("exec [Profile.Data].[Person.AddPhoto] @Personid,@Photo", dbconnection))
                {
                    // Replace 8000, below, with the correct size of the field
                    cmd.Parameters.Add("@Personid", SqlDbType.Int).Value = personid;
                    cmd.Parameters.Add("@Photo", SqlDbType.VarBinary).Value = image;
                    cmd.ExecuteNonQuery();
                    cmd.Connection.Close();
                }

                comm.Connection.Close();

                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }



            return true;


        }

        public byte[] ResizeImageFile(byte[] imageFile, int targetSize)
        {
            System.Drawing.Image original = System.Drawing.Image.FromStream(new System.IO.MemoryStream(imageFile));
            int targetH, targetW;
            if (original.Height > original.Width)
            {
                targetH = targetSize;
                targetW = (int)(original.Width * ((float)targetSize / (float)original.Height));
            }
            else
            {
                targetW = targetSize;
                targetH = (int)(original.Height * ((float)targetSize / (float)original.Width));
            }
            System.Drawing.Image imgPhoto = System.Drawing.Image.FromStream(new System.IO.MemoryStream(imageFile));
            // Create a new blank canvas.  The resized image will be drawn on this canvas.
            System.Drawing.Bitmap bmPhoto = new System.Drawing.Bitmap(targetW, targetH, System.Drawing.Imaging.PixelFormat.Format24bppRgb);
            bmPhoto.SetResolution(72, 72);
            System.Drawing.Graphics grPhoto = System.Drawing.Graphics.FromImage(bmPhoto);
            grPhoto.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
            grPhoto.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
            grPhoto.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
            grPhoto.DrawImage(imgPhoto, new System.Drawing.Rectangle(0, 0, targetW, targetH), 0, 0, original.Width, original.Height, System.Drawing.GraphicsUnit.Pixel);
            // Save out to memory and then to a file.  We dispose of all objects to make sure the files don't stay locked.
            System.IO.MemoryStream mm = new System.IO.MemoryStream();
            bmPhoto.Save(mm, System.Drawing.Imaging.ImageFormat.Jpeg);
            original.Dispose();
            imgPhoto.Dispose();
            bmPhoto.Dispose();
            grPhoto.Dispose();
            return mm.GetBuffer();
        }

        public Int64 GetStoreNode(string value)
        {

            StoreNodeRequest snr = new StoreNodeRequest();

            snr.Value = new StoreNodeParam();
            snr.Value.Value = value;
            snr.Value.ParamOrdinal = 0;

            snr.Langauge = new StoreNodeParam();
            snr.Langauge.Value = null;
            snr.Langauge.ParamOrdinal = 1;

            snr.DataType = new StoreNodeParam();
            snr.DataType.Value = null;
            snr.DataType.ParamOrdinal = 2;

            return this.GetNodeId(snr);

        }

        public bool DeleteTriple(Int64 subjectid, Int64 predicateid, Int64 objectid)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlCommand dbcommand = new SqlCommand();

            SqlParameter[] param = new SqlParameter[6];
            bool error = false;

            try
            {

                param[0] = new SqlParameter("@SubjectID", subjectid);
                param[1] = new SqlParameter("@PredicateID", predicateid);
                param[2] = new SqlParameter("@ObjectID", objectid);
                param[3] = new SqlParameter("@SessionID", sm.Session().SessionID);
                param[4] = new SqlParameter("@DeleteInverse", 1);

                param[5] = new SqlParameter("@Error", "");
                param[5].DbType = DbType.Boolean;
                param[5].Direction = ParameterDirection.Output;

                SqlCommand comm = GetDBCommand(ref dbconnection, "[RDF.].DeleteTriple", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param);

                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(comm);

                comm.Connection.Close();

                if (dbconnection.State == ConnectionState.Open)
                    dbconnection.Close();


                error = Convert.ToBoolean(param[5].Value);

                Framework.Utilities.Cache.Remove("Node Dependency " + subjectid.ToString());
                Framework.Utilities.Cache.CreateDependency(subjectid.ToString());


                if (error)
                    Framework.Utilities.DebugLogging.Log("Delete Triple blew up with the following values -- {[RDF.].DeleteTriple} DeleteInverse: 1 SubjectID:" + subjectid.ToString() + " PredicateID:" + predicateid.ToString() + " ObjectID:" + objectid.ToString() + " SessionID:" + sm.Session().SessionID);




            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;


        }

        public bool AddExistingEntity(Int64 subjectid, Int64 predicateid, Int64 objectid)
        {

            bool error = false;
            try
            {

                StoreTripleRequest str = new StoreTripleRequest();
                str.Subject = new StoreTripleParam();
                str.Subject.Value = subjectid;
                str.Subject.ParamOrdinal = 0;

                str.Predicate = new StoreTripleParam();
                str.Predicate.Value = predicateid;
                str.Predicate.ParamOrdinal = 1;

                str.Object = new StoreTripleParam();
                str.Object.Value = objectid;
                str.Object.ParamOrdinal = 2;

                str.StoreInverse = new StoreTripleParam();
                str.StoreInverse.Value = 1;
                str.StoreInverse.ParamOrdinal = 3;

                error = this.GetStoreTriple(str);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;

        }
        public Int64 AddNewEntity(string label, string classuri)
        {

            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);

            SqlParameter[] param = new SqlParameter[5];

            string error = string.Empty;

            dbconnection.Open();

            param[0] = new SqlParameter("@label", label);
            param[1] = new SqlParameter("@EntityClassURI", classuri);
            param[2] = new SqlParameter("@ForceNewEntity", 1);
            param[3] = new SqlParameter("@SessionID", sm.Session().SessionID);

            param[4] = new SqlParameter("@NodeID", null);
            param[4].DbType = DbType.Int64;
            param[4].Direction = ParameterDirection.Output;

            SqlCommand comm = GetDBCommand(ref dbconnection, "[RDF.].GetStoreNode", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param);

            //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
            ExecuteSQLDataCommand(comm);

            comm.Connection.Close();

            if (dbconnection.State == ConnectionState.Open)
                dbconnection.Close();




            return Convert.ToInt64(param[4].Value.ToString());

        }
        public bool AddLiteral(Int64 subjectid, Int64 predicateid, Int64 objectid)
        {

            bool error = false;
            try
            {

                StoreTripleRequest str = new StoreTripleRequest();
                str.Subject = new StoreTripleParam();
                str.Subject.Value = subjectid;
                str.Subject.ParamOrdinal = 0;

                str.Predicate = new StoreTripleParam();
                str.Predicate.Value = predicateid;
                str.Predicate.ParamOrdinal = 1;

                str.Object = new StoreTripleParam();
                str.Object.Value = objectid;
                str.Object.ParamOrdinal = 2;

                error = this.GetStoreTriple(str);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;

        }

        public bool MoveTripleUp(Int64 subjectid, Int64 predicateid, Int64 objectid)
        {

            bool error = false;
            try
            {

                StoreTripleRequest str = new StoreTripleRequest();
                str.Subject = new StoreTripleParam();
                str.Subject.Value = subjectid;
                str.Subject.ParamOrdinal = 0;

                str.Predicate = new StoreTripleParam();
                str.Predicate.Value = predicateid;
                str.Predicate.ParamOrdinal = 1;

                str.Object = new StoreTripleParam();
                str.Object.Value = objectid;
                str.Object.ParamOrdinal = 2;

                str.MoveUpOne = new StoreTripleParam();
                str.MoveUpOne.Value = 1;
                str.MoveUpOne.ParamOrdinal = 3;

                error = this.GetStoreTriple(str);


            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;

        }

        public bool MoveTripleDown(Int64 subjectid, Int64 predicateid, Int64 objectid)
        {


            bool error = false;
            try
            {
                StoreTripleRequest str = new StoreTripleRequest();
                str.Subject = new StoreTripleParam();
                str.Subject.Value = subjectid;
                str.Subject.ParamOrdinal = 0;

                str.Predicate = new StoreTripleParam();
                str.Predicate.Value = predicateid;
                str.Predicate.ParamOrdinal = 1;

                str.Object = new StoreTripleParam();
                str.Object.Value = objectid;
                str.Object.ParamOrdinal = 2;

                str.MoveDownOne = new StoreTripleParam();
                str.MoveDownOne.Value = 1;
                str.MoveDownOne.ParamOrdinal = 3;

                error = this.GetStoreTriple(str);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;

        }

        public bool UpdateLiteral(Int64 subjectid, Int64 predicateid, Int64 oldobjectid, Int64 newobjectid)
        {
            SessionManagement sm = new SessionManagement();

            bool error = false;

            try
            {
                StoreTripleRequest str = new StoreTripleRequest();
                str.Subject = new StoreTripleParam();
                str.Subject.Value = subjectid;
                str.Subject.ParamOrdinal = 0;

                str.Predicate = new StoreTripleParam();
                str.Predicate.Value = predicateid;
                str.Predicate.ParamOrdinal = 1;

                str.Object = new StoreTripleParam();
                str.Object.Value = newobjectid;
                str.Object.ParamOrdinal = 2;

                str.OldObject = new StoreTripleParam();
                str.OldObject.Value = oldobjectid;
                str.OldObject.ParamOrdinal = 3;

                error = this.GetStoreTriple(str);


            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;


        }

        public bool AddAward(Int64 subjectid, string label, string institution,
                    string startdate, string enddate)
        {
            bool error = false;
            try
            {

                StoreAwardReceiptRequest sarr = new StoreAwardReceiptRequest();
                sarr.AwardOrHonorForID = new StoreAwardReceiptParam();
                sarr.AwardOrHonorForID.Value = subjectid;
                sarr.AwardOrHonorForID.ParamOrdinal = 0;

                sarr.Label = new StoreAwardReceiptParam();
                sarr.Label.Value = label;
                sarr.Label.ParamOrdinal = 1;

                sarr.AwardConferedBy = new StoreAwardReceiptParam();
                sarr.AwardConferedBy.Value = institution;
                sarr.AwardConferedBy.ParamOrdinal = 2;

                sarr.StartDate = new StoreAwardReceiptParam();
                sarr.StartDate.Value = startdate;
                sarr.StartDate.ParamOrdinal = 3;

                sarr.EndDate = new StoreAwardReceiptParam();
                sarr.EndDate.Value = enddate;
                sarr.EndDate.ParamOrdinal = 4;

                error = this.StoreAwardReceipt(sarr);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;

        }

        public bool UpdateAward(string subjecturi, string label, string institution,
                    string startdate, string enddate)
        {
            bool error = false;
            try
            {

                StoreAwardReceiptRequest sarr = new StoreAwardReceiptRequest();
                sarr.ExistingAwardReceiptURI = new StoreAwardReceiptParam();
                sarr.ExistingAwardReceiptURI.Value = subjecturi;
                sarr.ExistingAwardReceiptURI.ParamOrdinal = 0;

                sarr.Label = new StoreAwardReceiptParam();
                sarr.Label.Value = label;
                sarr.Label.ParamOrdinal = 1;

                sarr.AwardConferedBy = new StoreAwardReceiptParam();
                sarr.AwardConferedBy.Value = institution;
                sarr.AwardConferedBy.ParamOrdinal = 2;

                sarr.StartDate = new StoreAwardReceiptParam();
                sarr.StartDate.Value = startdate;
                sarr.StartDate.ParamOrdinal = 3;

                sarr.EndDate = new StoreAwardReceiptParam();
                sarr.EndDate.Value = enddate;
                sarr.EndDate.ParamOrdinal = 4;

                sarr.AwardOrHonorForID = new StoreAwardReceiptParam();
                sarr.AwardOrHonorForID.Value = this.GetStoreNode(subjecturi).ToString();
                sarr.AwardOrHonorForID.ParamOrdinal = 5;
                error = this.StoreAwardReceipt(sarr);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;


        }

        private bool StoreAwardReceipt(StoreAwardReceiptRequest sarr)
        {

            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);

            SqlParameter[] param = new SqlParameter[sarr.Length];

            bool error = false;

            try
            {
                dbconnection.Open();

                if (sarr.ExistingAwardReceiptURI != null)
                    param[sarr.ExistingAwardReceiptURI.ParamOrdinal] = new SqlParameter("@ExistingAwardReceiptURI", sarr.ExistingAwardReceiptURI.Value);

                if (sarr.AwardOrHonorForID != null)
                    param[sarr.AwardOrHonorForID.ParamOrdinal] = new SqlParameter("@awardOrHonorForID", Convert.ToInt64(sarr.AwardOrHonorForID.Value));

                if (sarr.Label != null)
                    param[sarr.Label.ParamOrdinal] = new SqlParameter("@Label", sarr.Label.Value.ToString());

                if (sarr.AwardConferedBy != null)
                    param[sarr.AwardConferedBy.ParamOrdinal] = new SqlParameter("@awardConferredBy", sarr.AwardConferedBy.Value.ToString());

                if (sarr.StartDate != null)
                    param[sarr.StartDate.ParamOrdinal] = new SqlParameter("@startDate", sarr.StartDate.Value.ToString());

                if (sarr.EndDate != null)
                    param[sarr.EndDate.ParamOrdinal] = new SqlParameter("@endDate", sarr.EndDate.Value.ToString());


                param[sarr.Length - 3] = new SqlParameter("@sessionID", sm.Session().SessionID);

                param[sarr.Length - 2] = new SqlParameter("@error", null);
                param[sarr.Length - 2].DbType = DbType.Boolean;
                param[sarr.Length - 2].Direction = ParameterDirection.Output;

                param[sarr.Length - 1] = new SqlParameter("@nodeid", null);
                param[sarr.Length - 1].DbType = DbType.Int64;
                param[sarr.Length - 1].Direction = ParameterDirection.Output;


                SqlCommand comm = GetDBCommand(ref dbconnection, "[Edit.Module].[CustomEditAwardOrHonor.StoreItem]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param);
                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(comm);


                comm.Connection.Close();

                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();

                error = Convert.ToBoolean(param[sarr.Length - 2].Value);

                Framework.Utilities.Cache.Remove("Node Dependency " + sarr.AwardOrHonorForID.Value.ToString());
                Framework.Utilities.Cache.CreateDependency(sarr.AwardOrHonorForID.Value.ToString());

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;

        }

        private Int64 GetNodeId(StoreNodeRequest snr)
        {
            System.Web.HttpBrowserCapabilities browser = HttpContext.Current.Request.Browser;

            if (snr.Value.Value.ToString().Contains(Environment.NewLine) && browser.Browser == "IE")
            {
                snr.Value.Value = snr.Value.Value.ToString().Replace(Environment.NewLine, ("\n"));

            }

            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);


            SqlParameter[] param = new SqlParameter[snr.Length];

            string error = string.Empty;

            dbconnection.Open();


            if (snr.Value != null)
                param[snr.Value.ParamOrdinal] = new SqlParameter("@value", snr.Value.Value);

            if (snr.Langauge != null)
                param[snr.Langauge.ParamOrdinal] = new SqlParameter("@language", null);

            if (snr.DataType != null)
                param[snr.DataType.ParamOrdinal] = new SqlParameter("@DataType", null);

            param[snr.Length - 3] = new SqlParameter("@SessionID", sm.Session().SessionID);

            param[snr.Length - 2] = new SqlParameter("@Error", null);
            param[snr.Length - 2].Size = 1;
            param[snr.Length - 2].DbType = DbType.String;
            param[snr.Length - 2].Direction = ParameterDirection.Output;
            param[snr.Length - 1] = new SqlParameter("@NodeID", null);
            param[snr.Length - 1].DbType = DbType.Int64;
            param[snr.Length - 1].Direction = ParameterDirection.Output;

            using (var cmd = GetDBCommand(dbconnection, "[RDF.].GetStoreNode", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param))
            {
                try
                {
                    //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                    ExecuteSQLDataCommand(cmd);
                }
                finally
                {
                    SqlConnection.ClearPool(dbconnection);
                    cmd.Connection.Close();
                    cmd.Dispose();
                }
            }


            return Convert.ToInt64(param[snr.Length - 1].Value.ToString());

        }

        private bool GetStoreTriple(StoreTripleRequest str)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);

            SqlParameter[] param = new SqlParameter[str.Length];

            bool error = false;

            try
            {

                dbconnection.Open();

                if (str.Subject != null)
                    param[str.Subject.ParamOrdinal] = new SqlParameter("@subjectid", Convert.ToInt64(str.Subject.Value));

                if (str.Predicate != null)
                    param[str.Predicate.ParamOrdinal] = new SqlParameter("@predicateid", Convert.ToInt64(str.Predicate.Value));

                if (str.Object != null)
                    param[str.Object.ParamOrdinal] = new SqlParameter("@objectid", Convert.ToInt64(str.Object.Value));

                if (str.OldObject != null)
                    param[str.OldObject.ParamOrdinal] = new SqlParameter("@oldobjectid", Convert.ToInt64(str.OldObject.Value));

                if (str.MoveUpOne != null)
                    param[str.MoveUpOne.ParamOrdinal] = new SqlParameter("@MoveUpOne", Convert.ToInt16(str.MoveUpOne.Value));

                if (str.MoveDownOne != null)
                    param[str.MoveDownOne.ParamOrdinal] = new SqlParameter("@MoveDownOne", Convert.ToInt16(str.MoveDownOne.Value));

                if (str.StoreInverse != null)
                    param[str.StoreInverse.ParamOrdinal] = new SqlParameter("@StoreInverse", Convert.ToInt16(str.StoreInverse.Value));

                param[str.Length - 2] = new SqlParameter("@sessionID", sm.Session().SessionID);

                param[str.Length - 1] = new SqlParameter("@error", null);
                param[str.Length - 1].DbType = DbType.Boolean;
                param[str.Length - 1].Direction = ParameterDirection.Output;

                using (var cmd = GetDBCommand("", "[RDF.].GetStoreTriple", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param))
                {

                    //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                    ExecuteSQLDataCommand(cmd);
                    cmd.Connection.Close();

                }
                error = Convert.ToBoolean(param[str.Length - 1].Value);

                Framework.Utilities.Cache.Remove("Node Dependency " + str.Subject.Value.ToString());
                Framework.Utilities.Cache.CreateDependency(str.Subject.Value.ToString());

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;

        }

        public bool UpdateSecuritySetting(Int64 subjectid, Int64 predicateid, int securitygroup)
        {

            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlParameter[] param = new SqlParameter[3];

            bool error = false;

            try
            {

                dbconnection.Open();

                param[0] = new SqlParameter("@NodeID", subjectid);
                param[1] = new SqlParameter("@PropertyID", predicateid);

                param[2] = new SqlParameter("@ViewSecurityGroup", securitygroup);

                SqlCommand comm = GetDBCommand(ref dbconnection, "[RDF.].SetNodePropertySecurity", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param);


                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(comm);


                comm.Connection.Close();
                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();

                Framework.Utilities.Cache.Remove("Node Dependency " + subjectid.ToString());
                Framework.Utilities.Cache.CreateDependency(subjectid.ToString());


            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                error = true;
                throw new Exception(e.Message);

            }

            return error;

        }
        public XmlDocument GetURIRelLink(string URL, ref string passeduri)
        {

            string result = string.Empty;
            XmlDocument rawdata = new XmlDocument();
            string rawhtml = string.Empty;
            XmlDocument htmlhead = new XmlDocument();
            try
            {
                HttpWebRequest request = null;
                request = (HttpWebRequest)WebRequest.Create(URL);
                request.Method = "POST";
                request.ContentType = "application/rdf+xml";
                request.ContentLength = URL.Length;

                using (Stream writeStream = request.GetRequestStream())
                {
                    UTF8Encoding encoding = new UTF8Encoding();
                    byte[] bytes = encoding.GetBytes(URL);
                    writeStream.Write(bytes, 0, bytes.Length);
                }

                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                {
                    using (Stream responseStream = response.GetResponseStream())
                    {
                        using (StreamReader readStream = new StreamReader(responseStream, Encoding.UTF8))
                        {
                            result = readStream.ReadToEnd();
                            readStream.Close();
                        }

                        responseStream.Close();
                    }
                }

                if (result.ToLower().Contains("<html"))
                {
                    string xml = result.Substring(result.ToLower().IndexOf("<head"), (result.ToLower().IndexOf("/head>") - result.ToLower().IndexOf("<head")) - 1) + "</head>";

                    rawhtml = result.Substring(result.ToLower().IndexOf("<head"), (result.ToLower().IndexOf("/head>") - result.ToLower().IndexOf("<head")) - 1);

                    int stopindex = 0;
                    int startindex = rawhtml.IndexOf("alternate");
                    for (int i = rawhtml.IndexOf("alternate"); i < rawhtml.Length; i++)
                    {
                        if (rawhtml.Substring(i, 2) == "/>")
                        {
                            stopindex = (i + 2) - startindex;

                            i = rawhtml.Length;
                        }
                    }

                    xml = rawhtml.Substring(startindex, stopindex);

                    if (xml.Contains("\""))
                    {
                        xml = "<link rel=\"" + xml;

                    }
                    else if (xml.Contains("'"))
                    {
                        xml = "<link rel='" + xml;
                    }
                    htmlhead.LoadXml(xml.ToLower());

                    //<link rel="alternate" type="application/rdf+xml" href="/individual/n25562/n25562.rdf" /> 

                    string uri = htmlhead.SelectSingleNode("link/@href").Value;

                    //If a prefix of the / char or ~ exists then remove them
                    if (uri.Substring(0, 1) == "~")
                        uri = uri.Substring(2);

                    if (uri.Substring(0, 1) == "/")
                        uri = uri.Substring(1);

                    if (!uri.Contains("http"))
                    {
                        string[] domianparse = URL.Split('/');

                        uri = domianparse[0] + "//" + domianparse[2] + "/" + uri;

                    }

                    passeduri = uri;
                    if (passeduri.Contains(".rdf"))
                    {
                        string[] rdfparse = passeduri.Split('/');
                        passeduri = passeduri.Replace("/" + rdfparse[rdfparse.Length - 1], "");

                    }

                    result = this.GetURIRelLink(uri, ref passeduri).OuterXml;

                }
                else if (result.Contains("rdf:RDF"))
                {
                    // do nothing, let it be loaded into the rawdata xml doc below.
                }
                else
                {
                    result = "<eof/>";
                }


                rawdata.LoadXml(result);

            }
            catch (Exception ex)
            {
                Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
            }

            return rawdata;
        }




        #region "Request and Param classes for edit of a triple"

        private class StoreTripleRequest
        {

            public StoreTripleRequest() { }

            public StoreTripleParam Subject { get; set; }
            public StoreTripleParam Predicate { get; set; }
            public StoreTripleParam Object { get; set; }
            public StoreTripleParam OldObject { get; set; }
            public StoreTripleParam MoveUpOne { get; set; }
            public StoreTripleParam MoveDownOne { get; set; }
            public StoreTripleParam StoreInverse { get; set; }

            public int Length
            {
                get
                {
                    int length = 0;

                    if (Subject != null)
                        length++;

                    if (Predicate != null)
                        length++;

                    if (Object != null)
                        length++;

                    if (OldObject != null)
                        length++;

                    if (MoveUpOne != null)
                        length++;

                    if (MoveDownOne != null)
                        length++;

                    if (StoreInverse != null)
                        length++;

                    //then add SessionID and Error params for the array creation
                    length = length + 2;


                    return length;

                }
            }

        }
        public class StoreTripleParam
        {
            public StoreTripleParam() { }

            public object Value { get; set; }
            public int ParamOrdinal { get; set; }

        }
        private class StoreNodeRequest
        {

            public StoreNodeRequest() { }

            public StoreNodeParam Value { get; set; }
            public StoreNodeParam Langauge { get; set; }
            public StoreNodeParam DataType { get; set; }
            public StoreNodeParam EntityClassURI { get; set; }
            public StoreNodeParam Label { get; set; }


            public int Length
            {
                get
                {
                    int length = 0;
                    //Don't include the NodeID in the count for Lenght, its an output param.
                    if (Value != null)
                        length++;

                    if (Langauge != null)
                        length++;

                    if (DataType != null)
                        length++;

                    if (EntityClassURI != null)
                        length++;

                    if (Label != null)
                        length++;


                    //then add SessionID, Error and return nodeID params for the array creation
                    length = length + 3;


                    return length;

                }
            }

        }
        public class StoreNodeParam
        {
            public StoreNodeParam() { }
            public object Value { get; set; }
            public int ParamOrdinal { get; set; }

        }
        public class StoreAwardReceiptParam
        {
            public StoreAwardReceiptParam() { }
            public object Value { get; set; }
            public int ParamOrdinal { get; set; }
        }
        private class StoreAwardReceiptRequest
        {
            public StoreAwardReceiptRequest() { }

            public StoreAwardReceiptParam ExistingAwardReceiptURI { get; set; }
            public StoreAwardReceiptParam AwardOrHonorForID { get; set; }
            public StoreAwardReceiptParam Label { get; set; }
            public StoreAwardReceiptParam AwardConferedBy { get; set; }
            public StoreAwardReceiptParam StartDate { get; set; }
            public StoreAwardReceiptParam EndDate { get; set; }


            public int Length
            {
                get
                {
                    int length = 0;

                    if (ExistingAwardReceiptURI != null)
                        length++;

                    if (AwardOrHonorForID != null)
                        length++;

                    if (Label != null)
                        length++;

                    if (AwardConferedBy != null)
                        length++;

                    if (EndDate != null)
                        length++;

                    if (StartDate != null)
                        length++;

                    //then add SessionID, Error and NodeID params for the array creation
                    length = length + 3;


                    return length;

                }
            }


        }
        #endregion

    }
}
