using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers
{
    public class Date
    {
        public static bool IsDate(string anyString)
        {
            if (anyString == null)
            {
                return false;
            }
            if (anyString.Length > 0)
            {
                try
                {
                    DateTime.Parse(anyString);
                }
                catch
                {
                    return false;
                }
                return true;
            }
            else
            {
                return false;
            }
        }
        public static string ReformatUISDateString(string dateString)
        {
            dateString = dateString.Trim();
            if (dateString.Equals(""))
            {
                return "";
            }
            else
            {
                return dateString.Substring(4, 2) + "/" + dateString.Substring(6, 2) + "/" + dateString.Substring(0, 4);
            }
        }
        public static double DaysBetween(DateTime dt1, DateTime dt2)
        {
            TimeSpan span = dt2 - dt1;
            return span.TotalDays;
        }
        public static int FiscalYear(DateTime dt)
        {
            if (dt == null)
            {
                return 0;
            }
            else if (dt == DateTime.MinValue)
            {
                return 0;
            }
            else
            {
                return GetFiscalYear(dt);
            }
        }
        public static int Quarter(DateTime dt)
        {
            if (dt == null)
            {
                return 0;
            }
            else if (dt == DateTime.MinValue)
            {
                return 0;
            }
            else
            {
                return GetQuarterName(dt);
            }
        }
        public static DateTime QuarterStartingDate(DateTime myDate)
        {
            return new DateTime(myDate.Year, (3 * GetQuarterName(myDate)) - 2, 1);
        }
        private static int GetFiscalYear(DateTime inputDate)
        {
            if (inputDate.Month > 6)
            {
                return inputDate.Year + 1;
            }
            else
            {
                return inputDate.Year;
            }
        }
        private static int GetQuarterName(DateTime myDate)
        {
            return (int)Math.Ceiling(myDate.Month / 3.0);
        }
        public static DateTime StartOfCurrentMonth
        {
            get
            {
                return DateTime.Parse(DateTime.Now.Month.ToString() + "/01/" + DateTime.Now.Year.ToString());
            }
        }
        public static int BUFiscalYear(DateTime dt)
        {
            if (dt.Month < 7)
            {
                return dt.Year;
            }
            else
            {
                return dt.Year + 1;
            }
        }
        public static int BUPeriod(DateTime dt)
        {
            if (dt.Month < 7)
            {
                return dt.Month + 6;
            }
            else
            {
                return dt.Month - 6;
            }
        }
        public static int BUQuarter(DateTime dt)
        {
            switch (dt.Month)
            { 
                case 7:
                case 8:
                case 9:
                    return 1;
                case 10:
                case 11:
                case 12:
                    return 2;
                case 1:
                case 2:
                case 3:
                    return 3;
                default:
                    return 4;
            }            
        }
        public static DateTime StartOfCurrentBUFiscalYear
        {
            get
            {
                return StartOfBUFiscalYear(StartOfCurrentMonth);
            }
        }
        public static DateTime StartOfBUFiscalYear(DateTime dt)
        {
            return DateTime.Parse("7/1/" + (BUFiscalYear(dt) - 1).ToString());
        }
    }
}
