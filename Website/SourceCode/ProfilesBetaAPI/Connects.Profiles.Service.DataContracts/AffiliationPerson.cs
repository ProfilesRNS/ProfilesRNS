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
    public partial class AffiliationPerson
    {
        private bool primaryField;
        private string institutionAbbreviationField;
        private string institutionNameField;
        private string departmentNameField;
        private string divisionNameField;
        private string jobTitleField;
        private string facultyTypeAffiliationField;

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
        public string InstitutionAbbreviation
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
        public string InstitutionName
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
        public string DepartmentName
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
        public string DivisionName
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
        public string JobTitle
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

        [System.Xml.Serialization.XmlElementAttribute("FacultyType")]
        [DataMember(IsRequired = false, Name = "FacultyType", Order = 7)]
        public string FacultyType
        {
            get
            {
                return this.facultyTypeAffiliationField;
            }
            set
            {
                this.facultyTypeAffiliationField = value;
            }
        }

    }

    [System.Xml.Serialization.XmlTypeAttribute()]
    [System.SerializableAttribute()]
    public partial class FacultyTypeAffiliationPerson
    {
        private bool visitingField;
        private bool emeritusField;
        private bool fullTimeField;
        private string textField;

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Visiting", Order = 0)]
        public bool Visiting
        {
            get
            {
                return this.visitingField;
            }
            set
            {
                this.visitingField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Emeritus", Order = 1)]
        public bool Emeritus
        {
            get
            {
                return this.emeritusField;
            }
            set
            {
                this.emeritusField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "FullTime", Order = 2)]
        public bool FullTime
        {
            get
            {
                return this.fullTimeField;
            }
            set
            {
                this.fullTimeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text")]
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
