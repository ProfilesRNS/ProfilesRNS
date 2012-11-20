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
using System.Collections;
using System.Collections.Generic;

namespace Connects.Profiles.Service.DataContracts
{
    [System.Xml.Serialization.XmlTypeAttribute()]
    [System.SerializableAttribute()]
    public class AffiliationList
    {
        private List<Affiliation> affiliationField;

        [System.Xml.Serialization.XmlElementAttribute("Affiliation")]
        public List<Affiliation> Affiliation
        {
            get
            {
                return this.affiliationField;
            }
            set
            {
                this.affiliationField = value;
            }
        }


    }
}
