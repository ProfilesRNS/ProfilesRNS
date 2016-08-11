/*

Run this script on:

	Profiles RNS Version 2.8.0

to update its data to:

	Profiles RNS Version 2.9.0

*** You are recommended to back up your database before running this script!

*** You should review each step of this script to ensure that it will not overwrite any customizations you have made to ProfilesRNS.

*** Make sure you run the ProfilesRNS_Upgrade_Schema.sql file before running this file.
 
*** Modify line 31, replace $(ProfilesRNSRootPath)\Data with the location that contains the various XML files that came with Profiles RNS 2.9.0 (not an older version of that file). These file has to be on the database server, not your local machine.

*/

--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
--*****
--***** Load new ontology file
--*****
--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************

EXEC [Framework.].[LoadXMLFile] @FilePath = '$(ProfilesRNSRootPath)\Data\PRNS_1.2.owl', @TableDestination = '[Ontology.Import].owl', @DestinationColumn = 'DATA', @NameValue = 'PRNS_1.2'

-- Import the Updated PRNS ontology into Profiles. This should not eliminate any customizations unless additional 
-- classes have been added to the PRNS ontology
DELETE FROM [Ontology.Import].OWL WHERE name = 'PRNS_1.0'
DELETE FROM [Ontology.Import].Triple WHERE OWL = 'PRNS_1.0'
DELETE FROM [Ontology.Import].OWL WHERE name = 'PRNS_1.1'
DELETE FROM [Ontology.Import].Triple WHERE OWL = 'PRNS_1.1'
UPDATE [Ontology.Import].OWL SET Graph = 3 WHERE name = 'PRNS_1.2'
EXEC [Ontology.Import].[ConvertOWL2Triple] @OWL = 'PRNS_1.2'

EXEC [RDF.Stage].[LoadTriplesFromOntology] @Truncate = 1
EXEC [RDF.Stage].[ProcessTriples]

/***
*
* Remove ORNG gadgets from person summary RDF.
*
***/

update [Ontology.].[ClassProperty] set  IsDetail =  1 where Class= 'http://xmlns.com/foaf/0.1/Person' and  NetworkProperty is null and  Property= 'http://orng.info/ontology/orng#hasLinks'
update [Ontology.].[ClassProperty] set  IsDetail =  1 where Class= 'http://xmlns.com/foaf/0.1/Person' and  NetworkProperty is null and  Property= 'http://orng.info/ontology/orng#hasSlideShare'
update [Ontology.].[ClassProperty] set  IsDetail =  1 where Class= 'http://xmlns.com/foaf/0.1/Person' and  NetworkProperty is null and  Property= 'http://orng.info/ontology/orng#hasTwitter'
update [Ontology.].[ClassProperty] set  IsDetail =  1 where Class= 'http://xmlns.com/foaf/0.1/Person' and  NetworkProperty is null and  Property= 'http://orng.info/ontology/orng#hasYouTube'


/***
*
* Freetext Keyword Module
*
***/

insert into [Ontology.].[ClassProperty] ( ClassPropertyID,Class, NetworkProperty, Property, IsDetail, Limit, _TagName, _PropertyLabel, _ObjectType, MinCardinality, MaxCardinality, CustomDisplayModule, CustomEditModule, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup) 
select max(ClassPropertyID) + 1, 'http://xmlns.com/foaf/0.1/Person', null, 'http://vivoweb.org/ontology/core#freetextKeyword', 1, null, 'vivo:freetextKeyword', 'keywords', 1, 0, 0, '<Module ID="ApplyXSLT"><ParamList><Param Name="XSLTPath">~/profile/XSLT/FreetextKeyword.xslt</Param></ParamList></Module>', '<Module ID="CustomEditFreetextKeyword"/>', -20, -20, -20, -20, -20, -20, 0, 0, 0.5, 1, 1, -1 from [Ontology.].[ClassProperty]


/***
*
* Education and Training Module
*
***/

