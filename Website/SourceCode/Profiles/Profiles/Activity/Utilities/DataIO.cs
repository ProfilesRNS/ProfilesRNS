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
using System.Configuration;
using Profiles.Framework.Utilities;

namespace Profiles.Activity.Utilities
{

    public class DataIO : Framework.Utilities.DataIO
    {

        private static readonly int activityCacheSize = 1000;
        private static readonly int cacheExpirationSeconds = 36000; // 10 hours
        private static readonly int chechForNewActivitiesSeconds = 60; // once a minute

        private readonly object syncLock = new object();
        private Random random = new Random();

        public List<Activity> GetActivity(Int64 lastActivityLogID, int count, bool declump)
        {
            List<Activity> activities = new List<Activity>();
            SortedList<Int64, Activity> cache = GetFreshCache();
            // grab as many as you can from the cache
            if (lastActivityLogID == -1)
            {
                activities.AddRange(cache.Values);
            }
            else if (cache.IndexOfKey(lastActivityLogID) != -1)
            {
                activities.AddRange(cache.Values);
                activities.RemoveRange(0, cache.IndexOfKey(lastActivityLogID) + 1);
            }

            List<Activity> retval = activities;
            if (declump)
            {
                retval = GetUnclumpedSubset(activities, count);
            }
            else if (count < retval.Count)
            {
                retval.RemoveRange(count, activities.Count - count);
            }

            if (count > retval.Count && retval.Count > 0)
            {
                // we need to go to the DB to get more. If we are declumping, we don't know exacly how many more we need but we make a good guess
                // and loop as needed
                if (declump)
                {
                    while (count > retval.Count)
                    {
                        SortedList<Int64, Activity> newActivities = GetRecentActivity(activities[activities.Count-1].Id, 10 * (count - retval.Count), true);
                        if (newActivities.Count == 0)
                        {
                            // nothing more to load, time to bail
                            break;
                        }
                        else
                        {
                            activities.AddRange(newActivities.Values);
                            retval = GetUnclumpedSubset(activities, count);
                        }
                    } 
                }
                else
                {
                    retval.AddRange(GetRecentActivity(retval[retval.Count - 1].Id, count - retval.Count, true).Values);
                }
            }
            return retval;
        }

        // makes sure you do not get consecutive activites for the same person. Instead, just randomly pick one of the activities in the consecutive 'clump'
        private List<Activity> GetUnclumpedSubset(List<Activity> activities, int count)
        {
            int id = -1;
            List<Activity> clumpedList = new List<Activity>();
            List<Activity> subset = new List<Activity>();

            foreach (Activity activity in activities)
            {
                if (id != activity.Profile.PersonId)
                {
                    //grab a random one from the old clumpedList
                    if (clumpedList.Count > 0)
                    {
                        subset.Add(clumpedList[random.Next(0, clumpedList.Count)]);
                        if (subset.Count == count)
                        {
                            clumpedList.Clear();
                            break;
                        }
                    }
                    // start a new clump for the new person
                    clumpedList.Clear();
                    id = activity.Profile.PersonId;
                }
                clumpedList.Add(activity);
            }
            // add the last one if needed
            if (clumpedList.Count > 0)
            {
                subset.Add(clumpedList[random.Next(0, clumpedList.Count)]);
            }

            return subset;        
        }

        private SortedList<Int64, Activity> GetFreshCache()
        {
            SortedList<Int64, Activity> cache = (SortedList<Int64, Activity>)Framework.Utilities.Cache.FetchObject("ActivityHistory");
            object isFresh = Framework.Utilities.Cache.FetchObject("ActivityHistoryIsFresh");
            if (cache == null)
            {
                // Grab a whole new one. This is expensive and should be unnecessary if we manage getting new ones well, so we don't do this often
                cache = GetRecentActivity(-1, activityCacheSize, true);
                Framework.Utilities.Cache.SetWithTimeout("ActivityHistory", cache, cacheExpirationSeconds);
            }
            else if (isFresh == null)
            {
                lock(syncLock)
                {
                    // get new ones from the DB

                    Int64 lastActivityLogID = cache.Count == 0 ? -1 : cache.Values[0].Id;
                    SortedList<Int64, Activity> newActivities = GetRecentActivity(lastActivityLogID, activityCacheSize, false);
                    // in with the new
                    foreach (Activity activity in newActivities.Values)
                    {
                        cache.Add(activity.Id, activity);
                    }
                    // out with the old
                    while (cache.Count > activityCacheSize)
                    {
                        cache.RemoveAt(cache.Count - 1);
                    }
                }
                // look for new activities once every minute
                Framework.Utilities.Cache.SetWithTimeout("ActivityHistoryIsFresh", new object(), chechForNewActivitiesSeconds);
            }
            return cache;
        }

