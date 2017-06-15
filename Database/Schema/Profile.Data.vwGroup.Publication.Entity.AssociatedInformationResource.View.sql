SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Profile.Data].[vwGroup.Publication.Entity.AssociatedInformationResource]
AS
	SELECT GroupID, EntityID, EntityDate FROM [Profile.Data].[Publication.Entity.InformationResource] ir
		JOIN [Profile.Data].[Publication.Group.Include] i
		ON ((ir.PMID = i.PMID AND ir.MPID IS NULL) OR (ir.MPID = i.MPID AND ir.PMID IS NULL))


GO
