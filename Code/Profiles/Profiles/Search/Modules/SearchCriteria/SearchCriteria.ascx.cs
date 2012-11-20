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
                output += base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchString", base.Namespaces).InnerText + "<br/>";

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://xmlns.com/foaf/0.1/lastName']", base.Namespaces) != null)
                output += base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://xmlns.com/foaf/0.1/lastName']", base.Namespaces).InnerText + "<br/>";

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://xmlns.com/foaf/0.1/firstName']", base.Namespaces) != null)
                output += base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://xmlns.com/foaf/0.1/firstName']", base.Namespaces).InnerText + "<br/>";

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://profiles.catalyst.harvard.edu/ontology/prns#hasPersonFilter']", base.Namespaces) != null)
            {
                string s = string.Empty;
                s = Request.QueryString["otherfilters"];

                foreach (GenericListItem gi in data.GetOtherOptions(s))
                {
                    Rank = data.GetConvertedURIListItem(data.GetListOfFilters(), gi.Value);
                    output += Rank + "<br/>";
                }
            }

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://vivoweb.org/ontology/core#positionInOrganization']", base.Namespaces) != null)
            {
                Institution = data.GetConvertedURIListItem(data.GetInstitutions(), base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://vivoweb.org/ontology/core#positionInOrganization']", base.Namespaces).InnerText);
                output += Institution + "<br/>";
            }

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://profiles.catalyst.harvard.edu/ontology/prns#positionInDepartment']", base.Namespaces) != null)
            {
                Department = data.GetConvertedURIListItem(data.GetDepartments(), base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://profiles.catalyst.harvard.edu/ontology/prns#positionInDepartment']", base.Namespaces).InnerText);
                output += Department + "<br/>";
            }

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://profiles.catalyst.harvard.edu/ontology/prns#positionInDivision']", base.Namespaces) != null)
            {
                Division = data.GetConvertedURIListItem(data.GetDivisions(), base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property2='http://profiles.catalyst.harvard.edu/ontology/prns#positionInDivision']", base.Namespaces).InnerText);
                output += Division + "<br/>";
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






    }
}
