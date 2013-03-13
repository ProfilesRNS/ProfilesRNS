/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;
using System.Text;

namespace Profiles.Framework.Utilities
{

    public class Namespace
    {
        XmlNamespaceManager _nsmrequest;
        XmlAttributeCollection ac;

        public Namespace()
        {

        }

        public XmlNamespaceManager LoadNamespaces(XmlDocument data)
        {
            if (data.ChildNodes.Count > 0)
            {
                _nsmrequest = new XmlNamespaceManager(data.NameTable);
                ac = data.DocumentElement.Attributes;
                foreach (XmlAttribute a in ac)
                {
                    if (a.Name.Split(':').Count() > 1)
                        _nsmrequest.AddNamespace(a.Name.Split(':')[1], a.Value);
                }
            }
            return _nsmrequest;
        }

      
    }
}
