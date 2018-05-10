using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers
{
    public class StringMethods
    {
        public static string AddSpaces(string name)
        {
            string strReturn = "";
            string strChar = "";

            for (int i = 0; i < name.Length; i++)
            {
                strChar = name.Substring(i, 1);
                if (i != 0)
                {
                    if (strChar.ToUpper().Equals(strChar))
                    {
                        strReturn += " ";
                    }
                }
                strReturn += strChar;
            }
            return strReturn;
        }
        public static void AddString(ref string current, string toAdd, string delimiter)
        {
            current = current.Trim();
            if (current.Equals(""))
            {
                current = toAdd.Trim();
            }
            else
            {
                current += delimiter + toAdd;
            }
        }
        public static void AddString(ref string current, string toAdd)
        {
            AddString(ref current, toAdd, ",");
        }
        public static string CamelCase(string name)
        {
            string work = ReformatName(name);
            return work.Substring(0, 1).ToLower() + work.Substring(1);
        }
        public static string CreateAddress(string line1, string line2, string city, string county, string state, string postalCode, string country)
        {
            string address = string.Empty;
            if (!string.IsNullOrEmpty(line1))
            {
                address = line1;
            }
            if (!string.IsNullOrEmpty(line2))
            {
                DevelopmentBase.Helpers.StringMethods.AddString(ref address, line2, Environment.NewLine);
            }
            if (!string.IsNullOrEmpty(city))
            {
                DevelopmentBase.Helpers.StringMethods.AddString(ref address, city, Environment.NewLine);
            }
            if (!string.IsNullOrEmpty(county))
            {
                DevelopmentBase.Helpers.StringMethods.AddString(ref address, county, ", ");
            }
            if (!string.IsNullOrEmpty(state))
            {
                DevelopmentBase.Helpers.StringMethods.AddString(ref address, state, ", ");
            }
            if (!string.IsNullOrEmpty(postalCode))
            {
                DevelopmentBase.Helpers.StringMethods.AddString(ref address, postalCode, " ");
            }
            if (!string.IsNullOrEmpty(country))
            {
                DevelopmentBase.Helpers.StringMethods.AddString(ref address, country, " " + Environment.NewLine);
            }
            return address;
        }
        public static string CreateDelimitedString(List<string> list, string delimter)
        {
            string returnString = list[0];
            if (list.Count > 0)
            {
                returnString = list[0];
                if (list.Count > 1)
                {
                    for (int i = 1; i < list.Count; i++)
                    {
                        returnString += delimter + list[i];
                    }
                }
            }
            return returnString;
        }
        public static string CreateDelimitedString(IEnumerable<string> items, string delimter)
        {
            return CreateDelimitedString(items.ToList(), delimter);
        }

        public static string DisplayAsHTML(string input)
        {
            if (string.IsNullOrEmpty(input))
            {
                return string.Empty;
            }
            return input.Replace(Environment.NewLine, "<br />");
        }
        public static string FormatPhoneWithExtension(string phoneNumber, string extension)
        {
            if (phoneNumber != null && !phoneNumber.Trim().Equals(string.Empty) && extension != null && !extension.Trim().Equals(string.Empty))
            {
                return phoneNumber + " Ext. " + extension;
            }
            else if (phoneNumber != null && !phoneNumber.Trim().Equals(string.Empty))
            {
                return phoneNumber;
            }
            else if (extension != null && !extension.Trim().Equals(string.Empty))
            {
                return "Ext. " + extension;
            }
            else
            {
                return string.Empty;
            }
        }
        public static String GenerateRandomString(string validCharsSource, int retStringSize)
        {
            Random rnd = new Random();
            System.Text.StringBuilder buffer = new System.Text.StringBuilder();
            for (int i = 0; i < retStringSize; i++)
            {
                int value = rnd.Next(0, validCharsSource.Length);
                buffer.Append(validCharsSource, value, 1);
            }
            rnd = null;
            return buffer.ToString();
        }
        public static string ReformatName(string name)
        {
            string strReturn = "";
            string strChar = "";
            bool isUpper = true;

            for (int i = 0; i < name.Length; i++)
            {
                strChar = name.Substring(i, 1);
                if (strChar.Equals(" ") || strChar.Equals("_"))
                {
                    isUpper = true;
                }
                else
                {
                    if (isUpper)
                    {
                        strReturn += strChar.ToUpper();
                        isUpper = false;
                    }
                    else
                    {
                        strReturn += strChar;
                    }
                }
            }
            return strReturn;
        }
        public static string ShowValueAsString(bool isNull, int value)
        {
            if (isNull)
            {
                return string.Empty;
            }
            else
            {
                return value.ToString();
            }
        }
        public static string ShowValueAsString(bool isNull, long value)
        {
            if (isNull)
            {
                return string.Empty;
            }
            else
            {
                return value.ToString();
            }
        }
        public static string SwitchNewLineToHTML(string input)
        {
            return input.Replace(Environment.NewLine, "<br />");
        }
        public static Dictionary<string, string> GetDictionary(object obj)
        {
            Dictionary<string, string> columnValues = new System.Collections.Generic.Dictionary<string, string>();

            switch (obj.GetType().ToString())
            {
                case "System.Data.DataRow":
                    System.Data.DataRow dr = ((System.Data.DataRow)obj);
                    for (int columnLoop = 0; columnLoop < dr.Table.Columns.Count; columnLoop++)
                    {
                        object value = dr[columnLoop];
                        if (value == null)
                        {
                            columnValues.Add(dr.Table.Columns[columnLoop].ColumnName, null);
                        }
                        else
                        {
                            columnValues.Add(dr.Table.Columns[columnLoop].ColumnName, value.ToString());
                        }
                    }
                    break;

                default:
                    PropertyInfo[] propertyList = obj.GetType().GetProperties();
                    foreach (PropertyInfo property in propertyList)
                    {
                        object value = property.GetValue(obj, null);
                        if (value == null)
                        {
                            columnValues.Add(property.Name, null);
                        }
                        else
                        {
                            columnValues.Add(property.Name, value.ToString());
                        }
                    }
                    break;
            }
            return columnValues;
        }
        public static string ReplaceEmbeddedFields(string text, string startField, string endField, object obj)
        {
            Dictionary<string, string> columnValues = GetDictionary(obj);
            return ReplaceEmbeddedFields(text, startField, endField, columnValues);
        }
        public static string ReplaceEmbeddedFields(string text, string startField, string endField, Dictionary<string, string> columnValues)
        {
            string colName = null;

            int i = 0;
            int j = 0;
            i = text.IndexOf(startField);
            while (i > 0)
            {
                j = text.IndexOf(endField);
                colName = text.Substring(i + startField.Length, j - i - startField.Length);
                colName = colName.Trim(' ');
                text = text.Remove(i, j - i + endField.Length);

                //IF colName is in colNames then it is VALID else it is INVALID
                if (columnValues.ContainsKey(colName))
                {

                    if (columnValues[colName] != null)
                    {
                        text = text.Insert(i, columnValues[colName].ToString());
                    }
                }
                else
                {
                    Exception ex = new Exception("Invalid column found in Find and Replace!");
                    throw ex;
                }
                i = text.IndexOf(startField);
            }
            return text;

            //string result = text;
            //foreach (KeyValuePair<string, string> item in columnValues)
            //{
            //    result = Regex.Replace(result, startField + item.Key + endField, item.Value, RegexOptions.IgnoreCase);
            //}

            //string col = string.Empty;

            //col = Regex.Match(result, startField + @".*" + endField).Value;
            //if (col.Length > 0)
            //{
            //    throw new DevelopmentBase.BO.ExceptionSafeToDisplay(col + " place holder does not match any column.");
            //}

            //return result;
        }
    }
}
