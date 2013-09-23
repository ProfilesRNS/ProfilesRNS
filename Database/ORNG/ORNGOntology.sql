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
-- Wire the person to the ApplicationInstance
-----------------------						
--
--  Instead do this as a custom property per each type of application, see AddAppToOntology
--		
--EXEC [Ontology.].[AddProperty]	@OWL = 'ORNG_1.0', 
--								@PropertyURI = 'http://orng.info/ontology/orng#hasApplicationInstance',
--								@PropertyName = 'has ORNG Application Instance',
--								@ObjectType = 0,
--								@PropertyGroupURI = 'http://orng.info/ontology/orng#PropertyGroupORNGApplications', 
--								@ClassURI = 'http://xmlns.com/foaf/0.1/Person',
--								@IsDetail = 0,
--								@IncludeDescription = 1								
--UPDATE [Ontology.].[ClassProperty] set EditExistingSecurityGroup = -20, IsDetail = 0, IncludeDescription = 1,
--		CustomEdit = 1, CustomEditModule = '<Module ID="EditOntologyGadgets">
--			<ParamList>
--			  <Param Name="ChromeId">gadgets-edit</Param>
--			</ParamList>
--		  </Module>',
--		CustomDisplay = 1, CustomDisplayModule = '<Module ID="ViewOntologyGadgets">
--			<ParamList>
--			  <Param Name="ChromeId">gadgets-view</Param>
--			</ParamList>
--		  </Module>',
--		EditSecurityGroup = -20, EditPermissionsSecurityGroup = -20, -- was -20's
--		EditAddNewSecurityGroup = -20, EditAddExistingSecurityGroup = -20, EditDeleteSecurityGroup = -20 
--where property = 'http://orng.info/ontology/orng#hasApplicationInstance';

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
								@PropertyURI = 'http://orng.info/ontology/orng#applicationDataValue',
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
-- each class is person with a gadget, so we need the id to be a concatenation of the personid 
-- and the appid.  One view joining apps, addregistry, appdata and person (by node id) should give 
-- us what we need.  Need to think about registry stuff, and need to think about non-person apps

--INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
--		Class, NetworkProperty, Property, 
--		MapTable, 
--		sInternalType, sInternalID, 
--		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
--		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
--	VALUES (1001, 1, 1, 1,
--		'http://orng.info/ontology/orng#Application', NULL, NULL,
--		'[ORNG.].[vwAppPerson]',
--		'ORNG Application', 'NodeIdAppId',
--		NULL, NULL, NULL, NULL, NULL, NULL,
--		0, 1, NULL, -1, -40);

--INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
--		Class, NetworkProperty, Property, 
--		MapTable, 
--		sInternalType, sInternalID, 
--		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
--		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
--	VALUES (1002, 1, 1, 1,
--		'http://orng.info/ontology/orng#Application', NULL, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
--		'[ORNG.].[vwAppPerson]',
--		'ORNG Application', 'NodeIdAppId',
--		NULL, NULL, NULL, '''http://orng.info/ontology/orng#Application''', NULL, NULL,
--		0, 1, NULL, -1, -40);
		
--INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
--		Class, NetworkProperty, Property, 
--		MapTable, 
--		sInternalType, sInternalID, 
--		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
--		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
--	VALUES (1003, 1, 1, 1,
--		'http://orng.info/ontology/orng#Application', NULL, 'http://www.w3.org/2000/01/rdf-schema#label',
--		'[ORNG.].[vwAppPerson]',
--		'ORNG Application', 'NodeIdAppId',
--		NULL, NULL, NULL, 'Label', NULL, NULL, -- should this include persons name? Yes!
--		1, 1, NULL, -1, -40);
		
--INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
--		Class, NetworkProperty, Property, 
--		MapTable, 
--		sInternalType, sInternalID, 
--		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
--		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
--	VALUES (1004, 1, 1, 1,
--		'http://orng.info/ontology/orng#Application', NULL, 'http://orng.info/ontology/orng#applicationId',
--		'[ORNG.].[vwAppPerson]',
--		'ORNG Application', 'NodeIdAppId',
--		NULL, NULL, NULL, 'appId', NULL, NULL,
--		1, 1, NULL, -1, -40);		

