using System.Text;
using System.Xml;
using System.Xml.Xsl;
using System.IO;
using System.Collections.Generic;

namespace Profiles.Framework.Utilities
{
    public static class XslHelper
    {      
        /// <summary>
        /// This method transforms the XSLT/XML in RAM and is much faster than the asp:XML server control.
        /// </summary>
        /// <param name="xsltpath"></param>
        /// <param name="args"></param>
        /// <param name="input"></param>
        /// <returns></returns>
        public static string TransformInMemory(string xsltpath, XsltArgumentList args, string input)
        {
            XslCompiledTransform xsl = new XslCompiledTransform(false);
            StringBuilder sb = new StringBuilder();
            XmlWriterSettings settings = new XmlWriterSettings();

            xsl.Load(xsltpath);
            
            //Only fragment will work for RDF/XML processing for some reason.  The XML is complete and well formed but
            // only Fragment works.
            settings.ConformanceLevel = ConformanceLevel.Fragment;

            XmlReader xReader = XmlReader.Create(new StringReader(input));
            XmlWriter xWriter = XmlWriter.Create(sb, settings);

            xsl.Transform(xReader, args, xWriter);

            //Strip out the namespaces the microsoft transform process places in the output.
            string output = sb.ToString().Replace("xmlns:fn=\"http://www.w3.org/2005/xpath-functions\"", "");
            output = output.Replace("xmlns:xs=\"http://www.w3.org/2001/XMLSchema\"", "");
            

            xReader.Close();
            xWriter.Close();
            
            return output;

            
        }
      
    }

}
