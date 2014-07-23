using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{
    public partial class PersonAffiliation
    {
        internal List<ProfilesRNSDLL.BO.ORCID.PersonAffiliation> GetSuccessfullyProcessedAffiliations(int orcidpersonID)
        {
            System.Data.Common.DbCommand cmd = GetCommand();
            string sql = GetSelectString();
            sql += "FROM ";
            sql += "    [ORCID.].PersonAffiliation  ";
            sql += "    INNER JOIN [ORCID.].PersonMessage ON [ORCID.].PersonAffiliation.PersonMessageID = [ORCID.].PersonMessage.PersonMessageID   ";
            sql += "WHERE ";
            sql += "    [ORCID.].PersonAffiliation.PersonID = @ORCIDPersonID ";
            sql += "    AND [ORCID.].PersonMessage.RecordStatusID = " + ((int)BO.ORCID.REFRecordStatus.REFRecordStatuss.Success).ToString();
            cmd.CommandText = sql;
            cmd.CommandType = System.Data.CommandType.Text;
            AddParam(ref cmd, "@ORCIDPersonID", orcidpersonID);
            return PopulateCollectionObject(FillTable(cmd), false);
        }
        internal List<ProfilesRNSDLL.BO.ORCID.PersonAffiliation> GetAffiliations(int profileDataPersonID)
        {
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].[AffiliationsForORCID.GetList]");
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            AddParam(ref cmd, "@ProfileDataPersonID", profileDataPersonID);

            System.Data.DataTable dt = FillTable(cmd);

            List<ProfilesRNSDLL.BO.ORCID.PersonAffiliation> personAffiliations = new List<BO.ORCID.PersonAffiliation>();

            foreach(System.Data.DataRow dr in dt.Rows)
            {
                ProfilesRNSDLL.BO.ORCID.PersonAffiliation personAffiliation = new ProfilesRNSDLL.BO.ORCID.PersonAffiliation();
                if (dr.IsNull("PersonAffiliationID"))
                {
                    personAffiliation.PersonAffiliationIDIsNull = true;
                }
                else
                {
                    personAffiliation.PersonAffiliationID = int.Parse(dr["PersonAffiliationID"].ToString());
                }
                if (dr.IsNull("ProfilesID"))
                {
                    personAffiliation.ProfilesIDIsNull = true;
                }
                else
                {
                    personAffiliation.ProfilesID = int.Parse(dr["ProfilesID"].ToString());
                }
                personAffiliation.AffiliationTypeID = int.Parse(dr["AffiliationTypeID"].ToString());
                if (dr.IsNull("PersonID"))
                {
                    personAffiliation.PersonIDIsNull = true;
                }
                else
                {
                    personAffiliation.PersonID = int.Parse(dr["PersonID"].ToString());
                }
                if (dr.IsNull("PersonMessageID"))
                {
                    personAffiliation.PersonMessageIDIsNull = true;
                }
                else
                {
                    personAffiliation.PersonMessageID = int.Parse(dr["PersonMessageID"].ToString());
                }
                if (dr.IsNull("DecisionID"))
                {
                    personAffiliation.DecisionID = (int)BO.ORCID.REFDecision.REFDecisions.Public;
                }
                else
                {
                    personAffiliation.DecisionID = int.Parse(dr["DecisionID"].ToString());
                }
                if (!dr.IsNull("DepartmentName") && !dr["DepartmentName"].ToString().Equals(string.Empty))
                {
                    personAffiliation.DepartmentName = dr["DepartmentName"].ToString();
                }
                else
                {
                    personAffiliation.DepartmentNameIsNull = true;
                }
                if (!dr.IsNull("RoleTitle") && !dr["RoleTitle"].ToString().Equals(string.Empty))
                {
                    personAffiliation.RoleTitle = dr["RoleTitle"].ToString();
                }
                else
                {
                    personAffiliation.RoleTitleIsNull = true;
                }

                if (!dr.IsNull("StartDate"))
                {
                    personAffiliation.StartDate = DateTime.Parse(dr["StartDate"].ToString());
                }
                else
                {
                    personAffiliation.StartDateIsNull = true;
                }

                if (!dr.IsNull("EndDate"))
                {
                    personAffiliation.EndDate = DateTime.Parse(dr["EndDate"].ToString());
                }
                else
                {
                    personAffiliation.EndDateIsNull = true;
                }

                if (!dr.IsNull("OrganizationName") && !dr["OrganizationName"].ToString().Equals(string.Empty))
                {
                    personAffiliation.OrganizationName = dr["OrganizationName"].ToString();
                }
                else
                {
                    personAffiliation.OrganizationNameIsNull = true;
                }

                if (!dr.IsNull("City") && !dr["City"].ToString().Equals(string.Empty))
                {
                    personAffiliation.OrganizationCity = dr["City"].ToString();
                }
                else
                {
                    personAffiliation.OrganizationCityIsNull = true;
                }

                if (!dr.IsNull("State") && !dr["State"].ToString().Equals(string.Empty))
                {
                    personAffiliation.OrganizationRegion = dr["State"].ToString();
                }
                else
                {
                    personAffiliation.OrganizationRegionIsNull = true;
                }
                if (!dr.IsNull("Country") && !dr["Country"].ToString().Equals(string.Empty))
                {
                    personAffiliation.OrganizationCountry = dr["Country"].ToString();
                }
                else
                {
                    personAffiliation.OrganizationCountryIsNull = true;
                }

                if (!dr.IsNull("DisambiguationID") && !dr["DisambiguationID"].ToString().Equals(string.Empty))
                {
                    personAffiliation.DisambiguationID = dr["DisambiguationID"].ToString();
                    personAffiliation.DisambiguationSource = dr["DisambiguationSource"].ToString();
                }
                else
                {
                    personAffiliation.DisambiguationIDIsNull = true;
                    personAffiliation.DisambiguationSourceIsNull = true;
                }
                personAffiliations.Add(personAffiliation);
            }
            return personAffiliations;
        } 
    }
}
