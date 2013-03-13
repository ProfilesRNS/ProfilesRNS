/*  
 
    Copyright (c) 2008-2010 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/

using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Reflection;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.Schema;

namespace Connects.Profiles.Utility
{
    public class XmlValidate
    {
        private bool m_Success = false;
        private XmlSchemaCollection schemas;
        StringBuilder stringBuilder;
        #region XML Validation Via XSD

        private void ValidationCallBack(Object sender, ValidationEventArgs args)
        {
            //Display the validation error.  This is only called on error
            stringBuilder.Append(args.Message);

        }

        public bool ValidateXml(string inputXML, string xsdUri)
        {
             stringBuilder = new StringBuilder();

            bool validated = false;

            // Create the XmlSchemaSet class.
            XmlSchemaSet sc = new XmlSchemaSet();

            // Add the schema to the collection.
            sc.Add(null, xsdUri);

            // Set the validation settings.
            XmlReaderSettings settings = new XmlReaderSettings();
            settings.ValidationType = ValidationType.Schema;
            settings.Schemas = sc;
            settings.ConformanceLevel = ConformanceLevel.Auto;
            settings.ValidationEventHandler += new ValidationEventHandler(ValidationCallBack);
            

            XmlTextReader reader = new XmlTextReader(new StringReader(inputXML));
            while (reader.Read())
            { }

            if (stringBuilder.ToString() == String.Empty)
                validated = true;

            return validated;
        }

        #endregion

    }
}
