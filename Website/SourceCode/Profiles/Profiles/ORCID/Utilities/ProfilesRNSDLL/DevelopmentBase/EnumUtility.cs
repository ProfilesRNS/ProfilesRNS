using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.ComponentModel;
using System.Reflection; 

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public static class EnumUtility
    {
        public enum ListItemSortType
        {
            ByValueIncreasing = 1,
            ByValueDecreasing = 2,
            ByTextIncreasing = 3,
            ByTextDecreasing = 4
        }
        public static string GetDescriptionFromEnumValue(Enum value)
        {
            DescriptionAttribute attribute = value.GetType()
                .GetField(value.ToString())
                .GetCustomAttributes(typeof(DescriptionAttribute), false)
                .SingleOrDefault() as DescriptionAttribute;
            return attribute == null ? value.ToString() : attribute.Description;
        }

        public static T GetEnumValueFromDescription<T>(string description)
        {
            var type = typeof(T);
            if (!type.IsEnum)
                throw new ArgumentException();
            FieldInfo[] fields = type.GetFields();
            var field = fields
                            .SelectMany(f => f.GetCustomAttributes(
                                typeof(DescriptionAttribute), false), ( 
                                    f, a) => new { Field = f, Att = a })
                            .Where(a => ((DescriptionAttribute)a.Att)
                                .Description == description).SingleOrDefault();
            return field == null ? default(T) : (T)field.Field.GetRawConstantValue();
        }

        public static T GetEnumValueFromEndOfDescription<T>(string description)
        {
            var type = typeof(T);
            if (!type.IsEnum)
                throw new ArgumentException();
            FieldInfo[] fields = type.GetFields();
            var field = fields
                            .SelectMany(f => f.GetCustomAttributes(
                                typeof(DescriptionAttribute), false), (
                                    f, a) => new { Field = f, Att = a })
                            .Where(a => ((DescriptionAttribute)a.Att)
                                .Description.ToLower().EndsWith(description.ToLower())).First();
            return field == null ? default(T) : (T)field.Field.GetRawConstantValue();
        }

        public static IEnumerable<EnumDataSourceItem> GetItemListByDescription(Type enumType, ListItemSortType sortType)
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
                item.key = DevelopmentBase.Common.EnumDescription((Enum)values.GetValue(i));
                item.isPrivate = DevelopmentBase.Common.EnumIsPrivate((Enum)values.GetValue(i));
                items.Add(item);
            }
            if (sortType == ListItemSortType.ByTextIncreasing)
            {
                
                var returnList = from i in items orderby i.key ascending select i;
                return returnList;
            }
            else if (sortType == ListItemSortType.ByTextDecreasing)
            {
                var returnList = from i in items orderby i.key descending select i;
                return returnList;
            }
            else if (sortType == ListItemSortType.ByValueIncreasing)
            {
                var returnList = from i in items orderby i.key ascending select i;
                return returnList;
            }
            else if (sortType == ListItemSortType.ByValueDecreasing)
            {
                var returnList = from i in items orderby i.key descending select i;
                return returnList;
            }
            else
            {
                var returnList = from i in items select i;
                return returnList;
            }
        }
        
        public static void BindToDropDownFromDescriptions(ref System.Web.UI.WebControls.DropDownList ddl, Type enumType, ListItemSortType sortType)
        {
            ddl.DataSource = GetItemListByDescription(enumType, sortType);
            ddl.DataTextField = "key";
            ddl.DataValueField = "value";
            ddl.DataBind();
        }
    }
}
