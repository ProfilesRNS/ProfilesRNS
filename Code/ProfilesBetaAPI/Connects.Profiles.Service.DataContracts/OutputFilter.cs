/*  
 
    Copyright (c) 2008-2010 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace Connects.Profiles.Service.DataContracts
{
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://connects.profiles.schema/profiles/query")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "http://connects.profiles.schema/profiles/query", IsNullable = true)]
    [DataContract(Namespace = "http://connects.profiles.schema/profiles/query", Name = "OutputFilter")]
    public partial class OutputFilter
    {
        private bool summaryField;
        private string textField;

        [System.Xml.Serialization.XmlAttributeAttribute("Summary")]
        [DataMember(IsRequired = false, Name = "Summary", Order = 1)]
        public bool Summary
        {
            get
            {
                return summaryField;
            }
            set
            {
                summaryField = value;
            }
        }

        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = false, Name = "Text", Order = 2)]
        public string Text
        {
            get
            {
                return textField;
            }
            set
            {
                textField = value;
            }
        }
    }


    [System.Xml.Serialization.XmlTypeAttribute()]
    [System.SerializableAttribute()]
    [DataContract(Name = "OutputFilterList")]
    public class OutputFilterList
    {
        private List<OutputFilter> outputFilterField;
        private OutputFilterDefaultEnum defaultField;

        [System.Xml.Serialization.XmlAttributeAttribute("Default")]
        [DataMember(IsRequired = false, Name = "Default")]
        public OutputFilterDefaultEnum Default
        {
            get
            {
                return defaultField;
            }
            set
            {
                defaultField = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("OutputFilter")]
        public List<OutputFilter> OutputFilter
        {
            get
            {
                return this.outputFilterField;
            }
            set
            {
                this.outputFilterField = value;
            }
        }
    }

    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "OutputFilterDefaultEnum")]
    public enum OutputFilterDefaultEnum
    {
        [EnumMemberAttribute(Value = "auto")]
        auto,

        [EnumMemberAttribute(Value = "all")]
        all,

        [EnumMemberAttribute(Value = "none")]
        none
    }

}
