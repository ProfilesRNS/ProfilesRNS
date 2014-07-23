using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Mail;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public class Email
    {
        /* The class assumes that the host has been set in the web.config e.g.
         *  <system.net>
		    <mailSettings>
			<smtp from="FacDev@bu.edu">
				<network host="extbulk.bu.edu" />
			</smtp>
		    </mailSettings>
	        </system.net>
         */
        public static void SendMail(MailMessage mail, SmtpClient MailClient)
        {
            if (MailClient != null)
            {
                MailClient.Send(mail);
            }
        }
        public static void SendEmail(string from, string to, string cc, string subject, string body)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            EmailMsg.To.Add(new MailAddress(to));
            EmailMsg.CC.Add(new MailAddress(cc));
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = true;
            EmailMsg.Priority = MailPriority.Normal;

            SmtpClient MailClient = new SmtpClient();
            MailClient.Send(EmailMsg);
        }
        public static void SendEmail(string from, List<string> to, string cc, string subject, string body)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            foreach (string s in to)
            {
                EmailMsg.To.Add(new MailAddress(s));
            }
            EmailMsg.CC.Add(new MailAddress(cc));
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = true;
            EmailMsg.Priority = MailPriority.Normal;

            SmtpClient MailClient = new SmtpClient();
            MailClient.Send(EmailMsg);
        }
        public static void SendEmail(string from, string to, string subject, string body)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            EmailMsg.To.Add(new MailAddress(to));
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = true;
            EmailMsg.Priority = MailPriority.Normal;

            SmtpClient MailClient = new SmtpClient();
            MailClient.Send(EmailMsg);
        }

        public static void SendEmail(string from, string[] toAddresses, string[] ccAddresses, string subject, string body, System.IO.Stream stream, string filename)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            for (int i = 0; i < toAddresses.Count(); i++)
            {
                EmailMsg.To.Add(new MailAddress(toAddresses[i]));
            }
            for (int i = 0; i < ccAddresses.Count(); i++)
            {
                EmailMsg.CC.Add(new MailAddress(ccAddresses[i]));
            }
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = true;
            EmailMsg.Priority = MailPriority.Normal;

            System.Net.Mime.ContentType ct = new System.Net.Mime.ContentType("Application/pdf");

            Attachment a = new Attachment(stream, ct);
            a.Name = filename;

            EmailMsg.Attachments.Add(a);

            SmtpClient MailClient = new SmtpClient();
            MailClient.Send(EmailMsg);
        }


        public static void SendEmail(string from, string to, string subject, string body, System.IO.Stream stream, string filename)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            EmailMsg.To.Add(new MailAddress(to));
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = true;
            EmailMsg.Priority = MailPriority.Normal;
 
            System.Net.Mime.ContentType ct = new System.Net.Mime.ContentType("Application/pdf"); 
 
            Attachment a = new Attachment(stream, ct);
            a.Name = filename;

            EmailMsg.Attachments.Add(a);

            SmtpClient MailClient = new SmtpClient();
            MailClient.Send(EmailMsg);
        }
        public static void SendEmail(string from, string to, string cc, string subject, string body, System.IO.Stream stream, string filename)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            EmailMsg.To.Add(new MailAddress(to));
            EmailMsg.CC.Add(new MailAddress(cc));
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = true;
            EmailMsg.Priority = MailPriority.Normal;

            System.Net.Mime.ContentType ct = new System.Net.Mime.ContentType("Application/pdf");

            Attachment a = new Attachment(stream, ct);
            a.Name = filename;

            EmailMsg.Attachments.Add(a);

            SmtpClient MailClient = new SmtpClient();
            MailClient.Send(EmailMsg);
        }
        public static void SendEmail(string from, string[] to, string[] cc, string[] bcc, string subject, string body, System.IO.Stream stream, string filename)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            foreach (string emailAddress in to)
            {
                EmailMsg.To.Add(new MailAddress(emailAddress));
            }
            foreach (string emailAddress in cc)
            {
                EmailMsg.CC.Add(new MailAddress(emailAddress));
            }
            foreach (string emailAddress in bcc)
            {
                EmailMsg.Bcc.Add(new MailAddress(emailAddress));
            }
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = true;
            EmailMsg.Priority = MailPriority.Normal;

            System.Net.Mime.ContentType ct = new System.Net.Mime.ContentType("Application/pdf");

            Attachment a = new Attachment(stream, ct);
            a.Name = filename;

            EmailMsg.Attachments.Add(a);

            SmtpClient MailClient = new SmtpClient();
            MailClient.Send(EmailMsg);
        }
        public static void SendEmail(string from, string to, string cc, string bcc, string subject, string body, System.IO.Stream stream, string filename)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            EmailMsg.To.Add(new MailAddress(to));
            if (!cc.Trim().Equals(string.Empty))
            {
                EmailMsg.CC.Add(new MailAddress(cc));
            }
            if (!bcc.Trim().Equals(string.Empty))
            {
                EmailMsg.Bcc.Add(new MailAddress(bcc));
            }
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = true;
            EmailMsg.Priority = MailPriority.Normal;

            System.Net.Mime.ContentType ct = new System.Net.Mime.ContentType("Application/pdf");

            Attachment a = new Attachment(stream, ct);
            a.Name = filename;

            EmailMsg.Attachments.Add(a);

            SmtpClient MailClient = new SmtpClient();
            MailClient.Send(EmailMsg);
        }
        public static void SendEmail(string from, List<string> to, string subject, string body)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            foreach (string s in to)
            {
                EmailMsg.To.Add(new MailAddress(s));
            }
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = true;
            EmailMsg.Priority = MailPriority.Normal;

            SmtpClient MailClient = new SmtpClient();
            MailClient.Send(EmailMsg);
        }
        public static void SendEmail(string from, List<string> to, List<string> cc, string subject, string body)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            foreach (string s in to)
            {
                EmailMsg.To.Add(new MailAddress(s));
            }
            foreach (string c in cc)
            {
                EmailMsg.CC.Add(new MailAddress(c));
            }
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = true;
            EmailMsg.Priority = MailPriority.Normal;

            SmtpClient MailClient = new SmtpClient();
            MailClient.Send(EmailMsg);
        }
        public static void SendEmail(string from, List<string> to, List<string> cc, string subject, string body, System.Net.Mail.SmtpClient smtp)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            foreach (string s in to)
            {
                EmailMsg.To.Add(new MailAddress(s));
            }
            foreach (string c in cc)
            {
                EmailMsg.CC.Add(new MailAddress(c));
            }
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = true;
            EmailMsg.Priority = MailPriority.Normal;

            smtp.Send(EmailMsg);
        }
        public static void SendEmail(string from, List<string> to, string subject, string body, System.Net.Mail.SmtpClient smtp)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            foreach (string s in to)
            {
                EmailMsg.To.Add(new MailAddress(s));
            }
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = true;
            EmailMsg.Priority = MailPriority.Normal;

            smtp.Send(EmailMsg);
        }
        public static void SendEmail(string from, string to, string subject, string body, System.Net.Mail.SmtpClient smtp)
        {
            //SmtpClient smtp = new SmtpClient(mailserver);
            MailMessage mm;
            mm = new MailMessage(from, to);
            //if (!string.IsNullOrEmpty(email.CC)) { mm.CC.Add(email.CC); }
            //if (!string.IsNullOrEmpty(email.BCC)) { mm.Bcc.Add(email.BCC); }
            mm.Subject = subject;
            mm.Body = body;
            smtp.Send(mm);
        }
        public static void SendEmail(string to, string subject, string body)
        {
            SendEmail(Common.GetConfig("ContactEmail"), to, subject, body);
        }
        public static void SendEmail(string from, List<string> to, List<string> cc, List<string> bcc, string subject, string body, bool isBodyHtml, List<System.Net.Mail.Attachment> attachments, System.Net.Mail.SmtpClient smtp)
        {
            MailMessage EmailMsg = new MailMessage();
            EmailMsg.From = new MailAddress(from);
            foreach (string s in to)
            {
                EmailMsg.To.Add(new MailAddress(s));
            }
            foreach (string c in cc)
            {
                EmailMsg.CC.Add(new MailAddress(c));
            }
            foreach (string c in bcc)
            {
                EmailMsg.Bcc.Add(new MailAddress(c));
            }
            EmailMsg.Subject = subject;
            EmailMsg.Body = body;
            EmailMsg.IsBodyHtml = isBodyHtml;

            foreach (System.Net.Mail.Attachment att in attachments)
            {
                EmailMsg.Attachments.Add(att);
            }
            EmailMsg.Priority = MailPriority.Normal;

            smtp.Send(EmailMsg);
        }
        public static void SendEmailAppointment(DateTime startDate, DateTime endDate, string subject, string summary, string location, string attendeeName, string attendeeEmail, string organizerName, string organizerEmail)
        {
            Guid loGUID = Guid.NewGuid();
            SendEmailAppointment(startDate, endDate, subject, summary, location, attendeeName, attendeeEmail, organizerName, organizerEmail, loGUID.ToString());
        }
        public static void SendEmailAppointment(DateTime startDate, DateTime endDate, string subject, string summary, string location, string attendeeName, string attendeeEmail, string organizerName, string organizerEmail, string uniqueIdentifier)
        {
            // Send the calendar message to the attendee

            MailMessage loMsg = new MailMessage();
            AlternateView loTextView = null;
            AlternateView loHTMLView = null;
            AlternateView loCalendarView = null;
            SmtpClient loSMTPServer = new SmtpClient();

            // SMTP settings set up in web.config such as:
            //  <system.net>
            //   <mailSettings>
            //    <smtp>
            //     <network
            //       host = "exchange.mycompany.com"
            //       port = "25"
            //       userName = "username"
            //       password="password" />
            //    </smtp>
            //   </mailSettings>
            //  </system.net>

            // Set up the different mime types contained in the message
            System.Net.Mime.ContentType loTextType = new System.Net.Mime.ContentType("text/plain");
            System.Net.Mime.ContentType loHTMLType = new System.Net.Mime.ContentType("text/html");
            System.Net.Mime.ContentType loCalendarType = new System.Net.Mime.ContentType("text/calendar");

            // Add parameters to the calendar header
            loCalendarType.Parameters.Add("method", "REQUEST");
            loCalendarType.Parameters.Add("name", "meeting.ics");

            // Create message body parts
            loTextView = AlternateView.CreateAlternateViewFromString(BodyText(startDate, endDate, subject, summary, location, attendeeName, attendeeEmail, organizerName, organizerEmail), loTextType);
            loMsg.AlternateViews.Add(loTextView);

            loHTMLView = AlternateView.CreateAlternateViewFromString(BodyHTML(startDate, endDate, subject, summary, location, attendeeName, attendeeEmail, organizerName, organizerEmail), loHTMLType);
            loMsg.AlternateViews.Add(loHTMLView);

            loCalendarView = AlternateView.CreateAlternateViewFromString(VCalendar(startDate, endDate, subject, summary, location, attendeeName, attendeeEmail, organizerName, organizerEmail, uniqueIdentifier), loCalendarType);
            loCalendarView.TransferEncoding = System.Net.Mime.TransferEncoding.SevenBit;
            loMsg.AlternateViews.Add(loCalendarView);

            // Adress the message

            loMsg.From = new MailAddress(organizerEmail);
            loMsg.To.Add(new MailAddress(attendeeEmail));
            loMsg.Subject = subject;

            // Send the message
            loSMTPServer.DeliveryMethod = SmtpDeliveryMethod.Network;
            loSMTPServer.Send(loMsg);
        }
        private static string BodyText(DateTime startDate, DateTime endDate, string subject, string summary, string location, string attendeeName, string attendeeEmail, string organizerName, string organizerEmail)
        {
            // Return the Body in text format
            string BODY_TEXT = "Type:Single Meeting" + Environment.NewLine;
            BODY_TEXT += "Organizer: {0}" + Environment.NewLine;
            BODY_TEXT += "Start Time:{1}" + Environment.NewLine;
            BODY_TEXT += "End Time:{2}" + Environment.NewLine;
            BODY_TEXT += "Time Zone:{3}" + Environment.NewLine;
            BODY_TEXT += "Location: {4}" + Environment.NewLine + Environment.NewLine;
            BODY_TEXT += "*~*~*~*~*~*~*~*~*~*" + Environment.NewLine + Environment.NewLine + "{5}";

            return string.Format(BODY_TEXT, organizerName, startDate.ToLongDateString() + " " + startDate.ToLongTimeString(), endDate.ToLongDateString() + " " + endDate.ToLongTimeString(), System.TimeZone.CurrentTimeZone.StandardName, location, summary);
        }
        private static string BodyHTML(DateTime startDate, DateTime endDate, string subject, string summary, string location, string attendeeName, string attendeeEmail, string organizerName, string organizerEmail)
        {

            // Return the Body in HTML format
            string BODY_HTML = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2//EN\">" + Environment.NewLine;
            BODY_HTML += "<HTML>" + Environment.NewLine;
            BODY_HTML += "<HEAD>" + Environment.NewLine;
            BODY_HTML += "<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=utf-8\">" + Environment.NewLine;
            BODY_HTML += "<META NAME=\"Generator\" CONTENT=\"MS Exchange Server version 6.5.7652.24\">" + Environment.NewLine;
            BODY_HTML += "<TITLE>{0}</TITLE>" + Environment.NewLine;
            BODY_HTML += "</HEAD>" + Environment.NewLine;
            BODY_HTML += "<BODY>" + Environment.NewLine;
            BODY_HTML += "<!-- Converted from text/plain format -->" + Environment.NewLine;
            BODY_HTML += "<P><FONT SIZE=2>Type:Single Meeting<BR>" + Environment.NewLine;
            BODY_HTML += "Organizer:{1}<BR>" + Environment.NewLine;
            BODY_HTML += "Start Time:{2}<BR>" + Environment.NewLine;
            BODY_HTML += "End Time:{3}<BR>" + Environment.NewLine;
            BODY_HTML += "Time Zone:{4}<BR>" + Environment.NewLine;
            BODY_HTML += "Location:{5}<BR>" + Environment.NewLine;
            BODY_HTML += "<BR>" + Environment.NewLine;
            BODY_HTML += "*~*~*~*~*~*~*~*~*~*<BR>" + Environment.NewLine;
            BODY_HTML += "<BR>" + Environment.NewLine;
            BODY_HTML += "{6}<BR>" + Environment.NewLine;
            BODY_HTML += "</FONT>" + Environment.NewLine;
            BODY_HTML += "</P>" + Environment.NewLine + Environment.NewLine;
            BODY_HTML += "</BODY>" + Environment.NewLine;
            BODY_HTML += "</HTML>";

            return string.Format(BODY_HTML, summary, organizerName, startDate.ToLongDateString() + " " + startDate.ToLongTimeString(), endDate.ToLongDateString() + " " + endDate.ToLongTimeString(), System.TimeZone.CurrentTimeZone.StandardName, location, summary);

        }
        private static string VCalendar(DateTime startDate, DateTime endDate, string subject, string summary, string location, string attendeeName, string attendeeEmail, string organizerName, string organizerEmail, string uniqueIdentifier)
        {

            // Return the Calendar text in vCalendar format, compatible with most calendar programs

            string lcDateFormat = "yyyyMMddTHHmmssZ";
            
            // Or use the guid of an exiting meeting?

            string VCAL_FILE = "BEGIN:VCALENDAR" + Environment.NewLine;
            VCAL_FILE += "METHOD:REQUEST" + Environment.NewLine;
            VCAL_FILE += "PRODID:Microsoft CDO for Microsoft Exchange" + Environment.NewLine + "VERSION:2.0" + Environment.NewLine + "BEGIN:VTIMEZONE" + Environment.NewLine + "TZID:(GMT-06.00) Central Time (US & Canada)" + Environment.NewLine + "X-MICROSOFT-CDO-TZID:11" + Environment.NewLine + "BEGIN:STANDARD" + Environment.NewLine + "DTSTART:16010101T020000" + Environment.NewLine + "TZOFFSETFROM:-0500" + Environment.NewLine + "TZOFFSETTO:-0600" + Environment.NewLine + "RRULE:FREQ=YEARLY;WKST=MO;INTERVAL=1;BYMONTH=11;BYDAY=1SU" + Environment.NewLine + "END:STANDARD" + Environment.NewLine + "BEGIN:DAYLIGHT" + Environment.NewLine + "DTSTART:16010101T020000" + Environment.NewLine + "TZOFFSETFROM:-0600" + Environment.NewLine + "TZOFFSETTO:-0500" + Environment.NewLine + "RRULE:FREQ=YEARLY;WKST=MO;INTERVAL=1;BYMONTH=3;BYDAY=2SU" + Environment.NewLine + "END:DAYLIGHT" + Environment.NewLine + "END:VTIMEZONE" + Environment.NewLine + "BEGIN:VEVENT" + Environment.NewLine + "DTSTAMP:{8}" + Environment.NewLine + "DTSTART:{0}" + Environment.NewLine + "SUMMARY:{7}" + Environment.NewLine + "UID:{5}" + Environment.NewLine + "ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=\"{9}\":MAILTO:{9}" + Environment.NewLine + "ACTION;RSVP=TRUE;CN=\"{4}\":MAILTO:{4}" + Environment.NewLine + "ORGANIZER;CN=\"{3}\":mailto:{4}" + Environment.NewLine + "LOCATION:{2}" + Environment.NewLine + "DTEND:{1}" + Environment.NewLine + "DESCRIPTION:{7}\\N" + Environment.NewLine + "SEQUENCE:1" + Environment.NewLine + "PRIORITY:5" + Environment.NewLine + "CLASS:" + Environment.NewLine + "CREATED:{8}" + Environment.NewLine + "LAST-MODIFIED:{8}" + Environment.NewLine + "STATUS:CONFIRMED" + Environment.NewLine + "TRANSP:OPAQUE" + Environment.NewLine + "X-MICROSOFT-CDO-BUSYSTATUS:BUSY" + Environment.NewLine + "X-MICROSOFT-CDO-INSTTYPE:0" + Environment.NewLine + "X-MICROSOFT-CDO-INTENDEDSTATUS:BUSY" + Environment.NewLine + "X-MICROSOFT-CDO-ALLDAYEVENT:FALSE" + Environment.NewLine + "X-MICROSOFT-CDO-IMPORTANCE:1" + Environment.NewLine + "X-MICROSOFT-CDO-OWNERAPPTID:-1" + Environment.NewLine + "X-MICROSOFT-CDO-ATTENDEE-CRITICAL-CHANGE:{8}" + Environment.NewLine + "X-MICROSOFT-CDO-OWNER-CRITICAL-CHANGE:{8}" + Environment.NewLine + "BEGIN:VALARM" + Environment.NewLine + "ACTION:DISPLAY" + Environment.NewLine + "DESCRIPTION:REMINDER" + Environment.NewLine + "TRIGGER;RELATED=START:-PT00H15M00S" + Environment.NewLine + "END:VALARM" + Environment.NewLine + "END:VEVENT" + Environment.NewLine + "END:VCALENDAR" + Environment.NewLine;

            return string.Format(VCAL_FILE, startDate.ToUniversalTime().ToString(lcDateFormat), endDate.ToUniversalTime().ToString(lcDateFormat), location, organizerName, organizerEmail, "{" + uniqueIdentifier + "}", summary, subject, System.DateTime.Now.ToUniversalTime().ToString(lcDateFormat),
            attendeeEmail);
        }
    }
}