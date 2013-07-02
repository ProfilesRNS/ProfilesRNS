SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Profile.Data].[vwPublication.Entity.InformationResource]
AS
SELECT EntityID, PMID, MPID, EntityName, EntityDate, Reference, Source, URL, PubYear, YearWeight, SummaryXML, IsActive
	FROM [Profile.Data].[Publication.Entity.InformationResource]
	WHERE IsActive = 1
GO
