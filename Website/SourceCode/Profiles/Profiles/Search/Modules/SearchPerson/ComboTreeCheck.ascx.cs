
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
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml;

using Profiles.Framework.Utilities;

namespace Profiles.Search.Modules.SearchPerson
{
    public partial class ComboTreeCheck : System.Web.UI.UserControl
    {
        private string script;
        private bool end;
        private Profiles.Search.Utilities.DataIO data;



        public string SelectedText
        {
            get
            {
                if (ViewState["SelectedText"] == null) return "";
                return ViewState["SelectedText"].ToString();
            }
        }

        public string DataMasterName
        {
            get
            {
                if (ViewState["DataMasterName"] == null) return "MasterTable";
                return ViewState["DataMasterName"].ToString();
            }
            set
            {
                ViewState["DataMasterName"] = value;
            }
        }

        public string DataDetailName
        {
            get
            {
                if (ViewState["DataDetailName"] == null) return "DetailTable";
                return ViewState["DataDetailName"].ToString();
            }
            set
            {
                ViewState["DataDetailName"] = value;
            }
        }

        public string DataMasterIDField
        {
            get
            {
                if (ViewState["DataMasterIDField"] == null) return "MasterID";
                return ViewState["DataMasterIDField"].ToString();
            }
            set
            {
                ViewState["DataMasterIDField"] = value;
            }
        }

        public string DataMasterTextField
        {
            get
            {
                if (ViewState["DataMasterTextField"] == null) return "Text";
                return ViewState["DataMasterTextField"].ToString();
            }
            set
            {
                ViewState["DataMasterTextField"] = value;
            }
        }

        public string DataMasterExpandField
        {
            get
            {
                if (ViewState["DataMasterExpandField"] == null) return "Expanded";
                return ViewState["DataMasterExpandField"].ToString();
            }
            set
            {
                ViewState["DataMasterExpandField"] = value;
            }
        }

        public string DataDetailIDField
        {
            get
            {
                if (ViewState["DataDetailIDField"] == null) return "DetailID";
                return ViewState["DataDetailIDField"].ToString();
            }
            set
            {
                ViewState["DataDetailIDField"] = value;
            }
        }

        public string DataDetailTextField
        {
            get
            {
                if (ViewState["DataDetailTextField"] == null) return "Text";
                return ViewState["DataDetailTextField"].ToString();
            }
            set
            {
                ViewState["DataDetailTextField"] = value;
            }
        }

        public string DataDetailCheckedField
        {
            get
            {
                if (ViewState["DataDetailCheckedField"] == null) return "Checked";
                return ViewState["DataDetailCheckedField"].ToString();
            }
            set
            {
                ViewState["DataDetailCheckedField"] = value;
            }
        }

