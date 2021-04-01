/*

Run this script on:

	Profiles RNS Version 3.0.0

to update its data to:

	Profiles RNS Version 3.1.0

*** You are recommended to back up your database before running this script!

*** You should review each step of this script to ensure that it will not overwrite any customizations you have made to ProfilesRNS.

*** Make sure you run the ProfilesRNS_Upgrade_Schema.sql file before running this file.
   
*/

-- Set the Display module for Awards and Honors and Educational Training in Ontology..ClassProperty rather than [Ontology.].[PropertyGroupProperty]
update [Ontology.].[ClassProperty] set  CustomDisplayModule =  '<Module ID="ApplyXSLT"><ParamList><Param Name="XSLTPath">~/profile/XSLT/Awards.xslt</Param></ParamList></Module>' where Class= 'http://xmlns.com/foaf/0.1/Person' and  NetworkProperty is null and  Property= 'http://vivoweb.org/ontology/core#awardOrHonor'
update [Ontology.].[ClassProperty] set  CustomDisplayModule =  '<Module ID="ApplyXSLT"><ParamList><Param Name="XSLTPath">~/profile/XSLT/EducationalTraining.xslt</Param></ParamList></Module>' where Class= 'http://xmlns.com/foaf/0.1/Person' and  NetworkProperty is null and  Property= 'http://vivoweb.org/ontology/core#educationalTraining'

update [Ontology.].[PropertyGroupProperty] set CustomDisplayModule = null where PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupBiography' and PropertyURI = 'http://vivoweb.org/ontology/core#awardOrHonor'
update [Ontology.].[PropertyGroupProperty] set CustomDisplayModule = null where PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupBiography' and PropertyURI = 'http://vivoweb.org/ontology/core#educationalTraining'


-- Enable Basic ORCID module by default. This will not be enabled if the ORCID Integration Module is active.
update [Ontology.].[ClassProperty] set  CustomEditModule =  '<Module ID="CustomEditBasicORCID"/>', EditSecurityGroup =  -20, EditPermissionsSecurityGroup =  -20, EditExistingSecurityGroup =  -20, EditAddNewSecurityGroup =  -20, ViewSecurityGroup =  -1 where Class= 'http://xmlns.com/foaf/0.1/Person' and  NetworkProperty is null and  Property= 'http://vivoweb.org/ontology/core#orcidId' and ViewSecurityGroup = -50


-- Populate Author2Person table nightly for coauthor links.
declare @stepID int
select @stepID = step from [Framework.].Job where JobGroup = 7 and Script = 'EXEC [Profile.Data].[Publication.Entity.UpdateEntity]'
update [Framework.].Job set step = step + 1 where step >= @stepID and JobGroup = 7
insert into [Framework.].Job (JobID, JobGroup, Step, IsActive, Script) select max(JobID) + 1, 7, @stepID, 1, 'EXEC [Profile.Data].[Publication.Pubmed.UpdateAuthor2Person]'  from [Framework.].Job


-- Populate the PRNSWebservice.Options table
update [Profile.Import].[PRNSWebservice.Options]  set [batchSize] = 10000, [GetPostDataProc] = '[Profile.Data].[Publication.Pubmed.GetPMIDsforBibliometrics]', [ImportDataProc] = '[Profile.Data].[Publication.Pubmed.ParseBibliometricResults]' where [job] = 'bibliometrics'

update [Profile.Import].[PRNSWebservice.Options]  set [GetPostDataProc] = '[Profile.Import].[GoogleWebservice.GetGeocodeAPIData]', [ImportDataProc] = '[Profile.Import].[GoogleWebservice.ParseGeocodeResults]' where [job] = 'geocode'

INSERT [Profile.Import].[PRNSWebservice.Options] ([job], [url], [options], [apiKey], [logLevel], [batchSize], [GetPostDataProc], [ImportDataProc]) VALUES (N'Funding', N'http://profiles.catalyst.harvard.edu/services/NIHGrants/FindFunding.asp', NULL, NULL, 0, 100, N'[Profile.Import].[PRNSWebservice.Funding.GetPersonInfoForDisambiguation]', N'[Profile.Import].[PRNSWebservice.Funding.ParseDisambiguationXML]')
GO
INSERT [Profile.Import].[PRNSWebservice.Options] ([job], [url], [options], [apiKey], [logLevel], [batchSize], [GetPostDataProc], [ImportDataProc]) VALUES (N'GetPubMedXML', N'http://profiles.catalyst.harvard.edu/services/GetPMIDs/GetPubMedXML.asp', N'GetOnlyNewXML=True', NULL, 0, NULL, N'[Profile.Import].[PRNSWebservice.PubMed.GetAllPMIDs]', N'[Profile.Import].[Publication.Pubmed.AddPubMedXML]')
GO
INSERT [Profile.Import].[PRNSWebservice.Options] ([job], [url], [options], [apiKey], [logLevel], [batchSize], [GetPostDataProc], [ImportDataProc]) VALUES (N'GetPubMedXML_All', N'http://profiles.catalyst.harvard.edu/services/GetPMIDs/GetPubMedXML.asp', N'GetOnlyNewXML=FALSE', NULL, 0, NULL, N'[Profile.Import].[PRNSWebservice.PubMed.GetAllPMIDs]', N'[Profile.Import].[Publication.Pubmed.AddPubMedXML]')
GO
INSERT [Profile.Import].[PRNSWebservice.Options] ([job], [url], [options], [apiKey], [logLevel], [batchSize], [GetPostDataProc], [ImportDataProc]) VALUES (N'PubMedDisambiguation_GetPubs', N'http://profiles.catalyst.harvard.edu/services/GetPMIDs/default.asp', NULL, NULL, 0, NULL, N'[Profile.Import].[PRNSWebservice.PubMed.GetPersonInfoForDisambiguation]', N'[Profile.Import].[PRNSWebservice.PubMed.ImportDisambiguationResults]')
GO


/******************************
*
*   Update all derived fields
*
******************************/
EXEC [Ontology.].[UpdateDerivedFields]
EXEC [Ontology.].[UpdateCounts]
EXEC [Ontology.].CleanUp @action='UpdateIDs'

GO