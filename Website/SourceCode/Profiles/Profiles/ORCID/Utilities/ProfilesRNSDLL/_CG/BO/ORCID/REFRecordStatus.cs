using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class REFRecordStatus : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IREFRecordStatus
    { 
        # region Private variables 
          /*! RecordStatusID state (Record StatusID) */ 
          private int _RecordStatusID;
          /*! StatusDescription state (Status Description) */ 
          private string _StatusDescription;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int RecordStatusID 
        { 
              get { return _RecordStatusID; } 
              set { _RecordStatusID = value; RecordStatusIDIsNull = false; } 
        } 
        public bool RecordStatusIDIsNull { get; set; }
        public string RecordStatusIDErrors { get; set; }
        
        public string StatusDescription 
        { 
              get { return _StatusDescription; } 
              set { _StatusDescription = value; StatusDescriptionIsNull = false; } 
        } 
        public bool StatusDescriptionIsNull { get; set; }
        public string StatusDescriptionErrors { get; set; }
        public override string IdentityValue { get { throw new Exception("This table does not have an identity."); } } 
        public override bool IdentityIsNull { get { throw new Exception("This table does not have an identity."); } } 
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!RecordStatusIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Record StatusID: " + RecordStatusIDErrors; 
                  } 
                  if (!StatusDescriptionErrors.Equals(string.Empty))
                  { 
                      returnString += "Status Description: " + StatusDescriptionErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public BO.Interfaces.ORCID.IREFRecordStatus DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            RecordStatusIDIsNull = true; 
            RecordStatusIDErrors = string.Empty; 
            StatusDescriptionIsNull = true; 
            StatusDescriptionErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
        public enum REFRecordStatuss{
			[DescriptionAttribute("Success")]
			Success=1
			,[DescriptionAttribute("Failed")]
			Failed=2
			,[DescriptionAttribute("Exclude")]
			Exclude=3
			,[DescriptionAttribute("Add")]
			Add=4
			,[DescriptionAttribute("Waiting to be sent to ORCID")]
			Waiting_to_be_sent_to_ORCID=6
			,[DescriptionAttribute("Waiting for ORCID User for approval")]
			Waiting_for_ORCID_User_for_approval=7
			,[DescriptionAttribute("Inserting PubMed Publications in to ORCID Work Table")]
			Inserting_PubMed_Publications_in_to_ORCID_Work_Table=8
			,[DescriptionAttribute("Created BIO Update ORCID Message")]
			Created_BIO_Update_ORCID_Message=9
			,[DescriptionAttribute("Denied Access")]
			Denied_Access=10
			,[DescriptionAttribute("ORCID User Denied")]
			ORCID_User_Denied=11
        }
 
        # endregion // Enums 
    } 
 
} 
