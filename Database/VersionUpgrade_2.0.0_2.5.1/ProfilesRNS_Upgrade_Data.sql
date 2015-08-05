/*

Run this script on:

	Profiles RNS Version 2.0.0

to update its data to:

	Profiles RNS Version 2.5.1

*** You are recommended to back up your database before running this script!

*** This script will delete any customizations made to [Framework.].Job
*** If you added additional steps to [Framework.].Job you will need to manually merge these changes.

*** This script will make changes to OpenSocial application URLs, to hit versions compatible with the latest version of ShindigOrng, If you are hosting the OpenSocial xml locally, you will need to update this XML.

*** You should review each step of this script to ensure that it will not overwrite any customizations you have made to ProfilesRNS.

*** Make sure you run the ProfilesRNS_Upgrade_Schema.sql file before running this file.

*** Modify lines 25, 26, and 27, replace $(ProfilesRNSRootPath)\Data with the location that contains the various XML files that came with Profiles RNS 2.5.1 (not an older version of that file). These file has to be on the database server, not your local machine.
 
*/




--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
--*****
--***** Load new ontology and install data files
--*****
--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************

EXEC [Framework.].[LoadXMLFile] @FilePath = '$(ProfilesRNSRootPath)\Data\PRNS_1.1.owl', @TableDestination = '[Ontology.Import].owl', @DestinationColumn = 'DATA', @NameValue = 'PRNS_1.1'
EXEC [Framework.].[LoadXMLFile] @FilePath = '$(ProfilesRNSRootPath)\Data\ORNG_1.0.owl', @TableDestination = '[Ontology.Import].owl', @DestinationColumn = 'DATA', @NameValue = 'ORNG_1.0';
EXEC [Framework.].[LoadXMLFile] @FilePath = '$(ProfilesRNSRootPath)\Data\InstallData.xml', @TableDestination = '[Framework.].[InstallData]', @DestinationColumn = 'DATA'

-- Import the Updated PRNS and new ORNG ontology into Profiles. This should not eliminate any customizations unless additional 
-- classes have been added to the PRNS ontology
UPDATE [Ontology.Import].OWL SET Graph = 3 WHERE name = 'PRNS_1.1'
EXEC [Ontology.Import].[ConvertOWL2Triple] @OWL = 'PRNS_1.1'
UPDATE [Ontology.Import].OWL SET Graph = 4 WHERE name = 'ORNG_1.0'
EXEC [Ontology.Import].[ConvertOWL2Triple] @OWL = 'ORNG_1.0'

EXEC [RDF.Stage].[LoadTriplesFromOntology] @Truncate = 1
EXEC [RDF.Stage].[ProcessTriples]





--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
--*****
--***** Add two new steps to the nightly and weekly jobs
--*****
--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************

UPDATE [Framework.].[Job]
	SET Step = Step + 1
	WHERE JobGroup = 3 AND Step >= 2

INSERT INTO [Framework.].[Job] (JobID, JobGroup, Step, IsActive, Script)
	SELECT MAX(JobID)+1, 3, 2, 1, 'EXEC [RDF.SemWeb].[UpdateHash2Base64]'
	FROM [Framework.].[Job]

INSERT INTO [Framework.].[Job] (JobID, JobGroup, Step, IsActive, Script)
	SELECT MAX(JobID)+1, 7, 
		(SELECT MAX(Step)+1 FROM [Framework.].[Job] WHERE JobGroup = 7), 
		1, 'EXEC [User.Session].[DeleteOldSessionRDF]'
	FROM [Framework.].[Job]






--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
--*****
--***** Update ORNG from 2.0.0 to 2.5.1
--*****
--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************


---------------------------------------------------------------
-- There are significant changes to ORNG in 2.5.1, If you have altered your ORNG installation from the default installation with v2.0.0
-- you will need to ensure that the changes you have made will continue to work. 
-- If you are hosting the default open social applications locally you will need to update the XML to the latest XML
-- or change to URLs to use the XML hosted at http://profiles.ucsf.edu/apps_2.1/
--
-- If you have additional gadgets you will need to test them with the latest version of ShindigOrng.war. You will also need to add them to
-- the gadget ontology, this is described in the ORNG install guide.
--
-- You should run this section of code even if you are not using ORNG. 
-- in version 2.5.1, ORNG schema objects, and ontology objects are loaded into the database by default, but security groups
-- are used to keep them hidden until ORNG is enabled.
---------------------------------------------------------------


