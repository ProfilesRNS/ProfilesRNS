SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Module].[GenericRDF.AddPluginToProfile]
@SubjectID BIGINT=NULL, @SubjectURI nvarchar(255)=NULL, @PluginName varchar(55), @SessionID UNIQUEIDENTIFIER=NULL, @Error BIT=NULL OUTPUT, @NodeID BIGINT=NULL OUTPUT
AS
BEGIN
	DECLARE @InternalType nvarchar(100)
	DECLARE @InternalID nvarchar(100)
	DECLARE @Label nvarchar(255)
	DECLARE @LabelID BIGINT
	DECLARE @PredicateURI nvarchar(100)
	DECLARE @SearchableData nvarchar(max)
	DECLARE @SearchableDataID BIGINT
	
	IF (@SubjectID IS NULL)
		SET @SubjectID = [RDF.].fnURI2NodeID(@SubjectURI)

	SELECT @InternalType = [Object] FROM [Ontology.Import].[Triple] 
		WHERE [Subject] = 'http://profiles.catalyst.harvard.edu/ontology/prns#PluginInstance' AND [Predicate] = 'http://www.w3.org/2000/01/rdf-schema#label'

	SELECT @InternalID = InternalID + '-' + @pluginName FROM [RDF.Stage].[InternalNodeMap]
		WHERE [NodeID] = @SubjectID AND Class = 'http://xmlns.com/foaf/0.1/Person'

	IF (@InternalID is null)
	BEGIN
		SELECT @InternalID = InternalID + '-GROUP-' + @pluginName FROM [RDF.Stage].[InternalNodeMap]
			WHERE [NodeID] = @SubjectID AND Class = 'http://xmlns.com/foaf/0.1/Group'
	END

	SELECT @SearchableData = SearchableData from [Profile.Module].[GenericRDF.Data] WHERE Name = @PluginName and NodeID = @SubjectID
	

	EXEC [RDF.].GetStoreNode	@Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#PluginInstance',
								@InternalType = @InternalType,
								@InternalID = @InternalID,
								@SessionID = @SessionID, 
								@Error = @Error OUTPUT, 
								@NodeID = @NodeID OUTPUT

	select @PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/plugins#' + @PluginName

	-- for some reason, this Status in [RDF.Stage].InternalNodeMap is set to 0, not 3.  This causes issues so
	-- we fix
	UPDATE [RDF.Stage].[InternalNodeMap] SET [Status] = 3 WHERE NodeID = @NodeID			

	SELECT @Label = @InternalType + '^^' + @InternalID
		
	EXEC [RDF.].GetStoreNode @Value = @Label, @Language = NULL, @DataType = NULL,
		@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @LabelID OUTPUT	

	EXEC [RDF.].GetStoreNode @Value = @SearchableData, @Language = NULL, @DataType = NULL,
		@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @SearchableDataID OUTPUT	


	-- Add the Type
	EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
								@PredicateURI = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
								@ObjectURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PluginInstance',
								--@SessionID = @SessionID,
								@Error = @Error OUTPUT
	-- Add the Label
	EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
								@PredicateURI = 'http://www.w3.org/2000/01/rdf-schema#label',
								@ObjectID = @LabelID,
								--@SessionID = @SessionID,
								@Error = @Error OUTPUT
	-- Add Searchable Data
	EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
								@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#pluginSearchableData',
								@ObjectID = @SearchableDataID,
								--@SessionID = @SessionID,
								@Error = @Error OUTPUT
	-- Link the ApplicationInstance to the person
	EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
								@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#pluginInstanceFor',
								@ObjectID = @SubjectID,
								--@SessionID = @SessionID,
								@Error = @Error OUTPUT								
	-- Link the person to the ApplicationInstance

	EXEC [RDF.].GetStoreTriple	@SubjectID = @SubjectID,
								@PredicateURI = @PredicateURI,
								@ObjectID = @NodeID,
								--@SessionID = @SessionID,
								@Error = @Error OUTPUT

END
GO
