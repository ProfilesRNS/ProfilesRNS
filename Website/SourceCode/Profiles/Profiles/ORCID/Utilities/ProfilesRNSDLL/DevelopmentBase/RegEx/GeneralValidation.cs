using System.Text.RegularExpressions;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.RegEx
{
    public class GeneralValidation
    {
        public static bool IsEmail(string Email)
        {
            string strRegex = @"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}" +
                @"\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\" +
                @".)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$";
            Regex re = new Regex(strRegex);
            if (re.IsMatch(Email))
                return (true);
            else
                return (false);
        }
        public static bool isValidEmail(string Email)
        {
            string strRegex = @"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*";
            Regex re = new Regex(strRegex);
            if (re.IsMatch(Email))
                return (true);
            else
                return (false);
        }
        public static bool IsValidPhoneNumber(string PhoneNumber)
        {
            string strRegex = @"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$";
            System.Text.RegularExpressions.Regex _Regex = new System.Text.RegularExpressions.Regex(strRegex);
            if (_Regex.IsMatch(PhoneNumber))
                return (true);
            else
                return (false);
        }
        public static bool IsValidIntegerOfNSize(int value, int Nsize)
        {
            return IsValidIntegerOfNSize(value.ToString(), Nsize);
        }
        public static bool IsValidIntegerOfNSize(string value, int Nsize)
        {
            string strRegex = @"^[0-9]{" + Nsize.ToString() + @"}$";
            System.Text.RegularExpressions.Regex _Regex = new System.Text.RegularExpressions.Regex(strRegex);
            if (_Regex.IsMatch(value))
                return (true);
            else
                return (false);
        }
        public static string RemoveNonIntegerChars(string input)
        {
            string pattern = "[^0-9]+";
            string replacement = "";
            Regex rgx = new Regex(pattern);
            return rgx.Replace(input, replacement);
        }
    }
}
