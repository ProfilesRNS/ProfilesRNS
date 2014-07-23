using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class REFWorkExternalType : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IREFWorkExternalType, IEqualityComparer<REFWorkExternalType>, IEquatable<REFWorkExternalType> 
    { 
        # region Private variables 
          /*! WorkExternalTypeID state (Work External TypeID) */ 
          private int _WorkExternalTypeID;
          /*! WorkExternalType state (Work External Type) */ 
          private string _WorkExternalType;
          /*! WorkExternalDescription state (Work External Description) */ 
          private string _WorkExternalDescription;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int WorkExternalTypeID 
        { 
              get { return _WorkExternalTypeID; } 
              set { _WorkExternalTypeID = value; WorkExternalTypeIDIsNull = false; } 
        } 
        public bool WorkExternalTypeIDIsNull { get; set; }
        public string WorkExternalTypeIDErrors { get; set; }
        public string WorkExternalTypeIDText { get { if (WorkExternalTypeIDIsNull){ return string.Empty; } return WorkExternalTypeID.ToString(); } } 
        public override string IdentityValue { get { if (WorkExternalTypeIDIsNull){ return string.Empty; } return WorkExternalTypeID.ToString(); } } 
        public override bool IdentityIsNull { get { return WorkExternalTypeIDIsNull; } } 
        
        public string WorkExternalType 
        { 
              get { return _WorkExternalType; } 
              set { _WorkExternalType = value; WorkExternalTypeIsNull = false; } 
        } 
        public bool WorkExternalTypeIsNull { get; set; }
        public string WorkExternalTypeErrors { get; set; }
        
        public string WorkExternalDescription 
        { 
              get { return _WorkExternalDescription; } 
              set { _WorkExternalDescription = value; WorkExternalDescriptionIsNull = false; } 
        } 
        public bool WorkExternalDescriptionIsNull { get; set; }
        public string WorkExternalDescriptionErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!WorkExternalTypeIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Work External TypeID: " + WorkExternalTypeIDErrors; 
                  } 
                  if (!WorkExternalTypeErrors.Equals(string.Empty))
                  { 
                      returnString += "Work External Type: " + WorkExternalTypeErrors; 
                  } 
                  if (!WorkExternalDescriptionErrors.Equals(string.Empty))
                  { 
                      returnString += "Work External Description: " + WorkExternalDescriptionErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(REFWorkExternalType left, REFWorkExternalType right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.WorkExternalTypeID == right.WorkExternalTypeID;
        }
        public int GetHashCode(REFWorkExternalType obj)
        {
            return (obj.WorkExternalTypeID).GetHashCode();
        }
        public bool Equals(REFWorkExternalType other)
        {
            if (this.WorkExternalTypeID == other.WorkExternalTypeID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return WorkExternalTypeID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IREFWorkExternalType DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            WorkExternalTypeIDIsNull = true; 
            WorkExternalTypeIDErrors = string.Empty; 
            WorkExternalTypeIsNull = true; 
            WorkExternalTypeErrors = string.Empty; 
            WorkExternalDescriptionIsNull = true; 
            WorkExternalDescriptionErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
        public enum REFWorkExternalTypes{
			[DescriptionAttribute("arxiv")]
			arxiv=1
			,[DescriptionAttribute("asin")]
			asin=2
			,[DescriptionAttribute("bibcode")]
			bibcode=3
			,[DescriptionAttribute("doi")]
			doi=4
			,[DescriptionAttribute("eid")]
			eid=5
			,[DescriptionAttribute("Id")]
			Id=6
			,[DescriptionAttribute("isbn")]
			isbn=7
			,[DescriptionAttribute("issn")]
			issn=8
			,[DescriptionAttribute("jfm")]
			jfm=9
			,[DescriptionAttribute("jstor")]
			jstor=10
			,[DescriptionAttribute("lccn")]
			lccn=11
			,[DescriptionAttribute("mr")]
			mr=12
			,[DescriptionAttribute("oclc")]
			oclc=13
			,[DescriptionAttribute("ol")]
			ol=14
			,[DescriptionAttribute("osti")]
			osti=15
			,[DescriptionAttribute("pmc")]
			pmc=16
			,[DescriptionAttribute("pmid")]
			pmid=17
			,[DescriptionAttribute("rfc")]
			rfc=18
			,[DescriptionAttribute("ssrn")]
			ssrn=19
			,[DescriptionAttribute("zbl")]
			zbl=20
        }
 
        # endregion // Enums 
    } 
 
} 