---------------------------------------------------------------
-- Add ORNG ontology items
---------------------------------------------------------------

 
--[Ontology.].[ClassGroup] 
-- Add the ORNG Applications class group. This should not affect any existing customizations.
Declare @so int
select @so = MAX(SortOrder)+1 from [Ontology.].[ClassGroup]
insert into [Ontology.].[ClassGroup] (ClassGroupURI, SortOrder, _ClassGroupLabel, IsVisible)
Values('http://orng.info/ontology/orng#ClassGroupORNGApplications', @so, 'ORNG Applications', 1)

--[Ontology.].[ClassGroupClass]
-- Add the ORNG Applications class group class. This should not affect any existing customizations.
insert into [Ontology.].[ClassGroupClass] (ClassGroupURI, ClassURI, SortOrder, _ClassLabel)
values('http://orng.info/ontology/orng#ClassGroupORNGApplications', 'http://orng.info/ontology/orng#Application', 1, 'ORNG Application')
  
--[Ontology.].[ClassProperty]
-- Add ORNG properties to the ClassProperty Table. This should not affect any existing customizations
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1001, N'http://orng.info/ontology/orng#Application', NULL, N'http://orng.info/ontology/orng#applicationId', 0, NULL, 0, 0, 0.5, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1002, N'http://orng.info/ontology/orng#Application', NULL, N'http://orng.info/ontology/orng#applicationURL', 0, NULL, 0, 0, 0.5, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1003, N'http://orng.info/ontology/orng#Application', NULL, N'http://www.w3.org/2000/01/rdf-schema#label', 0, NULL, 0, 0, 1, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1004, N'http://orng.info/ontology/orng#ApplicationInstance', NULL, N'http://orng.info/ontology/orng#applicationInstanceForPerson', 0, NULL, 0, 0, 0, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1005, N'http://orng.info/ontology/orng#ApplicationInstance', NULL, N'http://orng.info/ontology/orng#applicationInstanceOfApplication', 0, NULL, 1, 0, 0, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1006, N'http://orng.info/ontology/orng#ApplicationInstance', NULL, N'http://orng.info/ontology/orng#hasApplicationInstanceData', 0, NULL, 1, 0, 0, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1007, N'http://orng.info/ontology/orng#ApplicationInstance', NULL, N'http://www.w3.org/2000/01/rdf-schema#label', 0, NULL, 0, 0, 1, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1008, N'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, N'http://orng.info/ontology/orng#applicationInstanceDataValue', 0, NULL, 0, 0, 0.5, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1009, N'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, N'http://www.w3.org/2000/01/rdf-schema#label', 0, NULL, 0, 0, 1, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule], [_ClassNode], [_NetworkPropertyNode], [_PropertyNode], [_TagName], [_PropertyLabel], [_ObjectType], [_NumberOfNodes], [_NumberOfTriples]) VALUES (1010, N'http://xmlns.com/foaf/0.1/Person', NULL, N'http://orng.info/ontology/orng#hasLinks', 0, NULL, 0, 0, 0, 1, 1, -50, -50, -50, -50, -50, -50, -50, 0, NULL, N'<Module ID="ViewPersonalGadget"><ParamList><Param Name="AppId">103</Param><Param Name="Label">Websites</Param><Param Name="View">profile</Param><Param Name="OptParams">{''hide_titlebar'':1}</Param></ParamList></Module>', N'<Module ID="EditPersonalGadget"><ParamList><Param Name="AppId">103</Param><Param Name="Label">Websites</Param><Param Name="View">home</Param><Param Name="OptParams">{''hide_titlebar'':1}</Param></ParamList></Module>', 84, NULL, 51, N'orng:hasLinks', N'Websites', 0, 0, 0)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule], [_ClassNode], [_NetworkPropertyNode], [_PropertyNode], [_TagName], [_PropertyLabel], [_ObjectType], [_NumberOfNodes], [_NumberOfTriples]) VALUES (1011, N'http://xmlns.com/foaf/0.1/Person', NULL, N'http://orng.info/ontology/orng#hasSlideShare', 0, NULL, 0, 0, 0, 1, 1, -50, -50, -50, -50, -50, -50, -50, 0, NULL, N'<Module ID="ViewPersonalGadget"><ParamList><Param Name="AppId">101</Param><Param Name="Label">Featured Presentations</Param><Param Name="View">profile</Param><Param Name="OptParams">{''hide_titlebar'':1}</Param></ParamList></Module>', N'<Module ID="EditPersonalGadget"><ParamList><Param Name="AppId">101</Param><Param Name="Label">Featured Presentations</Param><Param Name="View">home</Param><Param Name="OptParams">{''hide_titlebar'':1}</Param></ParamList></Module>', 84, NULL, 53, N'orng:hasSlideShare', N'Featured Presentations', 0, 0, 0)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule], [_ClassNode], [_NetworkPropertyNode], [_PropertyNode], [_TagName], [_PropertyLabel], [_ObjectType], [_NumberOfNodes], [_NumberOfTriples]) VALUES (1012, N'http://xmlns.com/foaf/0.1/Person', NULL, N'http://orng.info/ontology/orng#hasTwitter', 0, NULL, 0, 0, 0, 1, 1, -50, -50, -50, -50, -50, -50, -50, 0, NULL, N'<Module ID="ViewPersonalGadget"><ParamList><Param Name="AppId">112</Param><Param Name="Label">Twitter</Param><Param Name="View">profile</Param><Param Name="OptParams">{''hide_titlebar'':1}</Param></ParamList></Module>', N'<Module ID="EditPersonalGadget"><ParamList><Param Name="AppId">112</Param><Param Name="Label">Twitter</Param><Param Name="View">home</Param><Param Name="OptParams">{''hide_titlebar'':1}</Param></ParamList></Module>', 84, NULL, 55, N'orng:hasTwitter', N'Twitter', 0, 0, 0)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule], [_ClassNode], [_NetworkPropertyNode], [_PropertyNode], [_TagName], [_PropertyLabel], [_ObjectType], [_NumberOfNodes], [_NumberOfTriples]) VALUES (1013, N'http://xmlns.com/foaf/0.1/Person', NULL, N'http://orng.info/ontology/orng#hasYouTube', 0, NULL, 0, 0, 0, 1, 1, -50, -50, -50, -50, -50, -50, -50, 0, NULL, N'<Module ID="ViewPersonalGadget"><ParamList><Param Name="AppId">114</Param><Param Name="Label">Featured Videos</Param><Param Name="View">profile</Param><Param Name="OptParams">{''hide_titlebar'':1}</Param></ParamList></Module>', N'<Module ID="EditPersonalGadget"><ParamList><Param Name="AppId">114</Param><Param Name="Label">Featured Videos</Param><Param Name="View">home</Param><Param Name="OptParams">{''hide_titlebar'':1}</Param></ParamList></Module>', 84, NULL, 57, N'orng:hasYouTube', N'Featured Videos', 0, 0, 0)