insert into [Ontology.].[ClassProperty] ( ClassPropertyID,Class, NetworkProperty, Property, IsDetail, Limit, _TagName, _PropertyLabel, _ObjectType, MinCardinality, MaxCardinality, CustomDisplayModule, CustomEditModule, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup) 
select max(ClassPropertyID) + 1, 'http://vivoweb.org/ontology/core#EducationalTraining', null, 'http://profiles.catalyst.harvard.edu/ontology/prns#endDate', 0, null, 'prns:endDate', 'end date', 1, 0, null, null, null, -40, -40, -40, -40, -40, -40, 0, 0, 0, 0, 0, -1 from [Ontology.].[ClassProperty]
insert into [Ontology.].[ClassProperty] ( ClassPropertyID,Class, NetworkProperty, Property, IsDetail, Limit, _TagName, _PropertyLabel, _ObjectType, MinCardinality, MaxCardinality, CustomDisplayModule, CustomEditModule, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup) 
select max(ClassPropertyID) + 1, 'http://vivoweb.org/ontology/core#EducationalTraining', null, 'http://profiles.catalyst.harvard.edu/ontology/prns#trainingAtOrganization', 0, null, 'prns:trainingAtOrganization', 'educational organization', 1, 0, null, null, null, -40, -40, -40, -40, -40, -40, 0, 0, 0.5, 0, 0, -1 from [Ontology.].[ClassProperty]
insert into [Ontology.].[ClassProperty] ( ClassPropertyID,Class, NetworkProperty, Property, IsDetail, Limit, _TagName, _PropertyLabel, _ObjectType, MinCardinality, MaxCardinality, CustomDisplayModule, CustomEditModule, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup) 
select max(ClassPropertyID) + 1, 'http://vivoweb.org/ontology/core#EducationalTraining', null, 'http://profiles.catalyst.harvard.edu/ontology/prns#trainingLocation', 0, null, 'prns:trainingLocation', 'training location', 1, 0, null, null, null, -40, -40, -40, -40, -40, -40, 0, 0, 0.5, 0, 0, -1 from [Ontology.].[ClassProperty]

update [Ontology.].[ClassProperty] set  CustomEditModule =  '<Module ID="CustomEditEducationalTraining"/>', EditSecurityGroup =  -20, EditPermissionsSecurityGroup =  -20, EditExistingSecurityGroup =  -20, EditAddNewSecurityGroup =  -20, EditAddExistingSecurityGroup =  -20, EditDeleteSecurityGroup =  -20, SearchWeight =  0.1, CustomDisplay =  1, CustomEdit =  1 where Class= 'http://xmlns.com/foaf/0.1/Person' and  NetworkProperty is null and  Property= 'http://vivoweb.org/ontology/core#educationalTraining'
update [Ontology.].[ClassProperty] set  IsDetail =  0 where Class= 'http://vivoweb.org/ontology/core#EducationalTraining' and  NetworkProperty is null and  Property= 'http://vivoweb.org/ontology/core#degreeEarned'
update [Ontology.].[ClassProperty] set  IsDetail =  0 where Class= 'http://vivoweb.org/ontology/core#EducationalTraining' and  NetworkProperty is null and  Property= 'http://vivoweb.org/ontology/core#majorField'

insert into [Ontology.].[PropertyGroupProperty] ( PropertyGroupURI, PropertyURI, SortOrder, CustomDisplayModule, CustomEditModule) 
values ('http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupAddress', 'http://profiles.catalyst.harvard.edu/ontology/prns#trainingLocation', 26, null, null)
insert into [Ontology.].[PropertyGroupProperty] ( PropertyGroupURI, PropertyURI, SortOrder, CustomDisplayModule, CustomEditModule) 
values ('http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview', 'http://profiles.catalyst.harvard.edu/ontology/prns#trainingAtOrganization', 224, null, null)
update [Ontology.].[PropertyGroupProperty] set  CustomDisplayModule =  '<Module ID="ApplyXSLT"><ParamList><Param Name="XSLTPath">~/profile/XSLT/EducationalTraining.xslt</Param></ParamList></Module>' where PropertyGroupURI= 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupBiography' and  PropertyURI= 'http://vivoweb.org/ontology/core#educationalTraining'


