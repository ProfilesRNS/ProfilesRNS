INSERT INTO [Ontology.].[Namespace] (URI, Prefix) 
	VALUES ('http://orng.info/ontology/orng#', 'orng');
	
-- DELETE FROM [Ontology.Import].owl where Name = 'ORNG_1.0';
	
EXEC [Framework.].[LoadXMLFile] @FilePath = 'D:\Shared\ProfilesRNS200\Data\ORNG_1.0.owl', @TableDestination = '[Ontology.Import].owl', @DestinationColumn = 'DATA', @NameValue = 'ORNG_1.0';

UPDATE [Ontology.Import].OWL SET Graph = 4 WHERE name = 'ORNG_1.0';

EXEC [Ontology.Import].[ConvertOWL2Triple] @OWL = 'ORNG_1.0';
	
EXEC [RDF.Stage].[LoadTriplesFromOntology] @Truncate = 1;
EXEC [RDF.Stage].[ProcessTriples];
EXEC [Ontology.].[UpdateDerivedFields];

INSERT INTO [Ontology.].[ClassGroupClass] (ClassGroupURI, ClassURI, SortOrder) 
	VALUES ('http://profiles.catalyst.harvard.edu/ontology/prns#ORNGApplications', 'http://orng.info/ontology/orng#Application',1);
-- NEED TO ADD TO [Ontology.].[ClassGroup] as well!!!	