-- Add ORNG steps to the DataMap. This should not affect any existing customizations
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup]) VALUES (1022, 1, 1, 1, N'http://orng.info/ontology/orng#ApplicationInstance', NULL, N'http://orng.info/ontology/orng#hasApplicationInstanceData', N'[ORNG.].[vwAppPersonData]', N'ORNG Application Instance', N'PersonIdAppId', NULL, NULL, NULL, N'http://orng.info/ontology/orng#ApplicationInstanceData', N'ORNG Application Instance Data', N'PrimaryId', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'1', NULL, N'-1', N'-40')
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup]) VALUES (1025, 1, 1, 1, N'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, N'http://orng.info/ontology/orng#applicationInstanceDataValue', N'[ORNG.].[vwAppPersonData]', N'ORNG Application Instance Data', N'PrimaryId', NULL, NULL, NULL, NULL, NULL, NULL, N'value', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'1', NULL, N'-1', N'-40')
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup]) VALUES (1023, 1, 1, 1, N'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, N'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', N'[ORNG.].[vwAppPersonData]', N'ORNG Application Instance Data', N'PrimaryId', NULL, NULL, NULL, NULL, NULL, NULL, N'''http://orng.info/ontology/orng#ApplicationInstanceData''', NULL, NULL, NULL, NULL, NULL, NULL, 0, N'1', NULL, N'-1', N'-40')
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup]) VALUES (1024, 1, 1, 1, N'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, N'http://www.w3.org/2000/01/rdf-schema#label', N'[ORNG.].[vwAppPersonData]', N'ORNG Application Instance Data', N'PrimaryId', NULL, NULL, NULL, NULL, NULL, NULL, N'keyname', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'1', NULL, N'-1', N'-40')
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup], [_ClassNode], [_NetworkPropertyNode], [_PropertyNode]) VALUES (1030, 1, 1, 1, N'http://orng.info/ontology/orng#Application', NULL, NULL, N'[ORNG.].Apps', N'ORNG Application', N'REPLACE(RTRIM(RIGHT(url, CHARINDEX(''/'', REVERSE(url)) - 1)), ''.xml'', '''')', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'1', NULL, N'-1', N'-40', 25, NULL, NULL)
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup], [_ClassNode], [_NetworkPropertyNode], [_PropertyNode]) VALUES (1026, 1, 1, 1, N'http://orng.info/ontology/orng#Application', NULL, N'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', N'[ORNG.].Apps', N'ORNG Application', N'REPLACE(RTRIM(RIGHT(url, CHARINDEX(''/'', REVERSE(url)) - 1)), ''.xml'', '''')', NULL, NULL, NULL, NULL, NULL, NULL, N'''http://orng.info/ontology/orng#Application''', NULL, NULL, NULL, NULL, NULL, NULL, 0, N'1', NULL, N'-1', N'-40', 25, NULL, 14)
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup], [_ClassNode], [_NetworkPropertyNode], [_PropertyNode]) VALUES (1027, 1, 1, 1, N'http://orng.info/ontology/orng#Application', NULL, N'http://www.w3.org/2000/01/rdf-schema#label', N'[ORNG.].Apps', N'ORNG Application', N'REPLACE(RTRIM(RIGHT(url, CHARINDEX(''/'', REVERSE(url)) - 1)), ''.xml'', '''')', NULL, NULL, NULL, NULL, NULL, NULL, N'REPLACE(RTRIM(RIGHT(url, CHARINDEX(''/'', REVERSE(url)) - 1)), ''.xml'', '''')', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'1', NULL, N'-1', N'-40', 25, NULL, 15)
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup], [_ClassNode], [_NetworkPropertyNode], [_PropertyNode]) VALUES (1028, 1, 1, 1, N'http://orng.info/ontology/orng#Application', NULL, N'http://orng.info/ontology/orng#applicationId', N'[ORNG.].Apps', N'ORNG Application', N'REPLACE(RTRIM(RIGHT(url, CHARINDEX(''/'', REVERSE(url)) - 1)), ''.xml'', '''')', NULL, NULL, NULL, NULL, NULL, NULL, N'AppID', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'1', NULL, N'-1', N'-40', 25, NULL, 29)
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup], [_ClassNode], [_NetworkPropertyNode], [_PropertyNode]) VALUES (1029, 1, 1, 1, N'http://orng.info/ontology/orng#Application', NULL, N'http://orng.info/ontology/orng#applicationURL', N'[ORNG.].Apps', N'ORNG Application', N'REPLACE(RTRIM(RIGHT(url, CHARINDEX(''/'', REVERSE(url)) - 1)), ''.xml'', '''')', NULL, NULL, NULL, NULL, NULL, NULL, N'Url', NULL, NULL, NULL, NULL, NULL, NULL, 0, N'1', NULL, N'-1', N'-40', 25, NULL, 45)
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, ViewSecurityGroup, EditSecurityGroup, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, Weight, OrderBy, oInternalType, oInternalID, oValue, oDataType, oLanguage, oStartDate, sInternalType, sInternalID, cClass, cInternalType, cInternalID, oClass) 
select max(DataMapID) + 1, 1, 1, 1, 'http://orng.info/ontology/orng#ApplicationInstanceData', null, null, '[ORNG.].[vwAppPersonData]', '-1', '-40', null, null, null, 0, '1', null, null, null, null, null, null, null, 'ORNG Application Instance Data', 'PrimaryId', null, null, null, null from [Ontology.].[DataMap]