        private DataSet m_DataSet;
        public DataSet DataSource
        {
            set
            {
                end = false;
                data = new Profiles.Search.Utilities.DataIO();


                Repeater rMaster = (Repeater)this.FindControl("rMaster");
                m_DataSet = value;
                DataTable l_dtMaster = m_DataSet.Tables[DataMasterName];
                rMaster.DataSource = l_dtMaster;

                rMaster.DataBind();

                end = true;
            }
            get
            {
                Repeater rMaster = (Repeater)this.FindControl("rMaster");
                if (rMaster.Items.Count <= 0) return null;
                DataSet l_dsResult = FormingStructure();
                DataTable l_dtMaster = l_dsResult.Tables[DataMasterName];
                DataTable l_dtDetail = l_dsResult.Tables[DataDetailName];

                foreach (RepeaterItem l_MasterItem in rMaster.Items)
                {
                    int l_MasterID = int.Parse(((HiddenField)l_MasterItem.FindControl("hdnMasterID")).Value);
                    string l_MasterText = ((Label)l_MasterItem.FindControl("lMasterText")).Text;
                    bool l_isExpand = ((HiddenField)l_MasterItem.FindControl("hdnIsExpand")).Value == "1";
                    DataRow l_MasterRow = l_dtMaster.NewRow();
                    l_MasterRow[DataMasterIDField] = l_MasterID;
                    l_MasterRow[DataMasterTextField] = l_MasterText;
                    l_MasterRow[DataMasterExpandField] = l_isExpand;
                    l_dtMaster.Rows.Add(l_MasterRow);

                    Repeater l_rDetail = (Repeater)l_MasterItem.FindControl("rDetail");
                    if (l_rDetail != null && l_rDetail.Items.Count > 0)
                    {
                        foreach (RepeaterItem l_DetailItem in l_rDetail.Items)
                        {
                            int l_DetailID = int.Parse(((HiddenField)l_DetailItem.FindControl("hdnDetailID")).Value);
                            string l_DetailText = ((HiddenField)l_DetailItem.FindControl("hdnDetailText")).Value;
                            bool l_isChecked = ((CheckBox)l_DetailItem.FindControl("checkDetailText")).Checked;

                            DataRow l_DetailRow = l_dtDetail.NewRow();
                            l_DetailRow[DataMasterIDField] = l_MasterID;
                            l_DetailRow[DataDetailIDField] = l_DetailID;
                            l_DetailRow[DataDetailTextField] = l_DetailText;
                            l_DetailRow[DataDetailCheckedField] = l_isChecked;
                            l_dtDetail.Rows.Add(l_DetailRow);
                        }
                    }
                }

                return l_dsResult;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            ResetContent();

        }


        public void ResetContent()
        {
            if (!IsPostBack)
            {
                ImageButton ibExpand = (ImageButton)this.FindControl("ibExpand");

                ibExpand.ImageUrl = Root.Domain + "/framework/Images/blank.gif";

                ibExpand.OnClientClick = string.Format("ShowMainContent('{0}'); return false;", ClientID);

            }
            
            ScriptManager.RegisterStartupScript(this, GetType(), "updateOnStart" + ClientID, String.Format("UpadateAllCTC('{0}', true);", ClientID), true);

            if (!script.IsNullOrEmpty())
                ScriptManager.RegisterStartupScript(this, GetType(), "runOnStaret" + ClientID, script, true);
            
            
        }

        protected void rMaster_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView l_Item = (DataRowView)e.Item.DataItem;
                int l_MasterID = (int)l_Item[DataMasterIDField];

                HiddenField l_hdnMasterID = (HiddenField)e.Item.FindControl("hdnMasterID");
                l_hdnMasterID.Value = l_MasterID.ToString();

                HiddenField l_hdnIsExpand = (HiddenField)e.Item.FindControl("hdnIsExpand");
                bool l_isExpand = false;
                if (l_Item[DataMasterExpandField] != DBNull.Value)
                {
                    l_isExpand = (bool)l_Item[DataMasterExpandField];
                }
                l_hdnIsExpand.Value = l_isExpand ? "1" : "0";

                HtmlImage l_imgExpand = (HtmlImage)e.Item.FindControl("imgExpand");
                l_imgExpand.Attributes.Add("onclick", string.Format("ShowDetailContent('{0}', '{1}'); return false;", ClientID, l_MasterID));
                l_imgExpand.Attributes.Add("src", l_isExpand ? Root.Domain + "/framework/images/expand.gif" : Root.Domain + "/framework/images/collapse.gif");


                HtmlGenericControl l_divDetail = (HtmlGenericControl)e.Item.FindControl("divDetail");
                l_divDetail.Style.Add("display", l_isExpand ? "inline" : "none");



                DataTable l_dtDetailsALL = m_DataSet.Tables[DataDetailName];
                DataTable l_dtDetails = l_dtDetailsALL.Clone();

                bool l_AtLeastOneSel = false;
                foreach (DataRow l_Detail in l_dtDetailsALL.Rows)
                {
                    if ((int)l_Detail[DataMasterIDField] == l_MasterID)
                    {
                        DataRow l_Filtered = l_dtDetails.NewRow();
                        l_Filtered.ItemArray = l_Detail.ItemArray;
                        l_dtDetails.Rows.Add(l_Filtered);
                        if (!l_AtLeastOneSel)
                        {
                            if (l_Detail[DataDetailCheckedField] != DBNull.Value && (bool)l_Detail[DataDetailCheckedField])
                            {
                                l_AtLeastOneSel = true;
                            }
                        }
                    }
                }

                Label l_lMasterText = (Label)e.Item.FindControl("lMasterText");
                l_lMasterText.CssClass = l_AtLeastOneSel ? "ExistSelectCTC" : "";
                l_lMasterText.Text = l_Item[DataMasterTextField].ToString();

                Repeater l_rDetail = (Repeater)e.Item.FindControl("rDetail");
                l_rDetail.DataSource = l_dtDetails;
                l_rDetail.DataBind();
            }
        }

