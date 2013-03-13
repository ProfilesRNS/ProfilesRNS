/*  
 
    Copyright (c) 2008-2010 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Xml;
using System.Xml.Xsl;
using System.Resources;
using System.Reflection;
using System.IO;

namespace Connects.Profiles.Utility
{
    /// <summary>
    /// the help functions for serialize, de-serialize, and transform of WCF xml
    /// </summary>
    public class WCFXmlUtilities
    {
        /// <summary>
        /// Transform from source xml into data contract type using XSLT stored in the 
        /// resource file
        /// </summary>
        /// <param name="source">the source xml</param>
        /// <param name="xsltResourceKey">the key to retrive XSLT from resource file. 
        /// The resource file has to be embeded into the assembly containing target data type</param>
        /// <param name="type">the target data contract type</param>
        /// <returns>de-serialized data contract object</returns>
        public static object TransForm(XmlReader source, string xsltResourceKey, Type type)
        {
            //read xslt from resource
            ResourceManager mgr = new ResourceManager("HP.SPOCK2.ContentService.DataContracts.DataContract", type.Assembly);
            string str = mgr.GetString(xsltResourceKey);
            using (MemoryStream xslt = new MemoryStream(System.Text.ASCIIEncoding.ASCII.GetBytes(str)))
            {
                //load xslt
                XslCompiledTransform trans = new XslCompiledTransform();
                trans.Load(XmlReader.Create(xslt));

                using (MemoryStream sm = new MemoryStream())
                {
                    //transform to Xmlwriter
                    using (XmlWriter writer = XmlWriter.Create(sm))
                    {
                        trans.Transform(source, writer);
                        //The 3 bytes is hard coded here to avoid "empty" xml node. The idea is to give 
                        //an empty instance but null, even if the SP returns nothing. Comparing with null object, 
                        //the empty instance will allow some operations on the object such as casting.

                        //The 3 bytes are based on the observation. For some reasons, the SP returns nothing but still
                        //creates 3 bytes of memory stream.

                        if (sm.Length <= 3) 
                        {
                            return Activator.CreateInstance(type);
                        }
                            

                        sm.Seek(0, SeekOrigin.Begin);

                        // USE THIS FOR DEBUGGING XML DIRECTLY
                        //string xmlFilename = "C:\\XmlOut\\" + DateTime.Now.Ticks.ToString() + ".xml";
                        //sm.WriteTo(new FileStream(xmlFilename, FileMode.OpenOrCreate));

                        //de-serialize to target object
                        using (XmlDictionaryReader reader = XmlDictionaryReader.CreateTextReader(
                            sm, new XmlDictionaryReaderQuotas()))
                        {

                            DataContractSerializer serializer = new
                                DataContractSerializer(type);

                            
                            return serializer.ReadObject(reader);
                        }
                    }
                }
            }
        }


        public static string TransformToXmlString(XmlReader source, string xsltResourceKey, Type type)
        {
            //read xslt from resource
            ResourceManager mgr = new ResourceManager("HP.SPOCK2.ContentService.DataContracts.DataContract", type.Assembly);
            string str = mgr.GetString(xsltResourceKey);
            using (MemoryStream xslt = new MemoryStream(System.Text.ASCIIEncoding.ASCII.GetBytes(str)))
            {
                //load xslt
                XslCompiledTransform trans = new XslCompiledTransform();
                trans.Load(XmlReader.Create(xslt));

                StringBuilder stb = new StringBuilder();

               //transform to Xmlwriter
                using (XmlWriter writer = XmlWriter.Create(stb))
                {
                        trans.Transform(source, writer);
                        return stb.ToString();
                }
            }
        }

        /// <summary>
        /// Serialize data contract into XML string
        /// This one has some issues, we need to do more work !!!
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static string SerializeDataContract(object obj)
        {
            using(MemoryStream ms = new MemoryStream())
            using (XmlDictionaryWriter writer = XmlDictionaryWriter.CreateTextWriter(ms))
            {
                DataContractSerializer serializer = new DataContractSerializer(obj.GetType());
                serializer.WriteObject(writer, obj);
                ms.Seek(0, SeekOrigin.Begin);
                using (StreamReader reader = new StreamReader(ms))
                {
                    return reader.ReadToEnd();
                }
            }
        }

        /// <summary>
        /// Deserialize data contract object from xml string
        /// </summary>
        /// <param name="xml"></param>
        /// <param name="type"></param>
        /// <returns></returns>
        public static object DeSerializeDataContract(string xml, Type type)
        {
            using (MemoryStream sm = new MemoryStream(System.Text.ASCIIEncoding.ASCII.GetBytes(xml)))
            using (XmlDictionaryReader reader = XmlDictionaryReader.CreateTextReader(
                sm, new XmlDictionaryReaderQuotas()))
            {

                DataContractSerializer serializer = new
                    DataContractSerializer(type);

                return serializer.ReadObject(reader);
            }
        }

    }
}
