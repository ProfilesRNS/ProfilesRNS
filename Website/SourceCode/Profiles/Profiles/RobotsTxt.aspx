<%@ Page Language="C#" %>
<%Response.ContentType = "text/plain";%>User-Agent: *
Disallow: /shindigorng/
<%Response.Write("Sitemap: " + Profiles.Framework.Utilities.Root.Domain + "/sitemap.xml");%>
Crawl-Delay: 10