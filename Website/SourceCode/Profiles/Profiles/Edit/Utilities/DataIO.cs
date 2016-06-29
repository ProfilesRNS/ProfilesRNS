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

            using (SqlConnection dbconnection = new SqlConnection(connstr))
            {
                int personid = 0;

                try
                {
                    dbconnection.Open();
                    //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                    using (SqlDataReader reader = GetDBCommand(connstr, "select i.internalid from  [RDF.Stage].internalnodemap i with(nolock) where i.nodeid = " + nodeid.ToString(), CommandType.Text, CommandBehavior.CloseConnection, null).ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            personid = Convert.ToInt32(reader[0]);
                        }
                    }
                }
                catch (Exception e)
                {
                    Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                    throw new Exception(e.Message);
                }

                return personid;
            }
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
                    Framework.Utilities.Cache.AlterDependency(HttpContext.Current.Request.QueryString["subjectid"].ToString());

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

        public void AddPublication(int personID, long subjectID, int pmid, XmlDocument PropertyListXML)
        {
            ActivityLog(PropertyListXML, subjectID, "PMID", "" + pmid);
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);

            SqlParameter[] param = new SqlParameter[2];

            try
            {
                dbconnection.Open();

                param[0] = new SqlParameter("@userid", personID);

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

        public void DeletePublications(int personid, long subjectid, bool deletePMID, bool deleteMPID)
        {
            EditActivityLog(subjectid, "http://vivoweb.org/ontology/core#authorInAuthorship", null, deletePMID ? "deletePMID = true" : "deletePMID = false", deleteMPID ? "deleteMPID = true" : "deleteMPID = false");
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

        public void DeleteOnePublication(int personid, long subjectID, string pubid, XmlDocument PropertyListXML)
        {
            ActivityLog(PropertyListXML, subjectID, "PubID", pubid);
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

        public void EditCustomPublication(Hashtable parameters, long subjectID, XmlDocument PropertyListXML)
        {
            ActivityLog(PropertyListXML, subjectID, "MPID", parameters["@mpid"].ToString());
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

        public void AddCustomPublication(Hashtable parameters, int personid, long subjectID, XmlDocument PropertyListXML)
        {
            ActivityLog(PropertyListXML, subjectID, parameters["@HMS_PUB_CATEGORY"].ToString(), parameters["@PUB_TITLE"].ToString());
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



        public bool SaveImage(long subjectID, byte[] image, XmlDocument PropertyListXML)
        {
            ActivityLog(PropertyListXML, subjectID);
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
                    cmd.Parameters.Add("@Personid", SqlDbType.Int).Value = GetPersonID(subjectID);
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

                Framework.Utilities.Cache.AlterDependency(subjectid.ToString());

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
        public bool AddLiteral(Int64 subjectid, Int64 predicateid, Int64 objectid, XmlDocument PropertyListXML)
        {
            ActivityLog(PropertyListXML, subjectid);
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
            EditActivityLog(subjectid, predicateid, null);
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
            EditActivityLog(subjectid, predicateid, null);

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

        public bool UpdateLiteral(Int64 subjectid, Int64 predicateid, Int64 oldobjectid, Int64 newobjectid, XmlDocument PropertyListXML)
        {
            ActivityLog(PropertyListXML, subjectid);
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
                    string startdate, string enddate, XmlDocument PropertyListXML)
        {
            ActivityLog(PropertyListXML, subjectid, label, institution);
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
                    string startdate, string enddate, XmlDocument PropertyListXML)
        {
            long subjectid = this.GetStoreNode(subjecturi);
            ActivityLog(PropertyListXML, subjectid, label, institution);
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
                sarr.AwardOrHonorForID.Value = subjectid.ToString();
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

                Framework.Utilities.Cache.AlterDependency(str.Subject.Value.ToString());

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
            EditActivityLog(subjectid, GetProperty(predicateid), "" + securitygroup);

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

        #region FUNDING



        public void AddUpdateFunding(FundingState fs)
        {
            string connstr = this.GetConnectionString();
            SqlConnection dbconnection = new SqlConnection(connstr);

            System.Text.StringBuilder sbSQL = new StringBuilder();

            SqlParameter[] param = new SqlParameter[13];

            if (fs.StartDate == "?")
                fs.StartDate = string.Empty;

            if (fs.EndDate == "?")
                fs.EndDate = string.Empty;

            try
            {
                dbconnection.Open();
                param[0] = new SqlParameter("@FundingRoleID", fs.FundingRoleID);
                param[1] = new SqlParameter("@PersonID", fs.PersonID);
                param[2] = new SqlParameter("@FundingID", fs.FullFundingID); //this will use the full funding id but can be loaded with the core or fill depending on if its a sub grant or not.
                param[3] = new SqlParameter("@FundingID2", fs.CoreProjectNum); //This will always be the core number
                param[4] = new SqlParameter("@RoleLabel", fs.RoleLabel);
                param[5] = new SqlParameter("@RoleDescription", fs.RoleDescription);
                param[6] = new SqlParameter("@AgreementLabel", fs.AgreementLabel);
                param[7] = new SqlParameter("@GrantAwardedBy", fs.GrantAwardedBy);
                param[8] = new SqlParameter("@StartDate", fs.StartDate == "?" ? "" : fs.StartDate);
                param[9] = new SqlParameter("@EndDate", fs.EndDate == "?" ? "" : fs.EndDate);
                param[10] = new SqlParameter("@PrincipalInvestigatorName", fs.PrincipalInvestigatorName);
                param[11] = new SqlParameter("@Abstract", fs.Abstract);
                param[12] = new SqlParameter("@Source", fs.Source);

                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(GetDBCommand(dbconnection, "[Profile.Data].[Funding.AddUpdateFunding]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

        }

        public void FundingUpdateOnePerson(FundingState fs)
        {
            try
            {
                this.ExecuteSQLDataCommand("[Profile.Data].[Funding.Entity.UpdateEntityOnePerson] 	@PersonID = " + fs.PersonID.ToString());

                if (HttpContext.Current.Request.QueryString["subjectid"] != null)
                {
                    Framework.Utilities.Cache.AlterDependency(HttpContext.Current.Request.QueryString["subjectid"].ToString());


                }

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }
        }

        public FundingState GetFundingItem(Guid FundingRoleID)
        {
            string connstr = this.GetConnectionString();
            SqlConnection dbconnection = new SqlConnection(connstr);
            dbconnection.Open();
            System.Text.StringBuilder sbSQL = new StringBuilder();
            FundingState fs = null;

            sbSQL.AppendLine("[Profile.Data].[Funding.GetFundingItem] @FundingRoleID = '" + FundingRoleID.ToString() + "'");

            using (SqlDataReader dr = GetSQLDataReader(GetDBCommand(dbconnection, sbSQL.ToString(), CommandType.Text, CommandBehavior.CloseConnection, null)))
            {
                while (dr.Read())
                    fs = new FundingState
                    {
                        Abstract = dr["Abstract"].ToString(),
                        AgreementLabel = dr["AgreementLabel"].ToString(),
                        EndDate = String.Format("{0:M/d/yyyy}", Convert.ToDateTime(dr["EndDate"])),
                        FundingID = dr["FundingID"].ToString(),
                        Source = dr["Source"].ToString(),
                        GrantAwardedBy = dr["GrantAwardedBy"].ToString(),
                        FundingRoleID = new Guid(dr["FundingRoleID"].ToString()),
                        FullFundingID = dr["FundingID"].ToString(),
                        CoreProjectNum = dr["FundingID2"].ToString(),
                        PersonID = Convert.ToInt32(dr["PersonID"]),
                        PrincipalInvestigatorName = dr["PrincipalInvestigatorName"].ToString(),
                        RoleDescription = dr["RoleDescription"].ToString(),
                        RoleLabel = dr["RoleLabel"].ToString(),
                        StartDate = String.Format("{0:M/d/yyyy}", Convert.ToDateTime(dr["StartDate"])),
                    };

                if (!dr.IsClosed)
                    dr.Close();
            }


            return fs;

        }
        public List<FundingState> GetFunding(int PersonID)
        {
            string connstr = this.GetConnectionString();
            SqlConnection dbconnection = new SqlConnection(connstr);
            dbconnection.Open();
            System.Text.StringBuilder sbSQL = new StringBuilder();
            List<FundingState> fs = new List<FundingState>();

            sbSQL.AppendLine("[Profile.Data].[Funding.GetPersonFunding] @personid = " + PersonID.ToString());

            using (SqlDataReader dr = GetSQLDataReader(GetDBCommand(dbconnection, sbSQL.ToString(), CommandType.Text, CommandBehavior.CloseConnection, null)))
            {
                while (dr.Read())
                    fs.Add(new FundingState
                    {
                        Abstract = dr["Abstract"].ToString(),
                        AgreementLabel = dr["AgreementLabel"] == null ? "" : dr["AgreementLabel"].ToString(),
                        EndDate = Convert.ToDateTime(dr["EndDate"]).ToString("MMM d, yyyy"),
                        FundingID = dr["FundingID"].ToString(),
                        Source = dr["Source"].ToString(),
                        FullFundingID = dr["FundingID"].ToString(),
                        CoreProjectNum = dr["FundingID2"].ToString(),
                        GrantAwardedBy = dr["GrantAwardedBy"].ToString(),
                        FundingRoleID = new Guid(dr["FundingRoleID"].ToString()),
                        PersonID = Convert.ToInt32(dr["PersonID"]),
                        PrincipalInvestigatorName = dr["PrincipalInvestigatorName"].ToString(),
                        RoleDescription = dr["RoleDescription"].ToString(),
                        RoleLabel = dr["RoleLabel"].ToString(),
                        StartDate = Convert.ToDateTime(dr["StartDate"]).ToString("MMM d, yyyy"),

                    });

                if (!dr.IsClosed)
                    dr.Close();
            }


            return fs;

        }

        public void DeleteFunding(Guid FundingRoleID, int personid)
        {
            System.Text.StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("[Profile.Data].[Funding.DeleteFunding]   @FundingRoleID = '" + FundingRoleID.ToString() + "'");

            ExecuteSQLDataCommand(sbSQL.ToString());

        }

        #endregion

        #region "freetext keywords"
        public string getAutoCompleteSuggestions(string text)
        {
            string retVal = "";
            try
            {
                string sql = " select distinct top 10  TermName, c.Rawweight from [Profile.Data].[Concept.Mesh.Term] t " +
                                "left join [Profile.Cache].[Concept.Mesh.Count] c " +
                                " on t.DescriptorName = c.MeshHeader " +
                                " where t.TermName like @text + '%'" +
                                " order by c.RawWeight desc ";

                SqlParameter[] p = new SqlParameter[1];
                p[0] = new SqlParameter("@text", text);

                using (SqlDataReader sqldr = this.GetSQLDataReader(sql, CommandType.Text, CommandBehavior.CloseConnection, p))
                {
                    bool first = true;
                    while (sqldr.Read())
                    {
                        string str = sqldr["TermName"].ToString();
                        if (first)
                        {
                            retVal = retVal + "{\"value\":\"" + str.Replace("\\", "\\\\").Replace("\"", "\\\"") + "\"}";
                            first = false;
                        }
                        else retVal = retVal + ",{\"value\":\"" + str.Replace("\\", "\\\\").Replace("\"", "\\\"") + "\"}";
                    }
                    //Always close your readers
                    if (!sqldr.IsClosed)
                        sqldr.Close();

                }
            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + " " + e.StackTrace);
                throw new Exception(e.Message);
            }
            //this.GetSQLDataReader();
            return "[" + retVal + "]";
        }

        #endregion

        #region EducationalTraining

        public bool AddEducationalTraining(Int64 subjectid, string institution, string location,
                    string degree, string enddate, string fieldOfStudy, XmlDocument PropertyListXML)
        {
            //ActivityLog(PropertyListXML, GetPersonID(subjectid), label, institution);
            bool error = false;
            try
            {

                EducationalTrainingRequest eatr = new EducationalTrainingRequest();
                eatr.EducationalTrainingForID = new StoreNodeParam();
                eatr.EducationalTrainingForID.Value = subjectid;
                eatr.EducationalTrainingForID.ParamOrdinal = 0;

                eatr.Institution = new StoreNodeParam();
                eatr.Institution.Value = institution;
                eatr.Institution.ParamOrdinal = 1;

                eatr.Location = new StoreNodeParam();
                eatr.Location.Value = location;
                eatr.Location.ParamOrdinal = 2;

                eatr.Degree = new StoreNodeParam();
                eatr.Degree.Value = degree;
                eatr.Degree.ParamOrdinal = 3;

                eatr.EndDate = new StoreNodeParam();
                eatr.EndDate.Value = enddate;
                eatr.EndDate.ParamOrdinal = 4;

                eatr.FieldOfStudy = new StoreNodeParam();
                eatr.FieldOfStudy.Value = fieldOfStudy;
                eatr.FieldOfStudy.ParamOrdinal = 5;

                error = this.StoreEducationalTrainingReceipt(eatr);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;

        }

        public bool UpdateEducationalTraining(string subjecturi, string institution, string location,
                    string degree, string enddate, string fieldOfStudy)
        {
            bool error = false;
            try
            {
                string label = degree + " " + institution;

                EducationalTrainingRequest eatr = new EducationalTrainingRequest();
                eatr.ExistingEducationalTrainingURI = new StoreNodeParam();
                eatr.ExistingEducationalTrainingURI.Value = subjecturi;
                eatr.ExistingEducationalTrainingURI.ParamOrdinal = 0;

                eatr.Institution = new StoreNodeParam();
                eatr.Institution.Value = institution;
                eatr.Institution.ParamOrdinal = 1;

                eatr.Location = new StoreNodeParam();
                eatr.Location.Value = location;
                eatr.Location.ParamOrdinal = 2;

                eatr.Degree = new StoreNodeParam();
                eatr.Degree.Value = degree;
                eatr.Degree.ParamOrdinal = 3;

                eatr.EndDate = new StoreNodeParam();
                eatr.EndDate.Value = enddate;
                eatr.EndDate.ParamOrdinal = 4;

                eatr.FieldOfStudy = new StoreNodeParam();
                eatr.FieldOfStudy.Value = fieldOfStudy;
                eatr.FieldOfStudy.ParamOrdinal = 5;

                eatr.EducationalTrainingForID = new StoreNodeParam();
                eatr.EducationalTrainingForID.Value = this.GetStoreNode(subjecturi).ToString();
                eatr.EducationalTrainingForID.ParamOrdinal = 6;
                error = this.StoreEducationalTrainingReceipt(eatr);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;


        }

        private bool StoreEducationalTrainingReceipt(EducationalTrainingRequest eatr)
        {

            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            SqlConnection dbconnection = new SqlConnection(connstr);

            SqlParameter[] param = new SqlParameter[eatr.Length];

            bool error = false;

            try
            {
                dbconnection.Open();

                if (eatr.ExistingEducationalTrainingURI != null)
                    param[eatr.ExistingEducationalTrainingURI.ParamOrdinal] = new SqlParameter("@ExistingEducationalTrainingURI", eatr.ExistingEducationalTrainingURI.Value);

                if (eatr.EducationalTrainingForID != null)
                    param[eatr.EducationalTrainingForID.ParamOrdinal] = new SqlParameter("@educationalTrainingForID", Convert.ToInt64(eatr.EducationalTrainingForID.Value));

                if (eatr.Institution != null)
                    param[eatr.Institution.ParamOrdinal] = new SqlParameter("@institution", eatr.Institution.Value.ToString());

                if (eatr.Location != null)
                    param[eatr.Location.ParamOrdinal] = new SqlParameter("@location", eatr.Location.Value.ToString());

                if (eatr.Degree != null)
                    param[eatr.Degree.ParamOrdinal] = new SqlParameter("@degree", eatr.Degree.Value.ToString());

                if (eatr.EndDate != null)
                    param[eatr.EndDate.ParamOrdinal] = new SqlParameter("@endDate", eatr.EndDate.Value.ToString());

                if (eatr.FieldOfStudy != null)
                    param[eatr.FieldOfStudy.ParamOrdinal] = new SqlParameter("@fieldOfStudy", eatr.FieldOfStudy.Value.ToString());




                param[eatr.Length - 3] = new SqlParameter("@sessionID", sm.Session().SessionID);

                param[eatr.Length - 2] = new SqlParameter("@error", null);
                param[eatr.Length - 2].DbType = DbType.Boolean;
                param[eatr.Length - 2].Direction = ParameterDirection.Output;

                param[eatr.Length - 1] = new SqlParameter("@nodeid", null);
                param[eatr.Length - 1].DbType = DbType.Int64;
                param[eatr.Length - 1].Direction = ParameterDirection.Output;

                // TODO
                SqlCommand comm = GetDBCommand(ref dbconnection, "[Edit.Module].[CustomEditEducationalTraining.StoreItem]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param);
                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(comm);


                comm.Connection.Close();

                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();

                error = Convert.ToBoolean(param[eatr.Length - 2].Value);

                Framework.Utilities.Cache.AlterDependency(eatr.EducationalTrainingForID.Value.ToString());
            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return error;

        }

        #endregion


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

        private class EducationalTrainingRequest
        {
            public EducationalTrainingRequest() { }

            public StoreNodeParam ExistingEducationalTrainingURI { get; set; }
            public StoreNodeParam EducationalTrainingForID { get; set; }
            public StoreNodeParam Institution { get; set; }
            public StoreNodeParam Location { get; set; }
            public StoreNodeParam Degree { get; set; }
            public StoreNodeParam EndDate { get; set; }
            public StoreNodeParam FieldOfStudy { get; set; }



            public int Length
            {
                get
                {
                    int length = 0;

                    if (ExistingEducationalTrainingURI != null)
                        length++;

                    if (EducationalTrainingForID != null)
                        length++;

                    if (Institution != null)
                        length++;

                    if (Location != null)
                        length++;

                    if (Degree != null)
                        length++;

                    if (EndDate != null)
                        length++;

                    if (FieldOfStudy != null)
                        length++;

                    //then add SessionID, Error and NodeID params for the array creation
                    length = length + 3;


                    return length;

                }
            }


        }

        #endregion

        #region ActivityLog

        protected void ActivityLog(XmlDocument PropertyListXML, long subjectID)
        {
            ActivityLog(PropertyListXML, subjectID, null, null);
        }

        protected void ActivityLog(XmlDocument PropertyListXML, long subjectID, string param1, string param2)
        {
            string property = null;
            string privacyCode = null;
            if (PropertyListXML != null)
            {
                if (PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@URI") != null)
                    property = PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@URI").Value;
                if (PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup") != null)
                    privacyCode = PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value;
            }
            EditActivityLog(subjectID, property, privacyCode, param1, param2);
        }
        #endregion
    }
}
