using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.WebControls;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public class UICommon
    {
        public static List<string> GetSelectedValues(System.Web.UI.WebControls.ListItemCollection lic)
        {
            List<string> selectedItems = new List<string>();
            foreach (System.Web.UI.WebControls.ListItem li in lic)
            { 
                if (li.Selected)
                {
                    selectedItems.Add(li.Value);
                }
            }
            return selectedItems;
        }
        public static List<int> GetSelectedValuesInt(System.Web.UI.WebControls.ListItemCollection lic)
        {
            List<int> selectedItems = new List<int>();
            foreach (System.Web.UI.WebControls.ListItem li in lic)
            {
                if (li.Selected)
                {
                    selectedItems.Add(int.Parse(li.Value));
                }
            }
            return selectedItems;
        }
        public static List<int> GetValueListInt(System.Web.UI.WebControls.ListBox lb)
        {
            List<int> selectedItems = new List<int>();
            foreach (System.Web.UI.WebControls.ListItem li in lb.Items)
            {
                    selectedItems.Add(int.Parse(li.Value));
            }
            return selectedItems;
        }
        public static List<int> GetSelectedValuesInt(System.Web.UI.WebControls.ListBox lb)
        {
            List<int> selectedItems = new List<int>();
            foreach (System.Web.UI.WebControls.ListItem li in lb.Items)
            {
                if (li.Selected)
                {
                    selectedItems.Add(int.Parse(li.Value));
                }
            }
            return selectedItems;
        }
        public static int GetIntFromTextBox(TextBox textBox)
        {
            int returnValue = 0;
            int.TryParse(textBox.Text, out returnValue);
            return returnValue;
        }
        public static int GetIntFromLabel(Label label)
        {
            int returnValue = 0;
            int.TryParse(label.Text, out returnValue);
            return returnValue;
        }
        public static double GetDblFromTextBox(TextBox textBox)
        {
            double returnValue = 0;
            double.TryParse(textBox.Text, out returnValue);
            return returnValue;
        }
        public static double GetDblFromLabel(Label label)
        {
            double returnValue = 0;
            double.TryParse(label.Text, out returnValue);
            return returnValue;
        }
        public static void SetValue(string boField, bool boFieldIsNull, TextBox textBox)
        {
            if (boFieldIsNull)
            {
                textBox.Text = string.Empty;
            }
            else
            {
                textBox.Text = boField;
            }
        }
        public static void SetValue(int boField, bool boFieldIsNull, TextBox textBox)
        {
            if (boFieldIsNull)
            {
                textBox.Text = string.Empty;
            }
            else
            {
                textBox.Text = boField.ToString();
            }
        }
        public static void SetValue(double boField, bool boFieldIsNull, TextBox textBox)
        {
            if (boFieldIsNull)
            {
                textBox.Text = string.Empty;
            }
            else
            {
                textBox.Text = boField.ToString();
            }
        }
        public static void SetValue(double boField, double ValueWhenNull, bool boFieldIsNull, TextBox textBox)
        {
            if (boFieldIsNull)
            {
                textBox.Text = ValueWhenNull.ToString();
            }
            else
            {
                textBox.Text = boField.ToString();
            }
        }
        public static void SetValue(string boField, Label label)
        {
            label.Text = boField.ToString();
        }
        public static void SetValue(int boField, bool boFieldIsNull, Label label)
        {
            if (boFieldIsNull)
            {
                label.Text = string.Empty;
            }
            else
            {
                label.Text = boField.ToString();
            }
        }
        public static void SetValue(string boField, bool boFieldIsNull, Label label)
        {
            if (boFieldIsNull)
            {
                label.Text = string.Empty;
            }
            else
            {
                label.Text = boField.ToString();
            }
        }
        public static void SetValue(DateTime boField, bool boFieldIsNull, Label label)
        {
            if (boFieldIsNull)
            {
                label.Text = string.Empty;
            }
            else
            {
                label.Text = boField.ToString();
            }
        }
        public static void SetValue(DateTime boField, bool boFieldIsNull, TextBox textBox)
        {
            SetValue(boField, boFieldIsNull, textBox, false);
        }
        public static void SetValue(DateTime boField, bool boFieldIsNull, TextBox textBox, bool UseShortDateFormat)
        {
            if (boFieldIsNull)
            {
                textBox.Text = string.Empty;
            }
            else
            {
                if (UseShortDateFormat)
                {
                    textBox.Text = boField.ToShortDateString();
                }
                else
                {
                    textBox.Text = boField.ToString();
                }
            }
        }
        public static void SetValue(int boField, bool boFieldIsNull, DropDownList dropDownList)
        {
            dropDownList.ClearSelection();
            if (boFieldIsNull)
            {
                return;
            }
            else
            {
                ListItem li = dropDownList.Items.FindByValue(boField.ToString());
                if (!(li == null))
                {
                    li.Selected = true;
                }
            }
        }
        public static void SetValue(double boField, bool boFieldIsNull, DropDownList dropDownList)
        {
            dropDownList.ClearSelection();
            if (boFieldIsNull)
            {
                return;
            }
            else
            {
                ListItem li = dropDownList.Items.FindByValue(boField.ToString("F1"));
                if (!(li == null))
                {
                    li.Selected = true;
                }
            }
        }
        public static void SetValue(string boField, DropDownList dropDownList)
        {
            SetValue(boField, false, dropDownList);
        }
        public static void SetValue(string boField, bool boFieldIsNull, DropDownList dropDownList)
        {
            dropDownList.ClearSelection();
            if (boFieldIsNull)
            {
                return;
            }
            else
            {
                ListItem li = dropDownList.Items.FindByValue(boField);
                if (!(li == null))
                {
                    li.Selected = true;
                }
            }
        }
        public static void SetValue(int boField, bool boFieldIsNull, ListBox lb)
        {
            lb.ClearSelection();
            if (boFieldIsNull)
            {
                return;
            }
            else
            {
                ListItem li = lb.Items.FindByValue(boField.ToString());
                if (!(li == null))
                {
                    li.Selected = true;
                }
            }
        }
        public static void SetValue(int boField, ListBox lb)
        {
            SetValue(boField, false, lb);
        }
        public static void SetValue(bool boField, bool boFieldIsNull, CheckBox checkBox)
        {
            if (!boFieldIsNull)
            {
                checkBox.Checked = boField;
            }
        }
        public static void SetValue(bool boField, RadioButton rb)
        {
            rb.Checked = boField;
        }
        public static string TranslateBoolValue(bool? boolVal)
        {
            if (boolVal == true) return "Yes";
            else if (boolVal == false) return "No";
            else return "N/A";
        }
        public static string BoolDesc(bool isNull, bool boolVal)
        {
            if (isNull)
            {
                return string.Empty;
            }
            if (boolVal)
            {
                return "Yes";
            }
            else if (!boolVal)
            {
                return "No";
            }
            else
            {
                return string.Empty;
            }
        }
        public static string DoubleToYesNo(bool isNull, double val)
        {
            return DoubleToYesNo(isNull, val, string.Empty);
        }
        public static string DoubleToYesNo(bool isNull, double val, string defaultReturnVal)
        {
            if (isNull)
            {
                return defaultReturnVal;
            }
            if (val == 1)
            {
                return "Yes";
            }
            else if (val == 0)
            {
                return "No";
            }
            else
            {
                return defaultReturnVal;
            }
        }
        public static void SetErrorAndMessage(Label labelError, Label labelMessage, string error, string message)
        {
            labelError.Text = error.Replace(Environment.NewLine, "<br />");
            labelMessage.Text = message.Replace(Environment.NewLine, "<br />");
        }
        public static void GetQueryStringValue(Label label, string paramName)
        {
            label.Text = string.Empty;
            if (System.Web.HttpContext.Current.Request.QueryString[paramName] != null)
            {
                if (!System.Web.HttpContext.Current.Request.QueryString[paramName].ToString().Equals(string.Empty))
                {
                    label.Text = System.Web.HttpContext.Current.Request.QueryString[paramName].ToString();
                }
            }
        }
        public static void GetQueryStringValue(TextBox txtBox, string paramName)
        {
            txtBox.Text = string.Empty;
            if (System.Web.HttpContext.Current.Request.QueryString[paramName] != null)
            {
                if (!System.Web.HttpContext.Current.Request.QueryString[paramName].ToString().Equals(string.Empty))
                {
                    txtBox.Text = System.Web.HttpContext.Current.Request.QueryString[paramName].ToString();
                }
            }
        }
        public static void GetQueryStringValue(DropDownList ddl, string paramName)
        {
            if (System.Web.HttpContext.Current.Request.QueryString[paramName] != null)
            {
                if (!System.Web.HttpContext.Current.Request.QueryString[paramName].ToString().Equals(string.Empty))
                {
                    DropDownListSelect(ref ddl, System.Web.HttpContext.Current.Request.QueryString[paramName].ToString());
                }
            }
        }
        public static void BindToEnum(ref DropDownList dropDownList, Type enumType)
        {
            BindToEnum(ref dropDownList, enumType, true);
        }
        public static void BindToEnum(ref DropDownList dropDownList, Type enumType, bool addBlank)
        {
            dropDownList.DataSource = DevelopmentBase.Common.BindToEnum(enumType);
            dropDownList.DataValueField = "value";
            dropDownList.DataTextField = "key";
            dropDownList.DataBind();
            if (addBlank)
            {
                dropDownList.Items.Insert(0, new ListItem("", ""));
            }
        }
        public static void DropDownListSelect(ref DropDownList ddl, string value)
        {
            ddl.ClearSelection();
            ListItem li = ddl.Items.FindByValue(value);
            if (li != null)
            {
                li.Selected = true;
            }
        }
        public static void ListBoxSelect(ref ListBox ddl, string value)
        {
            ddl.ClearSelection();
            ListItem li = ddl.Items.FindByValue(value);
            if (li != null)
            {
                li.Selected = true;
            }
        }
        public static string GetStringFromIntList(List<int> list, char delimiter)
        {
            StringBuilder strList = new StringBuilder();

            foreach (int i in list)
            {
                strList.Append(i.ToString() + delimiter);
            }
            if (strList.Length > 0) { strList.Remove(strList.Length - 1, 1); }
            return strList.ToString();
        }
        public static string GetStringFromStringList(List<string> list, char delimiter)
        {
            StringBuilder strList = new StringBuilder();

            foreach (string i in list)
            {
                strList.Append(i + delimiter);
            }
            if (strList.Length > 0) { strList.Remove(strList.Length - 1, 1); }
            return strList.ToString();
        }
    }
}

