SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Profile.Data].[vwURL] AS 
	SELECT [UrlID], [URL], [WebPageTitle], null as [PublicationDate] FROM [Profile.Data].[Group.Websites]
	UNION SELECT [UrlID], [URL], [WebPageTitle], [PublicationDate] FROM [Profile.Data].[Group.MediaLinks]
	UNION SELECT [UrlID], [URL], [WebPageTitle], null as [PublicationDate] FROM [Profile.Data].[Person.Websites]
	UNION SELECT [UrlID], [URL], [WebPageTitle], [PublicationDate] FROM [Profile.Data].[Person.MediaLinks]
GO