/***
*
* Research Activities and Funding module
*
***/

update [Ontology.].[ClassProperty] set  _PropertyLabel = 'research activities and funding', CustomDisplayModule =  '<Module ID="CustomViewResearcherRole"/>', CustomEditModule =  '<Module ID="CustomEditResearcherRole"/>', EditSecurityGroup =  -20, EditPermissionsSecurityGroup =  -20, EditAddNewSecurityGroup =  -20, EditDeleteSecurityGroup =  -20, SearchWeight =  0.3, CustomDisplay =  1, CustomEdit =  1 where Class= 'http://xmlns.com/foaf/0.1/Person' and  NetworkProperty is null and  Property= 'http://vivoweb.org/ontology/core#hasResearcherRole'
insert into [Ontology.].[ClassProperty] ( ClassPropertyID,Class, NetworkProperty, Property, IsDetail, Limit, _TagName, _PropertyLabel, _ObjectType, MinCardinality, MaxCardinality, CustomDisplayModule, CustomEditModule, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup) 
select max(ClassPropertyID) + 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://profiles.catalyst.harvard.edu/ontology/prns#endDate', 0, null, 'prns:endDate', 'end date', 1, 0, null, null, null, -40, -40, -40, -40, -40, -40, 1, 0, 0, 0, 0, -1 from [Ontology.].[ClassProperty]
insert into [Ontology.].[ClassProperty] ( ClassPropertyID,Class, NetworkProperty, Property, IsDetail, Limit, _TagName, _PropertyLabel, _ObjectType, MinCardinality, MaxCardinality, CustomDisplayModule, CustomEditModule, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup) 
select max(ClassPropertyID) + 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://profiles.catalyst.harvard.edu/ontology/prns#startDate', 0, null, 'prns:startDate', 'start date', 1, 0, null, null, null, -40, -40, -40, -40, -40, -40, 1, 0, 0, 0, 0, -1 from [Ontology.].[ClassProperty]
insert into [Ontology.].[ClassProperty] ( ClassPropertyID,Class, NetworkProperty, Property, IsDetail, Limit, _TagName, _PropertyLabel, _ObjectType, MinCardinality, MaxCardinality, CustomDisplayModule, CustomEditModule, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup) 
select max(ClassPropertyID) + 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://purl.org/ontology/bibo/abstract', 1, null, 'bibo:abstract', 'abstract', 1, 0, null, null, null, -40, -40, -40, -40, -40, -40, 1, 0, 0.5, 0, 0, -1 from [Ontology.].[ClassProperty]
insert into [Ontology.].[ClassProperty] ( ClassPropertyID,Class, NetworkProperty, Property, IsDetail, Limit, _TagName, _PropertyLabel, _ObjectType, MinCardinality, MaxCardinality, CustomDisplayModule, CustomEditModule, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup) 
select max(ClassPropertyID) + 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://vivoweb.org/ontology/core#contributingRole', 1, null, 'vivo:contributingRole', 'contributor', 0, 0, null, null, null, -40, -40, -40, -40, -40, -40, 1, 0, 0, 0, 0, -1 from [Ontology.].[ClassProperty]
insert into [Ontology.].[ClassProperty] ( ClassPropertyID,Class, NetworkProperty, Property, IsDetail, Limit, _TagName, _PropertyLabel, _ObjectType, MinCardinality, MaxCardinality, CustomDisplayModule, CustomEditModule, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup) 
select max(ClassPropertyID) + 1, 'http://vivoweb.org/ontology/core#ResearcherRole', null, 'http://vivoweb.org/ontology/core#description', 0, null, 'vivo:description', 'description', 1, 0, null, null, null, -40, -40, -40, -40, -40, -40, 1, 0, 0.5, 0, 0, -1 from [Ontology.].[ClassProperty]
insert into [Ontology.].[ClassProperty] ( ClassPropertyID,Class, NetworkProperty, Property, IsDetail, Limit, _TagName, _PropertyLabel, _ObjectType, MinCardinality, MaxCardinality, CustomDisplayModule, CustomEditModule, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup) 
select max(ClassPropertyID) + 1, 'http://vivoweb.org/ontology/core#ResearcherRole', null, 'http://vivoweb.org/ontology/core#roleContributesTo', 0, null, 'vivo:roleContributesTo', 'contributes to', 0, 0, null, null, null, -40, -40, -40, -40, -40, -40, 1, 0, 1, 0, 0, -1 from [Ontology.].[ClassProperty]

