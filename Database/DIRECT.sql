


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Display.].[DIRECT.GetSiteListJson]
AS
BEGIN
	select (select SiteID, SiteName from [Direct.].[Sites] where isActive = 1 order by SortOrder for JSON path) as json
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Display.].[DIRECT.GetSiteQueryURLs]
AS
BEGIN
	select SiteID, QueryURL from [Direct.].[Sites] where isActive = 1
END
GO
