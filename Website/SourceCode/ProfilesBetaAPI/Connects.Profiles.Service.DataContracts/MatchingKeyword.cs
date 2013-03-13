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
    [DataContract(Name = "MatchingKeyword")]
    public partial class MatchingKeyword
    {
        private string keywordField;
        private List<MatchingMeshHeader> matchingMeshHeaderField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "Keyword", Order = 1, EmitDefaultValue = false)]
        public string Keyword
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

        [System.Xml.Serialization.XmlElement()]
        [DataMember(IsRequired = false, Name = "MatchingMeshHeader", Order = 2)]
        public List<MatchingMeshHeader> MatchingMeshHeader
        {
            get
            {
                return this.matchingMeshHeaderField;
            }
            set
            {
                this.matchingMeshHeaderField = value;
            }
        }

    }

    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "MatchingMeshHeader")]
    public partial class MatchingMeshHeader 
    {
        private string weightField;
        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "Weight", Order = 1, EmitDefaultValue = false)]
        public string Weight
        {
            get
            {
                return this.weightField;
            }
            set
            {
                this.weightField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = true, Name = "Text", Order = 2, EmitDefaultValue = false)]
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
    [CollectionDataContract(Name = "MatchingKeywordList")]
    public class MatchingKeywordList : List<MatchingKeyword>
    {
    }

}
