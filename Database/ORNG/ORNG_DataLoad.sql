INSERT INTO [Ontology.].[Namespace] (URI, Prefix) 
	VALUES ('http://orng.info/ontology/orng#', 'orng');
	
-- DELETE FROM [Ontology.Import].owl where Name = 'ORNG_1.0';
	
EXEC [Framework.].[LoadXMLFile] @FilePath = 'D:\Shared\ProfilesRNS200\Data\ORNG_1.0.owl', @TableDestination = '[Ontology.Import].owl', @DestinationColumn = 'DATA', @NameValue = 'ORNG_1.0';

UPDATE [Ontology.Import].OWL SET Graph = 4 WHERE name = 'ORNG_1.0';

EXEC [Ontology.Import].[ConvertOWL2Triple] @OWL = 'ORNG_1.0';
	
EXEC [RDF.Stage].[LoadTriplesFromOntology] @Truncate = 1;
EXEC [RDF.Stage].[ProcessTriples];

INSERT INTO [Ontology.].[ClassGroup] (ClassGroupURI, SortOrder, IsVisible) 
	VALUES ('http://orng.info/ontology/orng#ClassGroupORNGApplications', 7, 1);

INSERT INTO [Ontology.].[ClassGroupClass] (ClassGroupURI, ClassURI, SortOrder) 
	VALUES ('http://orng.info/ontology/orng#ClassGroupORNGApplications', 'http://orng.info/ontology/orng#Application',1);

INSERT INTO [Ontology.].[PropertyGroup] (PropertyGroupURI, SortOrder) 
	VALUES ('http://orng.info/ontology/orng#PropertyGroupORNGApplications', 17); -- move this to be #11, after PropertyGroupOutreach

EXEC [Ontology.].[UpdateDerivedFields];

--SELECT * FROM [Ontology.].[ClassProperty] where Class like '%orng%' or Property like '%orng%';
--DELETE FROM [Ontology.].[ClassProperty] where Class like '%orng%' or Property like '%orng%';
--SELECT * FROM [Ontology.].[PropertyGroupProperty] where PropertyURI like '%orng%';
--DELETE FROM [Ontology.].[PropertyGroupProperty] where PropertyURI like '%orng%';

-- Add ClassPoperty for ORNGApplication 
INSERT INTO [Ontology.].[ClassProperty] (ClassPropertyID, 
		Class, NetworkProperty, Property, 
		IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, 
		CustomDisplay, CustomEdit, ViewSecurityGroup, 
		EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, 
		MinCardinality, MaxCardinality, 
		CustomDisplayModule, CustomEditModule)
	VALUES (9997,
			'http://orng.info/ontology/orng#Application', NULL, 'http://www.w3.org/2000/01/rdf-schema#label',
			0, NULL, 0, 0, 1,
			0, 0, -1,
			-40, -40, -40, -40, -40, -40,
			0, NULL,
			NULL, NULL);

INSERT INTO [Ontology.].[ClassProperty] (ClassPropertyID, 
		Class, NetworkProperty, Property, 
		IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, 
		CustomDisplay, CustomEdit, ViewSecurityGroup, 
		EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, 
		MinCardinality, MaxCardinality, 
		CustomDisplayModule, CustomEditModule)
	VALUES (9998,
			'http://orng.info/ontology/orng#ApplicationInstance', NULL, 'http://www.w3.org/2000/01/rdf-schema#label',
			0, NULL, 0, 0, 1,
			0, 0, -1,
			-40, -40, -40, -40, -40, -40,
			0, NULL,
			NULL, NULL);
			
INSERT INTO [Ontology.].[ClassProperty] (ClassPropertyID, 
		Class, NetworkProperty, Property, 
		IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, 
		CustomDisplay, CustomEdit, ViewSecurityGroup, 
		EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, 
		MinCardinality, MaxCardinality, 
		CustomDisplayModule, CustomEditModule)
	VALUES (9999,
			'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, 'http://www.w3.org/2000/01/rdf-schema#label',
			0, NULL, 0, 0, 1,
			0, 0, -1,
			-40, -40, -40, -40, -40, -40,
			0, NULL,
			NULL, NULL);
-----
EXEC [Ontology.].[UpdateDerivedFields];
-----
EXEC [Ontology.].[AddProperty]	@OWL = 'ORNG_1.0',
								@PropertyURI = 'http://orng.info/ontology/orng#applicationId',
								@PropertyName = 'ORNG Application Id',
								@ObjectType = 1,
								@PropertyGroupURI = 'http://orng.info/ontology/orng#PropertyGroupORNGApplications',
								@ClassURI = 'http://orng.info/ontology/orng#Application',
								@IsDetail = 0,
								@IncludeDescription = 0
								
EXEC [Ontology.].[AddProperty]	@OWL = 'ORNG_1.0',
								@PropertyURI = 'http://orng.info/ontology/orng#applicationURL',
								@PropertyName = 'ORNG Application URL',
								@ObjectType = 1,
								@PropertyGroupURI = 'http://orng.info/ontology/orng#PropertyGroupORNGApplications',
								@ClassURI = 'http://orng.info/ontology/orng#Application',
								@IsDetail = 0,
								@IncludeDescription = 0

