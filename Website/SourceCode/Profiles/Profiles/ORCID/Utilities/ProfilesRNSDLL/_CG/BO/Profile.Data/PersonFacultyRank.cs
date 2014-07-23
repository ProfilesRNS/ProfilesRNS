using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Data
{ 
    public partial class PersonFacultyRank : ProfilesRNSBaseClassBO, BO.Interfaces.Profile.Data.IPersonFacultyRank, IEqualityComparer<PersonFacultyRank>, IEquatable<PersonFacultyRank> 
    { 
        # region Private variables 
          /*! FacultyRankID state (Faculty RankID) */ 
          private int _FacultyRankID;
          /*! FacultyRank state (Faculty Rank) */ 
          private string _FacultyRank;
          /*! FacultyRankSort state (Faculty Rank Sort) */ 
          private int _FacultyRankSort;
          /*! Visible state (Visible) */ 
          private bool _Visible;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int FacultyRankID 
        { 
              get { return _FacultyRankID; } 
              set { _FacultyRankID = value; FacultyRankIDIsNull = false; } 
        } 
        public bool FacultyRankIDIsNull { get; set; }
        public string FacultyRankIDErrors { get; set; }
        public string FacultyRankIDText { get { if (FacultyRankIDIsNull){ return string.Empty; } return FacultyRankID.ToString(); } } 
        public override string IdentityValue { get { if (FacultyRankIDIsNull){ return string.Empty; } return FacultyRankID.ToString(); } } 
        public override bool IdentityIsNull { get { return FacultyRankIDIsNull; } } 
        
        public string FacultyRank 
        { 
              get { return _FacultyRank; } 
              set { _FacultyRank = value; FacultyRankIsNull = false; } 
        } 
        public bool FacultyRankIsNull { get; set; }
        public string FacultyRankErrors { get; set; }
        
        public int FacultyRankSort 
        { 
              get { return _FacultyRankSort; } 
              set { _FacultyRankSort = value; FacultyRankSortIsNull = false; } 
        } 
        public bool FacultyRankSortIsNull { get; set; }
        public string FacultyRankSortErrors { get; set; }
        
        public bool Visible 
        { 
              get { return _Visible; } 
              set { _Visible = value; VisibleIsNull = false; } 
        } 
        public bool VisibleIsNull { get; set; }
        public string VisibleErrors { get; set; }
        public string VisibleDesc { get { if (VisibleIsNull){ return string.Empty; } else if (Visible){ return "Yes"; } else { return "No"; } } } 
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!FacultyRankIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Faculty RankID: " + FacultyRankIDErrors; 
                  } 
                  if (!FacultyRankErrors.Equals(string.Empty))
                  { 
                      returnString += "Faculty Rank: " + FacultyRankErrors; 
                  } 
                  if (!FacultyRankSortErrors.Equals(string.Empty))
                  { 
                      returnString += "Faculty Rank Sort: " + FacultyRankSortErrors; 
                  } 
                  if (!VisibleErrors.Equals(string.Empty))
                  { 
                      returnString += "Visible: " + VisibleErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(PersonFacultyRank left, PersonFacultyRank right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.FacultyRankID == right.FacultyRankID;
        }
        public int GetHashCode(PersonFacultyRank obj)
        {
            return (obj.FacultyRankID).GetHashCode();
        }
        public bool Equals(PersonFacultyRank other)
        {
            if (this.FacultyRankID == other.FacultyRankID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return FacultyRankID.GetHashCode();
        }

        public BO.Interfaces.Profile.Data.IPersonFacultyRank DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            FacultyRankIDIsNull = true; 
            FacultyRankIDErrors = string.Empty; 
            FacultyRankIsNull = true; 
            FacultyRankErrors = string.Empty; 
            FacultyRankSortIsNull = true; 
            FacultyRankSortErrors = string.Empty; 
            VisibleIsNull = true; 
            VisibleErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
