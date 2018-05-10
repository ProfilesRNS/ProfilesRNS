using System;
using System.Data;
using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.Profile.Data
{
    public partial class Person
    {
        internal System.Data.DataView GetSearchResults(bool primaryAffiliationOnly, string selectedInstitutionIDs, 
                                                        string selectedDepartmentIDs, string selectedDivisionIDs, 
                                                        string selectedFacultyRankIDs)
        {
            DbCommand cmd = GetCommand();
            string sql = "    SELECT TOP 100 PERCENT ";
            sql += "        [Profile.Data].[Person].[PersonID] ";
            sql += "        , [Profile.Data].[Person].[UserID] ";
            sql += "        , [Profile.Data].[Person].[EmailAddr] ";
            sql += "        , [Profile.Data].[Person].[FacultyRankID] ";
            sql += "        , [Profile.Data].[Person].[InternalUsername] ";
            sql += "		, [Profile.Data].[Person.FacultyRank].FacultyRank ";
            sql += "		, [Profile.Data].[Person].LastName + ', ' + [Profile.Data].[Person].FirstName AS DisplayName ";
            sql += "		, [Profile.Data].[Organization.Institution].InstitutionName ";
            sql += "		, [Profile.Data].[Organization.Department].DepartmentName ";
            sql += "		, [Profile.Data].[Organization.Division].DivisionName ";
            sql += "		, OP.ORCID ";
            sql += "    FROM ";
            sql += "        [Profile.Data].[Person] ";
            sql += "		LEFT JOIN [Profile.Data].[Person.FacultyRank] ON [Profile.Data].[Person].FacultyRankID = [Profile.Data].[Person.FacultyRank].FacultyRankID ";
            sql += "		LEFT JOIN [ORCID.].Person OP ON [Profile.Data].[Person].InternalUsername = OP.InternalUsername ";
            sql += "		INNER JOIN  [Profile.Data].[Person.Affiliation]  ";
            sql += "			ON  ";
            sql += "				[Profile.Data].[Person].PersonID = [Profile.Data].[Person.Affiliation].PersonID ";
            sql += "				AND [Profile.Data].[Person.Affiliation].IsPrimary = 1 ";
            sql += "		INNER JOIN  ";
            sql += "		    ( ";
            sql += "		        SELECT ";
            sql += "		            PersonID  ";
            sql += "		        FROM  ";
            sql += "		            [Profile.Data].[Person.Affiliation]  ";
            sql += "		        WHERE  ";
            sql += "		            (IsActive = 1)  ";
            if (primaryAffiliationOnly)
            {
                sql += "		            AND (IsPrimary = 1)  ";
            }
            sql += "		            AND (InstitutionID IN (" + selectedInstitutionIDs + "))  ";
            if (!selectedDepartmentIDs.ToLower().Equals("all"))
            {
                sql += "		            AND (DepartmentID IN (" + selectedDepartmentIDs + "))  ";
            }
            if (!selectedDivisionIDs.ToLower().Equals("all"))
            {
                sql += "		            AND (DivisionID IN (" + selectedDivisionIDs + "))  ";
            }
            sql += "		        GROUP BY  ";
            sql += "		            PersonID ";
            sql += "		    ) SelectedPeopleFromAffiliations ON  [Profile.Data].[Person].PersonID = SelectedPeopleFromAffiliations.PersonID ";
            sql += "		LEFT JOIN   [Profile.Data].[Organization.Institution] ON [Profile.Data].[Person.Affiliation].InstitutionID = [Profile.Data].[Organization.Institution].InstitutionID ";
            sql += "		LEFT JOIN   [Profile.Data].[Organization.Department] ON [Profile.Data].[Person.Affiliation].DepartmentID = [Profile.Data].[Organization.Department].DepartmentID ";
            sql += "		LEFT JOIN   [Profile.Data].[Organization.Division] ON [Profile.Data].[Person.Affiliation].DivisionID = [Profile.Data].[Organization.Division].DivisionID ";
            sql += "	WHERE  ";
            sql += "		NOT ([Profile.Data].[Person].EmailAddr IS NULL) ";
            sql += "		AND [Profile.Data].[Person].IsActive = 1 ";
            sql += "		AND [Profile.Data].[Person].Visible = 1 ";
            sql += "		AND OP.ORCID IS NULL ";
            sql += "		AND [Profile.Data].[Person].FacultyRankID IN (" + selectedFacultyRankIDs + ") ";
            sql += "	ORDER BY ";
            sql += "		[Profile.Data].[Organization.Institution].InstitutionName ";
            sql += "		, [Profile.Data].[Organization.Department].DepartmentName ";
            sql += "		, [Profile.Data].[Organization.Division].DivisionName ";
            sql += "		, [Profile.Data].[Person].LastName  ";
            sql += "		, [Profile.Data].[Person].FirstName ";
            cmd.CommandText = sql;
            cmd.CommandType = CommandType.Text;
            return FillTable(cmd).DefaultView;
        }
        internal System.Data.DataView GetPeopleWithoutAnORCID()
        {
            DbCommand cmd = GetCommand("[ORCID.].[PeopleWithoutAnORCID]");
            cmd.CommandType = CommandType.StoredProcedure;
            return FillTable(cmd).DefaultView;
        }
        internal System.Data.DataView GetPeopleWithoutAnORCIDByName(string partialName)
        {
            DbCommand cmd = GetCommand("[ORCID.].[PeopleWithoutAnORCIDByName]");
            cmd.CommandType = CommandType.StoredProcedure;
            AddParam(ref cmd, "@PartialName", partialName);
            return FillTable(cmd).DefaultView;
        }
        internal Int64 GetNodeId(string internalUsername)
        {
            string sql = "SELECT ";
            sql += "    [RDF.Stage].InternalNodeMap.NodeID  ";
            sql += "FROM  ";
            sql += "    [RDF.Stage].InternalNodeMap  ";
            sql += "    INNER JOIN [User.Account].[User] ON [RDF.Stage].InternalNodeMap.InternalID = [User.Account].[User].PersonID  ";
            sql += "WHERE ";
            sql += "    ([RDF.Stage].InternalNodeMap.Class = 'http://xmlns.com/foaf/0.1/Person') ";
            sql += "    AND ([User.Account].[User].InternalUserName = N'" + internalUsername + "')";

            DbCommand cmd = GetCommand();
            cmd.CommandText = sql;
            cmd.CommandType = CommandType.Text;

            System.Data.DataTable dt = FillTable(cmd);
            if (dt.Rows.Count > 0)
            {
                if (!dt.Rows[0].IsNull("NodeID"))
                {
                    return Int64.Parse(dt.Rows[0]["NodeID"].ToString());
                }
            }
            return -1;
        }
        internal string GetInternalUsername(Int64 nodeID)
        {
            string sql = "SELECT ";
            sql += "    [User.Account].[User].InternalUserName ";
            sql += "FROM ";
            sql += "    [RDF.Stage].InternalNodeMap  ";
            sql += "    INNER JOIN [User.Account].[User] ON [RDF.Stage].InternalNodeMap.InternalID = [User.Account].[User].PersonID ";
            sql += "WHERE ";
            sql += "    ([RDF.Stage].InternalNodeMap.Class = 'http://xmlns.com/foaf/0.1/Person')  ";
            sql += "    AND ([RDF.Stage].InternalNodeMap.NodeID = " + nodeID.ToString() + ") ";

            DbCommand cmd = GetCommand();
            cmd.CommandText = sql;
            cmd.CommandType = CommandType.Text;

            System.Data.DataTable dt = FillTable(cmd);
            if (dt.Rows.Count > 0)
            {
                if (!dt.Rows[0].IsNull("InternalUserName"))
                {
                    return dt.Rows[0]["InternalUserName"].ToString();
                }
            }
            return string.Empty;
        }
    }
}