---- now wire into people and back
---- Do this Per Gadget!!
----INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
----		Class, NetworkProperty, Property, 
----		MapTable, 
----		sInternalType, sInternalID, 
----		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
----		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
----	VALUES (1005, 1, 1, 1,
----		'http://xmlns.com/foaf/0.1/Person', NULL, 'http://orng.info/ontology/orng#hasApplication',
----		'[ORNG.].[vwAppPerson]',
----		'Person', 'PersonID',
----		'http://orng.info/ontology/orng#Application', 'ORNG Application', 'NodeIdAppId', NULL, NULL, NULL,
----		0, 1, NULL, -1, -40);
		
--INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
--		Class, NetworkProperty, Property, 
--		MapTable, 
--		sInternalType, sInternalID, 
--		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
--		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
--	VALUES (1006, 1, 1, 1,
--		'http://orng.info/ontology/orng#Application', NULL, 'http://orng.info/ontology/orng#applicationForPerson',
--		'[ORNG.].[vwAppPerson]',
--		'ORNG Application', 'NodeIdAppId',
--		'http://xmlns.com/foaf/0.1/Person', 'Person', 'PersonID', NULL, NULL, NULL,
--		0, 1, NULL, -1, -40);

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

SELECT * FROM [Ontology.].[DataMap] where DataMapID >= 900;

--DELETE from [Ontology.].[DataMap] where DataMapID >= 900;
-- update DataMap
EXEC [Ontology.].UpdateDerivedFields;  
-- then run CapitalizeCategories

exec [ORNG.].[RemoveAppFromOntology] 103;
exec [ORNG.].[RemoveAppFromOntology] 114;
exec [ORNG.].[RemoveAppFromOntology] 115;
exec [ORNG.].[RemoveAppFromOntology] 101;
exec [ORNG.].[RemoveAppFromOntology] 102;
--exec [ORNG.].[RemoveAppFromOntology] 108;
exec [ORNG.].[RemoveAppFromOntology] 109;
exec [ORNG.].[RemoveAppFromOntology] 112;
exec [ORNG.].[RemoveAppFromOntology] 118;
exec [ORNG.].[RemoveAppFromOntology] 116;

exec [ORNG.].[AddAppToOntology] 103;
exec [ORNG.].[AddAppToOntology] 114;
exec [ORNG.].[AddAppToOntology] 115;
exec [ORNG.].[AddAppToOntology] 101;
exec [ORNG.].[AddAppToOntology] 102;
--exec [ORNG.].[AddAppToOntology] 108;
exec [ORNG.].[AddAppToOntology] 109;
exec [ORNG.].[AddAppToOntology] 112;
exec [ORNG.].[AddAppToOntology] 118;
exec [ORNG.].[AddAppToOntology] 116;

EXEC [Ontology.].[UpdateDerivedFields];

SELECT * from [ORNG.].AppViews where appId in (103, 114, 115, 101, 102, 109, 112, 118, 116);
DELETE from [ORNG.].AppViews where appId in (103, 114, 115, 101, 102, 109, 112, 118, 116);

-- run the following and execute the resulting sql
SELECT 'EXEC [ORNG.].[AddAppToPerson] @appId = ' + cast(appId as varchar) + ', @SubjectID = ' + cast(nodeId as varchar) + ';'
	FROM [ORNG.].[AppRegistry] WHERE visibility = 'Public' and appId in (103, 114, 115, 101, 102, 109, 112, 118, 116);	

-- test
-- Add and view Application
DECLARE @ApplicationNodeID BIGINT
EXEC [ORNG.].[AddAppToOntology] @appId = 103,  @NodeID = @ApplicationNodeID OUTPUT
--EXEC [ORNG.].RemoveAppFromOntology @appId = 103,  @NodeID = @ApplicationNodeID OUTPUT
SELECT @ApplicationNodeID; --14891931
EXEC [RDF.].[GetDataRDF] @subject = 14891931, @showDetails = 1, @expand = 1;

