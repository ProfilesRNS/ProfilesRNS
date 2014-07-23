using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORNG
{ 
    public partial class AppRegistry : ProfilesRNSBaseClassBO, BO.Interfaces.ORNG.IAppRegistry
    { 
        # region Private variables 
          /*! nodeid state (Nodeid) */ 
          private long _nodeid;
          /*! appId state (App Id) */ 
          private int _appId;
          /*! visibility state (Visibility) */ 
          private string _visibility;
          /*! createdDT state (Created D T) */ 
          private System.DateTime _createdDT;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public long nodeid 
        { 
              get { return _nodeid; } 
              set { _nodeid = value; nodeidIsNull = false; } 
        } 
        public bool nodeidIsNull { get; set; }
        public string nodeidErrors { get; set; }
        
        public int appId 
        { 
              get { return _appId; } 
              set { _appId = value; appIdIsNull = false; } 
        } 
        public bool appIdIsNull { get; set; }
        public string appIdErrors { get; set; }
        
        public string visibility 
        { 
              get { return _visibility; } 
              set { _visibility = value; visibilityIsNull = false; } 
        } 
        public bool visibilityIsNull { get; set; }
        public string visibilityErrors { get; set; }
        
        public System.DateTime createdDT 
        { 
              get { return _createdDT; } 
              set { _createdDT = value; createdDTIsNull = false; } 
        } 
        public bool createdDTIsNull { get; set; }
        public string createdDTErrors { get; set; }
        public string createdDTDesc { get { if (createdDTIsNull){ return string.Empty; } return createdDT.ToShortDateString(); } } 
        public string createdDTTime { get { if (createdDTIsNull){ return string.Empty; } return createdDT.ToShortTimeString(); } } 
        public override string IdentityValue { get { throw new Exception("This table does not have an identity."); } } 
        public override bool IdentityIsNull { get { throw new Exception("This table does not have an identity."); } } 
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!nodeidErrors.Equals(string.Empty))
                  { 
                      returnString += "Nodeid: " + nodeidErrors; 
                  } 
                  if (!appIdErrors.Equals(string.Empty))
                  { 
                      returnString += "App Id: " + appIdErrors; 
                  } 
                  if (!visibilityErrors.Equals(string.Empty))
                  { 
                      returnString += "Visibility: " + visibilityErrors; 
                  } 
                  if (!createdDTErrors.Equals(string.Empty))
                  { 
                      returnString += "Created D T: " + createdDTErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public BO.Interfaces.ORNG.IAppRegistry DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            nodeidIsNull = true; 
            nodeidErrors = string.Empty; 
            appIdIsNull = true; 
            appIdErrors = string.Empty; 
            visibilityIsNull = true; 
            visibilityErrors = string.Empty; 
            createdDTIsNull = true; 
            createdDTErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
