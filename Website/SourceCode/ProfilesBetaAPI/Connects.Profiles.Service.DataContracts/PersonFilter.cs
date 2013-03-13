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
    [DataContract(Name = "PersonFilter")]
    public partial class PersonFilter
    {
        private string textField;

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(IsRequired = true, Name = "Text", Order = 1, EmitDefaultValue = false)]
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
    [CollectionDataContract(Name = "PersonFilterList")]
    public class PersonFilterList : List<PersonFilter>
    {
    }

}