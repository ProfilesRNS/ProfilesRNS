using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Profiles.ORCID.Modules.UpdateSecurityGroupDefaultDecisions
{
    public partial class UpdateSecurityGroupDefaultDecisions : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.rptSecurityGroups.DataSource = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.RDF.Security.Group().Gets();
                this.rptSecurityGroups.DataBind();
            }
        }
        protected void rptSecurityGroups_ItemDataBound(Object Sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DropDownList ddlDefaultORCIDDecisionID = (DropDownList)e.Item.FindControl("ddlDefaultORCIDDecisionID");
                ddlDefaultORCIDDecisionID.ClearSelection();
                ListItem it;
                it = ddlDefaultORCIDDecisionID.Items.FindByValue(DataBinder.Eval(e.Item, "DataItem.DefaultORCIDDecisionID").ToString());
                if (!(it == null))
                {
                    it.Selected = true;
                }
            }
        }
        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.RDF.Security.Group groupBLL = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.RDF.Security.Group();
            foreach (RepeaterItem ri in this.rptSecurityGroups.Items)
            {
                if (ri.ItemType == ListItemType.Item || ri.ItemType == ListItemType.AlternatingItem)
                {
                    DropDownList ddlDefaultORCIDDecisionID = (DropDownList)ri.FindControl("ddlDefaultORCIDDecisionID");
                    Label lblSecurityGroupID = (Label)ri.FindControl("lblSecurityGroupID");
                    Label lblGroupError = (Label)ri.FindControl("lblGroupError");
                    Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.RDF.Security.Group bo = groupBLL.Get(int.Parse(lblSecurityGroupID.Text));
                    bo.DefaultORCIDDecisionID = int.Parse(ddlDefaultORCIDDecisionID.SelectedValue);
                    if (!groupBLL.Edit(bo))
                    {
                        lblGroupError.Text = bo.AllErrors;
                    }                    
                }
            }
        }
    }
}