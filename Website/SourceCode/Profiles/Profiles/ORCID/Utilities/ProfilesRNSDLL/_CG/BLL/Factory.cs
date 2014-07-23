using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL
{
    public abstract partial class Factory : DevelopmentBase.Factory
    {
        # region private variables
        private ProfilesRNSDLL.BLL.ORNG.AppData _AppData = null;
        private ProfilesRNSDLL.BLL.ORNG.AppRegistry _AppRegistry = null;
        private ProfilesRNSDLL.BLL.ORNG.Apps _Apps = null;
        private ProfilesRNSDLL.BLL.ORCID.ErrorLog _ErrorLog = null;
        private ProfilesRNSDLL.BLL.ORCID.FieldLevelAuditTrail _FieldLevelAuditTrail = null;
        private ProfilesRNSDLL.BLL.Profile.Import.FreetextKeywords _FreetextKeywords = null;
        private ProfilesRNSDLL.BLL.RDF.Security.Group _Group = null;
        private ProfilesRNSDLL.BLL.Profile.Import.NIHAwards _NIHAwards = null;
        private ProfilesRNSDLL.BLL.RDF.Node _Node = null;
        private ProfilesRNSDLL.BLL.Profile.Data.OrganizationDepartment _OrganizationDepartment = null;
        private ProfilesRNSDLL.BLL.Profile.Data.OrganizationDivision _OrganizationDivision = null;
        private ProfilesRNSDLL.BLL.Profile.Data.OrganizationInstitution _OrganizationInstitution = null;
        private ProfilesRNSDLL.BLL.ORCID.Person _Person = null;
        private ProfilesRNSDLL.BLL.Profile.Data.Person _Person = null;
        private ProfilesRNSDLL.BLL.ORCID.PersonAffiliation _PersonAffiliation = null;
        private ProfilesRNSDLL.BLL.ORCID.PersonAlternateEmail _PersonAlternateEmail = null;
        private ProfilesRNSDLL.BLL.Profile.Data.PersonFacultyRank _PersonFacultyRank = null;
        private ProfilesRNSDLL.BLL.ORCID.PersonMessage _PersonMessage = null;
        private ProfilesRNSDLL.BLL.ORCID.PersonOthername _PersonOthername = null;
        private ProfilesRNSDLL.BLL.ORCID.PersonToken _PersonToken = null;
        private ProfilesRNSDLL.BLL.ORCID.PersonURL _PersonURL = null;
        private ProfilesRNSDLL.BLL.ORCID.PersonWork _PersonWork = null;
        private ProfilesRNSDLL.BLL.ORCID.PersonWorkIdentifier _PersonWorkIdentifier = null;
        private ProfilesRNSDLL.BLL.ORCID.RecordLevelAuditTrail _RecordLevelAuditTrail = null;
        private ProfilesRNSDLL.BLL.ORCID.RecordLevelAuditType _RecordLevelAuditType = null;
        private ProfilesRNSDLL.BLL.ORCID.REFDecision _REFDecision = null;
        private ProfilesRNSDLL.BLL.ORCID.REFPermission _REFPermission = null;
        private ProfilesRNSDLL.BLL.RDF.Triple _Triple = null;
        # endregion // private variables

        public ProfilesRNSDLL.BLL.ORNG.AppData AppData
        {
            get
            {
                if (_AppData == null)
                {
                    _AppData = new ProfilesRNSDLL.BLL.ORNG.AppData(AppUser);
                }
                return _AppData;
            }
        }
        public ProfilesRNSDLL.BLL.ORNG.AppRegistry AppRegistry
        {
            get
            {
                if (_AppRegistry == null)
                {
                    _AppRegistry = new ProfilesRNSDLL.BLL.ORNG.AppRegistry(AppUser);
                }
                return _AppRegistry;
            }
        }
        public ProfilesRNSDLL.BLL.ORNG.Apps Apps
        {
            get
            {
                if (_Apps == null)
                {
                    _Apps = new ProfilesRNSDLL.BLL.ORNG.Apps(AppUser);
                }
                return _Apps;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.ErrorLog ErrorLog
        {
            get
            {
                if (_ErrorLog == null)
                {
                    _ErrorLog = new ProfilesRNSDLL.BLL.ORCID.ErrorLog(AppUser);
                }
                return _ErrorLog;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.FieldLevelAuditTrail FieldLevelAuditTrail
        {
            get
            {
                if (_FieldLevelAuditTrail == null)
                {
                    _FieldLevelAuditTrail = new ProfilesRNSDLL.BLL.ORCID.FieldLevelAuditTrail(AppUser);
                }
                return _FieldLevelAuditTrail;
            }
        }
        public ProfilesRNSDLL.BLL.Profile.Import.FreetextKeywords FreetextKeywords
        {
            get
            {
                if (_FreetextKeywords == null)
                {
                    _FreetextKeywords = new ProfilesRNSDLL.BLL.Profile.Import.FreetextKeywords(AppUser);
                }
                return _FreetextKeywords;
            }
        }
        public ProfilesRNSDLL.BLL.RDF.Security.Group Group
        {
            get
            {
                if (_Group == null)
                {
                    _Group = new ProfilesRNSDLL.BLL.RDF.Security.Group(AppUser);
                }
                return _Group;
            }
        }
        public ProfilesRNSDLL.BLL.Profile.Import.NIHAwards NIHAwards
        {
            get
            {
                if (_NIHAwards == null)
                {
                    _NIHAwards = new ProfilesRNSDLL.BLL.Profile.Import.NIHAwards(AppUser);
                }
                return _NIHAwards;
            }
        }
        public ProfilesRNSDLL.BLL.RDF.Node Node
        {
            get
            {
                if (_Node == null)
                {
                    _Node = new ProfilesRNSDLL.BLL.RDF.Node(AppUser);
                }
                return _Node;
            }
        }
        public ProfilesRNSDLL.BLL.Profile.Data.OrganizationDepartment OrganizationDepartment
        {
            get
            {
                if (_OrganizationDepartment == null)
                {
                    _OrganizationDepartment = new ProfilesRNSDLL.BLL.Profile.Data.OrganizationDepartment(AppUser);
                }
                return _OrganizationDepartment;
            }
        }
        public ProfilesRNSDLL.BLL.Profile.Data.OrganizationDivision OrganizationDivision
        {
            get
            {
                if (_OrganizationDivision == null)
                {
                    _OrganizationDivision = new ProfilesRNSDLL.BLL.Profile.Data.OrganizationDivision(AppUser);
                }
                return _OrganizationDivision;
            }
        }
        public ProfilesRNSDLL.BLL.Profile.Data.OrganizationInstitution OrganizationInstitution
        {
            get
            {
                if (_OrganizationInstitution == null)
                {
                    _OrganizationInstitution = new ProfilesRNSDLL.BLL.Profile.Data.OrganizationInstitution(AppUser);
                }
                return _OrganizationInstitution;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.Person Person
        {
            get
            {
                if (_Person == null)
                {
                    _Person = new ProfilesRNSDLL.BLL.ORCID.Person(AppUser);
                }
                return _Person;
            }
        }
        public ProfilesRNSDLL.BLL.Profile.Data.Person Person
        {
            get
            {
                if (_Person == null)
                {
                    _Person = new ProfilesRNSDLL.BLL.Profile.Data.Person(AppUser);
                }
                return _Person;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.PersonAffiliation PersonAffiliation
        {
            get
            {
                if (_PersonAffiliation == null)
                {
                    _PersonAffiliation = new ProfilesRNSDLL.BLL.ORCID.PersonAffiliation(AppUser);
                }
                return _PersonAffiliation;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.PersonAlternateEmail PersonAlternateEmail
        {
            get
            {
                if (_PersonAlternateEmail == null)
                {
                    _PersonAlternateEmail = new ProfilesRNSDLL.BLL.ORCID.PersonAlternateEmail(AppUser);
                }
                return _PersonAlternateEmail;
            }
        }
        public ProfilesRNSDLL.BLL.Profile.Data.PersonFacultyRank PersonFacultyRank
        {
            get
            {
                if (_PersonFacultyRank == null)
                {
                    _PersonFacultyRank = new ProfilesRNSDLL.BLL.Profile.Data.PersonFacultyRank(AppUser);
                }
                return _PersonFacultyRank;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.PersonMessage PersonMessage
        {
            get
            {
                if (_PersonMessage == null)
                {
                    _PersonMessage = new ProfilesRNSDLL.BLL.ORCID.PersonMessage(AppUser);
                }
                return _PersonMessage;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.PersonOthername PersonOthername
        {
            get
            {
                if (_PersonOthername == null)
                {
                    _PersonOthername = new ProfilesRNSDLL.BLL.ORCID.PersonOthername(AppUser);
                }
                return _PersonOthername;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.PersonToken PersonToken
        {
            get
            {
                if (_PersonToken == null)
                {
                    _PersonToken = new ProfilesRNSDLL.BLL.ORCID.PersonToken(AppUser);
                }
                return _PersonToken;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.PersonURL PersonURL
        {
            get
            {
                if (_PersonURL == null)
                {
                    _PersonURL = new ProfilesRNSDLL.BLL.ORCID.PersonURL(AppUser);
                }
                return _PersonURL;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.PersonWork PersonWork
        {
            get
            {
                if (_PersonWork == null)
                {
                    _PersonWork = new ProfilesRNSDLL.BLL.ORCID.PersonWork(AppUser);
                }
                return _PersonWork;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.PersonWorkIdentifier PersonWorkIdentifier
        {
            get
            {
                if (_PersonWorkIdentifier == null)
                {
                    _PersonWorkIdentifier = new ProfilesRNSDLL.BLL.ORCID.PersonWorkIdentifier(AppUser);
                }
                return _PersonWorkIdentifier;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.RecordLevelAuditTrail RecordLevelAuditTrail
        {
            get
            {
                if (_RecordLevelAuditTrail == null)
                {
                    _RecordLevelAuditTrail = new ProfilesRNSDLL.BLL.ORCID.RecordLevelAuditTrail(AppUser);
                }
                return _RecordLevelAuditTrail;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.RecordLevelAuditType RecordLevelAuditType
        {
            get
            {
                if (_RecordLevelAuditType == null)
                {
                    _RecordLevelAuditType = new ProfilesRNSDLL.BLL.ORCID.RecordLevelAuditType(AppUser);
                }
                return _RecordLevelAuditType;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.REFDecision REFDecision
        {
            get
            {
                if (_REFDecision == null)
                {
                    _REFDecision = new ProfilesRNSDLL.BLL.ORCID.REFDecision(AppUser);
                }
                return _REFDecision;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.REFPermission REFPermission
        {
            get
            {
                if (_REFPermission == null)
                {
                    _REFPermission = new ProfilesRNSDLL.BLL.ORCID.REFPermission(AppUser);
                }
                return _REFPermission;
            }
        }
        public ProfilesRNSDLL.BLL.RDF.Triple Triple
        {
            get
            {
                if (_Triple == null)
                {
                    _Triple = new ProfilesRNSDLL.BLL.RDF.Triple(AppUser);
                }
                return _Triple;
            }
        }
    }
}
