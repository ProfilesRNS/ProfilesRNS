/*

Run this script on:

	Profiles RNS Version 2.0.0

to update its data to:

	Profiles RNS Version 2.5.1

*** You are recommended to back up your database before running this script!
*** This script will delete any customizations made to [Ontology.Presentation].[XML]
*** If you have customized the presentation XML you will need to manually merge these changes.

*** Make sure you run the ProfilesRNS_Upgrade_Schema_Part1.sql file before running this file.
*** Run this script before you run ProfilesRNS_Upgrade_Schema_Part2.sql.

*** Modify lines 21, 22, and 23, replace $(ProfilesRNSRootPath)\Data with the location that contains the various XML files that came with Profiles RNS 2.5.1 (not an older version of that file). These file has to be on the database server, not your local machine.

*/
EXEC [Framework.].[LoadXMLFile] @FilePath = '$(ProfilesRNSRootPath)\Data\PRNS_1.1.owl', @TableDestination = '[Ontology.Import].owl', @DestinationColumn = 'DATA', @NameValue = 'PRNS_1.1'
EXEC [Framework.].[LoadXMLFile] @FilePath = '$(ProfilesRNSRootPath)\Data\ORNG_1.0.owl', @TableDestination = '[Ontology.Import].owl', @DestinationColumn = 'DATA', @NameValue = 'ORNG_1.0';
EXEC [Framework.].[LoadXMLFile] @FilePath = '$(ProfilesRNSRootPath)\Data\InstallData.xml', @TableDestination = '[Framework.].[InstallData]', @DestinationColumn = 'DATA'

UPDATE [Ontology.Import].OWL SET Graph = 3 WHERE name = 'PRNS_1.1'
EXEC [Ontology.Import].[ConvertOWL2Triple] @OWL = 'PRNS_1.1'



UPDATE [Ontology.Import].OWL SET Graph = 4 WHERE name = 'ORNG_1.0'
EXEC [Ontology.Import].[ConvertOWL2Triple] @OWL = 'ORNG_1.0'

EXEC [RDF.Stage].[LoadTriplesFromOntology] @Truncate = 1
EXEC [RDF.Stage].[ProcessTriples]



 DECLARE @x XML
 SELECT @x = ( SELECT TOP 1
                        Data
               FROM     [Framework.].[InstallData]
               ORDER BY InstallDataID DESC
             ) 


Truncate table [Framework.].Job
--[Framework.].[Job]
INSERT INTO [Framework.].Job
        ( JobID,
		  JobGroup,
          Step,
          IsActive,
          Script
        ) 
SELECT	R.x.value('JobID[1]','varchar(max)'),
		R.x.value('JobGroup[1]','varchar(max)'),
		R.x.value('Step[1]','varchar(max)'),
		R.x.value('IsActive[1]','varchar(max)'),
		R.x.value('Script[1]','varchar(max)')
FROM    ( SELECT
                  @x.query
                  ('Import[1]/Table[@Name=''[Framework.].[Job]'']')
                  x
      ) t
CROSS APPLY x.nodes('//Row') AS R ( x )


---------------------------------------------------------------
-- [Ontology.]
---------------------------------------------------------------
 
 --[Ontology.].[ClassGroup]
 insert into [Ontology.].[ClassGroup] (ClassGroupURI, SortOrder, _ClassGroupLabel, IsVisible)
 Values('http://orng.info/ontology/orng#ClassGroupORNGApplications', 7, 'ORNG Applications', 1)
 

 --[Ontology.].[ClassGroupClass]
insert into [Ontology.].[ClassGroupClass] (ClassGroupURI, ClassURI, SortOrder, _ClassLabel)
values('http://orng.info/ontology/orng#ClassGroupORNGApplications', 'http://orng.info/ontology/orng#Application', 1, 'ORNG Application')
  
