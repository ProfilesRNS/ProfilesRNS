SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [ORNG.].[vwPerson]
as
SELECT n.nodeId
      ,par.[Value] + '/' + na.[UrlName] profileURL, p.IsActive
  FROM [Framework.].Parameter par JOIN
  [Profile.Data].[Person] p ON  par.[ParameterID] = 'basePath'
	LEFT JOIN [UCSF.].[NameAdditions] na on na.internalusername = p.internalusername
	LEFT JOIN [RDF.Stage].internalnodemap n on n.internalid = p.personId
	and n.[class] = 'http://xmlns.com/foaf/0.1/Person' 




GO
