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
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "LocalNetwork")]
    public partial class LocalNetwork
    {
        private NetworkPeople peopleField;
        private NetworkCoAuthors coAuthorsField;

        [DataMember(IsRequired = true, Name = "NetworkPeople", Order = 1)]
        public NetworkPeople NetworkPeople
        {
            get
            {
                return this.peopleField;
            }
            set
            {
                this.peopleField = value;
            }
        }

        [DataMember(IsRequired = true, Name = "NetworkCoAuthors", Order = 2)]
        public NetworkCoAuthors NetworkCoAuthors
        {
            get
            {
                return this.coAuthorsField;
            }
            set
            {
                this.coAuthorsField = value;
            }
        }

    }

    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "NetworkPerson")]
    public partial class NetworkPerson
    {
        private int idField;
        private int dField;
        private int pubsField;
        private string fnField;
        private string lnField;
        private float w2Field;

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "id", Order = 1)]
        public int id
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
        [DataMember(IsRequired = true, Name = "d", Order = 2)]
        public int d
        {
            get
            {
                return this.dField;
            }
            set
            {
                this.dField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "pubs", Order = 3)]
        public int pubs
        {
            get
            {
                return this.pubsField;
            }
            set
            {
                this.pubsField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "fn", Order = 4)]
        public string fn
        {
            get
            {
                return this.fnField;
            }
            set
            {
                this.fnField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "ln", Order = 4)]
        public string ln
        {
            get
            {
                return this.lnField;
            }
            set
            {
                this.lnField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "w2", Order = 5)]
        public float w2
        {
            get
            {
                return this.w2Field;
            }
            set
            {
                this.w2Field = value;
            }
        }


    }

    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute()]
    [DataContract(Name = "NetworkCoAuthor")]
    public partial class NetworkCoAuthor
    {
        private int id1Field;
        private int id2Field;
        private int nField;
        private float wField;
        private int y1Field;
        private int y2Field;

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "id1", Order = 1)]
        public int id1
        {
            get
            {
                return this.id1Field;
            }
            set
            {
                this.id1Field = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "id2", Order = 2)]
        public int id2
        {
            get
            {
                return this.id2Field;
            }
            set
            {
                this.id2Field = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "n", Order = 3)]
        public int n
        {
            get
            {
                return this.nField;
            }
            set
            {
                this.nField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "w", Order = 4)]
        public float w
        {
            get
            {
                return this.wField;
            }
            set
            {
                this.wField = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "y1", Order = 5)]
        public int y1
        {
            get
            {
                return this.y1Field;
            }
            set
            {
                this.y1Field = value;
            }
        }

        [System.Xml.Serialization.XmlAttributeAttribute()]
        [DataMember(IsRequired = true, Name = "y2", Order = 6)]
        public int y2
        {
            get
            {
                return this.y2Field;
            }
            set
            {
                this.y2Field = value;
            }
        }
    }

    [System.Xml.Serialization.XmlTypeAttribute()]
    [CollectionDataContract(Name = "NetworkPeople")]
    public class NetworkPeople : List<NetworkPerson>
    {
    }

    [System.Xml.Serialization.XmlTypeAttribute()]
    [CollectionDataContract(Name = "NetworkCoAuthors")]
    public class NetworkCoAuthors : List<NetworkCoAuthor>
    {
    }


}