        private SortedList<Int64, Activity> GetRecentActivity(Int64 lastActivityLogID, int count, bool older)
        {
            SortedList<Int64, Activity> activities = new SortedList<Int64, Activity>(new ReverseComparer());

            string sql = "SELECT top " + count + "  i.activityLogID," +
                            "p.personid,n.nodeid,p.firstname,p.lastname," +
                            "i.methodName,i.property,cp._PropertyLabel as propertyLabel,i.param1,i.param2,i.createdDT " +
                            "FROM [Framework.].[Log.Activity] i " +
                            "LEFT OUTER JOIN [Profile.Data].[Person] p ON i.personId = p.personID " +
                            "LEFT OUTER JOIN [RDF.Stage].internalnodemap n on n.internalid = p.personId and n.[class] = 'http://xmlns.com/foaf/0.1/Person' "+
                            "LEFT OUTER JOIN [Ontology.].[ClassProperty] cp ON cp.Property = i.property  and cp.Class = 'http://xmlns.com/foaf/0.1/Person' " +
                            "LEFT OUTER JOIN [RDF.].[Node] rn on [RDF.].fnValueHash(null, null, i.property) = rn.ValueHash " +
	                        "LEFT OUTER JOIN [RDF.Security].[NodeProperty] np on n.NodeID = np.NodeID and rn.NodeID = np.Property " +
                            "where p.IsActive=1 and (np.ViewSecurityGroup = -1 or (i.privacyCode = -1 and np.ViewSecurityGroup is null) or (i.privacyCode is null and np.ViewSecurityGroup is null))" +
                            (lastActivityLogID != -1 ? (" and i.activityLogID " + (older ? "< " : "> ") + lastActivityLogID) : "") +
                            "order by i.activityLogID desc";
            using (SqlDataReader reader = GetQueryOutputReader(sql))
            {
                while (reader.Read())
                {
                    string param1 = reader["param1"].ToString();
                    string param2 = reader["param2"].ToString();
                    string activityLogId = reader["activityLogId"].ToString();
                    string property = reader["property"].ToString();
                    string propertyLabel = reader["propertyLabel"].ToString();
                    string personid = reader["personid"].ToString();
                    string nodeid = reader["nodeid"].ToString();
                    string firstname = reader["firstname"].ToString();
                    string lastname = reader["lastname"].ToString();
                    string methodName = reader["methodName"].ToString();

                    string journalTitle = "";
                    string url = "";
                    string queryTitle = "";
                    string title = "";
                    string body = "";
                    if (param1 == "PMID" || param1 == "Add PMID")
                    {
                        url = "http://www.ncbi.nlm.nih.gov/pubmed/" + param2;
                        queryTitle = "SELECT JournalTitle FROM [Profile.Data].[Publication.PubMed.General] " +
                                        "WHERE PMID = cast(" + param2 + " as int)";
                        journalTitle = GetStringValue(queryTitle, "JournalTitle");
                    }
                    if (property == "http://vivoweb.org/ontology/core#ResearcherRole")
                    {
                        queryTitle = "select AgreementLabel from [Profile.Data].[Funding.Role] r " +
                                        "join [Profile.Data].[Funding.Agreement] a " +
                                        "on r.FundingAgreementID = a.FundingAgreementID " +
                                        " and r.FundingRoleID = '" + param1 + "'";
                        journalTitle = GetStringValue(queryTitle, "AgreementLabel");
                    }
                    if (methodName.CompareTo("Profiles.Edit.Utilities.DataIO.AddPublication") == 0)
                    {
                        title = "added a PubMed publication";
                        body = "added a publication from: " + journalTitle;
                    }
                    else if (methodName.CompareTo("Profiles.Edit.Utilities.DataIO.AddCustomPublication") == 0)
                    {
                        title = "added a custom publication";
                        if (param2.Length > 100) param2 = param2.Substring(0, 100) + "...";
                        body = "added \"" + param1 + "\" into " + propertyLabel +
                            " section : " + param2;
                    }
                    else if (methodName.CompareTo("Profiles.Edit.Utilities.DataIO.UpdateSecuritySetting") == 0)
                    {
                        title = "made a section visible";
                        body = "made \"" + propertyLabel + "\" public";
                    }
                    else if (methodName.CompareTo("Profiles.Edit.Utilities.DataIO.AddUpdateFunding") == 0)
                    {
                        title = "added a research activity or funding";
                        body = "added a research activity or funding: " + journalTitle;
                    }
                    else if (methodName.CompareTo("[Profile.Data].[Funding.LoadDisambiguationResults]") == 0)
                    {
                        title = "has a new research activity or funding";
                        body = "has a new research activity or funding: " + journalTitle;
                    }
                    else if (property == "http://vivoweb.org/ontology/core#hasMemberRole")
                    {

                        queryTitle = "select GroupName from [Profile.Data].[vwGroup.General] where GroupNodeID = " + param1;
                        string groupName = GetStringValue(queryTitle, "GroupName");
                        title = "joined group: " + groupName;
                        body = "joined group: " + groupName;
                    }
                    else if (methodName.IndexOf("Profiles.Edit.Utilities.DataIO.Add") == 0)
                    {
                        title = "added an item";
                        if (param1.Length != 0)
                        {
                            body = body = "added \"" + param1 + "\" into " + propertyLabel + " section";
                        }
                        else
                        {
                            body = "added \"" + propertyLabel + "\" section";
                        }

                    }
                    else if (methodName.IndexOf("Profiles.Edit.Utilities.DataIO.Update") == 0)
                    {
                        title = "updated an item";
                        if (param1.Length != 0)
                        {
                            body = "updated \"" + param1 + "\" in " + propertyLabel + " section";
                        }
                        else
                        {
                            body = "updated \"" + propertyLabel + "\" section";
                        }
                    }
                    else if (methodName.CompareTo("[Profile.Data].[Publication.Pubmed.LoadDisambiguationResults]") == 0 && param1.CompareTo("Add PMID") == 0)
                    {
                        title = "has a new PubMed publication";
                        body = "has a new publication listed from: " + journalTitle;
                    }
                    else if (methodName.CompareTo("[Profile.Import].[LoadProfilesData]") == 0 && param1.CompareTo("Person Insert") == 0)
                    {
                        title = "added to Profiles";
                        body = "now has a Profile page";
                    }

                    // there are situations where a new person is loaded but we don't yet have them in the system
                    // best to skip them for now
                    if (!String.IsNullOrEmpty(title) /*&& UCSFIDSet.ByNodeId[Convert.ToInt64(nodeid)] != null*/)
                    {
                        try
                        {
                            Activity act = new Activity
                            {
                                Id = Convert.ToInt64(activityLogId),
                                Message = body,
                                LinkUrl = url,
                                Title = title,
                                CreatedDT = Convert.ToDateTime(reader["CreatedDT"]),
                                CreatedById = activityLogId,
                                Profile = new Profile
                                {
                                    Name = firstname + " " + lastname,
                                    PersonId = Convert.ToInt32(personid),
                                    NodeID = Convert.ToInt64(nodeid),
                                    URL = Root.Domain + "/profile/" + nodeid,
                                    Thumbnail = Root.Domain + "/profile/Modules/CustomViewPersonGeneralInfo/PhotoHandler.ashx?NodeID=" + nodeid + "&Thumbnail=True&Width=45"
                                }
                            };
                            activities.Add(act.Id, act);
                        }
                        catch (Exception e) { }
                    }
                }
            }
            return activities;
        }
		
