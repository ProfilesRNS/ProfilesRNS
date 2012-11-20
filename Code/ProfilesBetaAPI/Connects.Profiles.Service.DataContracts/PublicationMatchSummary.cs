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
    [DataContract(Name = "PublicationMatchSummary")]
    public partial class PublicationMatchSummary : PublicationMatchDetailList
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
}
