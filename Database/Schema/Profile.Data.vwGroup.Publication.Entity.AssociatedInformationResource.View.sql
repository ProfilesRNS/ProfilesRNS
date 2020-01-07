SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Profile.Data].[vwGroup.Publication.Entity.AssociatedInformationResource]
AS
	SELECT GroupID, EntityID, EntityDate FROM [Profile.Data].[Publication.Entity.InformationResource] ir
		JOIN [Profile.Data].[Publication.Group.Include] i
		ON ((ir.PMID = i.PMID AND ir.MPID IS NULL) OR (ir.MPID = i.MPID AND ir.PMID IS NULL))
	UNION
	SELECT g.GroupID, InformationResourceID, EntityDate FROM [Profile.Data].[Publication.Group.Option] o
		JOIN [Profile.Data].[Group.Member] g
		ON o.GroupID = g.GroupID and o.IncludeMemberPublications = 1 and g.IsActive = 1
		JOIN [User.Account].[User] u
		ON g.UserID = u.UserID
		JOIN [Profile.Data].[vwPublication.Entity.Authorship] a
		ON u.PersonID = a.PersonID
GO
