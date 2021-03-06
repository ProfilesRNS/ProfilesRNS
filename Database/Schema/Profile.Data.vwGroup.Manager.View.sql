SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Profile.Data].[vwGroup.Manager] AS 
	SELECT m.GroupID, m.UserID, g.ViewSecurityGroup, -40 EditSecurityGroup
	FROM [Profile.Data].[Group.Manager] m
		INNER JOIN [Profile.Data].[Group.General] g
			ON g.GroupID = m.GroupID
	WHERE g.ViewSecurityGroup <> 0
GO
