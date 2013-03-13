using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml.Serialization;
using System.IO;
using System.Text;

namespace ProfilesSearchAPI.Utilities
{
    public static class SerializeXML
    {
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
    }
}
