//using System.Threading.Tasks;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public class DOI
    {
        public const string DOI_NOT_FOUND_MESSAGE = "Not found";
        public static string Get(string pmid)
        {
            string doiURL = "http://www.pmid2doi.org/rest/json/batch/doi?pmids=[" + pmid + "]";
            string JSON_DOI = DevelopmentBase.Helpers.WebPageContent.Get(doiURL);
            // [{"pmid":21927676,"doi":"10.3390/v3081501"}]

            if (JSON_DOI.Contains("\"pmid\":") && JSON_DOI.Contains("\"doi\":\""))
            {
                string returnPMID = System.Text.RegularExpressions.Regex.Split(JSON_DOI, "\"pmid\":")[1];
                returnPMID = returnPMID.Substring(0, returnPMID.IndexOf(","));
                string doi = System.Text.RegularExpressions.Regex.Split(JSON_DOI, "\"doi\":\"")[1];
                doi = doi.Substring(0, doi.IndexOf("\""));
                if (returnPMID.Equals(pmid))
                {
                    return doi;
                }
            }
            return DOI_NOT_FOUND_MESSAGE;
        }
        //private static string GetWebResponse(string url)
        //{

        //    var httpWebRequest = (HttpWebRequest)WebRequest.Create(url);
        //    httpWebRequest.ContentType = "application/x-www-form-urlencoded";
        //    httpWebRequest.Method = "POST";

        //    var sb = new StringBuilder();

        //    byte[] requestBytes = Encoding.UTF8.GetBytes(sb.ToString());
        //    httpWebRequest.ContentLength = requestBytes.Length;

        //    using (var requestStream = httpWebRequest.GetRequestStream())
        //    {
        //        requestStream.Write(requestBytes, 0, requestBytes.Length);
        //        requestStream.Close();
        //    }

        //    using (System.IO.Stream response = httpWebRequest.GetRequestStream())
        //    {
        //        var reader = new StreamReader(response);
        //        return reader.ReadToEnd();
        //    }
        //}
    }
}