        protected void rDetail_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView l_Item = (DataRowView)e.Item.DataItem;
                CheckBox l_checkDetailText = (CheckBox)e.Item.FindControl("checkDetailText");

                if (l_Item[DataDetailCheckedField] != DBNull.Value && (bool)l_Item[DataDetailCheckedField])
                {
                    l_checkDetailText.Checked = true;
                }

                l_checkDetailText.Text = l_Item[DataDetailTextField].ToString();

                HiddenField l_hdnDetailText = (HiddenField)e.Item.FindControl("hdnDetailText");
                l_hdnDetailText.Value = l_Item[DataDetailTextField].ToString();

                HiddenField l_hdnDetailID = (HiddenField)e.Item.FindControl("hdnDetailID");
                l_hdnDetailID.Value = l_Item[DataDetailIDField].ToString();


                l_checkDetailText.Attributes.Add("onclick", string.Format("ClickCheckBox('{0}', this);", ClientID));

                if (this.SearchRequest != null)
                {
                    if (!end && this.SearchRequest.OuterXml.Contains(data.GetConvertedListItem(data.GetListOfFilters(), l_checkDetailText.Text)))
                    {
                        script += "document.getElementById('" + l_checkDetailText.ClientID + "').checked=true; ClickCheckBox('" + ClientID + "',document.getElementById('" + l_checkDetailText.ClientID + "'));";
                    }

                }
            }
        }

        private DataSet FormingStructure()
        {
            DataSet l_dsScheme = new DataSet();
            string l_DataMasterName = DataMasterName;
            string l_DataMasterIDField = DataMasterIDField;
            string l_DataMasterTextField = DataMasterTextField;
            string l_DataMasterExpandField = DataMasterExpandField;

            string l_DataDetailName = DataDetailName;
            string l_DataDetailTextField = DataDetailTextField;
            string l_DataDetailCheckedField = DataDetailCheckedField;

            DataTable l_dtMasterName = new DataTable(l_DataMasterName);
            DataColumn l_ColumnID = new DataColumn(l_DataMasterIDField, typeof(int));
            DataColumn l_ColumnText = new DataColumn(l_DataMasterTextField, typeof(string));
            DataColumn l_ColumnExpanded = new DataColumn(l_DataMasterExpandField, typeof(bool));
            l_dtMasterName.Columns.AddRange(new DataColumn[] { l_ColumnID, l_ColumnText, l_ColumnExpanded });

            DataTable l_dtDetail = new DataTable(l_DataDetailName);
            DataColumn l_ColumnIDSlave = new DataColumn(DataDetailIDField, typeof(int));
            DataColumn l_ColumnMasterIDSlave = new DataColumn(l_DataMasterIDField, typeof(int));

            DataColumn l_ColumnDetailText = new DataColumn(l_DataDetailTextField, typeof(string));
            DataColumn l_ColumnCheckedField = new DataColumn(l_DataDetailCheckedField, typeof(bool));
            l_dtDetail.Columns.AddRange(new DataColumn[] { l_ColumnIDSlave, l_ColumnMasterIDSlave, l_ColumnDetailText, l_ColumnCheckedField });

            l_dsScheme.Tables.Add(l_dtMasterName);
            l_dsScheme.Tables.Add(l_dtDetail);

            return l_dsScheme;
        }


        public XmlDocument SearchRequest { get; set; }

        public string Script { get; set; }
    }

}