--[Ontology.].[ClassProperty]
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1001, N'http://orng.info/ontology/orng#Application', NULL, N'http://orng.info/ontology/orng#applicationId', 0, NULL, 0, 0, 0.5, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1002, N'http://orng.info/ontology/orng#Application', NULL, N'http://orng.info/ontology/orng#applicationURL', 0, NULL, 0, 0, 0.5, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1003, N'http://orng.info/ontology/orng#Application', NULL, N'http://www.w3.org/2000/01/rdf-schema#label', 0, NULL, 0, 0, 1, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1004, N'http://orng.info/ontology/orng#ApplicationInstance', NULL, N'http://orng.info/ontology/orng#applicationInstanceForPerson', 0, NULL, 0, 0, 0, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1005, N'http://orng.info/ontology/orng#ApplicationInstance', NULL, N'http://orng.info/ontology/orng#applicationInstanceOfApplication', 0, NULL, 1, 0, 0, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1006, N'http://orng.info/ontology/orng#ApplicationInstance', NULL, N'http://orng.info/ontology/orng#hasApplicationInstanceData', 0, NULL, 1, 0, 0, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1007, N'http://orng.info/ontology/orng#ApplicationInstance', NULL, N'http://www.w3.org/2000/01/rdf-schema#label', 0, NULL, 0, 0, 1, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1008, N'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, N'http://orng.info/ontology/orng#applicationInstanceDataValue', 0, NULL, 0, 0, 0.5, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)
INSERT [Ontology.].[ClassProperty] ([ClassPropertyID], [Class], [NetworkProperty], [Property], [IsDetail], [Limit], [IncludeDescription], [IncludeNetwork], [SearchWeight], [CustomDisplay], [CustomEdit], [ViewSecurityGroup], [EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], [EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], [MinCardinality], [MaxCardinality], [CustomDisplayModule], [CustomEditModule]) VALUES (1009, N'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, N'http://www.w3.org/2000/01/rdf-schema#label', 0, NULL, 0, 0, 1, 0, 0, -1, -40, -40, -40, -40, -40, -40, 0, NULL, NULL, NULL)


  
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup]) VALUES (1022, 1, 1, 1, N'http://orng.info/ontology/orng#ApplicationInstance', NULL, N'http://orng.info/ontology/orng#hasApplicationInstanceData', N'[ORNG.].[vwAppPersonData]', N'ORNG Application Instance', N'PersonIdAppId', NULL, NULL, NULL, N'http://orng.info/ontology/orng#ApplicationInstanceData', N'ORNG Application Instance Data', N'PrimaryId', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'1', NULL, N'-1', N'-40')
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup]) VALUES (1025, 1, 1, 1, N'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, N'http://orng.info/ontology/orng#applicationInstanceDataValue', N'[ORNG.].[vwAppPersonData]', N'ORNG Application Instance Data', N'PrimaryId', NULL, NULL, NULL, NULL, NULL, NULL, N'value', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'1', NULL, N'-1', N'-40')
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup]) VALUES (1023, 1, 1, 1, N'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, N'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', N'[ORNG.].[vwAppPersonData]', N'ORNG Application Instance Data', N'PrimaryId', NULL, NULL, NULL, NULL, NULL, NULL, N'''http://orng.info/ontology/orng#ApplicationInstanceData''', NULL, NULL, NULL, NULL, NULL, NULL, 0, N'1', NULL, N'-1', N'-40')
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup]) VALUES (1024, 1, 1, 1, N'http://orng.info/ontology/orng#ApplicationInstanceData', NULL, N'http://www.w3.org/2000/01/rdf-schema#label', N'[ORNG.].[vwAppPersonData]', N'ORNG Application Instance Data', N'PrimaryId', NULL, NULL, NULL, NULL, NULL, NULL, N'keyname', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'1', NULL, N'-1', N'-40')
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup]) VALUES (1106, 1, 1, 1, N'http://xmlns.com/foaf/0.1/Person', NULL, N'http://profiles.catalyst.harvard.edu/ontology/prns#hasEagleIData', N'(select distinct PersonID from [Profile.Data].[EagleI.HTML]) t', N'Person', N'PersonID', NULL, NULL, NULL, NULL, NULL, NULL, N'''true''', N'http://www.w3.org/2001/XMLSchema#boolean', NULL, NULL, NULL, NULL, NULL, 1, N'1', NULL, N'-1', N'-40')
INSERT [Ontology.].[DataMap] ([DataMapID], [DataMapGroup], [IsAutoFeed], [Graph], [Class], [NetworkProperty], [Property], [MapTable], [sInternalType], [sInternalID], [cClass], [cInternalType], [cInternalID], [oClass], [oInternalType], [oInternalID], [oValue], [oDataType], [oLanguage], [oStartDate], [oStartDatePrecision], [oEndDate], [oEndDatePrecision], [oObjectType], [Weight], [OrderBy], [ViewSecurityGroup], [EditSecurityGroup]) VALUES (1107, 100, 0, 1, N'http://xmlns.com/foaf/0.1/Person', NULL, N'http://vivoweb.org/ontology/core#orcidId', N'(select p.PersonID, o.ORCID from [ORCID.].[Person] o join [profile.data].[Person] p on o.internalusername = p.InternalUsername) t', N'Person', N'PersonID', NULL, NULL, NULL, NULL, NULL, NULL, N'ORCID', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'1', NULL, N'-1', N'-20')

 
update [Ontology.].PropertyGroup set SortOrder = SortOrder + 1 where SortOrder > 2
insert into [Ontology.].PropertyGroup (PropertyGroupURI, SortOrder) values ('http://orng.info/ontology/orng#PropertyGroupORNGApplications', 3)
  
  
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#applicationId', 1)
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#applicationInstanceDataValue', 5)
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#applicationInstanceForPerson', 4)
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#applicationInstanceOfApplication', 3)
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#applicationURL', 2)
INSERT [Ontology.].[PropertyGroupProperty] ([PropertyGroupURI], [PropertyURI], [SortOrder]) VALUES (N'http://orng.info/ontology/orng#PropertyGroupORNGApplications', N'http://orng.info/ontology/orng#hasApplicationInstanceData', 6)
  

