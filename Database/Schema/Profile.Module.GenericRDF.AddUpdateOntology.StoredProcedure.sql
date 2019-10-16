SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Module].[GenericRDF.AddUpdateOntology]
	@PluginName varchar(55)
AS
BEGIN 
	IF EXISTS (SELECT 1 WHERE @PluginName LIKE '%[^a-zA-Z0-9]%')
	BEGIN
		SELECT '@PluginName must contain only AlphaNumeric charactors. Spaces are not allowed.'
		RETURN
	END
/*
	IF NOT EXISTS (SELECT 1 FROM [Plugin.].Plugins WHERE Name = @PluginName)
	BEGIN
		SELECT '@PluginName does not exist in [Plugin.].Plugins'
		RETURN
	END
*/

	DECLARE @PropertyGroupURI varchar(400),
		@CustomDisplayModuleXML xml,
		@CustomEditModuleXML xml,
		@label varchar(55),
		@InternalType nvarchar(100),
		@PropertyURI nvarchar(400),
		@Error BIT,
		@NodeID BIGINT,
		@LabelNodeID BIGINT

	SET @PropertyURI = 'http://profiles.catalyst.harvard.edu/ontology/plugins#' + @PluginName

	SELECT @InternalType = n.value FROM [rdf.].[Triple] t JOIN [rdf.].Node n ON t.[Object] = n.NodeID 
		WHERE t.[Subject] = [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#Plugin')
		and t.Predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')



	IF EXISTS (SELECT 1 FROM [Profile.Module].[GenericRDF.Plugins] WHERE Name = @PluginName AND EnabledForPerson = 1)
	BEGIN
		SELECT @PropertyGroupURI=ISNULL(PropertyGroupURI, 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview'),
			@CustomDisplayModuleXML=ISNULL(CustomDisplayModuleXML, '<Module ID="' + CustomDisplayModule + '" />'),
			@CustomEditModuleXML=ISNULL(CustomEditModuleXML, '<Module ID="' + CustomEditModule + '" />'),
			@label = label
			FROM [Profile.Module].[GenericRDF.Plugins] WHERE Name = @PluginName AND EnabledForPerson = 1

		EXEC [Ontology.].[AddProperty]	@OWL = 'PLUGINS_1.0', 
									@PropertyURI = @PropertyURI,
									@PropertyName = @label,
									@ObjectType = 0,
									@PropertyGroupURI = @PropertyGroupURI, 
									@ClassURI = 'http://xmlns.com/foaf/0.1/Person',
									@IsDetail = 0,
									@IncludeDescription = 0

		UPDATE [Ontology.].[ClassProperty] set EditExistingSecurityGroup = -20, ViewSecurityGroup = -1,
			IsDetail = 0, IncludeDescription = 1, SearchWeight = 1,
			CustomEdit = 1, CustomEditModule = @CustomEditModuleXML,
			CustomDisplay = 1, CustomDisplayModule = @CustomDisplayModuleXML,
			EditSecurityGroup = -20, EditPermissionsSecurityGroup = -20, -- was -20's
			EditAddNewSecurityGroup = -20, EditAddExistingSecurityGroup = -20, EditDeleteSecurityGroup = -20 
		WHERE class = 'http://xmlns.com/foaf/0.1/Person'
			AND property = @PropertyURI
	END
	ELSE
	BEGIN
		UPDATE [Ontology.].[ClassProperty] set EditExistingSecurityGroup = -50, ViewSecurityGroup = -50,
			EditSecurityGroup = -50, EditPermissionsSecurityGroup = -50, -- was -20's
			EditAddNewSecurityGroup = -50, EditAddExistingSecurityGroup = -50, EditDeleteSecurityGroup = -50 
		WHERE class = 'http://xmlns.com/foaf/0.1/Person'
			AND property = @PropertyURI
	END


	IF EXISTS (SELECT 1 FROM [Profile.Module].[GenericRDF.Plugins] WHERE Name = @PluginName AND EnabledForGroup = 1)
	BEGIN

		SELECT @PropertyGroupURI=ISNULL(PropertyGroupURI, 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview'),
			@CustomDisplayModuleXML=ISNULL(CustomDisplayModuleXML, '<Module ID="' + CustomDisplayModule + '" />'),
			@CustomEditModuleXML=ISNULL(CustomEditModuleXML, '<Module ID="' + CustomEditModule + '" />'),
			@label = label
			FROM[Profile.Module].[GenericRDF.Plugins] WHERE Name = @PluginName AND EnabledForGroup = 1

		EXEC [Ontology.].[AddProperty]	@OWL = 'PLUGINS_1.0', 
									@PropertyURI = @PropertyURI,
									@PropertyName = @label,
									@ObjectType = 0,
									@PropertyGroupURI = @PropertyGroupURI, 
									@ClassURI = 'http://xmlns.com/foaf/0.1/Group',
									@IsDetail = 0,
									@IncludeDescription = 0


		UPDATE [Ontology.].[ClassProperty] set EditExistingSecurityGroup = -20, ViewSecurityGroup = -1,
			IsDetail = 0, IncludeDescription = 1, SearchWeight = 1,
			CustomEdit = 1, CustomEditModule = @CustomEditModuleXML,
			CustomDisplay = 1, CustomDisplayModule = @CustomDisplayModuleXML,
			EditSecurityGroup = -20, EditPermissionsSecurityGroup = -20, -- was -20's
			EditAddNewSecurityGroup = -20, EditAddExistingSecurityGroup = -20, EditDeleteSecurityGroup = -20 
		WHERE class = 'http://xmlns.com/foaf/0.1/Group'
			AND property = @PropertyURI
	END
	ELSE
	BEGIN
		UPDATE [Ontology.].[ClassProperty] set EditExistingSecurityGroup = -50, ViewSecurityGroup = -50,
			EditSecurityGroup = -50, EditPermissionsSecurityGroup = -50, -- was -20's
			EditAddNewSecurityGroup = -50, EditAddExistingSecurityGroup = -50, EditDeleteSecurityGroup = -50 
		WHERE class = 'http://xmlns.com/foaf/0.1/Group'
			AND property = @PropertyURI
	END
END
GO
