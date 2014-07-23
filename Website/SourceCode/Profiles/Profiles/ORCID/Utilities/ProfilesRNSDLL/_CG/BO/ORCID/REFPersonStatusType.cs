using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class REFPersonStatusType : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IREFPersonStatusType, IEqualityComparer<REFPersonStatusType>, IEquatable<REFPersonStatusType> 
    { 
        # region Private variables 
          /*! PersonStatusTypeID state (Person Status TypeID) */ 
          private int _PersonStatusTypeID;
          /*! StatusDescription state (Status Description) */ 
          private string _StatusDescription;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PersonStatusTypeID 
        { 
              get { return _PersonStatusTypeID; } 
              set { _PersonStatusTypeID = value; PersonStatusTypeIDIsNull = false; } 
        } 
        public bool PersonStatusTypeIDIsNull { get; set; }
        public string PersonStatusTypeIDErrors { get; set; }
        public string PersonStatusTypeIDText { get { if (PersonStatusTypeIDIsNull){ return string.Empty; } return PersonStatusTypeID.ToString(); } } 
        public override string IdentityValue { get { if (PersonStatusTypeIDIsNull){ return string.Empty; } return PersonStatusTypeID.ToString(); } } 
        public override bool IdentityIsNull { get { return PersonStatusTypeIDIsNull; } } 
        
        public string StatusDescription 
        { 
              get { return _StatusDescription; } 
              set { _StatusDescription = value; StatusDescriptionIsNull = false; } 
        } 
        public bool StatusDescriptionIsNull { get; set; }
        public string StatusDescriptionErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!PersonStatusTypeIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person Status TypeID: " + PersonStatusTypeIDErrors; 
                  } 
                  if (!StatusDescriptionErrors.Equals(string.Empty))
                  { 
                      returnString += "Status Description: " + StatusDescriptionErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(REFPersonStatusType left, REFPersonStatusType right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PersonStatusTypeID == right.PersonStatusTypeID;
        }
        public int GetHashCode(REFPersonStatusType obj)
        {
            return (obj.PersonStatusTypeID).GetHashCode();
        }
        public bool Equals(REFPersonStatusType other)
        {
            if (this.PersonStatusTypeID == other.PersonStatusTypeID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PersonStatusTypeID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IREFPersonStatusType DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PersonStatusTypeIDIsNull = true; 
            PersonStatusTypeIDErrors = string.Empty; 
            StatusDescriptionIsNull = true; 
            StatusDescriptionErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
        public enum REFPersonStatusTypes{
			[DescriptionAttribute("Opt-Out")]
			Opt_Out=1
			,[DescriptionAttribute("Opt-In: Push Profiles Data")]
			Opt_In_Push_Profiles_Data=2
			,[DescriptionAttribute("Opt-In: Do Not Push Profiles Data")]
			Opt_In_Do_Not_Push_Profiles_Data=3
			,[DescriptionAttribute("Awaiting Response")]
			Awaiting_Response=4
			,[DescriptionAttribute("ORCID Created")]
			ORCID_Created=5
			,[DescriptionAttribute("ORCID Provided")]
			ORCID_Provided=6
			,[DescriptionAttribute("Batch Push Failed")]
			Batch_Push_Failed=7
			,[DescriptionAttribute("Unknown")]
			Unknown=8
			,[DescriptionAttribute("User Push Failed")]
			User_Push_Failed=9
        }
 
        # endregion // Enums 
    } 
 
} 
