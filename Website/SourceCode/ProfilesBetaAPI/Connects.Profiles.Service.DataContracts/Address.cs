/*  
 
    Copyright (c) 2008-2010 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using System.Collections.Generic;

namespace Connects.Profiles.Service.DataContracts
{
    /// <remarks/>
    [System.Xml.Serialization.XmlTypeAttribute()]
    [System.SerializableAttribute()]
    public partial class Address
    {
        private string address1Field;
        private string address2Field;
        private string address3Field;
        private string address4Field;
        private string telephoneField;
        private string faxField;
        private string latitudeField;
        private string longitudeField;

        [System.Xml.Serialization.XmlElementAttribute("Address1")]
        [DataMember(IsRequired = false, Name = "Address1", Order = 1)]
        public string Address1
        {
            get
            {
                return this.address1Field;
            }
            set
            {
                this.address1Field = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("Address2")]
        [DataMember(IsRequired = false, Name = "Address2", Order = 2)]
        public string Address2
        {
            get
            {
                return this.address2Field;
            }
            set
            {
                this.address2Field = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("Address3")]
        [DataMember(IsRequired = false, Name = "Address3", Order = 3)]
        public string Address3
        {
            get
            {
                return this.address3Field;
            }
            set
            {
                this.address3Field = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("Address4")]
        [DataMember(IsRequired = false, Name = "Address4", Order = 4)]
        public string Address4
        {
            get
            {
                return this.address4Field;
            }
            set
            {
                this.address4Field = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("Telephone")]
        [DataMember(IsRequired = false, Name = "Telephone", Order = 5)]
        public string Telephone
        {
            get
            {
                return this.telephoneField;
            }
            set
            {
                this.telephoneField = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("Fax")]
        [DataMember(IsRequired = false, Name = "Fax", Order = 6)]
        public string Fax
        {
            get
            {
                return this.faxField;
            }
            set
            {
                this.faxField = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("Latitude")]
        [DataMember(IsRequired = false, Name = "Latitude", Order = 7)]
        public string Latitude
        {
            get
            {
                return this.latitudeField;
            }
            set
            {
                this.latitudeField = value;
            }
        }

        [System.Xml.Serialization.XmlElementAttribute("Longitude")]
        [DataMember(IsRequired = false, Name = "Longitude", Order = 8)]
        public string Longitude
        {
            get
            {
                return this.longitudeField;
            }
            set
            {
                this.longitudeField = value;
            }
        }

    }
}
