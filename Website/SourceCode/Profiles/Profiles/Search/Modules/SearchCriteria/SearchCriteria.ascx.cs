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
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;

using Profiles.Framework.Utilities;
using Profiles.Search.Utilities;

namespace Profiles.Search.Modules.SearchCriteria
{
    public partial class SearchCriteria : BaseModule
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public SearchCriteria() { }
        public SearchCriteria(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

        }

        private void DrawProfilesModule()
        {
            string output = string.Empty;
            Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchString", base.Namespaces) != null)
            {

                //   output += "<li>" + base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchString", base.Namespaces).InnerText + "</li>";
                foreach (XmlNode n in base.BaseData.SelectNodes("rdf:RDF/rdf:Description/vivo:overview/SearchDetails/SearchPhraseList/SearchPhrase", base.Namespaces))
                {
                    output += "<li>" + n.InnerText + "</li>";
                }
            }

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://xmlns.com/foaf/0.1/lastName']", base.Namespaces) != null)
                output += "<li>" + base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://xmlns.com/foaf/0.1/lastName']", base.Namespaces).InnerText + "</li>";

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://xmlns.com/foaf/0.1/firstName']", base.Namespaces) != null)
                output += "<li>" + base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://xmlns.com/foaf/0.1/firstName']", base.Namespaces).InnerText + "</li>";

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://profiles.catalyst.harvard.edu/ontology/prns#hasPersonFilter']", base.Namespaces) != null)
            {
                string s = string.Empty;
                if (!Request.QueryString["otherfilters"].IsNullOrEmpty())
                {
                    s = Request.QueryString["otherfilters"];
                    if (!s.IsNullOrEmpty())
                    {
                        foreach (GenericListItem gi in data.GetOtherOptions(s))
                        {
                            Filters = data.GetConvertedURIListItem(data.GetListOfFilters(), gi.Value);
                            output += "<li>" + Filters + "</li>";
                        }
                    }
                }
                else
                {
                    List<GenericListItem> g = new List<GenericListItem>();
                    g = data.GetListOfFilters();

                    foreach (XmlNode x in base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://profiles.catalyst.harvard.edu/ontology/prns#hasPersonFilter']", base.Namespaces))
                    {
                        s = data.GetConvertedURIListItem(g, x.InnerText);
                        output += "<li>" + s + "</li>";
                    }
                }
            }

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://vivoweb.org/ontology/core#positionInOrganization']", base.Namespaces) != null)
            {
                if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://vivoweb.org/ontology/core#positionInOrganization']/@IsExclude", base.Namespaces).Value == "1")
                    Institution = "(Except)";

                Institution += data.GetConvertedURIListItem(data.GetInstitutions(), base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://vivoweb.org/ontology/core#positionInOrganization']", base.Namespaces).InnerText);
                output += "<li>" + Institution + "</li>";
            }

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://profiles.catalyst.harvard.edu/ontology/prns#positionInDepartment']", base.Namespaces) != null)
            {
                if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://profiles.catalyst.harvard.edu/ontology/prns#positionInDepartment']/@IsExclude", base.Namespaces).Value == "1")
                    Department = "(Except) ";

                Department += data.GetConvertedURIListItem(data.GetDepartments(), base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://profiles.catalyst.harvard.edu/ontology/prns#positionInDepartment']", base.Namespaces).InnerText);
                output += "<li>" + Department + "</li>";
            }

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://profiles.catalyst.harvard.edu/ontology/prns#positionInDivision']", base.Namespaces) != null)
            {
                Division = data.GetConvertedURIListItem(data.GetDivisions(), base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://profiles.catalyst.harvard.edu/ontology/prns#positionInDivision']", base.Namespaces).InnerText);
                output += "<li>" + Division + "</li>";
            }



            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://profiles.catalyst.harvard.edu/ontology/prns#hasFacultyRank']", base.Namespaces) != null)
            {
                foreach (GenericListItem gi in data.GetFacultyRanks())
                {

                    if (base.BaseData.SelectSingleNode(".").InnerXml.Contains(gi.Value) && !gi.Value.IsNullOrEmpty())
                    {
                        Rank = gi.Text;
                        output += "<li>" + Rank + "</li>";
                    }
                }
            }

            litSearchCriteria.Text = output;

        }

        private string Institution { get; set; }
        private string Department { get; set; }
        private string Division { get; set; }
        private string Rank { get; set; }
        private string Keyword { get; set; }
        private string Fname { get; set; }
        private string Lname { get; set; }
        private string Filters { get; set; }






    }
}
