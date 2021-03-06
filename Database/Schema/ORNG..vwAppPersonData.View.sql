SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [ORNG.].[vwAppPersonData] as
	SELECT m.InternalID + '-' + CAST(a.AppID as varchar) + '-' + d.Keyname PrimaryId, 
	 m.InternalID + '-' + CAST(a.AppID as varchar)PersonIdAppId,
	 m.InternalID PersonId, a.AppID,
	 a.Name AppName, d.Keyname, d.Value FROM [ORNG.].[Apps] a 
	 join [ORNG.].AppData d on a.AppID = d.AppID 
	 join [RDF.Stage].InternalNodeMap m on d.NodeID = m.NodeID

GO
