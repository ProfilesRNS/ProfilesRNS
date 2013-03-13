/*  
 
    Copyright (c) 2008-2010 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.IO;
using System.Xml.Serialization;

namespace Connects.Profiles.Utility
{
    /// <summary>
    /// The help functions on handling XML
    /// </summary>
    public static class XmlUtilities
    {
        /// <summary>
        /// Method to convert a custom Object to XML string
        /// </summary>
        /// <param name="object">Object that is to be serialized to XML</param>
        /// <returns>XML string</returns>
        public static string SerializeObject(object obj)
        {
            MemoryStream memoryStream = new MemoryStream();
            try
            {
                XmlSerializer xs = new XmlSerializer(obj.GetType());
                XmlTextWriter writer = new XmlTextWriter(memoryStream, Encoding.UTF8);
                xs.Serialize(writer, obj);
                memoryStream = (MemoryStream)writer.BaseStream;
                string xml = UTF8ByteArrayToString(memoryStream.ToArray());
                return xml;
            }
            finally
            {
                memoryStream.Dispose();
            }
        }

        public static string SerializeToString(object obj)
        {
            XmlSerializer serializer = new XmlSerializer(obj.GetType());

            using (StringWriter writer = new StringWriter())
            {
                serializer.Serialize(writer, obj);

                return writer.ToString();
            }
        }

        /// <summary>
        /// Method to reconstruct an Object from XML string
        /// </summary>
        /// <param name="xml">input xml</param>
        /// <returns></returns>
        public static object DeserializeObject(string xml, Type type)
        {
            try
            {
                using (MemoryStream memoryStream = new MemoryStream(StringToUTF8ByteArray(xml)))
                {
                    XmlSerializer xs = new XmlSerializer(type);
                    return xs.Deserialize(memoryStream);
                }
            }
            catch (Exception ex) { throw ex; }



        }


        /// <summary>
        /// To convert a Byte Array of Unicode values (UTF-8 encoded) to a complete String.
        /// </summary>
        /// <param name="characters">Unicode Byte Array to be converted to String</param>
        /// <returns>String converted from Unicode Byte Array</returns>
        private static String UTF8ByteArrayToString(Byte[] characters)
        {
            UTF8Encoding encoding = new UTF8Encoding();
            String constructedString = encoding.GetString(characters);
            return (constructedString);

        }

        /// <summary>
        /// Converts the String to UTF8 Byte array and is used in De serialization
        /// </summary>
        /// <param name="xmlString"></param>
        /// <returns></returns>
        private static Byte[] StringToUTF8ByteArray(String xmlString)
        {
            UTF8Encoding encoding = new UTF8Encoding();
            Byte[] byteArray = encoding.GetBytes(xmlString);
            return byteArray;
        }

        public static string EncodeTo64(string toEncode)
        {
            byte[] toEncodeAsBytes = System.Text.ASCIIEncoding.ASCII.GetBytes(toEncode);
            string returnValue = System.Convert.ToBase64String(toEncodeAsBytes);

            return returnValue;
        }


        public static string DecodeFrom64(string encodedData)
        {
            byte[] encodedDataAsBytes = System.Convert.FromBase64String(encodedData);
            string returnValue = System.Text.ASCIIEncoding.ASCII.GetString(encodedDataAsBytes);

            return returnValue;
        }


        /// <summary>
        /// run xpath command from a command files. This is used for deployment
        /// </summary>
        /// <param name="inputFile">the input file</param>
        /// <param name="commandFile">file contans Xpath</param>
        /// <param name="outputFile">the output file</param>
        public static void RunXpath(string appMode, string inputFile, string commandFile, string outputFile)
        {
            //read config file
            using (FileStream fsInput = File.OpenRead(inputFile))
            {
                XmlDocument doc = new XmlDocument();
                doc.Load(fsInput);
                //read commandFile
                using (FileStream fsCommand = File.OpenRead(commandFile))
                {
                    XmlDocument cmd = new XmlDocument();
                    cmd.Load(fsCommand);
                    string query = string.Format("Deployment/Paramters[@env='{0}']/Parameter", appMode);
                    XmlNodeList paramters = cmd.SelectNodes(query);
                    foreach (XmlNode paramter in paramters)
                    {
                        string xpath = paramter.Attributes["path"].Value;
                        string name = paramter.Attributes["name"].Value;
                        string value = paramter.Attributes["value"].Value;
                        XmlNode node = doc.SelectSingleNode(xpath);
                        node.Attributes[name].Value = value;
                    }

                    doc.Save(outputFile);
                }
            }
            return;
        }

        #region XML Field and Attribute Helpers

        public static XmlNode AddXmlElement(XmlNode parent, string elementName, string elementValue)
        {

            XmlNode element = parent.AppendChild(parent.OwnerDocument.CreateNode(XmlNodeType.Element, elementName, ""));

            if (elementValue != "")

                element.InnerText = elementValue;

            return (element);

        }

        public static XmlNode AddXmlElement(XmlDocument parent, string elementName, string elementValue)
        {

            XmlNode element = parent.AppendChild(parent.CreateNode(XmlNodeType.Element, elementName, ""));

            if (elementValue != "")

                element.InnerText = elementValue;

            return (element);

        }

        public static XmlNode AddXmlAttribute(XmlNode element, string attrName, string attrValue)
        {

            XmlNode attr = element.Attributes.Append((XmlAttribute)element.OwnerDocument.CreateNode(XmlNodeType.Attribute, attrName, ""));

            if (attrValue != "")

                attr.Value = attrValue;

            return (attr);

        }

        public static void AddFieldRef(XmlNode viewFields, string fieldName)
        {

            XmlNode fieldRef = AddXmlElement(viewFields, "FieldRef", "");

            AddXmlAttribute(fieldRef, "Name", fieldName);

        }

     

        #endregion

    }
}