		        public int GetEditedCount()
        {
            string sql = "select count(*) from [Profile.Data].Person p " +
                            "join (select InternalID as PersonID from [RDF.Stage].InternalNodeMap i " +
                            "join (select distinct subject from [RDF.].Triple t " +
                            "join [RDF.].Node n on t.Predicate = n.NodeID and n.value in " +
                            "('http://profiles.catalyst.harvard.edu/ontology/prns#mainImage', 'http://vivoweb.org/ontology/core#awardOrHonor', " +
                            "'http://vivoweb.org/ontology/core#educationalTraining', 'http://vivoweb.org/ontology/core#freetextKeyword', 'http://vivoweb.org/ontology/core#overview')) t " +
                            "on i.NodeID = t.Subject and i.Class = 'http://xmlns.com/foaf/0.1/Person' union " +
                            "select distinct personid from [Profile.Data].[Publication.Person.Add] union " +
                            "select distinct personid from [Profile.Data].[Publication.Person.Exclude] as u) t " +
                            "on t.PersonID = p.PersonID " +
                            "and p.IsActive = 1";
                
            return GetCount(sql);
        }

        public int GetProfilesCount()
        {
            return GetCount("select count(*) from [Profile.Data].[Person] where isactive = 1;");
        }

        public int GetPublicationsCount()
        {
            string sql = "select (select count(distinct(PMID)) from [Profile.Data].[Publication.Person.Include] i join [Profile.Data].[Person] p on p.personid = i.personid where PMID is not null and isactive = 1) + " +
                                "(select count(distinct(MPID)) from [Profile.Data].[Publication.Person.Include] i join [Profile.Data].[Person] p on p.personid = i.personid where MPID is not null and isactive = 1);";
            return GetCount(sql);
        }

        private int GetCount(string sql)
        {
            string key = "Statistics: " + sql;
            // store this in the cache. Use the sql as part of the key
            string cnt = (string)Framework.Utilities.Cache.FetchObject(key);

            if (String.IsNullOrEmpty(cnt))
            {
                using (SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null))
                {
                    if (sqldr.Read())
                    {
                        cnt = sqldr[0].ToString();
                        Framework.Utilities.Cache.Set(key, cnt);
                    }
                }
            }
            return Convert.ToInt32(cnt);
        }

        private SqlDataReader GetQueryOutputReader(string sql)
        {

            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlCommand dbcommand = new SqlCommand(sql, dbconnection);
            SqlDataReader dbreader = null;
            dbconnection.Open();
            dbcommand.CommandTimeout = 5000;
            try
            {
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch (Exception ex)
            { string dd = ex.Message; }
            return dbreader;
        }

        private string GetStringValue(string sql, string columnName)
        {
            string value = "";
            using (SqlDataReader reader = GetQueryOutputReader(sql))
            {
                if (reader.Read())
                {
                    value = reader[columnName].ToString();
                }
            }
            return value;
        }

    }
}
