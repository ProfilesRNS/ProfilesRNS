<%@ Page Language="C#" ContentType="text/plain" %>
<%Response.Write("User-Agent: *" + Environment.NewLine);%>
<%Response.Write("Disallow: /shindigorng/" + Environment.NewLine);%>
<%Response.Write("Disallow: /sparql/" + Environment.NewLine);%>
<%Response.Write("Sitemap: " + Profiles.Framework.Utilities.Root.Domain + "/sitemap.xml" + Environment.NewLine);%>
<%Response.Write("Crawl-Delay: 10" + Environment.NewLine);%>
