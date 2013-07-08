SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Profile.Data].[vwPublication.Entity.General] AS
		SELECT e.EntityID, g.MedlineTA, g.JournalTitle Journal, g.Authors
			FROM [Profile.Data].[vwPublication.Entity.InformationResource] e, [Profile.Data].[Publication.PubMed.General] g
			WHERE e.pmid = g.pmid AND e.pmid IS NOT NULL AND e.IsActive = 1
		UNION ALL
		SELECT e.EntityID, null MedlineTA, g.PubTitle Journal, g.Authors
			FROM [Profile.Data].[vwPublication.Entity.InformationResource] e, [Profile.Data].[Publication.MyPub.General] g
			WHERE e.mpid = g.mpid AND e.pmid IS NULL AND e.MPID IS NOT NULL AND e.IsActive = 1
GO