-- Add ClassPoperty for ORNGApplication 
INSERT INTO [Ontology.].[ClassProperty] (ClassPropertyID, 
		Class, NetworkProperty, Property, 
		IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, 
		CustomDisplay, CustomEdit, ViewSecurityGroup, 
		EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, 
		MinCardinality, MaxCardinality, 
		CustomDisplayModule, CustomEditModule)
	VALUES (9998,
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
	VALUES (9999,
			'http://orng.info/ontology/orng#ApplicationData', NULL, 'http://www.w3.org/2000/01/rdf-schema#label',
			0, NULL, 0, 0, 1,
			0, 0, -1,
			-40, -40, -40, -40, -40, -40,
			0, NULL,
			NULL, NULL);
-- DELETE FROM [Ontology.].[ClassProperty] WHERE ClassPropertyID in (9998, 9999);			
EXEC [Ontology.].[UpdateDerivedFields];

EXEC [Ontology.].[AddProperty]	@OWL = 'ORNG_1.0',
								@PropertyURI = 'http://orng.info/ontology/orng#applicationId',
								@PropertyName = 'ApplicationId',
								@ObjectType = 1,
								@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupIdentifiers',
								@ClassURI = 'http://orng.info/ontology/orng#Application',
								@IsDetail = 0,
								@IncludeDescription = 0
EXEC [Ontology.].[AddProperty]	@OWL = 'ORNG_1.0', 
								@PropertyURI = 'http://orng.info/ontology/orng#hasApplication',
								@PropertyName = 'has ORNG application',
								@ObjectType = 0,
								@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview', 
								@ClassURI = 'http://xmlns.com/foaf/0.1/Person',
								@IsDetail = 1,
								@IncludeDescription = 1
EXEC [Ontology.].[AddProperty]	@OWL = 'ORNG_1.0',
								@PropertyURI = 'http://orng.info/ontology/orng#applicationForPerson',
								@PropertyName = 'ORNG Application for person',
								@ObjectType = 0,
								@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview',
								@ClassURI = 'http://orng.info/ontology/orng#Application',
								@IsDetail = 0,
								@IncludeDescription = 1
-- Application Data
EXEC [Ontology.].[AddProperty]	@OWL = 'ORNG_1.0',
								@PropertyURI = 'http://orng.info/ontology/orng#applicationDataValue',
								@PropertyName = 'ORNG ApplicationData value',
								@ObjectType = 1,
								@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupIdentifiers',
								@ClassURI = 'http://orng.info/ontology/orng#ApplicationData',
								@IsDetail = 0,
								@IncludeDescription = 0
EXEC [Ontology.].[AddProperty]	@OWL = 'ORNG_1.0', 
								@PropertyURI = 'http://orng.info/ontology/orng#hasApplicationData',
								@PropertyName = 'has ORNG ApplicationData',
								@ObjectType = 0,
								@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview', 
								@ClassURI = 'http://orng.info/ontology/orng#Application',
								@IsDetail = 1,
								@IncludeDescription = 1

ALTER VIEW [ORNG.].[vwAppPerson] as
	SELECT cast(m.NodeID as varchar) + '-' + CAST(a.appid as varchar) NodeIdAppId, 
	 a.Name + ' for ' + p.DisplayName Label, m.InternalID PersonId, a.appId,
	 a.name AppName, a.url AppUrl, r.visibility FROM [ORNG.].[Apps] a join [ORNG.].AppRegistry r on a.appId = r.appId join
	[RDF.Stage].InternalNodeMap m on r.nodeid = m.NodeID join [Profile.Data].Person p on p.PersonID = cast(m.InternalID as int);
	
select * from [orng.].[vwAppPerson];

ALTER VIEW [ORNG.].[vwAppPersonData] as
	SELECT cast(m.NodeID as varchar) + '-' + CAST(a.appid as varchar) + '-' + d.keyname PrimaryId, 
	 cast(m.NodeID as varchar) + '-' + CAST(a.appid as varchar)NodeIdAppId,
	 m.InternalID PersonId, a.appId,
	 a.name AppName, d.keyname, d.value FROM [ORNG.].[Apps] a 
	 join [ORNG.].AppData d on a.appId = d.appId 
	 join [RDF.Stage].InternalNodeMap m on d.nodeid = m.NodeID;

select top 100 * from [orng.].[vwAppPersonData];

-- next we need to run EXEC [Ontology.].[AddProperty]	for all the properties, be mindful of ObjectType!!

-- STOP
-- each class is person with a gadget, so we need the id to be a concatenation of the personid 
-- and the appid.  One view joining apps, addregistry, appdata and person (by node id) should give 
-- us what we need.  Need to think about registry stuff, and need to think about non-person apps

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1001, 1, 1, 1,
		'http://orng.info/ontology/orng#Application', NULL, NULL,
		'[ORNG.].[vwAppPerson]',
		'ORNG Application', 'NodeIdAppId',
		NULL, NULL, NULL, NULL, NULL, NULL,
		0, 1, NULL, -1, -40);

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1002, 1, 1, 1,
		'http://orng.info/ontology/orng#Application', NULL, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
		'[ORNG.].[vwAppPerson]',
		'ORNG Application', 'NodeIdAppId',
		NULL, NULL, NULL, '''http://orng.info/ontology/orng#Application''', NULL, NULL,
		0, 1, NULL, -1, -40);
		
INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1003, 1, 1, 1,
		'http://orng.info/ontology/orng#Application', NULL, 'http://www.w3.org/2000/01/rdf-schema#label',
		'[ORNG.].[vwAppPerson]',
		'ORNG Application', 'NodeIdAppId',
		NULL, NULL, NULL, 'Label', NULL, NULL, -- should this include persons name? Yes!
		1, 1, NULL, -1, -40);
		
INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1004, 1, 1, 1,
		'http://orng.info/ontology/orng#Application', NULL, 'http://orng.info/ontology/orng#applicationId',
		'[ORNG.].[vwAppPerson]',
		'ORNG Application', 'NodeIdAppId',
		NULL, NULL, NULL, 'appId', NULL, NULL,
		1, 1, NULL, -1, -40);		

-- now wire into people and back
INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1005, 1, 1, 1,
		'http://xmlns.com/foaf/0.1/Person', NULL, 'http://orng.info/ontology/orng#hasApplication',
		'[ORNG.].[vwAppPerson]',
		'Person', 'PersonID',
		'http://orng.info/ontology/orng#Application', 'ORNG Application', 'NodeIdAppId', NULL, NULL, NULL,
		0, 1, NULL, -1, -40);
		
INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1006, 1, 1, 1,
		'http://orng.info/ontology/orng#Application', NULL, 'http://orng.info/ontology/orng#applicationForPerson',
		'[ORNG.].[vwAppPerson]',
		'ORNG Application', 'NodeIdAppId',
		'http://xmlns.com/foaf/0.1/Person', 'Person', 'PersonID', NULL, NULL, NULL,
		0, 1, NULL, -1, -40);

--- AppData

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1007, 1, 1, 1,
		'http://orng.info/ontology/orng#ApplicationData', NULL, NULL,
		'[ORNG.].[vwAppPersonData]',
		'ORNG ApplicationData', 'PrimaryId',
		NULL, NULL, NULL, NULL, NULL, NULL,
		0, 1, NULL, -1, -40);

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1008, 1, 1, 1,
		'http://orng.info/ontology/orng#ApplicationData', NULL, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
		'[ORNG.].[vwAppPersonData]',
		'ORNG ApplicationData', 'PrimaryId',
		NULL, NULL, NULL, '''http://orng.info/ontology/orng#ApplicationData''', NULL, NULL,
		0, 1, NULL, -1, -40);

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1009, 1, 1, 1,
		'http://orng.info/ontology/orng#ApplicationData', NULL, 'http://www.w3.org/2000/01/rdf-schema#label',
		'[ORNG.].[vwAppPersonData]',
		'ORNG ApplicationData', 'PrimaryId',
		NULL, NULL, NULL, 'keyname', NULL, NULL, -- should this include persons name? Yes!
		1, 1, NULL, -1, -40);
		
INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1010, 1, 1, 1,
		'http://orng.info/ontology/orng#ApplicationData', NULL, 'http://orng.info/ontology/orng#applicationDataValue',
		'[ORNG.].[vwAppPersonData]',
		'ORNG ApplicationData', 'PrimaryId',
		NULL, NULL, NULL, 'value', NULL, NULL,
		1, 1, NULL, -1, -40);		

-- now wire into Application and back
INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1011, 1, 1, 1,
		'http://orng.info/ontology/orng#Application', NULL, 'http://orng.info/ontology/orng#hasApplicationData',
		'[ORNG.].[vwAppPersonData]',
		'ORNG Application', 'NodeIdAppId',
		'http://orng.info/ontology/orng#ApplicationData', 'ORNG ApplicationData', 'PrimaryId', NULL, NULL, NULL,
		0, 1, NULL, -1, -40);

--delete from [Ontology.].[DataMap] where DataMapID = 1011
-- update DataMap
EXEC [Ontology.].UpdateDerivedFields;  
-- then run CapitalizeCategories

EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1001, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1002, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1003, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1004, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1005, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1006, @ShowCounts = 1		
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1007, @ShowCounts = 1		
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1008, @ShowCounts = 1		
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1009, @ShowCounts = 1		
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1010, @ShowCounts = 1		
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1011, @ShowCounts = 1		

-- test
DECLARE @PersonNodeID BIGINT
SELECT @PersonNodeID = NodeID
	FROM [RDF.Stage].[InternalNodeMap]
	WHERE Class = 'http://xmlns.com/foaf/0.1/Person' AND InternalType = 'Person' AND InternalID = '5279558'
EXEC [RDF.].[GetDataRDF] @subject = @PersonNodeID, @showDetails = 1, @expand = 1;

EXEC [RDF.].[GetDataRDF] @subject = 14843292, @showDetails = 1, @expand = 1;

EXEC [RDF.].[GetDataRDF] @subject = 14843323, @showDetails = 1, @expand = 1;

--- THE FOLLOWING HAS NOT YET BEEN RUN!!!
EXEC [Ontology.].[CleanUp] @Action = 'UpdateIDs';


select * from [rdf.].Node where NodeID = 14843323;
select * from [rdf.].Triple where Subject = 14843323

select * from [rdf.].Triple t join [rdf.].Node n on t.Object = n.NodeID where t.Subject = 14843323--14843292