-- Add ORNG ontology to the Namespace table. This should not affect any existing customizations
INSERT INTO [Ontology.].[Namespace] ( URI , Prefix)
Values ('http://orng.info/ontology/orng#', 'orng')
 
-- Add ORNG to the Ontology..PropertyGroup table. This will define where on profile the ORNG components are located. If customized the propertyGroup sort order,
-- you should review this query to ensure that customizations are not lost.
update [Ontology.].PropertyGroup set SortOrder = SortOrder + 1 where SortOrder > 2
insert into [Ontology.].PropertyGroup (PropertyGroupURI, SortOrder) values ('http://orng.info/ontology/orng#PropertyGroupORNGApplications', 3)
  
-- Add ORNG items to the PropertyGroupProperty table.  This should not affect any existing customizations 
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#applicationId', 1)
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#applicationInstanceDataValue', 5)
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#applicationInstanceForPerson', 4)
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#applicationInstanceOfApplication', 3)
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#applicationURL', 2)
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#hasApplicationInstanceData', 6)
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder], [_TagName], [_PropertyLabel]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#hasLinks', 8, N'orng:hasLinks', N'Websites')
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder], [_TagName], [_PropertyLabel]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#hasSlideShare', 7, N'orng:hasSlideShare', N'Featured Presentations')
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder], [_TagName], [_PropertyLabel]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#hasTwitter', 9, N'orng:hasTwitter', N'Twitter')
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder], [_TagName], [_PropertyLabel]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#hasYouTube', 10, N'orng:hasYouTube', N'Featured Videos')