-- Associate person with Application Kirsten Bibbins-Domingo
DECLARE @ApplicationInstanceID BIGINT
EXEC [ORNG.].[AddAppToPerson] @appId = 103, @SubjectID = 370012, @NodeID = @ApplicationInstanceID OUTPUT
--EXEC [ORNG.].[RemoveAppFromPerson] @appId = 103, @SubjectID = 370012, @NodeID = @ApplicationInstanceID OUTPUT
SELECT @ApplicationInstanceID --14891932
EXEC [RDF.].[GetDataRDF] @subject = 14891944, @showDetails = 1, @expand = 1;
EXEC [RDF.].[GetDataRDF] @subject = 370012, @showDetails = 1, @expand = 1;

DECLARE @ApplicationInstanceID BIGINT --Eric Meeks
EXEC [ORNG.].[AddAppToPerson] @appId = 103, @SubjectID = 368698, @NodeID = @ApplicationInstanceID OUTPUT
--EXEC [ORNG.].[RemoveAppFromPerson] @appId = 103, @SubjectID = 368698, @NodeID = @ApplicationInstanceID OUTPUT
SELECT @ApplicationInstanceID --14891933
EXEC [RDF.].[GetDataRDF] @subject = 14891936, @showDetails = 1, @expand = 1;
EXEC [RDF.].[GetDataRDF] @subject = 368698, @showDetails = 1, @expand = 1;

DECLARE @PersonNodeID BIGINT
SELECT @PersonNodeID = NodeID
	FROM [RDF.Stage].[InternalNodeMap]
	WHERE Class = 'http://xmlns.com/foaf/0.1/Person' AND InternalType = 'Person' AND InternalID = '5138614'
EXEC [RDF.].[GetDataRDF] @subject = @PersonNodeID, @showDetails = 1, @expand = 1;

EXEC [RDF.].[GetDataRDF] @subject = 14874837, @showDetails = 1, @expand = 1;
EXEC [RDF.].DeleteNode @NodeID = 14874640, @DeleteType = 0

--EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1001, @ShowCounts = 1
--EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1002, @ShowCounts = 1
--EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1003, @ShowCounts = 1
--EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1004, @ShowCounts = 1
--EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1005, @ShowCounts = 1
--EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1006, @ShowCounts = 1		
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1007, @ShowCounts = 1		
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1008, @ShowCounts = 1		
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1009, @ShowCounts = 1		
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1010, @ShowCounts = 1		
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1011, @ShowCounts = 1		

--- THE FOLLOWING HAS NOT YET BEEN RUN!!!
EXEC [Ontology.].[CleanUp] @Action = 'UpdateIDs';


select * from [rdf.].Node where NodeID = 14843323;
select * from [rdf.].Triple where Subject = 14843323

select * from [rdf.].Triple t join [rdf.].Node n on t.Object = n.NodeID where t.Subject = 14891880;
--t.Predicate  in (14866933, 14866934, 14866925) ;

select * from [rdf.].Triple t join [rdf.].Node n on t.Object = n.NodeID where t.Subject in (14866933, 14866934, 14866925) 
or t.Predicate in (14866933, 14866934, 14866925) or t.Object in (14866933, 14866934, 14866925) ;

--- more fun
SELECT * from [Ontology.].[ClassProperty] where Property like '%orng%';
SELECT * from [Ontology.].[PropertyGroupProperty] where PropertyURI like '%orng%';
SELECT * from [Ontology.].[DataMap] where DataMapID  > 900;


--delete from [Ontology.].[ClassProperty] where Property like '%orng#%' and Class = 'http://xmlns.com/foaf/0.1/Person';
--delete from [Ontology.].[PropertyGroupProperty] where PropertyURI like '%orng%' and SortOrder > 4;
--delete from [Ontology.].[DataMap] where Property like '%orng#has%' and Class = 'http://xmlns.com/foaf/0.1/Person';

EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1012, @ShowCounts = 1	
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1013, @ShowCounts = 1	
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1014, @ShowCounts = 1	

