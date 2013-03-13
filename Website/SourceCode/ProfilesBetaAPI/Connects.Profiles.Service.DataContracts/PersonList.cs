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
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://connects.profiles.schema/profiles/personlist")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "http://connects.profiles.schema/profiles/personlist", IsNullable = true)]
    [DataContract(Namespace = "http://connects.profiles.schema/profiles/personlist", Name = "PersonList")]
    public partial class PersonList
    {
        private string queryIDField;

        private List<Person> personField;

        private bool completeField;

        private string thisCountField;

        private string totalCountField;

        [System.Xml.Serialization.XmlElementAttribute("Person")]
        [DataMember(IsRequired = false, Name = "Person", Order = 1)]
        public List<Person> Person
        {
            get
            {
                return this.personField;
            }
            set
            {
                this.personField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Complete", Order = 2)]
        public bool Complete
        {
            get
            {
                return this.completeField;
            }
            set
            {
                this.completeField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(DataType = "integer")]
        [DataMember(IsRequired = false, Name = "ThisCount", Order = 3)]
        public string ThisCount
        {
            get
            {
                return this.thisCountField;
            }
            set
            {
                this.thisCountField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(DataType = "integer")]
        [DataMember(IsRequired = false, Name = "TotalCount", Order = 4)]
        public string TotalCount
        {
            get
            {
                return this.totalCountField;
            }
            set
            {
                this.totalCountField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute(DataType = "string")]
        [DataMember(IsRequired = false, Name = "QueryID", Order = 5)]
        public string QueryID
        {
            get
            {
                return this.queryIDField;
            }
            set
            {
                this.queryIDField = value;
            }
        }

    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.3038")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "Person")]
    public partial class Person
    {

        private string personIDField;

        //shared
        private NamePerson nameField;

        private InternalIDList internalIdListField;

        private Address addressField;

        // shared
        private AffiliationListPerson affiliationListField;

        // unique
        private ProfileURL profileURLField;

        // unique
        private BasicStatistics basicStatisticsField;

        // unique
        private EmailImageUrl emailImageUrlField;

        // unique
        private PhotoUrl photoUrlField;

        // unique
        private AwardList awardListField;

        // unique
        private Narrative narrativeField;

        // unique
        private PublicationList publicationsField;
        private Publications publications;        
        private PassiveNetworks passiveNetworksField;

        private string queryRelevanceField;

        private bool visibleField;

        // unique
        [DataMember(IsRequired = false, Name = "PersonID")]
        public string PersonID
        {
            get
            {
                return this.personIDField;
            }
            set
            {
                this.personIDField = value;
            }
        }

        [XmlElement(ElementName="Name")]
        [DataMember(IsRequired = false, Name = "Name")]
        public NamePerson Name
        {
            get
            {
                return this.nameField;
            }
            set
            {
                this.nameField = value;
            }
        }

        [XmlElement(ElementName = "InternalIDList")]
        [DataMember(IsRequired = false, Name = "InternalIDList")]
        public InternalIDList InternalIDList
        {
            get
            {
                return this.internalIdListField;
            }
            set
            {
                this.internalIdListField = value;
            }
        }

        [XmlElement(ElementName = "Address")]
        [DataMember(IsRequired = false, Name = "Address")]
        public Address Address
        {
            get
            {
                return this.addressField;
            }
            set
            {
                this.addressField = value;
            }
        }

        [XmlElement(ElementName = "AffiliationList")]
        [DataMember(IsRequired = false, Name = "AffiliationList")]
        public AffiliationListPerson AffiliationList
        {
            get
            {
                return this.affiliationListField;
            }
            set
            {
                this.affiliationListField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "ProfileURL")]
        public ProfileURL ProfileURL
        {
            get
            {
                return this.profileURLField;
            }
            set
            {
                this.profileURLField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "BasicStatistics")]
        public BasicStatistics BasicStatistics
        {
            get
            {
                return this.basicStatisticsField;
            }
            set
            {
                this.basicStatisticsField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "EmailImageUrl")]
        public EmailImageUrl EmailImageUrl
        {
            get
            {
                return this.emailImageUrlField;
            }
            set
            {
                this.emailImageUrlField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "PhotoUrl")]
        public PhotoUrl PhotoUrl
        {
            get
            {
                return this.photoUrlField;
            }
            set
            {
                this.photoUrlField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "AwardList")]
        public AwardList AwardList
        {
            get
            {
                return this.awardListField;
            }
            set
            {
                this.awardListField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "Narrative")]
        public Narrative Narrative
        {
            get
            {
                return this.narrativeField;
            }
            set
            {
                this.narrativeField = value;
            }
        }
        
        [DataMember(IsRequired = false, Name = "PublicationList")]
        public PublicationList PublicationList
        {
            get
            {
                return this.publicationsField;
            }
            set
            {
                this.publicationsField = value;
            }
        }


        [DataMember(IsRequired = false, Name = "Publications")]
        public Publications Publications
        {
            get
            {
                return this.publications;
            }
            set
            {
                this.publications = value;
            }
        }       
        [DataMember(IsRequired = false, Name = "PassiveNetworks")]
        public PassiveNetworks PassiveNetworks
        {
            get
            {
                return this.passiveNetworksField;
            }
            set
            {
                this.passiveNetworksField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "QueryRelevance")]
        public string QueryRelevance
        {
            get
            {
                return this.queryRelevanceField;
            }
            set
            {
                this.queryRelevanceField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Visible")]
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
    }

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(TypeName = "Name")]
    [DataContract( Name = "Name")]
    public partial class NamePerson
    {

        private string fullNameField;

        private string firstNameField;

        private string middleNameField;

        private string lastNameField;

        private string suffixStringField;

        private string degreeStringField;

        [DataMember(IsRequired = false, Name = "FullName", Order = 1)]
        public string FullName
        {
            get
            {
                return this.fullNameField;
            }
            set
            {
                this.fullNameField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "FirstName", Order = 2)]
        public string FirstName
        {
            get
            {
                return this.firstNameField;
            }
            set
            {
                this.firstNameField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "MiddleName", Order = 3)]
        public string MiddleName
        {
            get
            {
                return this.middleNameField;
            }
            set
            {
                this.middleNameField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "LastName", Order = 4)]
        public string LastName
        {
            get
            {
                return this.lastNameField;
            }
            set
            {
                this.lastNameField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "SuffixString", Order = 5)]
        public string SuffixString
        {
            get
            {
                return this.suffixStringField;
            }
            set
            {
                this.suffixStringField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "DegreeString", Order = 6)]
        public string DegreeString
        {
            get
            {
                return this.degreeStringField;
            }
            set
            {
                this.degreeStringField = value;
            }
        }
    }

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "ProfileURL")]
    public partial class ProfileURL
    {

        private bool visibleField;

        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Visible", Order = 1)]
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

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "BasicStatistics")]
    public partial class BasicStatistics
    {

        private string publicationCountField;

        private int matchingPublicationCountField;

        private float matchScoreField;

        private bool visibleField;

        /// <remarks/>
        [DataMember(IsRequired = false, Name = "PublicationCount", Order = 1)]
        public string PublicationCount
        {
            get
            {
                return this.publicationCountField;
            }
            set
            {
                this.publicationCountField = value;
            }
        }

        /// <remarks/>
        [DataMember(IsRequired = false, Name = "MatchingPublicationCount", Order = 2)]
        public int MatchingPublicationCount
        {
            get
            {
                return this.matchingPublicationCountField;
            }
            set
            {
                this.matchingPublicationCountField = value;
            }
        }

        /// <remarks/>
        [DataMember(IsRequired = false, Name = "MatchScore", Order = 2)]
        public float MatchScore{
            get
            {
                return this.matchScoreField;
            }
            set
            {
                this.matchScoreField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Visible", Order = 3)]
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
    }

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "PassiveNetworks")]
    public partial class PassiveNetworks
    {

        private KeywordList2 keywordListField;

        private SimilarPersonList similarPersonListField;

        private CoAuthorList coAuthorListField;

        private NeighborList neighborListField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("KeywordList")]
        [DataMember(IsRequired = false, Name = "KeywordList", Order = 1)]
        public KeywordList2 KeywordList
        {
            get
            {
                return this.keywordListField;
            }
            set
            {
                this.keywordListField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("SimilarPersonList")]
        [DataMember(IsRequired = false, Name = "SimilarPersonList", Order = 2)]
        public SimilarPersonList SimilarPersonList 
        {
            get
            {
                return this.similarPersonListField;
            }
            set
            {
                this.similarPersonListField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("CoAuthorList")]
        [DataMember(IsRequired = false, Name = "CoAuthorList", Order = 3)]
        public CoAuthorList CoAuthorList
        {
            get
            {
                return this.coAuthorListField;
            }
            set
            {
                this.coAuthorListField = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("NeighborList")]
        [DataMember(IsRequired = false, Name = "NeighborList", Order = 4)]
        public NeighborList NeighborList
        {
            get
            {
                return this.neighborListField;
            }
            set
            {
                this.neighborListField = value;
            }
        }

    }

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "KeywordList")]
    public partial class KeywordList2
    {
        private int totalKeywordCountField;
        private List<Keyword2> keywordField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "TotalKeywordCount", Order = 1)]
        public int TotalKeywordCount
        {
            get
            {
                return this.totalKeywordCountField;
            }
            set
            {
                this.totalKeywordCountField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("Keyword")]
        [DataMember(IsRequired = false, Name = "Keyword", Order = 2)]
        public List<Keyword2> Keyword
        {
            get
            {
                return this.keywordField;
            }
            set
            {
                this.keywordField = value;
            }
        }
    }

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "Keyword")]
    public partial class Keyword2
    {
        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 1)]
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


    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "SimilarPersonList")]
    public partial class SimilarPersonList
    {

        private int totalSimilarPeopleCount;

        private List<SimilarPerson> similiarPersonField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "TotalSimilarPeopleCount", Order = 1)]
        public int TotalSimilarPeopleCount
        {
            get
            {
                return this.totalSimilarPeopleCount;
            }
            set
            {
                this.totalSimilarPeopleCount = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("SimilarPerson")]
        [DataMember(IsRequired = false, Name = "SimilarPerson", Order = 2)]
        public List<SimilarPerson> SimilarPerson
        {
            get
            {
                return this.similiarPersonField;
            }
            set
            {
                this.similiarPersonField = value;
            }
        }
    }

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "SimilarPerson")]
    public partial class SimilarPerson
    {
        private string personIdField;
        private bool coAuthorField;
        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "PersonID", Order = 1)]
        public string PersonID
        {
            get
            {
                return this.personIdField;
            }
            set
            {
                this.personIdField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "CoAuthor", Order = 2)]
        public bool CoAuthor
        {
            get
            {
                return this.coAuthorField;
            }
            set
            {
                this.coAuthorField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 3)]
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

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "CoAuthorList")]
    public partial class CoAuthorList
    {
        private int totalCoAuthorCount;
        private List<CoAuthor> coAuthorField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "TotalCoAuthorCount", Order = 1)]
        public int TotalCoAuthorCount
        {
            get
            {
                return this.totalCoAuthorCount;
            }
            set
            {
                this.totalCoAuthorCount = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute()]
        [DataMember(IsRequired = false, Name = "CoAuthor", Order = 2)]
        public List<CoAuthor> CoAuthor
        {
            get
            {
                return this.coAuthorField;
            }
            set
            {
                this.coAuthorField = value;
            }
        }
    }



    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "CoAuthor")]
    public partial class CoAuthor
    {
        private string personIdField;
        private string institutionField;
        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "PersonID", Order = 1)]
        public string PersonID
        {
            get
            {
                return this.personIdField;
            }
            set
            {
                this.personIdField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Institution", Order = 2)]
        public string Institution
        {
            get
            {
                return this.institutionField;
            }
            set
            {
                this.institutionField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 3)]
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


    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "NeighborList")]
    public partial class NeighborList
    {
        private List<Neighbor> neighborField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute()]
        [DataMember(IsRequired = false, Name = "Neighbor", Order = 2)]
        public List<Neighbor> Neighbor
        {
            get
            {
                return this.neighborField;
            }
            set
            {
                this.neighborField = value;
            }
        }
    }

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "Neighbor")]
    public partial class Neighbor
    {
        private string personIdField;
        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "PersonID", Order = 1)]
        public string PersonID
        {
            get
            {
                return this.personIdField;
            }
            set
            {
                this.personIdField = value;
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

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "EmailImageUrl")]
    public partial class EmailImageUrl
    {

        private bool visibleField;

        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Visible", Order = 1)]
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

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "PhotoUrl")]
    public partial class PhotoUrl
    {

        private bool visibleField;

        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Visible", Order = 1)]
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

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "Narrative")]
    public partial class Narrative
    {

        private bool visibleField;

        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Visible", Order = 1)]
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