---------------------------------------------------------------
-- [Ontology.Presentation]
---------------------------------------------------------------


 --[Ontology.Presentation].[XML]
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
          <Param Name="TimelineCaption">This graph shows the total number of publications written about "@ConceptName" by people in Harvard Catalyst Profiles by year, and whether "@ConceptName" was a major or minor topic of these publication. &lt;!--In all years combined, a total of [[[TODO:PUBLICATION COUNT]]] publications were written by people in Profiles.--&gt;</Param>
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

  
 ---------------------------------------------------------------
-- [ORCID.]
---------------------------------------------------------------
  
	INSERT INTO [ORCID.].[REF_Permission]
		(
			[PermissionScope],
			[PermissionDescription],
			[MethodAndRequest],
			[SuccessMessage],
			[FailedMessage]
		)
   SELECT	R.x.value('PermissionScope[1]','varchar(max)'),
			R.x.value('PermissionDescription[1]','varchar(max)'),
			R.x.value('MethodAndRequest[1]','varchar(max)'),
			R.x.value('SuccessMessage[1]','varchar(max)'),
			R.x.value('FailedMessage[1]','varchar(max)')
	 FROM    (SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[ORCID.].[REF_Permission]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )


	INSERT INTO [ORCID.].[REF_PersonStatusType]
		(
			[StatusDescription]
		)
   SELECT	R.x.value('StatusDescription[1]','varchar(max)')
	 FROM    (SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[ORCID.].[REF_PersonStatusType]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )


	INSERT INTO [ORCID.].[REF_RecordStatus]
		(
			[RecordStatusID],
			[StatusDescription]
		)
   SELECT	R.x.value('RecordStatusID[1]','varchar(max)'),
			R.x.value('StatusDescription[1]','varchar(max)')
	 FROM    (SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[ORCID.].[REF_RecordStatus]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )


	INSERT INTO [ORCID.].[REF_Decision]
		(
			[DecisionDescription],
			[DecisionDescriptionLong]
		)
   SELECT	R.x.value('DecisionDescription[1]','varchar(max)'),
			R.x.value('DecisionDescriptionLong[1]','varchar(max)')
	 FROM    (SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[ORCID.].[REF_Decision]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )

	INSERT INTO [ORCID.].[REF_WorkExternalType]
		(
			[WorkExternalType],
			[WorkExternalDescription]
		)
   SELECT	R.x.value('WorkExternalType[1]','varchar(max)'),
			R.x.value('WorkExternalDescription[1]','varchar(max)')
	 FROM    (SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[ORCID.].[REF_WorkExternalType]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )


	INSERT INTO [ORCID.].[RecordLevelAuditType]
		(
			[AuditType]
		)
   SELECT	R.x.value('AuditType[1]','varchar(max)')
	 FROM    (SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[ORCID.].[RecordLevelAuditType]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )



	INSERT INTO [ORCID.].[DefaultORCIDDecisionIDMapping]
		(
			[SecurityGroupID],
			[DefaultORCIDDecisionID]
		)
   SELECT	R.x.value('SecurityGroupID[1]','varchar(max)'),
			R.x.value('DefaultORCIDDecisionID[1]','varchar(max)')
	 FROM    (SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[ORCID.].[DefaultORCIDDecisionIDMapping]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )

EXEC [Ontology.].[UpdateDerivedFields]
EXEC [Ontology.].[UpdateCounts]
EXEC [Framework.].[RunJobGroup] @JobGroup = 3