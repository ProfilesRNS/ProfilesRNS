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
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "PublicationPhraseDetail")]
    public partial class PublicationPhraseDetail
    {
        private PhraseMeasurements phraseMeasurementsField;
        private Publication publicationField;
        private string publicationPhraseField;

        [DataMember(IsRequired = false, Name = "PhraseMeasurements", Order = 1)]
        public PhraseMeasurements PhraseMeasurements
        {
            get
            {
                return this.phraseMeasurementsField;
            }
            set
            {
                this.phraseMeasurementsField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "Publication", Order = 2)]
        public Publication Publication
        {
            get
            {
                return this.publicationField;
            }
            set
            {
                this.publicationField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "PublicationPhrase", Order = 3, EmitDefaultValue = false)]
        public string PublicationPhrase
        {
            get
            {
                return this.publicationPhraseField;
            }
            set
            {
                this.publicationPhraseField = value;
            }
        }
    }

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "PhraseMeasurements")]
    public partial class PhraseMeasurements
    {
        private SearchWeight searchWeightField;

        private float uniquenessWeightField;

        private TopicWeight topicWeightField;

        private AuthorWeight authorWeightField;

        private YearWeight yearWeightField;

        private float overallWeightField;

        [DataMember(IsRequired = false, Name = "SearchWeight", Order = 1)]
        public SearchWeight SearchWeight
        {
            get
            {
                return this.searchWeightField;
            }
            set
            {
                this.searchWeightField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "UniquenessWeight", Order = 2)]
        public float UniquenessWeight
        {
            get
            {
                return this.uniquenessWeightField;
            }
            set
            {
                this.uniquenessWeightField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "TopicWeight", Order = 3)]
        public TopicWeight TopicWeight
        {
            get
            {
                return this.topicWeightField;
            }
            set
            {
                this.topicWeightField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "AuthorWeight", Order = 4)]
        public AuthorWeight AuthorWeight
        {
            get
            {
                return this.authorWeightField;
            }
            set
            {
                this.authorWeightField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "YearWeight", Order = 5)]
        public YearWeight YearWeight
        {
            get
            {
                return this.yearWeightField;
            }
            set
            {
                this.yearWeightField = value;
            }
        }

        [DataMember(IsRequired = false, Name = "OverallWeight", Order = 6)]
        public float OverallWeight
        {
            get
            {
                return this.overallWeightField;
            }
            set
            {
                this.overallWeightField = value;
            }
        }

    }

    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "SearchWeight")]
    public partial class SearchWeight
    {
        private float searchWeightField;
        private string searchWeightTextField;

        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 1)]
        public float Text
        {
            get
            {
                return this.searchWeightField;
            }
            set
            {
                this.searchWeightField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "SearchWeightText", Order = 2)]
        public string SearchWeightText
        {
            get
            {
                return this.searchWeightTextField;
            }
            set
            {
                this.searchWeightTextField = value;
            }
        }
    }

    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "TopicWeight")]
    public partial class TopicWeight
    {
        private float topicWeightField;
        private string topicWeightTextField;

        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 1)]
        public float Text
        {
            get
            {
                return this.topicWeightField;
            }
            set
            {
                this.topicWeightField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "TopicWeightText", Order = 2)]
        public string TopicWeightText
        {
            get
            {
                return this.topicWeightTextField;
            }
            set
            {
                this.topicWeightTextField = value;
            }
        }
    }

    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "AuthorWeight")]
    public partial class AuthorWeight
    {
        private float authorWeightField;
        private string authorWeightTextField;

        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 1)]
        public float Text
        {
            get
            {
                return this.authorWeightField;
            }
            set
            {
                this.authorWeightField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "AuthorWeightText", Order = 2)]
        public string AuthorWeightText
        {
            get
            {
                return this.authorWeightTextField;
            }
            set
            {
                this.authorWeightTextField = value;
            }
        }
    }

    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "YearWeight")]
    public partial class YearWeight
    {
        private float yearWeightField;
        private string yearWeightTextField;

        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 1)]
        public float Text
        {
            get
            {
                return this.yearWeightField;
            }
            set
            {
                this.yearWeightField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "YearWeightText", Order = 2)]
        public string YearWeightText
        {
            get
            {
                return this.yearWeightTextField;
            }
            set
            {
                this.yearWeightTextField = value;
            }
        }
    }

    [System.Xml.Serialization.XmlTypeAttribute()]
    [CollectionDataContract(Name = "PublicationPhraseDetailList")]
    public class PublicationPhraseDetailList : List<PublicationPhraseDetail>
    {
    }

}

