INSERT INTO [Ontology.].[Namespace] (URI, Prefix) 
	VALUES ('http://profiles.ucsf.edu/ontology/ucsf#', 'ucsf');	

-- DELETE FROM [Ontology.Import].owl where Name = 'UCSF_1.0';
	
EXEC [Framework.].[LoadXMLFile] @FilePath = 'D:\Shared\ProfilesRNS200\Data\UCSF_1.0.owl', @TableDestination = '[Ontology.Import].owl', @DestinationColumn = 'DATA', @NameValue = 'UCSF_1.0';

UPDATE [Ontology.Import].OWL SET Graph = 5 WHERE name = 'UCSF_1.0';

SELECT * FROM [Ontology.Import].[Triple] where OWL = 'UCSF_1.0';
SELECT * FROM [Ontology.].[ClassProperty] where Property like '%ucsf%';

EXEC [Ontology.Import].[ConvertOWL2Triple] @OWL = 'UCSF_1.0';
	
-- NO LONGER NEEDED as these are loaded from the OWL file
--INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
--	VALUES ('ucsf_1.0', 4, 'http://ucsf/ontology#fiscalYear', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', 'http://www.w3.org/2002/07/owl#DatatypeProperty');
--INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
--	VALUES ('ucsf_1.0', 4, 'http://ucsf/ontology#fiscalYear', 'http://www.w3.org/2000/01/rdf-schema#label', 'Fiscal Year');

EXEC [RDF.Stage].[LoadTriplesFromOntology] @Truncate = 1;
EXEC [RDF.Stage].[ProcessTriples];
EXEC [Ontology.].[UpdateDerivedFields];

INSERT INTO [Ontology.].[ClassGroupClass] (ClassGroupURI, ClassURI, SortOrder) 
	VALUES ('http://profiles.catalyst.harvard.edu/ontology/prns#ClassGroupResearch', 'http://vivoweb.org/ontology/core#Grant',2);

UPDATE [Ontology.].[ClassProperty] set EditExistingSecurityGroup = -40, IsDetail = 0, IncludeDescription = 1,
		CustomEdit = 1, CustomEditModule = NULL,
		CustomDisplay = 1, CustomDisplayModule = NULL,
		EditSecurityGroup = -20, EditPermissionsSecurityGroup = -20, -- was -20's
		EditAddNewSecurityGroup = -40, EditAddExistingSecurityGroup = -40, EditDeleteSecurityGroup = -40, 
		_PropertyLabel = 'Awarded Grants'
where property = 'http://vivoweb.org/ontology/core#hasPrincipalInvestigatorRole';

UPDATE [Ontology.].[ClassProperty] set IsDetail = 0
where Property = 'http://vivoweb.org/ontology/core#sponsorAwardId';

--DELETE FROM 

-- change search weight!!!
EXEC [Ontology.].[AddProperty]	@OWL = 'UCSF_1.0',
								@PropertyURI = 'http://profiles.ucsf.edu/ontology/ucsf#grantFiscalYear',
								@PropertyName = 'Fiscal Year',
								@ObjectType = 1,
								@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupIdentifiers',
								@ClassURI = 'http://vivoweb.org/ontology/core#Grant',
								@IsDetail = 0,
								@IncludeDescription = 0;

EXEC [Ontology.].[AddProperty]	@OWL = 'UCSF_1.0',
								@PropertyURI = 'http://profiles.ucsf.edu/ontology/ucsf#grantApplicationId',
								@PropertyName = 'Appliation ID',
								@ObjectType = 1,
								@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupIdentifiers',
								@ClassURI = 'http://vivoweb.org/ontology/core#Grant',
								@IsDetail = 0,
								@IncludeDescription = 0;								

-- see the changes
SELECT * FROM [Ontology.].PropertyGroupProperty where PropertyURI like '%ucsf%';

SELECT * FROM [Ontology.].[DataMap] where Property like '%ucsf%';
--DELETE FROM [Ontology.].[DataMap] where Property like '%ucsf%';
SELECT * FROM [Ontology.].[DataMap] where Class like '%#Grant%';
SELECT * FROM [Ontology.].[DataMap] where Property like '%hasPrincipalI%';
--DELETE FROM [Ontology.].[DataMap] where Property like '%hasPrincipalI%';
--DELETE FROM [Ontology.].[DataMap] where Class like '%#Grant%';

-- add the grant object to the data map			
INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1001, 1, 1, 1,
		'http://vivoweb.org/ontology/core#Grant', NULL, NULL,
		'[UCSF].[vwGrant]',
		'Grant', 'ApplicationId',
		NULL, NULL, NULL, NULL, NULL, NULL,
		0, 1, NULL, -1, -40);

-- add the properties of the grant
INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1002, 1, 1, 1,
		'http://vivoweb.org/ontology/core#Grant', NULL, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
		'[UCSF].[vwGrant]',
		'Grant', 'ApplicationId',
		NULL, NULL, NULL, '''http://vivoweb.org/ontology/core#Grant''', NULL, NULL,
		0, 1, NULL, -1, -40);

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1003, 1, 1, 1,
		'http://vivoweb.org/ontology/core#Grant', NULL, 'http://www.w3.org/2000/01/rdf-schema#label',
		'[UCSF].[vwGrant]',
		'Grant', 'ApplicationId',
		NULL, NULL, NULL, 'ProjectTitle', NULL, NULL,
		1, 1, NULL, -1, -40);
		
INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1004, 1, 1, 1,
		'http://vivoweb.org/ontology/core#Grant', NULL, 'http://vivoweb.org/ontology/core#sponsorAwardId',
		'[UCSF].[vwGrant]',
		'Grant', 'ApplicationId',
		NULL, NULL, NULL, 'FullProjectNum', NULL, NULL,
		1, 1, NULL, -1, -40);		

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1005, 1, 1, 1,
		'http://vivoweb.org/ontology/core#Grant', NULL, 'http://profiles.ucsf.edu/ontology/ucsf#grantFiscalYear',
		'[UCSF].[vwGrant]',
		'Grant', 'ApplicationId',
		NULL, NULL, NULL, 'FY', NULL, NULL,
		1, 1, NULL, -1, -40);		
		
INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1006, 1, 1, 1,
		'http://vivoweb.org/ontology/core#Grant', NULL, 'http://profiles.ucsf.edu/ontology/ucsf#grantApplicationId',
		'[UCSF].[vwGrant]',
		'Grant', 'ApplicationId',
		NULL, NULL, NULL, 'ApplicationId', NULL, NULL,
		1, 1, NULL, -1, -40);		
		

-- do more

-- Create triples that link people and grants.
-- Both of these properties use oClass/oInternalType/oInternalID for the object.
-- 
--	Seems that the link to grants is one way!!!!
--
--INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
--		Class, NetworkProperty, Property, 
--		MapTable, 
--		sInternalType, sInternalID, 
--		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
--		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
--	VALUES (1005, 1, 1, 1,
--		'http://vivoweb.org/ontology/core#Grant', NULL, 'http://myuniversity/ontology#drivenBy',
--		'[Profile.Data].[Car]',
--		'Car', 'CarID',
--		'http://xmlns.com/foaf/0.1/Person', 'Person', 'PersonID', NULL, NULL, NULL,
--		0, 1, NULL, -1, -40)

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1007, 1, 1, 1,
		'http://xmlns.com/foaf/0.1/Person', NULL, 'http://vivoweb.org/ontology/core#hasPrincipalInvestigatorRole',
		'[UCSF].[vwGrant]',
		'Person', 'PersonID',
		'http://vivoweb.org/ontology/core#Grant', 'Grant', 'ApplicationId', NULL, NULL, NULL,
		0, 1, NULL, -1, -40);
		
-- update DataMap
EXEC [Ontology.].[UpdateDerivedFields];

EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1001, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1002, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1003, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1004, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1005, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1006, @ShowCounts = 1	
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1007, @ShowCounts = 1	-- swapped out with old one, should delete old one first!	

-- test
DECLARE @PersonNodeID BIGINT
SELECT @PersonNodeID = NodeID
	FROM [RDF.Stage].[InternalNodeMap]
	WHERE Class = 'http://xmlns.com/foaf/0.1/Person' AND InternalType = 'Person' AND InternalID = '5506943'--'4951128'
EXEC [RDF.].[GetDataRDF] @subject = @PersonNodeID, @showDetails = 1, @expand = 1;

EXEC [Ontology.].[CleanUp] @Action = 'UpdateIDs';
-- then run CapitalizeCategories


UPDATE [Ontology.].[ClassProperty] set EditExistingSecurityGroup = -40, IsDetail = 0, IncludeDescription = 0,
		CustomEdit = 1, CustomEditModule = '<Module ID="EditOntologyGadget" >
        <ParamList>
          <Param Name="GadgetName">Awarded Grants</Param>
          <Param Name="View">home</Param>
          <Param Name="OptParams">{''gadget_class'':''ORNGToggleGadget'', ''start_closed'':0, ''closed_width'':700}</Param>
        </ParamList>
      </Module>',
		EditSecurityGroup = -20, EditPermissionsSecurityGroup = -40, -- was -20's
		EditAddNewSecurityGroup = -40, EditAddExistingSecurityGroup = -40, EditDeleteSecurityGroup = -40, 
		_PropertyLabel = 'Awarded Grants'
where 
property = 'http://vivoweb.org/ontology/core#hasPrincipalInvestigatorRole';
---- note, above stuff seems like it might be all wrong :)

UPDATE [Ontology.].[ClassProperty] set EditExistingSecurityGroup = -20, IsDetail = 0, IncludeDescription = 0,
		CustomDisplay = 1, CustomDisplayModule = null,
		 --'<Module ID="ViewOntologyGadget" >
   --     <ParamList>
   --       <Param Name="GadgetName">Awarded Grants</Param>
   --       <Param Name="View">profile</Param>
   --       <Param Name="OptParams">{}</Param>
   --     </ParamList>
   --   </Module>',
		CustomEdit = 1, CustomEditModule = '<Module ID="EditOntologyGadget" >
        <ParamList>
          <Param Name="GadgetName">Awarded Grants</Param>
          <Param Name="View">home</Param>
          <Param Name="OptParams">{}</Param>
        </ParamList>
      </Module>',
		EditSecurityGroup = -20, EditPermissionsSecurityGroup = -20, -- was -20's
		EditAddNewSecurityGroup = -20, EditAddExistingSecurityGroup = -20, EditDeleteSecurityGroup = -20, 
		_PropertyLabel = 'Awarded Grants Test'
where 
property = 'http://vivoweb.org/ontology/core#hasPrincipalInvestigatorRole';

