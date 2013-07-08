SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Framework.].[ChangeBaseURI]
	@oldBaseURI varchar(1000),
	@newBaseURI varchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
    /* 
 
	EXAMPLE:
 
	exec [Framework.].uspChangeBaseURI	@oldBaseURI = 'http://connects.catalyst.harvard.edu/profiles/profile/',
										@newBaseURI = 'http://dev.connects.catalyst.harvard.edu/profiles/profile/'
 
	*/
 
	UPDATE [Framework.].[Parameter]
		SET Value = @newBaseURI
		WHERE ParameterID = 'baseURI'
 
	UPDATE [RDF.].[Node]
		SET Value = @newBaseURI + substring(value,len(@oldBaseURI)+1,len(value)),
			ValueHash = [RDF.].[fnValueHash](Language,DataType,@newBaseURI + substring(value,len(@oldBaseURI)+1,len(value)))
		WHERE Value LIKE @oldBaseURI + '%'
 
	UPDATE m
		SET m.ValueHash = n.ValueHash
		FROM [RDF.Stage].InternalNodeMap m, [RDF.].[Node] n
		WHERE m.NodeID = n.NodeID
 
	EXEC [Search.Cache].[Public.UpdateCache]

	EXEC [Search.Cache].[Private.UpdateCache]

END
GO
