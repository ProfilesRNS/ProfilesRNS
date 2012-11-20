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
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "Publications")]
    public partial class Publications
    {

        private PublicationList publicationListField;

        [DataMember(IsRequired = false, Name = "PublicationList", Order = 1)]
        public PublicationList PublicationList
        {
            get
            {
                return this.publicationListField;
            }
            set
            {
                this.publicationListField = value;
            }
        }
    }
  


    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "Publication")]
    public partial class Publication
    {

        private string publicationIDField;

        private string publicationReferenceField;

        private string publicationURLField;

        private string pubMedIDField;

        private PublicationMatchDetailList publicationMatchDetailListField;

        private string publicationDetailsField;

        private PublicationCustomCategory customCategoryField;

        private PublicationType typeField;

        private bool visibleField;

        private PublicationSourceList publicationSourceListField;

        [DataMember(IsRequired = false, Name = "PublicationID", Order = 1)]
        public string PublicationID
        {
            get
            {
                return this.publicationIDField;
            }
            set
            {
                this.publicationIDField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "PublicationReference", Order = 2)]
        public string PublicationReference
        {
            get
            {
                return this.publicationReferenceField;
            }
            set
            {
                this.publicationReferenceField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "PublicationURL", Order = 3)]
        public string PublicationURL
        {
            get
            {
                return this.publicationURLField;
            }
            set
            {
                this.publicationURLField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "PubMedID", Order = 4)]
        public string PubMedID
        {
            get
            {
                return this.pubMedIDField;
            }
            set
            {
                this.pubMedIDField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "PublicationMatchDetailList", Order = 5)]
        public PublicationMatchDetailList PublicationMatchDetailList
        {
            get
            {
                return this.publicationMatchDetailListField;
            }
            set
            {
                this.publicationMatchDetailListField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "PublicationDetails", Order = 6)]
        public string PublicationDetails
        {
            get
            {
                return this.publicationDetailsField;
            }
            set
            {
                this.publicationDetailsField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "CustomCategory", Order = 7, EmitDefaultValue=false)]
        public PublicationCustomCategory CustomCategory
        {
            get
            {
                return this.customCategoryField;
            }
            set
            {
                this.customCategoryField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Type", Order = 8)]
        public PublicationType Type
        {
            get
            {
                return this.typeField;
            }
            set
            {
                this.typeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Visible", Order = 9)]
        public bool Visible
        {
            get
            {
                return this.visibleField;
            }
            set
            {
                this.visibleField = value;
            }
        }

        /// <remarks/>
        [DataMember(IsRequired = false, Name = "PublicationSourceList", Order = 10)]
        public PublicationSourceList PublicationSourceList
        {
            get
            {
                return this.publicationSourceListField;
            }
            set
            {
                this.publicationSourceListField = value;
            }
        }

    }

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "PublicationCustomCategory")]
    public enum PublicationCustomCategory
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("")]
        [EnumMember(Value = "None")]
        None,

        
    /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("Reviews/Chapters/Editorials")]
        [EnumMember(Value = "Reviews/Chapters/Editorials")]
        ReviewsChaptersEditorials,


        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("Books/Monographs/Textbooks")]
        [EnumMember(Value = "Books/Monographs/Textbooks")]
        BooksMonographsTextbooks,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("Educational Materials")]
        [EnumMember(Value = "Educational Materials")]
        EducationalMaterials,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("Non-Print Materials")]
        [EnumMember(Value = "Non-Print Materials")]
        NonPrintMaterials,

        [EnumMember(Value = "Thesis")]
        Thesis,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("Education Materials")]
        [EnumMember(Value = "EducationMaterials")]
        EducationMaterials,

        [EnumMember(Value = "Abstracts")]
        Abstracts,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("Original Articles")]
        [EnumMember(Value = "OriginalArticles")]
        OriginalArticles,

        [EnumMember(Value = "Patents")]
        Patents,

        [EnumMember(Value = "Reviews")]
        Reviews,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("Clinical Communications")]
        [EnumMember(Value = "Clinical Communications")]
        ClinicalCommunications,

        /// <remarks/>
        [System.Xml.Serialization.XmlEnumAttribute("Proceedings of Meetings")]
        [EnumMember(Value = "Proceedings of Meetings")]
        ProceedingsofMeetings,

        [EnumMember(Value = "Books")]
        Books,
    }

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "PublicationType")]
    public enum PublicationType
    {
        [EnumMember(Value = "PubMed")]
        PubMed,

        [EnumMember(Value = "Custom")]
        Custom,
    }

}