-- Run this to clean up ontology tables
EXEC [Ontology.].[UpdateDerivedFields];


---------------------------------------------------------------
-- Change how data is stored for the links app
-- (One record per link instead of all links concatenated)
---------------------------------------------------------------

;WITH l AS (
	SELECT nodeId, appId, 'link_'+CAST(SortOrder AS VARCHAR(50)) keyName, 
		REPLACE(REPLACE(value,'"link_name"','"name"'),'"link_url"','"url"') value,
		createdDT, updatedDT
	FROM (
		SELECT nodeId, appId, keyname, '{'+r.x.value('.','VARCHAR(MAX)')+'}' value, createdDT, updatedDT,
			row_number() over (partition by nodeId order by createdDT)-1 SortOrder
		FROM (
			SELECT *, CAST('<link>'+REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(value,3,LEN(value)-4),'&','&amp;'),'<','&lt;'),'>','&gt;'),'},{','</link><link>')+'</link>' AS XML) x
			FROM [ORNG.].AppData
			WHERE keyname = 'links'
			and len(value) >= 7
		) t CROSS APPLY x.nodes('link') AS r(x)
	) t
)
SELECT *
	INTO #tmpAppData
	FROM (
		SELECT * FROM l
		UNION ALL
		SELECT nodeId, appId, 'links_count', CAST(COUNT(*) AS VARCHAR(50)), MAX(createdDT), MAX(updatedDT)
			FROM l
			GROUP BY nodeID, appId
	) t


delete from [ORNG.].AppData where keyname like 'links'
insert into [ORNG.].AppData select * From #tmpAppData
drop table #tmpAppData



---------------------------------------------------------------
-- Change the app URLs to point to the production server
---------------------------------------------------------------



-- Update URLs to get the latest application xml
-- If you are hosting the applications locally you can update this, and 
update [orng.].Apps set URL = 'http://profiles.ucsf.edu/apps_2.1/RDFTest.xml' where url = 'http://stage-profiles.ucsf.edu/apps_200/RDFTest.xml'
update [orng.].Apps set URL = 'http://profiles.ucsf.edu/apps_2.1/SlideShare.xml' where url = 'http://stage-profiles.ucsf.edu/apps_200/SlideShare.xml'
update [orng.].Apps set URL = 'http://profiles.ucsf.edu/apps_2.1/Links.xml' where url = 'http://stage-profiles.ucsf.edu/apps_200/Links.xml'
update [orng.].Apps set URL = 'http://profiles.ucsf.edu/apps_2.1/Twitter.xml' where url = 'http://stage-profiles.ucsf.edu/apps_200/Twitter.xml'
update [orng.].Apps set URL = 'http://profiles.ucsf.edu/apps_2.1/YouTube.xml' where url = 'http://stage-profiles.ucsf.edu/apps_200/YouTube.xml'



---------------------------------------------------------------
-- Disable old buggy list tool app
---------------------------------------------------------------

