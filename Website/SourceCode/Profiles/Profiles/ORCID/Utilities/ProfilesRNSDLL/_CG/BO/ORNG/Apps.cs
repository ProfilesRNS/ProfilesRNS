using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORNG
{
    public partial class Apps : ProfilesRNSBaseClassBO, BO.Interfaces.ORNG.IApps
    { 
        # region Private variables 
          /*! appId state (App Id) */ 
          private int _appId;
          /*! name state (Name) */ 
          private string _name;
          /*! url state (Url) */ 
          private string _url;
          /*! PersonFilterID state (Person FilterID) */ 
          private int _PersonFilterID;
          /*! enabled state (Enabled) */ 
          private bool _enabled;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int appId 
        { 
              get { return _appId; } 
              set { _appId = value; appIdIsNull = false; } 
        } 
        public bool appIdIsNull { get; set; }
        public string appIdErrors { get; set; }
        
        public string name 
        { 
              get { return _name; } 
              set { _name = value; nameIsNull = false; } 
        } 
        public bool nameIsNull { get; set; }
        public string nameErrors { get; set; }
        
        public string url 
        { 
              get { return _url; } 
              set { _url = value; urlIsNull = false; } 
        } 
        public bool urlIsNull { get; set; }
        public string urlErrors { get; set; }
        
        public int PersonFilterID 
        { 
              get { return _PersonFilterID; } 
              set { _PersonFilterID = value; PersonFilterIDIsNull = false; } 
        } 
        public bool PersonFilterIDIsNull { get; set; }
        public string PersonFilterIDErrors { get; set; }
        
        public bool enabled 
        { 
              get { return _enabled; } 
              set { _enabled = value; enabledIsNull = false; } 
        } 
        public bool enabledIsNull { get; set; }
        public string enabledErrors { get; set; }
        public string enabledDesc { get { if (enabledIsNull){ return string.Empty; } else if (enabled){ return "Yes"; } else { return "No"; } } } 
        public override string IdentityValue { get { throw new Exception("This table does not have an identity."); } } 
        public override bool IdentityIsNull { get { throw new Exception("This table does not have an identity."); } } 
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!appIdErrors.Equals(string.Empty))
                  { 
                      returnString += "App Id: " + appIdErrors; 
                  } 
                  if (!nameErrors.Equals(string.Empty))
                  { 
                      returnString += "Name: " + nameErrors; 
                  } 
                  if (!urlErrors.Equals(string.Empty))
                  { 
                      returnString += "Url: " + urlErrors; 
                  } 
                  if (!PersonFilterIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person FilterID: " + PersonFilterIDErrors; 
                  } 
                  if (!enabledErrors.Equals(string.Empty))
                  { 
                      returnString += "Enabled: " + enabledErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public BO.Interfaces.ORNG.IApps DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            appIdIsNull = true; 
            appIdErrors = string.Empty; 
            nameIsNull = true; 
            nameErrors = string.Empty; 
            urlIsNull = true; 
            urlErrors = string.Empty; 
            PersonFilterIDIsNull = true; 
            PersonFilterIDErrors = string.Empty; 
            enabledIsNull = true; 
            enabledErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
