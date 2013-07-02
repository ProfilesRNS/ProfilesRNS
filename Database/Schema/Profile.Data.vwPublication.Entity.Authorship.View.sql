SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Profile.Data].[vwPublication.Entity.Authorship]
AS
SELECT EntityID, EntityName, EntityDate, authorRank, numberOfAuthors, authorNameAsListed, authorWeight, authorPosition, PubYear, YearWeight, PersonID, InformationResourceID, SummaryXML, IsActive
	FROM [Profile.Data].[Publication.Entity.Authorship]
	WHERE IsActive = 1
GO
