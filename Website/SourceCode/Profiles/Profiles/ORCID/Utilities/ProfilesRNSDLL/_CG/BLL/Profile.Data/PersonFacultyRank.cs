using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data
{
    public partial class PersonFacultyRank : ProfilesRNSDLL.DAL.Profile.Data.PersonFacultyRank
    {
    
        # region Constructors 
    
        public PersonFacultyRank() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank bo) 
        { 
            /*! Check for missing values */ 
            /*! Check for out of Range values */ 
            if (!bo.FacultyRankIsNull) 
            { 
                if (bo.FacultyRank.Length > 100) 
                { 
                     bo.FacultyRankErrors += "This field has more characters than the maximum that can be stored, i.e. 100 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
