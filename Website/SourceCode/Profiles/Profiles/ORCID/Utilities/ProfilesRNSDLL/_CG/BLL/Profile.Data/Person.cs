using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data
{
    public partial class Person : ProfilesRNSDLL.DAL.Profile.Data.Person
    {
    
        # region Constructors 
    
        public Person() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.Profile.Data.Person bo) 
        { 
            /*! Check for missing values */ 
            /*! Check for out of Range values */ 
            if (!bo.FirstNameIsNull) 
            { 
                if (bo.FirstName.Length > 50) 
                { 
                     bo.FirstNameErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.LastNameIsNull) 
            { 
                if (bo.LastName.Length > 50) 
                { 
                     bo.LastNameErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.MiddleNameIsNull) 
            { 
                if (bo.MiddleName.Length > 50) 
                { 
                     bo.MiddleNameErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.DisplayNameIsNull) 
            { 
                if (bo.DisplayName.Length > 255) 
                { 
                     bo.DisplayNameErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.SuffixIsNull) 
            { 
                if (bo.Suffix.Length > 50) 
                { 
                     bo.SuffixErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.EmailAddrIsNull) 
            { 
                if (bo.EmailAddr.Length > 255) 
                { 
                     bo.EmailAddrErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.PhoneIsNull) 
            { 
                if (bo.Phone.Length > 35) 
                { 
                     bo.PhoneErrors += "This field has more characters than the maximum that can be stored, i.e. 35 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.FaxIsNull) 
            { 
                if (bo.Fax.Length > 25) 
                { 
                     bo.FaxErrors += "This field has more characters than the maximum that can be stored, i.e. 25 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.AddressLine1IsNull) 
            { 
                if (bo.AddressLine1.Length > 255) 
                { 
                     bo.AddressLine1Errors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.AddressLine2IsNull) 
            { 
                if (bo.AddressLine2.Length > 255) 
                { 
                     bo.AddressLine2Errors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.AddressLine3IsNull) 
            { 
                if (bo.AddressLine3.Length > 255) 
                { 
                     bo.AddressLine3Errors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.AddressLine4IsNull) 
            { 
                if (bo.AddressLine4.Length > 255) 
                { 
                     bo.AddressLine4Errors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.CityIsNull) 
            { 
                if (bo.City.Length > 55) 
                { 
                     bo.CityErrors += "This field has more characters than the maximum that can be stored, i.e. 55 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.StateIsNull) 
            { 
                if (bo.State.Length > 50) 
                { 
                     bo.StateErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.ZipIsNull) 
            { 
                if (bo.Zip.Length > 50) 
                { 
                     bo.ZipErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.BuildingIsNull) 
            { 
                if (bo.Building.Length > 255) 
                { 
                     bo.BuildingErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.RoomIsNull) 
            { 
                if (bo.Room.Length > 255) 
                { 
                     bo.RoomErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.AddressStringIsNull) 
            { 
                if (bo.AddressString.Length > 1000) 
                { 
                     bo.AddressStringErrors += "This field has more characters than the maximum that can be stored, i.e. 1000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.InternalUsernameIsNull) 
            { 
                if (bo.InternalUsername.Length > 50) 
                { 
                     bo.InternalUsernameErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
