using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;

namespace Profiles.Profile.Utilities
{
    public class VCardPerson
    {

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Organization { get; set; }

        public string JobTitle { get; set; }

        public string StreetAddress { get; set; }

        public string Zip { get; set; }

        public string City { get; set; }

        public string State { get; set; }

        public string CountryName { get; set; }

        public string Phone { get; set; }

        public string Mobile { get; set; }

        public string Email { get; set; }

        public string Fax { get; set; }

        public string HomePage { get; set; }

        public byte[] Image { get; set; }

        public override string ToString()
        {

            var builder = new StringBuilder();

            builder.AppendLine("BEGIN:VCARD");

            builder.AppendLine("VERSION:2.1");

            // Name

            builder.AppendLine("N:" + LastName + ";" + FirstName);

            // Full name

            builder.AppendLine("FN:" + FirstName + " " + LastName);

            // Address

            builder.Append("ADR;WORK;PREF:;;");
            if (StreetAddress != null)
                builder.Append(StreetAddress + ";");
            if (City != null)
                builder.Append(City + ";");
            if (State != null)
                builder.Append(State + ";");
            if (Zip != null)
                builder.Append(Zip + ";");
            if (CountryName != null)
                builder.AppendLine(CountryName);

            // Other data
            if (Organization != null)
                builder.AppendLine("ORG:" + Organization);
            if (JobTitle != null)
                builder.AppendLine("TITLE:" + JobTitle);
            if (Phone != null)
                builder.AppendLine("TEL;WORK;VOICE:" + Phone.Replace('/', '-'));
            if (Mobile != null)
                builder.AppendLine("TEL;CELL;VOICE:" + Mobile);
            if (Fax != null)
                builder.AppendLine("TEL;WORK;FAX:" + Fax.Replace('/', '-'));
            if (HomePage != null)
                builder.AppendLine("URL;WORK:" + HomePage);
            if (Email != null)
                builder.AppendLine("EMAIL;PREF;INTERNET:" + Email);

            if (Image != null)
            {
                builder.AppendLine("PHOTO;ENCODING=BASE64;TYPE=JPEG:");
                builder.AppendLine(Convert.ToBase64String(Image));
            }
            builder.AppendLine("END:VCARD");

            builder.AppendLine(string.Empty);

            return builder.ToString();

        }

    }
}