-- Disable the list tool application as this is not compatible with 2.5.1 (it also wasn't compatible with 2.0.0, but was have been enabled by default)
update [ORNG.].Apps set Enabled = 0 where AppID = 104



---------------------------------------------------------------
-- Update the security group settings for enabled apps
---------------------------------------------------------------
UPDATE p set p.EditExistingSecurityGroup = -20, p.ViewSecurityGroup = -1,
	p.CustomDisplay = 1, p.EditSecurityGroup = -20, p.EditPermissionsSecurityGroup = -20,
	p.EditAddNewSecurityGroup = -20, p.EditAddExistingSecurityGroup = -20,
	p.EditDeleteSecurityGroup = -20 
from [orng.].Apps a	join [Ontology.].[ClassProperty] p
	on 'http://orng.info/ontology/orng#has' + REPLACE(RTRIM(RIGHT(a.Url, CHARINDEX('/', REVERSE(a.Url)) - 1)), '.xml', '') = p.Property



---------------------------------------------------------------
-- Change the way that apps are linked to people
---------------------------------------------------------------

-- In version 2.5.1 the fact that a user has an ORNG application on their profile is stored in the RDF
-- The following code creates RDF for the example gadgets included with 2.0.0
-- If you added additional gadgets you will need to load their data into the RDF using the following 
-- code as an example.

SELECT *, ROW_NUMBER() OVER (ORDER BY nodeId, appId) i
	INTO #nodeApp
	FROM (
		SELECT DISTINCT d.nodeID, d.appid, isnull(visibility, 'Private') as visibility
		FROM [orng.].AppData d 
			LEFT OUTER JOIN [ORNG.].AppRegistry r
				ON d.nodeId = r.nodeID and d.appID = r.appID
		WHERE d.appId IN (101,103,112,114)
	) t

DECLARE @nodeID as bigint
DECLARE @appID as int
DECLARE @viewSecurityGroup as int
DECLARE @gadgetURI as nvarchar(255)
DECLARE @error bit

DECLARE @i INT
DECLARE @j INT
SELECT @i = 0
SELECT @j = ISNULL((SELECT COUNT(*) FROM #nodeApp),0)
WHILE (@i < @j)
BEGIN
	SELECT @i = @i + 1
	SELECT @nodeID = NodeID,
			@ViewSecurityGroup = (CASE WHEN visibility = 'Public' THEN -1 ELSE -40 END),
			@appID = appID,
			@gadgetURI = (CASE appID
						WHEN 101 THEN 'http://orng.info/ontology/orng#hasSlideShare'
						WHEN 103 THEN 'http://orng.info/ontology/orng#hasLinks'
						WHEN 112 THEN 'http://orng.info/ontology/orng#hasTwitter'
						WHEN 114 THEN 'http://orng.info/ontology/orng#hasYouTube'
						ELSE NULL END)
		FROM #nodeApp
		WHERE i = @i
	EXEC [ORNG.].[AddAppToPerson] @subjectID = @nodeID, @appID = @appID, @error = @error
	EXEC [RDF.].[SetNodePropertySecurity] @nodeID =	@nodeID, @propertyURI = @gadgetURI, @viewSecurityGroup = @viewSecurityGroup
END

DROP TABLE #nodeApp



---------------------------------------------------------------
-- Drop database items that are no longer used
---------------------------------------------------------------


-- Drop visibility column, this data has been moved into the RDF
ALTER TABLE [ORNG.].[AppRegistry] DROP COLUMN [visibility];



--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
--*****
--***** Add eagle-i
--*****
--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************


INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1014, N'http://xmlns.com/foaf/0.1/Person', NULL, N'http://profiles.catalyst.harvard.edu/ontology/prns#hasEagleIData', 1, NULL, 0, 0, 0.5, 1, 1, -50, -50, -50, -50, -50, -50, -50, 0, NULL, '<Module ID="CustomViewEagleI" />', '<Module ID="CustomEditEagleI" />')
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup]) VALUES (1106, 1, 1, 1, N'http://xmlns.com/foaf/0.1/Person', NULL, N'http://profiles.catalyst.harvard.edu/ontology/prns#hasEagleIData', N'(select distinct PersonID from [Profile.Data].[EagleI.HTML]) t', N'Person', N'PersonID', NULL, NULL, NULL, NULL, NULL, NULL, N'''true''', N'http://www.w3.org/2001/XMLSchema#boolean', NULL, NULL, NULL, NULL, NULL, 1, N'1', NULL, N'-1', N'-40')
insert into [Ontology.].[PropertyGroupProperty] ( PropertyGroupURI, PropertyURI, SortOrder, CustomDisplayModule, CustomEditModule) 
values ('http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupResearch', 'http://profiles.catalyst.harvard.edu/ontology/prns#hasEagleIData', 9, null, null)
  

