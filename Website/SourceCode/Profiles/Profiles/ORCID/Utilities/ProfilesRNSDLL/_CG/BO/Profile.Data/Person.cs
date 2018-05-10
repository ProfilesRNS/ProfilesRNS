using System;
using System.Collections.Generic;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Data
{
    public partial class Person : ProfilesRNSBaseClassBO, BO.Interfaces.Profile.Data.IPerson, IEqualityComparer<Person>, IEquatable<Person> 
    { 
        # region Private variables 
          /*! PersonID state (PersonID) */ 
          private int _PersonID;
          /*! UserID state (UserID) */ 
          private int _UserID;
          /*! FirstName state (First Name) */ 
          private string _FirstName;
          /*! LastName state (Last Name) */ 
          private string _LastName;
          /*! MiddleName state (Middle Name) */ 
          private string _MiddleName;
          /*! DisplayName state (Display Name) */ 
          private string _DisplayName;
          /*! Suffix state (Suffix) */ 
          private string _Suffix;
          /*! IsActive state (Is Active) */ 
          private bool _IsActive;
          /*! EmailAddr state (Email Addr) */ 
          private string _EmailAddr;
          /*! Phone state (Phone) */ 
          private string _Phone;
          /*! Fax state (Fax) */ 
          private string _Fax;
          /*! AddressLine1 state (Address Line 1) */ 
          private string _AddressLine1;
          /*! AddressLine2 state (Address Line 2) */ 
          private string _AddressLine2;
          /*! AddressLine3 state (Address Line 3) */ 
          private string _AddressLine3;
          /*! AddressLine4 state (Address Line 4) */ 
          private string _AddressLine4;
          /*! City state (City) */ 
          private string _City;
          /*! State state (State) */ 
          private string _State;
          /*! Zip state (Zip) */ 
          private string _Zip;
          /*! Building state (Building) */ 
          private string _Building;
          /*! Floor state (Floor) */ 
          private int _Floor;
          /*! Room state (Room) */ 
          private string _Room;
          /*! AddressString state (Address String) */ 
          private string _AddressString;
          /*! Latitude state (Latitude) */ 
          private double _Latitude;
          /*! Longitude state (Longitude) */ 
          private double _Longitude;
          /*! GeoScore state (Geo Score) */ 
          private int _GeoScore;
          /*! FacultyRankID state (Faculty RankID) */ 
          private int _FacultyRankID;
          /*! InternalUsername state (Internal Username) */ 
          private string _InternalUsername;
          /*! Visible state (Visible) */ 
          private bool _Visible;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PersonID 
        { 
              get { return _PersonID; } 
              set { _PersonID = value; PersonIDIsNull = false; } 
        } 
        public bool PersonIDIsNull { get; set; }
        public string PersonIDErrors { get; set; }
        public string PersonIDText { get { if (PersonIDIsNull){ return string.Empty; } return PersonID.ToString(); } } 
        public override string IdentityValue { get { if (PersonIDIsNull){ return string.Empty; } return PersonID.ToString(); } } 
        public override bool IdentityIsNull { get { return PersonIDIsNull; } } 
        
        public int UserID 
        { 
              get { return _UserID; } 
              set { _UserID = value; UserIDIsNull = false; } 
        } 
        public bool UserIDIsNull { get; set; }
        public string UserIDErrors { get; set; }
        
        public string FirstName 
        { 
              get { return _FirstName; } 
              set { _FirstName = value; FirstNameIsNull = false; } 
        } 
        public bool FirstNameIsNull { get; set; }
        public string FirstNameErrors { get; set; }
        
        public string LastName 
        { 
              get { return _LastName; } 
              set { _LastName = value; LastNameIsNull = false; } 
        } 
        public bool LastNameIsNull { get; set; }
        public string LastNameErrors { get; set; }
        
        public string MiddleName 
        { 
              get { return _MiddleName; } 
              set { _MiddleName = value; MiddleNameIsNull = false; } 
        } 
        public bool MiddleNameIsNull { get; set; }
        public string MiddleNameErrors { get; set; }
        
        public string DisplayName 
        { 
              get { return _DisplayName; } 
              set { _DisplayName = value; DisplayNameIsNull = false; } 
        } 
        public bool DisplayNameIsNull { get; set; }
        public string DisplayNameErrors { get; set; }
        
        public string Suffix 
        { 
              get { return _Suffix; } 
              set { _Suffix = value; SuffixIsNull = false; } 
        } 
        public bool SuffixIsNull { get; set; }
        public string SuffixErrors { get; set; }
        
        public bool IsActive 
        { 
              get { return _IsActive; } 
              set { _IsActive = value; IsActiveIsNull = false; } 
        } 
        public bool IsActiveIsNull { get; set; }
        public string IsActiveErrors { get; set; }
        public string IsActiveDesc { get { if (IsActiveIsNull){ return string.Empty; } else if (IsActive){ return "Yes"; } else { return "No"; } } } 
        
        public string EmailAddr 
        { 
              get { return _EmailAddr; } 
              set { _EmailAddr = value; EmailAddrIsNull = false; } 
        } 
        public bool EmailAddrIsNull { get; set; }
        public string EmailAddrErrors { get; set; }
        
        public string Phone 
        { 
              get { return _Phone; } 
              set { _Phone = value; PhoneIsNull = false; } 
        } 
        public bool PhoneIsNull { get; set; }
        public string PhoneErrors { get; set; }
        
        public string Fax 
        { 
              get { return _Fax; } 
              set { _Fax = value; FaxIsNull = false; } 
        } 
        public bool FaxIsNull { get; set; }
        public string FaxErrors { get; set; }
        
        public string AddressLine1 
        { 
              get { return _AddressLine1; } 
              set { _AddressLine1 = value; AddressLine1IsNull = false; } 
        } 
        public bool AddressLine1IsNull { get; set; }
        public string AddressLine1Errors { get; set; }
        
        public string AddressLine2 
        { 
              get { return _AddressLine2; } 
              set { _AddressLine2 = value; AddressLine2IsNull = false; } 
        } 
        public bool AddressLine2IsNull { get; set; }
        public string AddressLine2Errors { get; set; }
        
        public string AddressLine3 
        { 
              get { return _AddressLine3; } 
              set { _AddressLine3 = value; AddressLine3IsNull = false; } 
        } 
        public bool AddressLine3IsNull { get; set; }
        public string AddressLine3Errors { get; set; }
        
        public string AddressLine4 
        { 
              get { return _AddressLine4; } 
              set { _AddressLine4 = value; AddressLine4IsNull = false; } 
        } 
        public bool AddressLine4IsNull { get; set; }
        public string AddressLine4Errors { get; set; }
        
        public string City 
        { 
              get { return _City; } 
              set { _City = value; CityIsNull = false; } 
        } 
        public bool CityIsNull { get; set; }
        public string CityErrors { get; set; }
        
        public string State 
        { 
              get { return _State; } 
              set { _State = value; StateIsNull = false; } 
        } 
        public bool StateIsNull { get; set; }
        public string StateErrors { get; set; }
        
        public string Zip 
        { 
              get { return _Zip; } 
              set { _Zip = value; ZipIsNull = false; } 
        } 
        public bool ZipIsNull { get; set; }
        public string ZipErrors { get; set; }
        
        public string Building 
        { 
              get { return _Building; } 
              set { _Building = value; BuildingIsNull = false; } 
        } 
        public bool BuildingIsNull { get; set; }
        public string BuildingErrors { get; set; }
        
        public int Floor 
        { 
              get { return _Floor; } 
              set { _Floor = value; FloorIsNull = false; } 
        } 
        public bool FloorIsNull { get; set; }
        public string FloorErrors { get; set; }
        
        public string Room 
        { 
              get { return _Room; } 
              set { _Room = value; RoomIsNull = false; } 
        } 
        public bool RoomIsNull { get; set; }
        public string RoomErrors { get; set; }
        
        public string AddressString 
        { 
              get { return _AddressString; } 
              set { _AddressString = value; AddressStringIsNull = false; } 
        } 
        public bool AddressStringIsNull { get; set; }
        public string AddressStringErrors { get; set; }
        
        public double Latitude 
        { 
              get { return _Latitude; } 
              set { _Latitude = value; LatitudeIsNull = false; } 
        } 
        public bool LatitudeIsNull { get; set; }
        public string LatitudeErrors { get; set; }
        
        public double Longitude 
        { 
              get { return _Longitude; } 
              set { _Longitude = value; LongitudeIsNull = false; } 
        } 
        public bool LongitudeIsNull { get; set; }
        public string LongitudeErrors { get; set; }
        
        public int GeoScore 
        { 
              get { return _GeoScore; } 
              set { _GeoScore = value; GeoScoreIsNull = false; } 
        } 
        public bool GeoScoreIsNull { get; set; }
        public string GeoScoreErrors { get; set; }
        
        public int FacultyRankID 
        { 
              get { return _FacultyRankID; } 
              set { _FacultyRankID = value; FacultyRankIDIsNull = false; } 
        } 
        public bool FacultyRankIDIsNull { get; set; }
        public string FacultyRankIDErrors { get; set; }
        
        public string InternalUsername 
        { 
              get { return _InternalUsername; } 
              set { _InternalUsername = value; InternalUsernameIsNull = false; } 
        } 
        public bool InternalUsernameIsNull { get; set; }
        public string InternalUsernameErrors { get; set; }
        
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
                  if (!PersonIDErrors.Equals(string.Empty))
                  { 
                      returnString += "PersonID: " + PersonIDErrors; 
                  } 
                  if (!UserIDErrors.Equals(string.Empty))
                  { 
                      returnString += "UserID: " + UserIDErrors; 
                  } 
                  if (!FirstNameErrors.Equals(string.Empty))
                  { 
                      returnString += "First Name: " + FirstNameErrors; 
                  } 
                  if (!LastNameErrors.Equals(string.Empty))
                  { 
                      returnString += "Last Name: " + LastNameErrors; 
                  } 
                  if (!MiddleNameErrors.Equals(string.Empty))
                  { 
                      returnString += "Middle Name: " + MiddleNameErrors; 
                  } 
                  if (!DisplayNameErrors.Equals(string.Empty))
                  { 
                      returnString += "Display Name: " + DisplayNameErrors; 
                  } 
                  if (!SuffixErrors.Equals(string.Empty))
                  { 
                      returnString += "Suffix: " + SuffixErrors; 
                  } 
                  if (!IsActiveErrors.Equals(string.Empty))
                  { 
                      returnString += "Is Active: " + IsActiveErrors; 
                  } 
                  if (!EmailAddrErrors.Equals(string.Empty))
                  { 
                      returnString += "Email Addr: " + EmailAddrErrors; 
                  } 
                  if (!PhoneErrors.Equals(string.Empty))
                  { 
                      returnString += "Phone: " + PhoneErrors; 
                  } 
                  if (!FaxErrors.Equals(string.Empty))
                  { 
                      returnString += "Fax: " + FaxErrors; 
                  } 
                  if (!AddressLine1Errors.Equals(string.Empty))
                  { 
                      returnString += "Address Line 1: " + AddressLine1Errors; 
                  } 
                  if (!AddressLine2Errors.Equals(string.Empty))
                  { 
                      returnString += "Address Line 2: " + AddressLine2Errors; 
                  } 
                  if (!AddressLine3Errors.Equals(string.Empty))
                  { 
                      returnString += "Address Line 3: " + AddressLine3Errors; 
                  } 
                  if (!AddressLine4Errors.Equals(string.Empty))
                  { 
                      returnString += "Address Line 4: " + AddressLine4Errors; 
                  } 
                  if (!CityErrors.Equals(string.Empty))
                  { 
                      returnString += "City: " + CityErrors; 
                  } 
                  if (!StateErrors.Equals(string.Empty))
                  { 
                      returnString += "State: " + StateErrors; 
                  } 
                  if (!ZipErrors.Equals(string.Empty))
                  { 
                      returnString += "Zip: " + ZipErrors; 
                  } 
                  if (!BuildingErrors.Equals(string.Empty))
                  { 
                      returnString += "Building: " + BuildingErrors; 
                  } 
                  if (!FloorErrors.Equals(string.Empty))
                  { 
                      returnString += "Floor: " + FloorErrors; 
                  } 
                  if (!RoomErrors.Equals(string.Empty))
                  { 
                      returnString += "Room: " + RoomErrors; 
                  } 
                  if (!AddressStringErrors.Equals(string.Empty))
                  { 
                      returnString += "Address String: " + AddressStringErrors; 
                  } 
                  if (!LatitudeErrors.Equals(string.Empty))
                  { 
                      returnString += "Latitude: " + LatitudeErrors; 
                  } 
                  if (!LongitudeErrors.Equals(string.Empty))
                  { 
                      returnString += "Longitude: " + LongitudeErrors; 
                  } 
                  if (!GeoScoreErrors.Equals(string.Empty))
                  { 
                      returnString += "Geo Score: " + GeoScoreErrors; 
                  } 
                  if (!FacultyRankIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Faculty RankID: " + FacultyRankIDErrors; 
                  } 
                  if (!InternalUsernameErrors.Equals(string.Empty))
                  { 
                      returnString += "Internal Username: " + InternalUsernameErrors; 
                  } 
                  if (!VisibleErrors.Equals(string.Empty))
                  { 
                      returnString += "Visible: " + VisibleErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(Person left, Person right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PersonID == right.PersonID;
        }
        public int GetHashCode(Person obj)
        {
            return (obj.PersonID).GetHashCode();
        }
        public bool Equals(Person other)
        {
            if (this.PersonID == other.PersonID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PersonID.GetHashCode();
        }

        public BO.Interfaces.Profile.Data.IPerson DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PersonIDIsNull = true; 
            PersonIDErrors = string.Empty; 
            UserIDIsNull = true; 
            UserIDErrors = string.Empty; 
            FirstNameIsNull = true; 
            FirstNameErrors = string.Empty; 
            LastNameIsNull = true; 
            LastNameErrors = string.Empty; 
            MiddleNameIsNull = true; 
            MiddleNameErrors = string.Empty; 
            DisplayNameIsNull = true; 
            DisplayNameErrors = string.Empty; 
            SuffixIsNull = true; 
            SuffixErrors = string.Empty; 
            IsActiveIsNull = true; 
            IsActiveErrors = string.Empty; 
            EmailAddrIsNull = true; 
            EmailAddrErrors = string.Empty; 
            PhoneIsNull = true; 
            PhoneErrors = string.Empty; 
            FaxIsNull = true; 
            FaxErrors = string.Empty; 
            AddressLine1IsNull = true; 
            AddressLine1Errors = string.Empty; 
            AddressLine2IsNull = true; 
            AddressLine2Errors = string.Empty; 
            AddressLine3IsNull = true; 
            AddressLine3Errors = string.Empty; 
            AddressLine4IsNull = true; 
            AddressLine4Errors = string.Empty; 
            CityIsNull = true; 
            CityErrors = string.Empty; 
            StateIsNull = true; 
            StateErrors = string.Empty; 
            ZipIsNull = true; 
            ZipErrors = string.Empty; 
            BuildingIsNull = true; 
            BuildingErrors = string.Empty; 
            FloorIsNull = true; 
            FloorErrors = string.Empty; 
            RoomIsNull = true; 
            RoomErrors = string.Empty; 
            AddressStringIsNull = true; 
            AddressStringErrors = string.Empty; 
            LatitudeIsNull = true; 
            LatitudeErrors = string.Empty; 
            LongitudeIsNull = true; 
            LongitudeErrors = string.Empty; 
            GeoScoreIsNull = true; 
            GeoScoreErrors = string.Empty; 
            FacultyRankIDIsNull = true; 
            FacultyRankIDErrors = string.Empty; 
            InternalUsernameIsNull = true; 
            InternalUsernameErrors = string.Empty; 
            VisibleIsNull = true; 
            VisibleErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