insert into [Ontology.].[ClassGroupClass] ( ClassGroupURI, ClassURI, SortOrder, _ClassLabel) 
values ('http://profiles.catalyst.harvard.edu/ontology/prns#ClassGroupResearch', 'http://vivoweb.org/ontology/core#Grant', 2, 'Grant')

update [Ontology.].[ClassProperty] set  IsDetail =  0 where Class= 'http://vivoweb.org/ontology/core#Grant' and  NetworkProperty is null and  Property= 'http://vivoweb.org/ontology/core#sponsorAwardId'
update [Ontology.].[ClassProperty] set  IsDetail =  0 where Class= 'http://vivoweb.org/ontology/core#ResearcherRole' and  NetworkProperty is null and  Property= 'http://vivoweb.org/ontology/core#researcherRoleOf'

insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Agreement', null, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', '[Profile.Data].[Funding.Agreement]', '1', null, '-1', '-40', null, null, null, null, null, 0, null, null, null, null, '''http://vivoweb.org/ontology/core#Agreement''', null, 'Agreement', 'FundingAgreementID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Agreement', null, null, '[Profile.Data].[Funding.Agreement]', '1', null, '-1', '-40', null, null, null, null, null, 0, null, null, null, null, null, null, 'Agreement', 'FundingAgreementID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://profiles.catalyst.harvard.edu/ontology/prns#endDate', '[Profile.Data].[Funding.Agreement]', '1', null, '-1', '-40', null, null, null, null, null, 1, null, null, null, null, 'EndDate', null, 'Grant', 'FundingAgreementID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://profiles.catalyst.harvard.edu/ontology/prns#grandAwardedBy', '[Profile.Data].[Funding.Agreement]', '1', null, '-1', '-40', null, null, null, null, null, 1, null, null, null, null, 'GrantAwardedBy', null, 'Grant', 'FundingAgreementID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://profiles.catalyst.harvard.edu/ontology/prns#principalInvestigatorName', '[Profile.Data].[Funding.Agreement]', '1', null, '-1', '-40', null, null, null, null, null, 1, null, null, null, null, 'PrincipalInvestigatorName', null, 'Grant', 'FundingAgreementID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://profiles.catalyst.harvard.edu/ontology/prns#startDate', '[Profile.Data].[Funding.Agreement]', '1', null, '-1', '-40', null, null, null, null, null, 1, null, null, null, null, 'StartDate', null, 'Grant', 'FundingAgreementID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://purl.org/ontology/bibo/abstract', '[Profile.Data].[Funding.Agreement]', '1', null, '-1', '-40', null, null, null, null, null, 1, null, null, null, null, 'Abstract', null, 'Grant', 'FundingAgreementID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://vivoweb.org/ontology/core#contributingRole', '[Profile.Data].[Funding.Role]', '1', null, '-1', '-40', null, null, null, null, null, 0, null, 'http://vivoweb.org/ontology/core#ResearcherRole', 'ResearcherRole', 'FundingRoleID', null, null, 'Grant', 'FundingAgreementID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://vivoweb.org/ontology/core#sponsorAwardId', '[Profile.Data].[Funding.Agreement]', '1', null, '-1', '-40', null, null, null, null, null, 1, null, null, null, null, 'FundingID', null, 'Grant', 'FundingAgreementID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', '[Profile.Data].[Funding.Agreement]', '1', null, '-1', '-40', null, null, null, null, null, 0, null, null, null, null, '''http://vivoweb.org/ontology/core#Grant''', null, 'Grant', 'FundingAgreementID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Grant', null, 'http://www.w3.org/2000/01/rdf-schema#label', '[Profile.Data].[Funding.Agreement]', '1', null, '-1', '-40', null, null, null, null, null, 1, null, null, null, null, 'AgreementLabel', null, 'Grant', 'FundingAgreementID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Grant', null, null, '[Profile.Data].[Funding.Agreement]', '1', null, '-1', '-40', null, null, null, null, null, 0, null, null, null, null, null, null, 'Grant', 'FundingAgreementID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#ResearcherRole', null, 'http://vivoweb.org/ontology/core#description', '[Profile.Data].[Funding.Role]', '1', null, '-1', '-40', null, null, null, null, null, 1, null, null, null, null, 'RoleDescription', null, 'ResearcherRole', 'FundingRoleID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#ResearcherRole', null, 'http://vivoweb.org/ontology/core#researcherRoleOf', '[Profile.Data].[Funding.Role]', '1', null, '-1', '-40', null, null, null, null, null, 0, null, 'http://xmlns.com/foaf/0.1/Person', 'Person', 'PersonID', null, null, 'ResearcherRole', 'FundingRoleID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#ResearcherRole', null, 'http://vivoweb.org/ontology/core#roleContributesTo', '[Profile.Data].[Funding.Role]', '1', null, '-1', '-40', null, null, null, null, null, 0, null, 'http://vivoweb.org/ontology/core#Grant', 'Grant', 'FundingAgreementID', null, null, 'ResearcherRole', 'FundingRoleID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#ResearcherRole', null, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', '[Profile.Data].[Funding.Role]', '1', null, '-1', '-40', null, null, null, null, null, 0, null, null, null, null, '''http://vivoweb.org/ontology/core#ResearcherRole''', null, 'ResearcherRole', 'FundingRoleID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#ResearcherRole', null, 'http://www.w3.org/2000/01/rdf-schema#label', '[Profile.Data].[Funding.Role]', '1', null, '-1', '-40', null, null, null, null, null, 1, null, null, null, null, 'RoleLabel', null, 'ResearcherRole', 'FundingRoleID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#ResearcherRole', null, null, '[Profile.Data].[Funding.Role]', '1', null, '-1', '-40', null, null, null, null, null, 0, null, null, null, null, null, null, 'ResearcherRole', 'FundingRoleID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Role', null, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', '[Profile.Data].[Funding.Role]', '1', null, '-1', '-40', null, null, null, null, null, 0, null, null, null, null, '''http://vivoweb.org/ontology/core#Role''', null, 'Role', 'FundingRoleID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://vivoweb.org/ontology/core#Role', null, null, '[Profile.Data].[Funding.Role]', '1', null, '-1', '-40', null, null, null, null, null, 0, null, null, null, null, null, null, 'Role', 'FundingRoleID', null, null from [Ontology.].[DataMap]
insert into [Ontology.].[DataMap] ( DataMapID,DataMapGroup, IsAutoFeed, Graph, Class, NetworkProperty, Property, MapTable, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup, oLanguage, oStartDate, oStartDatePrecision, oEndDate, oEndDatePrecision, oObjectType, cInternalID, oClass, oInternalType, oInternalID, oValue, oDataType, sInternalType, sInternalID, cClass, cInternalType) 
select max(DataMapID) + 1, 1, 1, 1, 'http://xmlns.com/foaf/0.1/Person', null, 'http://vivoweb.org/ontology/core#hasResearcherRole', '[Profile.Data].[Funding.Role]', '1', null, '-1', '-40', null, null, null, null, null, 0, null, 'http://vivoweb.org/ontology/core#ResearcherRole', 'ResearcherRole', 'FundingRoleID', null, null, 'Person', 'PersonID', null, null from [Ontology.].[DataMap]