--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
--*****
--***** Add ORCID
--*****
--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************

-----------------------------------------------------------------------
-- Add ORCID Ontology
-----------------------------------------------------------------------
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup]) VALUES (1107, 100, 0, 1, N'http://xmlns.com/foaf/0.1/Person', NULL, N'http://vivoweb.org/ontology/core#orcidId', N'(select p.PersonID, o.ORCID from [ORCID.].[Person] o join [profile.data].[Person] p on o.internalusername = p.InternalUsername) t', N'Person', N'PersonID', NULL, NULL, NULL, NULL, NULL, NULL, N'ORCID', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'1', NULL, N'-1', N'-20')

-----------------------------------------------------------------------
-- Load [ORCID.] data tables from InstallData.xml
-----------------------------------------------------------------------

-- Load the install data XML into memory
DECLARE @x XML
SELECT @x = (SELECT TOP 1 Data FROM [Framework.].[InstallData] ORDER BY InstallDataID DESC) 
		   
INSERT INTO [ORCID.].[REF_Permission] ([PermissionScope],[PermissionDescription],[MethodAndRequest],[SuccessMessage],[FailedMessage])
	SELECT R.x.value('PermissionScope[1]','varchar(max)'),
		R.x.value('PermissionDescription[1]','varchar(max)'),
		R.x.value('MethodAndRequest[1]','varchar(max)'),
		R.x.value('SuccessMessage[1]','varchar(max)'),
		R.x.value('FailedMessage[1]','varchar(max)')
	FROM (SELECT @x.query('Import[1]/Table[@Name=''[ORCID.].[REF_Permission]'']') x) t CROSS APPLY x.nodes('//Row') AS R(x)

INSERT INTO [ORCID.].[REF_PersonStatusType] ([StatusDescription])
	SELECT R.x.value('StatusDescription[1]','varchar(max)')
	FROM (SELECT @x.query('Import[1]/Table[@Name=''[ORCID.].[REF_PersonStatusType]'']') x) t CROSS APPLY x.nodes('//Row') AS R(x)

INSERT INTO [ORCID.].[REF_RecordStatus] ([RecordStatusID],[StatusDescription])
	SELECT R.x.value('RecordStatusID[1]','varchar(max)'), R.x.value('StatusDescription[1]','varchar(max)')
	FROM (SELECT @x.query('Import[1]/Table[@Name=''[ORCID.].[REF_RecordStatus]'']') x) t CROSS APPLY x.nodes('//Row') AS R(x)

INSERT INTO [ORCID.].[REF_Decision] ([DecisionDescription],[DecisionDescriptionLong])
	SELECT R.x.value('DecisionDescription[1]','varchar(max)'), R.x.value('DecisionDescriptionLong[1]','varchar(max)')
	FROM (SELECT @x.query('Import[1]/Table[@Name=''[ORCID.].[REF_Decision]'']') x) t CROSS APPLY x.nodes('//Row') AS R(x)

INSERT INTO [ORCID.].[REF_WorkExternalType] ([WorkExternalType],[WorkExternalDescription])
	SELECT R.x.value('WorkExternalType[1]','varchar(max)'), R.x.value('WorkExternalDescription[1]','varchar(max)')
	FROM (SELECT @x.query('Import[1]/Table[@Name=''[ORCID.].[REF_WorkExternalType]'']') x) t CROSS APPLY x.nodes('//Row') AS R(x)

INSERT INTO [ORCID.].[RecordLevelAuditType] ([AuditType])
	SELECT R.x.value('AuditType[1]','varchar(max)')
	FROM (SELECT @x.query('Import[1]/Table[@Name=''[ORCID.].[RecordLevelAuditType]'']') x) t CROSS APPLY x.nodes('//Row') AS R(x)