-----------------------
-- Wire the ApplicationInstance to the Application
-----------------------								
EXEC [Ontology.].[AddProperty]	@OWL = 'ORNG_1.0', 
								@PropertyURI = 'http://orng.info/ontology/orng#applicationInstanceOfApplication',
								@PropertyName = 'ORNG Application Instance of Application',
								@ObjectType = 0,
								@PropertyGroupURI = 'http://orng.info/ontology/orng#PropertyGroupORNGApplications', 
								@ClassURI = 'http://orng.info/ontology/orng#ApplicationInstance',
								@IsDetail = 0,
								@IncludeDescription = 1	
-----------------------
-- Wire the ApplicationInstance to Person, reverse will be custom per app
-----------------------						
EXEC [Ontology.].[AddProperty]	@OWL = 'ORNG_1.0',
								@PropertyURI = 'http://orng.info/ontology/orng#applicationInstanceForPerson',
								@PropertyName = 'ORNG Application Instance for Person',
								@ObjectType = 0,
								@PropertyGroupURI = 'http://orng.info/ontology/orng#PropertyGroupORNGApplications',
								@ClassURI = 'http://orng.info/ontology/orng#ApplicationInstance',
								@IsDetail = 0,
								@IncludeDescription = 0
 --Application Data
EXEC [Ontology.].[AddProperty]	@OWL = 'ORNG_1.0',
								@PropertyURI = 'http://orng.info/ontology/orng#applicationInstanceDataValue',
								@PropertyName = 'ORNG Application Instance Data value',
								@ObjectType = 1,
								@PropertyGroupURI = 'http://orng.info/ontology/orng#PropertyGroupORNGApplications',
								@ClassURI = 'http://orng.info/ontology/orng#ApplicationInstanceData',
								@IsDetail = 0,
								@IncludeDescription = 0
								
EXEC [Ontology.].[AddProperty]	@OWL = 'ORNG_1.0', 
								@PropertyURI = 'http://orng.info/ontology/orng#hasApplicationInstanceData',
								@PropertyName = 'has ORNG Application Instance Data',
								@ObjectType = 0,
								@PropertyGroupURI = 'http://orng.info/ontology/orng#PropertyGroupORNGApplications', 
								@ClassURI = 'http://orng.info/ontology/orng#ApplicationInstance',
								@IsDetail = 0,
								@IncludeDescription = 1

EXEC [Ontology.].[UpdateDerivedFields];

--- AppData

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1007, 1, 1, 1,
		'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, NULL,
		'[ORNG.].[vwAppPersonData]',
		'ORNG Application Instance Data', 'PrimaryId',
		NULL, NULL, NULL, NULL, NULL, NULL,
		0, 1, NULL, -1, -40);

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1008, 1, 1, 1,
		'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
		'[ORNG.].[vwAppPersonData]',
		'ORNG Application Instance Data', 'PrimaryId',
		NULL, NULL, NULL, '''http://orng.info/ontology/orng#ApplicationInstanceData''', NULL, NULL,
		0, 1, NULL, -1, -40);

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1009, 1, 1, 1,
		'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, 'http://www.w3.org/2000/01/rdf-schema#label',
		'[ORNG.].[vwAppPersonData]',
		'ORNG Application Instance Data', 'PrimaryId',
		NULL, NULL, NULL, 'keyname', NULL, NULL, -- should this include persons name? Yes!
		1, 1, NULL, -1, -40);
		
INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1010, 1, 1, 1,
		'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, 'http://orng.info/ontology/orng#applicationInstanceDataValue',
		'[ORNG.].[vwAppPersonData]',
		'ORNG Application Instance Data', 'PrimaryId',
		NULL, NULL, NULL, 'value', NULL, NULL,
		1, 1, NULL, -1, -40);		

-- now wire into Application 
INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1011, 1, 1, 1,
		'http://orng.info/ontology/orng#ApplicationInstance', NULL, 'http://orng.info/ontology/orng#hasApplicationInstanceData',
		'[ORNG.].[vwAppPersonData]',
		'ORNG Application Instance', 'PersonIdAppId',
		'http://orng.info/ontology/orng#ApplicationInstanceData', 'ORNG Application Instance Data', 'PrimaryId', NULL, NULL, NULL,
		0, 1, NULL, -1, -40);

--SELECT * FROM [Ontology.].[DataMap] where DataMapID >= 900;

--DELETE from [Ontology.].[DataMap] where DataMapID >= 900;
-- update DataMap
EXEC [Ontology.].UpdateDerivedFields;  
-- then run CapitalizeCategories

--- THE FOLLOWING HAS NOT YET BEEN RUN!!!
EXEC [Ontology.].[CleanUp] @Action = 'UpdateIDs';


