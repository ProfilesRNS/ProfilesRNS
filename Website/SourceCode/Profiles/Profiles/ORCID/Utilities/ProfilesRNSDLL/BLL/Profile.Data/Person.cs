using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data
{
    public partial class Person
    {
        public new System.Data.DataView GetSearchResults(bool primaryAffiliationOnly, string selectedInstitutionIDs, string selectedDepartmentIDs, string selectedDivisionIDs, string selectedFacultyRankIDs)
        {
            return base.GetSearchResults(primaryAffiliationOnly, selectedInstitutionIDs, selectedDepartmentIDs, selectedDivisionIDs, selectedFacultyRankIDs);
        }
        public new System.Data.DataView GetPeopleWithoutAnORCID()
        {
            return base.GetPeopleWithoutAnORCID();
        }
        public new System.Data.DataView GetPeopleWithoutAnORCIDByName(string partialName)
        {
            return base.GetPeopleWithoutAnORCIDByName(partialName);
        }
        public new Int64 GetNodeId(string internalUsername)
        {
            return base.GetNodeId(internalUsername);
        }
        public new string GetInternalUsername(Int64 nodeID)
        {
            return base.GetInternalUsername(nodeID);
        }
    }
}