update [Ontology.Presentation].[XML] set  PresentationXML =  
'<Presentation PresentationClass="network">
  <PageOptions Columns="3" />
  <WindowName>{{{//rdf:RDF/rdf:Description[@rdf:about= ../rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{//rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}''s research topics</WindowName>
  <PageColumns>3</PageColumns>
  <PageTitle>{{{//rdf:RDF/rdf:Description[@rdf:about= ../rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{//rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}</PageTitle>
  <PageBackLinkName>Back to Profile</PageBackLinkName>
  <PageBackLinkURL>{{{//rdf:RDF/rdf:Description/rdf:subject/@rdf:resource}}}</PageBackLinkURL>
  <PageSubTitle>Concepts  ({{{//rdf:RDF/rdf:Description/prns:numberOfConnections}}})</PageSubTitle>
  <PageDescription>Concepts are derived automatically from a person''s publications.</PageDescription>
  <PanelTabType>Default</PanelTabType>
  <PanelList>
    <Panel Type="active">
      <Module ID="MiniSearch" />
      <Module ID="MainMenu" />
    </Panel>
    <Panel Type="main" TabSort="0" TabType="Default" Alias="cloud" Name="Cloud">
      <Module ID="NetworkList">
        <ParamList>
          <Param Name="Cloud">true</Param>
        </ParamList>
      </Module>
      <!--<Module ID="NetworkList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description[1]/@rdf:about</Param>
          <Param Name="InfoCaption">In this concept ''cloud'', the sizes of the concepts are based not only on the number of corresponding publications, but also how relevant the concepts are to the overall topics of the publications, how long ago the publications were written, whether the person was the first or senior author, and how many other people have written about the same topic. The largest concepts are those that are most unique to this person.</Param>
          <Param Name="BulletType" />
          <Param Name="Columns">2</Param>
          <Param Name="NetworkListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasConnection/@rdf:resource]</Param>
          <Param Name="CloudWeightNode">prns:connectionWeight</Param>
          <Param Name="ItemURLText">{{{rdf:Description[1]/rdf:object/@rdf:resource}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description[1]/rdf:object/@rdf:resource}}}</Param>
        </ParamList>
      </Module>-->
    </Panel>
    <Panel Type="main" TabSort="1" Alias="categories" Name="Categories">
      <Module ID="NetworkCategories">
        <ParamList>
          <Param Name="InfoCaption">Concepts listed here are grouped according to their ''semantic'' categories. Within each category, up to ten concepts are shown, in decreasing order of relevance.</Param>
          <Param Name="NetworkListNode">rdf:RDF/rdf:Description[@rdf:about= //rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]</Param>
          <Param Name="CategoryPath">//prns:meshSemanticGroupName</Param>
          <Param Name="ItemText">{{{//rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemURL">{{{//rdf:Description/@rdf:about}}}</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="2" Alias="timeline" Name="Timeline">
      <Module ID="NetworkTimeline">
        <ParamList>
          <Param Name="TimelineType">Concept</Param>
          <Param Name="InfoCaption">The timeline below shows the dates (blue tick marks) of publications associated with @SubjectName''s top concepts. The average publication date for each concept is shown as a red circle, illustrating changes in the primary topics that @SubjectName has written about over time.</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="3" Alias="details" Name="Details">
      <Module ID="ApplyXSLT">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="XSLTPath">~/profile/XSLT/ConceptDetail.xslt</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="passive">
      <Module ID="PassiveHeader" />
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Concepts</Param>
          <Param Name="Description">Derived automatically from this person''s publications.</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:hasResearchArea/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) concept(s)</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Co-Authors</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="Description">People in Profiles who have published with this person.</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:coAuthorOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Similar People</Param>
          <Param Name="Description">People who share similar concepts with this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:similarTo/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="CustomViewPersonSameDepartment" />
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Physical Neighbors</Param>
          <Param Name="Description">People whose addresses are nearby this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:physicalNeighborOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
        </ParamList>
      </Module>
    </Panel>
  </PanelList>
</Presentation>' where Type= 'N' and  Subject= 'http://xmlns.com/foaf/0.1/Person' and  Predicate= 'http://vivoweb.org/ontology/core#hasResearchArea' and  Object is null



update [Ontology.Presentation].[XML] set  PresentationXML =  '<Presentation PresentationClass="network">
  <PageOptions Columns="3" />
  <WindowName>{{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}''s co-authors</WindowName>
  <PageColumns>3</PageColumns>
  <PageTitle>{{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}</PageTitle>
  <PageBackLinkName>Back to Profile</PageBackLinkName>
  <PageBackLinkURL>{{{//rdf:RDF/rdf:Description/rdf:subject/@rdf:resource}}}</PageBackLinkURL>
  <PageSubTitle>Co-Authors ({{{//rdf:RDF/rdf:Description/prns:numberOfConnections}}})</PageSubTitle>
  <PageDescription>Co-Authors are people in Profiles who have published together.</PageDescription>
  <PanelTabType>Default</PanelTabType>
  <PanelList>
    <Panel Type="active">
      <Module ID="MiniSearch" />
      <Module ID="MainMenu" />
    </Panel>
    <Panel Type="main" TabSort="0" TabType="Default" Alias="list" Name="List">
      <Module ID="NetworkList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="BulletType">disc</Param>
          <Param Name="Columns">2</Param>
          <Param Name="NetworkListNode">rdf:RDF/rdf:Description[@rdf:about= ../rdf:Description[1]/prns:hasConnection/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdf:object/@rdf:resource}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/rdf:object/@rdf:resource}}}</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="1" Alias="map" Name="Map" DisplayRule="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/prns:latitude">
      <Module ID="NetworkMap">
        <ParamList>
          <Param Name="MapType">CoAuthor</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="2" Alias="radial" Name="Radial">
      <Module ID="NetworkRadial" />
    </Panel>
    <Panel Type="main" TabSort="3" Alias="cluster" Name="Cluster">
      <Module ID="NetworkCluster" />
    </Panel>
    <Panel Type="main" TabSort="4" Alias="timeline" Name="Timeline">
      <Module ID="NetworkTimeline">
        <ParamList>
          <Param Name="TimelineType">CoAuthor</Param>
          <Param Name="InfoCaption">The timeline below shows the dates (blue tick marks) of publications @SubjectName co-authored with other people in Profiles. The average publication date for each co-author is shown as a red circle, illustrating changes in the people that @SubjectName has worked with over time.</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="5" Alias="details" Name="Details">
      <Module ID="ApplyXSLT">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="XSLTPath">~/profile/XSLT/CoAuthorDetail.xslt</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="passive">
      <Module ID="PassiveHeader">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Concepts</Param>
          <Param Name="Description">Derived automatically from this person''s publications.</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:hasResearchArea/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) concept(s)</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Co-Authors</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="Description">People in Profiles who have published with this person.</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:coAuthorOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Similar People</Param>
          <Param Name="Description">People who share similar concepts with this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:similarTo/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="CustomViewPersonSameDepartment" />
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Physical Neighbors</Param>
          <Param Name="Description">People whose addresses are nearby this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:physicalNeighborOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
        </ParamList>
      </Module>
    </Panel>
  </PanelList>
</Presentation>' where Type= 'N' and  Subject= 'http://xmlns.com/foaf/0.1/Person' and  Predicate= 'http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf' and  Object is null


update [Ontology.Presentation].[XML] set  PresentationXML =  '<Presentation PresentationClass="network">
  <PageOptions Columns="3" />
  <WindowName>{{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}''s related authors</WindowName>
  <PageColumns>3</PageColumns>
  <PageTitle>{{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}</PageTitle>
  <PageBackLinkName>Back to Profile</PageBackLinkName>
  <PageBackLinkURL>{{{//rdf:RDF/rdf:Description/rdf:subject/@rdf:resource}}}</PageBackLinkURL>
  <PageSubTitle>Similar People ({{{//rdf:RDF/rdf:Description/prns:numberOfConnections}}})</PageSubTitle>
  <PageDescription>Similar people share similar sets of concepts, but are not necessarily co-authors.</PageDescription>
  <PanelTabType>Default</PanelTabType>
  <PanelList>
    <Panel Type="active">
      <Module ID="MiniSearch" />
      <Module ID="MainMenu" />
    </Panel>
    <Panel Type="main" TabSort="0" TabType="Default" Alias="list" Name="List">
      <Module ID="NetworkList">
        <ParamList>
          <Param Name="InfoCaption">The people in this list are ordered by decreasing similarity.     (<font color="red">*</font> These people are also co-authors.)</Param>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="BulletType">disc</Param>
          <Param Name="Columns">2</Param>
          <Param Name="NetworkListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasConnection/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdf:object/@rdf:resource}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/rdf:object/@rdf:resource}}}</Param>
          <Param Name="SortBy">Weight</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="1" Alias="map" Name="Map" DisplayRule="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/prns:latitude">
      <Module ID="NetworkMap">
        <ParamList>
          <Param Name="MapType">SimilarTo</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="3" Alias="details" Name="Details">
      <Module ID="ApplyXSLT">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="XSLTPath">~/profile/XSLT/SimilarPeopleDetail.xslt</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="passive">
      <Module ID="PassiveHeader">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Concepts</Param>
          <Param Name="Description">Derived automatically from this person''s publications.</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:hasResearchArea/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) concept(s)</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Co-Authors</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="Description">People in Profiles who have published with this person.</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:coAuthorOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Similar People</Param>
          <Param Name="Description">People who share similar concepts with this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:similarTo/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="CustomViewPersonSameDepartment" />
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Physical Neighbors</Param>
          <Param Name="Description">People whose addresses are nearby this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:physicalNeighborOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
        </ParamList>
      </Module>
    </Panel>
  </PanelList>
</Presentation>' where Type= 'N' and  Subject= 'http://xmlns.com/foaf/0.1/Person' and  Predicate= 'http://profiles.catalyst.harvard.edu/ontology/prns#similarTo' and  Object is null


update [Ontology.Presentation].[XML] set  PresentationXML =  '<Presentation PresentationClass="profile">
  <PageOptions Columns="3" />
  <WindowName>{{{rdf:RDF[1]/rdf:Description[1]/foaf:firstName[1]}}} {{{rdf:RDF[1]/rdf:Description[1]/foaf:lastName[1]}}}</WindowName>
  <PageColumns>3</PageColumns>
  <PageTitle>{{{rdf:RDF[1]/rdf:Description[1]/prns:fullName[1]}}}</PageTitle>
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
    <Panel Type="main" TabType="Fixed">
      <Module ID="CustomViewPersonGeneralInfo" />
      <Module ID="ApplyXSLT">
        <ParamList>
          <Param Name="XSLTPath">~/profile/XSLT/OtherPositions.xslt</Param>
        </ParamList>
      </Module>
      <Module ID="PropertyList">
        <ParamList />
      </Module>
      <Module ID="HRFooter" />
    </Panel>
    <Panel Type="passive">
      <Module ID="PassiveHeader">
        <ParamList>
          <Param Name="DisplayRule">rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections</Param>
          <Param Name="DisplayRule">rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections</Param>
          <Param Name="DisplayRule">rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="InfoCaption">Concepts</Param>
          <Param Name="Description">Derived automatically from this person''s publications.</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:hasResearchArea/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) concept(s)</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="InfoCaption">Co-Authors</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="Description">People in Profiles who have published with this person.</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:coAuthorOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="InfoCaption">Similar People</Param>
          <Param Name="Description">People who share similar concepts with this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:similarTo/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="CustomViewPersonSameDepartment" />
      <Module ID="Gadgets">
        <ParamList>
          <Param Name="HTML">
            <div id="gadgets-tools" class="gadgets-gadget-parent" />
          </Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="InfoCaption">Physical Neighbors</Param>
          <Param Name="Description">People whose addresses are nearby this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:physicalNeighborOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
        </ParamList>
      </Module>
    </Panel>
  </PanelList>
  <ExpandRDFList>
    <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
    <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#hasResearcherRole" Limit="1" />
  </ExpandRDFList>
</Presentation>' where Type= 'P' and  Subject= 'http://xmlns.com/foaf/0.1/Person' and  Predicate is null and  Object is null





		 
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