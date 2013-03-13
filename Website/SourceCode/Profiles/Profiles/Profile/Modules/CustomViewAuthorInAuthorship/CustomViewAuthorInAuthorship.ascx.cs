using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Globalization;
using System.Text;
using System.Xml;
using System.Xml.Xsl;

using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;


namespace Profiles.Profile.Modules
{
    public partial class CustomViewAuthorInAuthorship : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            DrawProfilesModule();
        }

        public CustomViewAuthorInAuthorship() : base() { }
        public CustomViewAuthorInAuthorship(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));

        }
        private void DrawProfilesModule()
        {


            DateTime d = DateTime.Now;
            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            List<Publication> publication = new List<Publication>();

            SqlDataReader reader = data.GetPublications(base.RDFTriple);

            while (reader.Read())
            {
                publication.Add(new Publication(reader["bibo_pmid"].ToString(), reader["prns_informationResourceReference"].ToString()));
            }

            rpPublication.DataSource = publication;
            rpPublication.DataBind();

            if (!reader.IsClosed)
                reader.Close();
           
           // Get timeline bar chart			
           using (reader = data.GetGoogleTimeline(base.RDFTriple, "[Profile.Module].[NetworkAuthorshipTimeline.Person.GetData]"))
           {
				while(reader.Read())
				{
					timelineBar.Src = reader["gc"].ToString();
				}
				reader.Close();           

               
           }

           if (timelineBar.Src == "")
           {
               timelineBar.Visible = false;
           }


		   // Login link
		  loginLiteral.Text = String.Format("<a href='{0}'>login</a>", Root.Domain + "/login/default.aspx?pin=send&method=login&edit=true");

          Framework.Utilities.DebugLogging.Log("PUBLICATION MODULE end Milliseconds:" + (DateTime.Now - d).TotalSeconds);

        }

        protected void rpPublication_OnDataBound(object sender, RepeaterItemEventArgs  e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Publication pub = (Publication)e.Item.DataItem;
                Label lblNum = (Label)e.Item.FindControl("lblNum");
                Label lblPublication = (Label)e.Item.FindControl("lblPublication");
                Literal litViewIn = (Literal)e.Item.FindControl("litViewIn");

                lblPublication.Text = pub.prns_informaitonResourceReference;
                if (pub.bibo_pmid != string.Empty && pub.bibo_pmid != null)
                {
                    litViewIn.Text = "View in: <a href='//www.ncbi.nlm.nih.gov/pubmed/" + pub.bibo_pmid + "' target='_blank'>PubMed</a>";

                }
            }
        }
        public class Publication
        {
            public Publication(string _bibo_pmid, string prns_informationresourcereference)
            {
                this.bibo_pmid = _bibo_pmid;
                this.prns_informaitonResourceReference = prns_informationresourcereference;
            }

            public string bibo_pmid { get; set; }
            public string prns_informaitonResourceReference { get; set; }


        }


    }
}