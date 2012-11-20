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
    [DataContract(Name = "PublicationSource")]
    public partial class PublicationSource    
    {
        private string idField;
        private string urlField;
        private bool primaryField;
        private string nameField;

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "ID", Order = 1, EmitDefaultValue = false)]
        public string ID
        {
            get
            {
                return this.idField;
            }
            set
            {
                this.idField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "URL", Order = 2, EmitDefaultValue = false)]
        public string URL
        {
            get
            {
                return this.urlField;
            }
            set
            {
                this.urlField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Primary", Order = 3, EmitDefaultValue = false)]
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

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = false, Name = "Name", Order = 4, EmitDefaultValue = false)]
        public string Name
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




    }

    [System.Xml.Serialization.XmlTypeAttribute()]
    [CollectionDataContract(Name = "PublicationSourceList")]
    public class PublicationSourceList : List<PublicationSource>
    {
    }
}
