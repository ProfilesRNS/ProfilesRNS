using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Net;
using System.IO;
using System.Text;
using System.Runtime.Serialization;
using System.Configuration;



using Profiles.Profile.Utilities;

namespace Profiles.Profile.Modules.CustomViewPersonGeneralInfo
{
    public partial class vcard : ProfileData
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Framework.Utilities.RDFTriple request = base.RDFTriple;
            VCardPerson vcard = new VCardPerson();
            this.LoadPresentationXML();

            XmlNode x = this.PresentationXML.SelectSingleNode("Presentation[1]/ExpandRDFList[1]");

            if (x != null)
                base.RDFTriple.ExpandRDFList = x.InnerXml;

            base.LoadRDFData();


            if (base.RDFData.SelectNodes("rdf:RDF[1]/rdf:Description[1]/*[1]", base.RDFNamespaces).Count < 1)
            {
                Response.Clear();
                Server.ClearError();
                Response.Status = "404 not found";
                Response.StatusCode = Convert.ToInt16("404");
                Server.Transfer("~/Error/404.aspx");
            }
            else
            {
                this.GetVcard(ref vcard);

                Response.Clear();
                Response.ContentType = "text/vcard";

                var cardString = vcard.ToString();
                var inputEncoding = Encoding.Default;
                var outputEncoding = Encoding.GetEncoding("windows-1257");
                var cardBytes = inputEncoding.GetBytes(cardString);
                var outputBytes = Encoding.Convert(inputEncoding, outputEncoding, cardBytes);
                Response.StatusCode = Convert.ToInt16("200");
                Response.AddHeader("Content-disposition", string.Format("attachment; filename=\"{0}\";", vcard.FirstName + "_" + vcard.LastName + ".vcf"));

                Response.OutputStream.Write(outputBytes, 0, outputBytes.Length);

                Response.End();
            }
        }

        private void GetVcard(ref VCardPerson vcard)
        {
            Framework.Utilities.Namespace nmgr = new Framework.Utilities.Namespace();
            Utilities.DataIO data = new DataIO();

            XmlNamespaceManager namespaces = nmgr.LoadNamespaces(base.RDFData);

            if (this.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[1]/prns:mainImage/@rdf:resource", namespaces) != null)
            {
                Stream stream = data.GetUserPhotoList(base.RDFTriple.Subject, false);

                if (stream != null)
                {
                   
                        vcard.Image = ReadFully(stream);
                   
                }
            }

            vcard.FirstName = this.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[1]/foaf:firstName", namespaces).InnerText;
            vcard.LastName = this.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[1]/foaf:lastName", namespaces).InnerText;
            vcard.HomePage = this.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[1]/@rdf:about", namespaces).Value;

            if (base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:personInPrimaryPosition/@rdf:resource]/vivo:hrJobTitle", namespaces) != null)
                vcard.JobTitle = base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:personInPrimaryPosition/@rdf:resource]/vivo:hrJobTitle", namespaces).InnerText;

            if (base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:personInPrimaryPosition/@rdf:resource]/vivo:positionInOrganization/@rdf:resource]", namespaces) != null)
                vcard.Organization = base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:personInPrimaryPosition/@rdf:resource]/vivo:positionInOrganization/@rdf:resource]", namespaces).InnerText;

            if (base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:address1", namespaces) != null)
                vcard.StreetAddress = base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:address1", namespaces).InnerText;

            if (base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:address2", namespaces) != null)
                vcard.StreetAddress = vcard.StreetAddress + " " + base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:address2", namespaces).InnerText;

            if (base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:address3", namespaces) != null)
                vcard.StreetAddress = vcard.StreetAddress + " " + base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:address3", namespaces).InnerText;

            if (base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:addressCity", namespaces) != null)
                vcard.City = base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:addressCity", namespaces).InnerText;

            if (base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:addressState", namespaces) != null)
                vcard.State = base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:addressState", namespaces).InnerText;

            if (base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:addressPostalCode", namespaces) != null)
                vcard.Zip = base.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:addressPostalCode", namespaces).InnerText;

            if (base.RDFData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/vivo:phoneNumber", namespaces) != null)
                vcard.Phone = base.RDFData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/vivo:phoneNumber", namespaces).InnerText;

            if (base.RDFData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/vivo:faxNumber", namespaces) != null)
                vcard.Fax = base.RDFData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/vivo:faxNumber", namespaces).InnerText;

            vcard.CountryName = "USA";

            if (this.RDFData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/vivo:email", namespaces) != null)
                vcard.Email = this.RDFData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/vivo:email", namespaces).InnerText;
        }

        public void LoadPresentationXML()
        {
            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            this.PresentationXML = data.GetPresentationData(this.RDFTriple);
        }

        public XmlDocument PresentationXML { get; set; }
        public Profiles.Framework.Template Master { get; set; }

        public static byte[] ReadFully(Stream input)
        {
            byte[] buffer = new byte[16 * 1024];
            using (MemoryStream ms = new MemoryStream())
            {
                int read;
                while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
                {
                    ms.Write(buffer, 0, read);
                }
                return ms.ToArray();
            }
        }
    }
}
