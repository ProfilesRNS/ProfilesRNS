using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.ComponentModel;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public class Common
    {

        #region "ENUM BINDING USING SHORT NAMES"
        public static IEnumerable<EnumDataSourceItem> BindToEnumShortNames(Type enumType)
        {
            // default the sort by value if order is not specified. If users needs to specify order, 
            // they need to call the following method directly and specify the order type
            return BindToEnumShortNames(enumType, ItemsListOrder.ByValue);
        }
        public static IEnumerable<EnumDataSourceItem> BindToEnumShortNames(Type enumType, ItemsListOrder order)
        {
            List<EnumDataSourceItem> items = new List<EnumDataSourceItem>();
            // get the names from the enumeration
            string[] names = Enum.GetNames(enumType);
            // get the values from the enumeration
            Array values = Enum.GetValues(enumType);
            for (int i = 0; i < names.Length; i++)
            {
                EnumDataSourceItem item = new EnumDataSourceItem();
                item.value = (int)values.GetValue(i);
                item.key = names[i];
                //item.key = EnumDescription((Enum)values.GetValue(i));
                items.Add(item);
            }
            if (order == ItemsListOrder.ByValue)
            {
                var returnList = from i in items orderby i.value select i;
                return returnList;
            }
            else  // sort by key
            {
                var returnList = from i in items orderby i.key select i;
                return returnList;
            }
        }
        #endregion

        public enum ItemsListOrder
        {
            ByValue = 1,
            ByText = 2
        }

        public static bool EnumIsPrivate(Enum value)
        {
            // Get the Private attribute value for the enum value
            FieldInfo fi = value.GetType().GetField(value.ToString());
            PrivateAttribute[] attributes = (PrivateAttribute[])fi.GetCustomAttributes(typeof(PrivateAttribute), false);
            if (attributes.Length > 0)
            {
                return attributes[0].IsPrivate;
            }
            else
            {
                return false;
            }
        }

        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.DropDownList lc, Type enumType)
        //{
        //    foreach (EnumDataSourceItem eds in BindToEnum(enumType))
        //    {
        //        lc.Items.Add(new System.Web.UI.WebControls.ListItem(eds.key.Replace("_", " "), eds.value.ToString()));
        //    }
        //}

        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.CheckBoxList lc, Type enumType)
        //{
        //    foreach (EnumDataSourceItem eds in BindToEnum(enumType))
        //    {
        //        lc.Items.Add(new System.Web.UI.WebControls.ListItem(eds.key.Replace("_", " "), eds.value.ToString()));
        //    }
        //}

        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.DropDownList ddl, Type enumType, bool addBlank, bool sortList)
        //{
        //    foreach (EnumDataSourceItem eds in BindToEnum(enumType, sortList))
        //    {
        //        ddl.Items.Add(new System.Web.UI.WebControls.ListItem(eds.key.Replace("_", " "), eds.value.ToString()));
        //    }
        //    if (addBlank)
        //    {
        //        System.Web.UI.WebControls.ListItem li = new System.Web.UI.WebControls.ListItem("", "");
        //        ddl.Items.Insert(0, li);
        //    }
        //}

        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.ListBox lc, Type enumType)
        //{
        //    foreach (EnumDataSourceItem eds in BindToEnum(enumType))
        //    {
        //        lc.Items.Add(new System.Web.UI.WebControls.ListItem(eds.key.Replace("_", " "), eds.value.ToString()));
        //    }
        //}
        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.ListBox lc, Type enumType, bool sortList, bool selectAll)
        //{
        //    foreach (EnumDataSourceItem eds in BindToEnum(enumType, sortList))
        //    {
        //        System.Web.UI.WebControls.ListItem li = new System.Web.UI.WebControls.ListItem(eds.key.Replace("_", " "), eds.value.ToString());
        //        li.Selected = selectAll;
        //        lc.Items.Add(li);
        //    }
        //}
        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.ListControl lc, Type enumType)
        //{
        //    foreach (EnumDataSourceItem eds in BindToEnum(enumType))
        //    {
        //        lc.Items.Add(new System.Web.UI.WebControls.ListItem(eds.key.Replace("_", " "), eds.value.ToString()));
        //    }
        //}
        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.RadioButtonList lc, Type enumType)
        //{
        //    foreach (EnumDataSourceItem eds in BindToEnum(enumType))
        //    {
        //        lc.Items.Add(new System.Web.UI.WebControls.ListItem(eds.key.Replace("_", " "), eds.value.ToString()));
        //    }
        //}

        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.ListControl lc, Type enumType, bool addBlank)
        //{
        //    BindListControlToEnum(ref lc, enumType);
        //    if (addBlank)
        //    {
        //        System.Web.UI.WebControls.ListItem li = new System.Web.UI.WebControls.ListItem("", "");
        //        lc.Items.Add(li);
        //    }
        //}
        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.DropDownList ddl, Type enumType, bool addBlank)
        //{
        //    BindListControlToEnum(ref ddl, enumType);
        //    if (addBlank)
        //    {
        //        System.Web.UI.WebControls.ListItem li = new System.Web.UI.WebControls.ListItem("", "");
        //        ddl.Items.Insert(0, li);
        //    }
        //}
        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.ListControl lc, Type enumType, bool addBlank, string valueToSelect)
        //{
        //    BindListControlToEnum(ref lc, enumType, addBlank);
        //    foreach (System.Web.UI.WebControls.ListItem li in lc.Items)
        //    {
        //        if (li.Value.Equals(valueToSelect))
        //        {
        //            li.Selected = true;
        //            return;
        //        }
        //    }
        //}
        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.ListControl lc, Type enumType, bool addBlank, bool selectAll)
        //{
        //    BindListControlToEnum(ref lc, enumType, addBlank);
        //    foreach (System.Web.UI.WebControls.ListItem li in lc.Items)
        //    {
        //        li.Selected = true;
        //    }
        //}
        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.RadioButtonList lc, Type enumType, bool addBlank)
        //{
        //    BindListControlToEnum(ref lc, enumType);
        //    if (addBlank)
        //    {
        //        System.Web.UI.WebControls.ListItem li = new System.Web.UI.WebControls.ListItem("", "");
        //        lc.Items.Add(li);
        //    }
        //}
        //public static void BindListControlToEnum(ref System.Web.UI.WebControls.RadioButtonList lc, Type enumType, bool addBlank, bool sortList)
        //{
        //    foreach (EnumDataSourceItem eds in BindToEnum(enumType, sortList))
        //    {
        //        System.Web.UI.WebControls.ListItem li = new System.Web.UI.WebControls.ListItem(eds.key.Replace("_", " "), eds.value.ToString());
        //        lc.Items.Add(li);
        //    }
        //    if (addBlank)
        //    {
        //        System.Web.UI.WebControls.ListItem li = new System.Web.UI.WebControls.ListItem("", "");
        //        lc.Items.Add(li);
        //    }
        //}
    
        public static IEnumerable<EnumDataSourceItem> BindToEnum(Type enumType)
        {
            return BindToEnum(enumType, true);
        }

        public static string EnumDescription(Enum value)
        {
            // Get the Description attribute value for the enum value
            FieldInfo fi = value.GetType().GetField(value.ToString());
            DescriptionAttribute[] attributes = (DescriptionAttribute[])fi.GetCustomAttributes(typeof(DescriptionAttribute), false);
            if (attributes.Length > 0)
            {
                return attributes[0].Description;
            }
            else
            {
                return value.ToString().Replace("_"," ");
            }  
        }
        
        public static IEnumerable<EnumDataSourceItem> BindToEnum(Type enumType, bool sortList)
        {
            List<EnumDataSourceItem> items = new List<EnumDataSourceItem>();
            // get the names from the enumeration
            string[] names = Enum.GetNames(enumType);
            // get the values from the enumeration
            Array values = Enum.GetValues(enumType);
            for (int i = 0; i < names.Length; i++)
            {
                EnumDataSourceItem item = new EnumDataSourceItem();
                item.value = (int)values.GetValue(i);
                //item.key = names[i];
                item.key = EnumDescription((Enum)values.GetValue(i));
                item.isPrivate = EnumIsPrivate((Enum)values.GetValue(i));
                items.Add(item);
            }
            if (!sortList)
            {
                //return items;
                var returnList = from i in items select i;
                return returnList;
            }
            else  // sort by value
            {
                //var returnList = from i in items orderby i.key select i;
                var returnList = from i in items orderby i.key select i;
                return returnList;
            }
        }

        public static string GetConfig(string param_name)
        {
            try
            {
                return System.Configuration.ConfigurationManager.AppSettings[param_name];
            }
            catch
            {
                throw new ArgumentNullException(("Unable to find "
                                + (param_name + " in the configuration file.")));
            }
        }
        public static int GetConfigInt(string param_name)
        {
            try
            {
                return int.Parse(System.Configuration.ConfigurationManager.AppSettings[param_name].ToString());
            }
            catch
            {
                throw new ArgumentNullException(("Unable to find "
                                + (param_name + " in the configuration file.")));
            }
        }

        //public static string WebFilePath {
        //    get
        //    {
        //        string currentExecution = System.Web.HttpContext.Current.Request.CurrentExecutionFilePath.ToString();
        //        return currentExecution.Split('/')[currentExecution.Split('/').Length - 1].Split('.')[0];
        //    }
        //}

        //public static string LoggedInUser {
        //    get
        //    {
        //        return System.Web.HttpContext.Current.User.Identity.Name.ToString().Trim();
        //    }
        //}

        //public static string UID
        //{
        //    get
        //    {
        //        if (System.Web.HttpContext.Current.Session["UID"] == null)
        //        {
        //            return string.Empty;
        //        }
        //        return System.Web.HttpContext.Current.Session["UID"].ToString();
        //    }
        //}

        //public static string LoggedInBUID
        //{
        //    get
        //    {
        //        if (System.Web.HttpContext.Current.Session["LoggedInBUID"] == null)
        //        {
        //            return string.Empty;
        //        }
        //        return System.Web.HttpContext.Current.Session["LoggedInBUID"].ToString();
        //    }
        //}
        
        //public static int PersonID
        //{
        //    get
        //    {
        //        if (System.Web.HttpContext.Current.Session["PersonID"] == null)
        //        {
        //            return 0;
        //        }
        //        return int.Parse(System.Web.HttpContext.Current.Session["PersonID"].ToString());
        //    }
        //}

        //public static int LoggedInPersonID
        //{
        //    get
        //    {
        //        int loggedInPersonID = 0;
        //        if (System.Web.HttpContext.Current.User.Identity.Name != null)
        //        {
        //            int.TryParse(System.Web.HttpContext.Current.User.Identity.Name.ToString().Trim(), out loggedInPersonID);
        //        }

        //        return loggedInPersonID;
        //    }
        //}

        //public static int CurrentPersonID
        //{
        //    get
        //    {
        //        return DevelopmentBase.Helpers.QueryString.GetQueryStringInt("CurrentPersonID");
        //    }
        //}

        public static BO.ExceptionSafeToDisplay ProcessAndReturnException(string UID, string friendlyMsg, Exception ExceptionToLog)
        {
            return DALBase.ProcessAndReturnException(UID,friendlyMsg, ExceptionToLog);
        }
    }

    public class PrivateAttribute : System.Attribute
    {
        public readonly bool _IsPrivate;
        public bool IsPrivate
        {
            get
            {
                return _IsPrivate;
            }
        }

        public PrivateAttribute(bool value)
        {
            _IsPrivate = value;
        }
    }
}
