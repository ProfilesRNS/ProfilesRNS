SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Profile.Data].[vwPerson.Photo]
AS
SELECT p.*, m.NodeID PersonNodeID, v.NodeID UserNodeID, o.Value+'Modules/CustomViewPersonGeneralInfo/PhotoHandler.ashx?NodeID='+CAST(m.NodeID as varchar(50)) URI
FROM [Profile.Data].[Person.Photo] p
	INNER JOIN [RDF.Stage].[InternalNodeMap] m
		ON m.Class = 'http://xmlns.com/foaf/0.1/Person'
			AND m.InternalType = 'Person'
			AND m.InternalID = CAST(p.PersonID as varchar(50))
	INNER JOIN [User.Account].[User] u
		ON p.PersonID = u.PersonID
	INNER JOIN [RDF.Stage].[InternalNodeMap] v
		ON v.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
			AND v.InternalType = 'User'
			AND v.InternalID = CAST(u.UserID as varchar(50))
	INNER JOIN [Framework.].[Parameter] o
		ON o.ParameterID = 'baseURI';
GO
