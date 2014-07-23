using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORNG
{ 
    public partial class AppData : ProfilesRNSBaseClassBO, BO.Interfaces.ORNG.IAppData
    { 
        # region Private variables 
          /*! nodeId state (Node Id) */ 
          private long _nodeId;
          /*! appId state (App Id) */ 
          private int _appId;
          /*! keyname state (Keyname) */ 
          private string _keyname;
          /*! value state (Value) */ 
          private string _value;
          /*! createdDT state (Created D T) */ 
          private System.DateTime _createdDT;
          /*! updatedDT state (Updated D T) */ 
          private System.DateTime _updatedDT;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public long nodeId 
        { 
              get { return _nodeId; } 
              set { _nodeId = value; nodeIdIsNull = false; } 
        } 
        public bool nodeIdIsNull { get; set; }
        public string nodeIdErrors { get; set; }
        
        public int appId 
        { 
              get { return _appId; } 
              set { _appId = value; appIdIsNull = false; } 
        } 
        public bool appIdIsNull { get; set; }
        public string appIdErrors { get; set; }
        
        public string keyname 
        { 
              get { return _keyname; } 
              set { _keyname = value; keynameIsNull = false; } 
        } 
        public bool keynameIsNull { get; set; }
        public string keynameErrors { get; set; }
        
        public string value 
        { 
              get { return _value; } 
              set { _value = value; valueIsNull = false; } 
        } 
        public bool valueIsNull { get; set; }
        public string valueErrors { get; set; }
        
        public System.DateTime createdDT 
        { 
              get { return _createdDT; } 
              set { _createdDT = value; createdDTIsNull = false; } 
        } 
        public bool createdDTIsNull { get; set; }
        public string createdDTErrors { get; set; }
        public string createdDTDesc { get { if (createdDTIsNull){ return string.Empty; } return createdDT.ToShortDateString(); } } 
        public string createdDTTime { get { if (createdDTIsNull){ return string.Empty; } return createdDT.ToShortTimeString(); } } 
        
        public System.DateTime updatedDT 
        { 
              get { return _updatedDT; } 
              set { _updatedDT = value; updatedDTIsNull = false; } 
        } 
        public bool updatedDTIsNull { get; set; }
        public string updatedDTErrors { get; set; }
        public string updatedDTDesc { get { if (updatedDTIsNull){ return string.Empty; } return updatedDT.ToShortDateString(); } } 
        public string updatedDTTime { get { if (updatedDTIsNull){ return string.Empty; } return updatedDT.ToShortTimeString(); } } 
        public override string IdentityValue { get { throw new Exception("This table does not have an identity."); } } 
        public override bool IdentityIsNull { get { throw new Exception("This table does not have an identity."); } } 
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!nodeIdErrors.Equals(string.Empty))
                  { 
                      returnString += "Node Id: " + nodeIdErrors; 
                  } 
                  if (!appIdErrors.Equals(string.Empty))
                  { 
                      returnString += "App Id: " + appIdErrors; 
                  } 
                  if (!keynameErrors.Equals(string.Empty))
                  { 
                      returnString += "Keyname: " + keynameErrors; 
                  } 
                  if (!valueErrors.Equals(string.Empty))
                  { 
                      returnString += "Value: " + valueErrors; 
                  } 
                  if (!createdDTErrors.Equals(string.Empty))
                  { 
                      returnString += "Created D T: " + createdDTErrors; 
                  } 
                  if (!updatedDTErrors.Equals(string.Empty))
                  { 
                      returnString += "Updated D T: " + updatedDTErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public BO.Interfaces.ORNG.IAppData DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            nodeIdIsNull = true; 
            nodeIdErrors = string.Empty; 
            appIdIsNull = true; 
            appIdErrors = string.Empty; 
            keynameIsNull = true; 
            keynameErrors = string.Empty; 
            valueIsNull = true; 
            valueErrors = string.Empty; 
            createdDTIsNull = true; 
            createdDTErrors = string.Empty; 
            updatedDTIsNull = true; 
            updatedDTErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