INSERT INTO [ORCID.].[DefaultORCIDDecisionIDMapping] ([SecurityGroupID],[DefaultORCIDDecisionID])
	SELECT R.x.value('SecurityGroupID[1]','varchar(max)'), R.x.value('DefaultORCIDDecisionID[1]','varchar(max)')
	FROM (SELECT @x.query('Import[1]/Table[@Name=''[ORCID.].[DefaultORCIDDecisionIDMapping]'']') x) t CROSS APPLY x.nodes('//Row') AS R(x)

 

--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
--*****
--***** Profiles Presentation XML Bug Fix
--*****
--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************

 --[Ontology.Presentation].[XML]
 -- Fix a bug on the profile page for MESH concepts. This bug caused an exception when clicking on the "See all people" link;
 -- This will affect any customizations made to the PresentionXML for MESH Concept pages, it will not affect PresentationXML changes to other pages.
update [Ontology.Presentation].[XML] set PresentationXML =
'<Presentation PresentationClass="profile">
  <PageOptions Columns="3" />
  <WindowName>{{{rdf:RDF[1]/rdf:Description[1]/rdfs:label[1]}}}</WindowName>
  <PageColumns>3</PageColumns>
  <PageTitle>{{{rdf:RDF[1]/rdf:Description[1]/rdfs:label[1]}}}</PageTitle>
  <PageBackLinkName />
  <PageBackLinkURL />
  <PageSubTitle />
  <PageDescription />
  <PanelTabType>Fixed</PanelTabType>
  <PanelList>
    <Panel Type="active">
      <Module ID="MiniSearch" />
      <Module ID="MainMenu" />
    </Panel>
    <Panel Type="main" TabSort="0" TabType="Default">
      <Module ID="CustomViewConceptMeshInfo">
        <ParamList />
      </Module>
    </Panel>
    <Panel Type="main" TabSort="0" TabType="Default">
      <Module ID="CustomViewConceptPublication">
        <ParamList>
          <Param Name="TimelineCaption">This graph shows the total number of publications written about "@ConceptName" by people in Profiles by year, and whether "@ConceptName" was a major or minor topic of these publication. &lt;!--In all years combined, a total of [[[TODO:PUBLICATION COUNT]]] publications were written by people in Profiles.--&gt;</Param>
          <Param Name="CitedCaption">Below are the publications written about "@ConceptName" that have been cited the most by articles in Pubmed Central.</Param>
          <Param Name="NewestCaption">Below are the most recent publications written about "@ConceptName" by people in Profiles.</Param>
          <Param Name="OldestCaption">Below are the earliest publications written about "@ConceptName" by people in Profiles.</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="passive">
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="InfoCaption">People</Param>
          <Param Name="Description">People who have written about this concept.</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:researchAreaOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">/search/default.aspx?searchtype=people&amp;searchfor={{{rdf:RDF/rdf:Description/rdfs:label}}}&amp;classuri=http://xmlns.com/foaf/0.1/Person&amp;erpage=15&amp;offset=0&amp;exactPhrase=true</Param>
          <Param Name="MoreText">See all people</Param>
        </ParamList>
      </Module>
      <Module ID="CustomViewConceptSimilarMesh">
        <ParamList>
          <Param Name="InfoCaption">Similar Concepts</Param>
          <Param Name="Description">People who have written about this concept.</Param>
        </ParamList>
      </Module>
      <Module ID="CustomViewConceptTopJournal">
        <ParamList>
          <Param Name="InfoCaption">Top Journals</Param>
          <Param Name="Description">Top journals in which articles about this concept have been published.</Param>
        </ParamList>
      </Module>
    </Panel>
  </PanelList>
</Presentation>'
where Subject = 'http://www.w3.org/2004/02/skos/core#Concept' 
and Predicate is null 
and Object is null



--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
--*****
--***** Finalize changes
--*****
--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
  
-- The next two rows update fields such as nodeID values, and table identifiers. This should not affect any existing customizations
EXEC [Ontology.].[UpdateDerivedFields]
EXEC [Ontology.].[UpdateCounts]
EXEC [Ontology.].CleanUp @action='UpdateIDs'

-- Update the RDF tables and cache
EXEC [Framework.].[RunJobGroup] @JobGroup = 3


GO