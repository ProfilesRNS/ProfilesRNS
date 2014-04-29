SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER view [ORNG.].[vwPerson]
as
SELECT n.nodeId
      ,par.[Value] + '/' + na.[UrlName] profileURL, p.IsActive
  FROM [Framework.].Parameter par JOIN
  [Profile.Data].[Person] p ON  par.[ParameterID] = 'basePath'
	LEFT JOIN [UCSF.].[NameAdditions] na on na.internalusername = p.internalusername
	LEFT JOIN [RDF.Stage].internalnodemap n on n.internalid = p.personId
	and n.[class] = 'http://xmlns.com/foaf/0.1/Person' 



GO

/****** Object:  StoredProcedure [ORNG.].[ReadAppData]    Script Date: 02/18/2014 16:15:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  [ORNG.].[ReadPerson](@uri nvarchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @nodeid bigint
	
	SELECT @nodeid = [RDF.].[fnURI2NodeID](@uri);

	SELECT * from [ORNG.].[vwPerson] WHERE nodeId = @nodeid
END

GO


-- see changes to [AddAppToOntology] with respect to optparams
--exec [ORNG.].[ReadPerson] 'http://stage-profiles.ucsf.edu/profiles200/profile/368698'

