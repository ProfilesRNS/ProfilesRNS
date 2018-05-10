using System.Runtime.Serialization;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    [DataContract]
    public abstract partial class BaseClassBO : DevelopmentBase.BO.IBaseClassBO
    {
        [DataMember]
        public abstract int TableId { get; }
        [DataMember]
        public abstract string TableSchemaName { get; }
        [DataMember]
        public bool Exists { get; set; }
        [DataMember]
        public bool HasError { get; set; }
        [DataMember]
        public string Error { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public virtual string IdentityValue { get; set; }
        [DataMember]
        public virtual bool IdentityIsNull { get; set; }

        protected virtual void InitializeProperties() 
        {
        }
        protected virtual void InitializePropertiesCG()
        { 
        }
        public string Tablename
        {
            get
            {
                return this.GetType().ToString().Split('.')[this.GetType().ToString().Split('.').Length - 1];
            }
        }
        [DataContract]
        public enum RecordLevelAuditTypes : int {
            [EnumMember]
            Added = 1,
            [EnumMember]
            Double_Entered = 2,
            [EnumMember]
            Edited = 3,
            [EnumMember]
            Deleted = 4,
            [EnumMember]
            Viewed = 5
        }

        public enum ProjectRoles
        {
        }

        public BaseClassBO()
        {
            Error = string.Empty;
            Message = string.Empty;
            InitializeProperties();
            InitializePropertiesCG();
        }
    } 
}
