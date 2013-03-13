/*  
 
    Copyright (c) 2008-2010 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System.Xml.Serialization;
using System.Runtime.Serialization;
using System.Collections.Generic;

namespace Connects.Profiles.Service.DataContracts
{
    /// <remarks/>
    [System.Xml.Serialization.XmlTypeAttribute()]
    [System.SerializableAttribute()]
    public partial class Affiliation
    {
        private bool primaryField;
        private AffiliationInstitutionAbbreviation institutionAbbreviationField;
        private AffiliationInstitutionName institutionNameField;
        private AffiliationDepartmentName departmentNameField;
        private AffiliationDivisionName divisionNameField;
        private AffiliationJobTitle jobTitleField;
        private AffiliationFacultyRank facultyRankField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Primary", Order = 1)]
        public bool Primary
        {
            get
            {
                return this.primaryField;
            }
            set
            {
                this.primaryField = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("InstitutionAbbreviation")]
        [DataMember(IsRequired = false, Name = "InstitutionAbbreviation", Order = 2)]
        public AffiliationInstitutionAbbreviation InstitutionAbbreviation
        {
            get
            {
                return this.institutionAbbreviationField;
            }
            set
            {
                this.institutionAbbreviationField = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("InstitutionName")]
        [DataMember(IsRequired = false, Name = "InstitutionName", Order = 3)]
        public AffiliationInstitutionName InstitutionName
        {
            get
            {
                return this.institutionNameField;
            }
            set
            {
                this.institutionNameField = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("DepartmentName")]
        [DataMember(IsRequired = false, Name = "DepartmentName", Order = 4)]
        public AffiliationDepartmentName DepartmentName
        {
            get
            {
                return this.departmentNameField;
            }
            set
            {
                this.departmentNameField = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("DivisionName")]
        [DataMember(IsRequired = false, Name = "DivisionName", Order = 5)]
        public AffiliationDivisionName DivisionName
        {
            get
            {
                return this.divisionNameField;
            }
            set
            {
                this.divisionNameField = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("JobTitle")]
        [DataMember(IsRequired = false, Name = "JobTitle", Order = 6)]
        public AffiliationJobTitle JobTitle
        {
            get
            {
                return this.jobTitleField;
            }
            set
            {
                this.jobTitleField = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("FacultyRank")]
        [DataMember(IsRequired = false, Name = "FacultyRank", Order = 7)]
        public AffiliationFacultyRank FacultyRank
        {
            get
            {
                return this.facultyRankField;
            }
            set
            {
                this.facultyRankField = value;
            }
        }

    }

    [System.Xml.Serialization.XmlTypeAttribute()]
    [System.SerializableAttribute()]
    public partial class AffiliationInstitutionAbbreviation
    {

        private bool excludeField;

        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Exclude", Order = 1)]
        public bool Exclude
        {
            get
            {
                return this.excludeField;
            }
            set
            {
                this.excludeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 2)]
        public string Text
        {
            get
            {
                return this.textField;
            }
            set
            {
                this.textField = value;
            }
        }
    }

    [System.Xml.Serialization.XmlTypeAttribute()]
    [System.SerializableAttribute()]
    public partial class AffiliationInstitutionName
    {

        private bool excludeField;

        private string textField;

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Exclude", Order = 1)]
        public bool Exclude
        {
            get
            {
                return this.excludeField;
            }
            set
            {
                this.excludeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 2)]
        public string Text
        {
            get
            {
                return this.textField;
            }
            set
            {
                this.textField = value;
            }
        }
    }

    [System.Xml.Serialization.XmlTypeAttribute()]
    [System.SerializableAttribute()]
    public partial class AffiliationDepartmentName
    {

        private bool excludeField;

        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Exclude", Order = 1)]
        public bool Exclude
        {
            get
            {
                return this.excludeField;
            }
            set
            {
                this.excludeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 2)]
        public string Text
        {
            get
            {
                return this.textField;
            }
            set
            {
                this.textField = value;
            }
        }
    }

    public partial class AffiliationDivisionName
    {

        private bool excludeField;

        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Exclude", Order = 1)]
        public bool Exclude
        {
            get
            {
                return this.excludeField;
            }
            set
            {
                this.excludeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 2)]
        public string Text
        {
            get
            {
                return this.textField;
            }
            set
            {
                this.textField = value;
            }
        }
    }

    public partial class AffiliationJobTitle
    {

        private bool excludeField;

        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Exclude", Order = 1)]
        public bool Exclude
        {
            get
            {
                return this.excludeField;
            }
            set
            {
                this.excludeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 2)]
        public string Text
        {
            get
            {
                return this.textField;
            }
            set
            {
                this.textField = value;
            }
        }
    }

    public partial class AffiliationFacultyRank
    {

        private bool excludeField;

        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Exclude", Order = 1)]
        public bool Exclude
        {
            get
            {
                return this.excludeField;
            }
            set
            {
                this.excludeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 2)]
        public string Text
        {
            get
            {
                return this.textField;
            }
            set
            {
                this.textField = value;
            }
        }
    }


}
