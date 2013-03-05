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

namespace Profiles.Framework.Utilities
{
    /// <summary>
    /// This class is used to parse string data for both XmlNode and XmlDocument data.
    /// 
    /// Parameter: string custom - contains an XPath query imbeded within a string value. The XPath will be contained in Triple brackets. {{{XPath}}} 
    ///     For Example:
    ///         {{{ XPath }}} string
    ///     
    ///         {{{//Profile/@EntityName}}} | Harvard Catalyst  
    ///         Concepts  ({{{//Profile/NetworkList/Network[@RelationshipType="Researches"]/@FullCount}}})
    ///         
    /// Parameter: XmlNode/XmlDocument - cotains xml based data used to apply to the custom XPath parameter.  XmlNode is part of a Network or Connection list loop call, XmlDocument will be used as part of a Profile data set
    ///         but is not restricted to just Profile data.
    ///             
    /// 
    /// 
    /// </summary>
    static class CustomParse
    {

        static public string ProcessBraces(string custom, XmlDocument data, XmlNamespaceManager namespaces)
        {


            int start = 0;
            int end = 0;
            int stoploop = 0;
            string xpath;
            string xpathresult = "";
            XmlNode xpathnode;
            if (custom == null) { return ""; }
            if (custom == string.Empty) { return ""; }

            start = custom.IndexOf("{{{");
            while (start >= 0)
            {
                end = custom.IndexOf("}}}", start + 3);
                if (end > start)
                {
                    xpath = custom.Substring(start + 3, end - start - 3);
                    xpathnode = data.SelectSingleNode(xpath, namespaces);
                    if (xpathnode != null)
                    {
                        xpathresult = xpathnode.InnerText;
                    }
                    if (xpathresult == string.Empty)
                    {
                        xpathresult = "";
                    }
                    custom = custom.Substring(0, start) + xpathresult + custom.Substring(end + 3, custom.Length - end - 3);
                    start = custom.IndexOf("{{{");
                    stoploop++;
                    if (stoploop > 10)
                    {
                        start = -1;
                    }
                }
                else
                {
                    start = -1;
                }
            }

            return custom;

        }

        //***************************************************************************************************************************************
        static public string Parse(string custom, XmlNode nodexml, XmlNamespaceManager namespaces)
        {
            XmlDocument data = new XmlDocument();
            data.LoadXml(nodexml.OuterXml);
            return ProcessBraces(custom, data, namespaces);
        }

        //***************************************************************************************************************************************
        static public string Parse(string custom, XmlDocument dataxml, XmlNamespaceManager namespaces)
        {
            return ProcessBraces(custom, dataxml, namespaces);
        }

        //***************************************************************************************************************************************
        static public string Parse(string custom, XmlDocument data, XmlNode node, XmlNamespaceManager namespaces)
        {
            return ProcessBraces(custom, data, namespaces);
        }

    }
}
