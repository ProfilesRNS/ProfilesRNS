/*

Run this script on:

	Profiles RNS Version 4.0.0

to update its data to:

	Profiles RNS Version 4.1.0

*** You are recommended to back up your database before running this script!

*** You should review each step of this script to ensure that it will not overwrite any customizations you have made to ProfilesRNS.

*** Make sure you run the ProfilesRNS_Upgrade_Schema.sql file before running this file.
   
*/


/***********************************************************************
*
*                            Filters
*
***********************************************************************/

-- Add the filter update to the nightly jobs
declare @maxStep int, @maxID int
select @maxStep= max (step) from [Framework.].Job where JobGroup = 7
select @maxID= max (JobID) from [Framework.].Job 
insert into [Framework.].Job (JobID, JobGroup, Step, IsActive, Script) values (@maxID + 1, 7, @maxStep + 1, 1, 'EXEC [Profile.Data].[Person.Filter.UpdateFilters]')
GO

--Set existing Filters to other options.
update [Profile.Data].[Person.Filter] set ETLProcedure = '[Profile.Import].[LoadProfilesData]', ETLParams = null, IsActive = 1, SearchDropdown = 'OtherOptions' 
GO


INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Photo', N'Address', 1, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://profiles.catalyst.harvard.edu/ontology/prns#mainImage', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Education and Training', N'Biography', 2, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://vivoweb.org/ontology/core#educationalTraining', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Awards and Honors', N'Biography', 3, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://vivoweb.org/ontology/core#awardOrHonor', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Overview', N'Overview', 4, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://vivoweb.org/ontology/core#overview', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Freetext Keywords', N'Overview', 5, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://vivoweb.org/ontology/core#freetextKeyword', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Webpage', N'Overview', 6, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://vivoweb.org/ontology/core#webpage', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Media Links', N'Overview', 7, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://profiles.catalyst.harvard.edu/ontology/prns#mediaLinks', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Available to Mentor - Students on Research', N'General Mentoring and Job Opportunities', 8, N'[Profile.Data].[Person.Filter.UpdateFilters]/MentoringOverview', N'studentsOnResearch', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Available to Mentor - Students on Career Development', N'General Mentoring and Job Opportunities', 9, N'[Profile.Data].[Person.Filter.UpdateFilters]/MentoringOverview', N'studentsOnCareerDevelopment', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Available to Mentor - Students on Work Life Balance', N'General Mentoring and Job Opportunities', 10, N'[Profile.Data].[Person.Filter.UpdateFilters]/MentoringOverview', N'studentsOnWorkLifeBalance', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Available to Mentor - Faculty on Research', N'General Mentoring and Job Opportunities', 11, N'[Profile.Data].[Person.Filter.UpdateFilters]/MentoringOverview', N'facultyOnResearch', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Available to Mentor - Faculty on Career Development', N'General Mentoring and Job Opportunities', 12, N'[Profile.Data].[Person.Filter.UpdateFilters]/MentoringOverview', N'facultyOnCareerDevelopment', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Available to Mentor - Faculty on Work Life Balance', N'General Mentoring and Job Opportunities', 13, N'[Profile.Data].[Person.Filter.UpdateFilters]/MentoringOverview', N'facultyOnWorkLifeBalance', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Available to Mentor - Residents and Fellows on Research', N'General Mentoring and Job Opportunities', 14, N'[Profile.Data].[Person.Filter.UpdateFilters]/MentoringOverview', N'residentsAndFellowsOnResearch', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Available to Mentor - Residents and Fellows on Career Development', N'General Mentoring and Job Opportunities', 15, N'[Profile.Data].[Person.Filter.UpdateFilters]/MentoringOverview', N'residentsAndFellowsOnCareerDevelopment', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Available to Mentor - Residents and Fellows on Work Life Balance', N'General Mentoring and Job Opportunities', 16, N'[Profile.Data].[Person.Filter.UpdateFilters]/MentoringOverview', N'residentsAndFellowsOnWorkLifeBalance', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Job Opportunities - Hiring Students', N'General Mentoring and Job Opportunities', 17, N'[Profile.Data].[Person.Filter.UpdateFilters]/Mentoring', N'Students', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Job Opportunities - Hiring Faculty', N'General Mentoring and Job Opportunities', 18, N'[Profile.Data].[Person.Filter.UpdateFilters]/Mentoring', N'Faculty', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Job Opportunities - Hiring Fellows and Postdocs', N'General Mentoring and Job Opportunities', 19, N'[Profile.Data].[Person.Filter.UpdateFilters]/Mentoring', N'Fellows', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Job Opportunities - Hiring Research Staff', N'General Mentoring and Job Opportunities', 20, N'[Profile.Data].[Person.Filter.UpdateFilters]/Mentoring', N'Staff', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Research Activities and Funding', N'Research', 21, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://vivoweb.org/ontology/core#hasResearcherRole', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Featured Presentations', N'Featured Content', 22, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://profiles.catalyst.harvard.edu/ontology/plugins#FeaturedPresentations', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Featured Videos', N'Featured Content', 23, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://profiles.catalyst.harvard.edu/ontology/plugins#FeaturedVideos', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'X (formerly Twitter)', N'Featured Content', 24, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://profiles.catalyst.harvard.edu/ontology/plugins#Twitter', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'Publications', N'Bibliographic', 25, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://vivoweb.org/ontology/core#authorInAuthorship', 1, N'Sections')
GO
INSERT [Profile.Data].[Person.Filter] ([PersonFilter], [PersonFilterCategory], [PersonFilterSort], [ETLProcedure], [ETLParams], [IsActive], [SearchDropdown]) VALUES (N'ORCID', N'Identifiers', 26, N'[Profile.Data].[Person.Filter.UpdateFilters]/Sections', N'http://vivoweb.org/ontology/core#orcidId', 1, N'Sections')
GO



/***********************************************************************
*
* If you wish to test the filters you must run the following queries to: 
*    1. Populate the filter data, 
*    2. Generate RDF Data for the filters
*    3. Update the Search Cache
*
* On larger sites this may take some time. 
* We recommend that you look in [Framework.].Job to see how long the 
* EXEC [Search.Cache].[Public.UpdateCache] step (part of Job Group 3)
* takes before running this on your production site as site performance
* may be affected.
*
* All these steps will be run during the nightly jobs. 
* So can be skipped here if preferred
*
***********************************************************************/

/* Populate the Filter data */
exec [Profile.Data].[Person.Filter.UpdateFilters]



/* Create RDF for filters */
CREATE TABLE #sql (
	i INT IDENTITY(0,1) PRIMARY KEY,
	s NVARCHAR(MAX)
)
INSERT INTO #sql (s)
	SELECT	'EXEC [RDF.Stage].ProcessDataMap '
				+'  @DataMapID = '+CAST(DataMapID AS VARCHAR(50))
	FROM (
		SELECT *
			FROM [Ontology.].DataMap
			WHERE MapTable like '%filter%'

	) t
	ORDER BY DataMapID


DECLARE @s NVARCHAR(MAX)
WHILE EXISTS (SELECT * FROM #sql)
BEGIN
	SELECT @s = s
		FROM #sql
		WHERE i = (SELECT MIN(i) FROM #sql)
	print @s
	EXEC sp_executesql @s
	DELETE
		FROM #sql
		WHERE i = (SELECT MIN(i) FROM #sql)
END

/* Update the Search Cache */
EXEC [Search.Cache].[Public.UpdateCache]
	



/***********************************************************************
*
*                            Mentoring
*
***********************************************************************/



/********
* Add items to the ontology
********/
INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('PRNS_1.4', 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupMentoring', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', 'http://www.w3.org/2002/07/owl#Class')

INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('PRNS_1.4', 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupMentoring', 'http://www.w3.org/2000/01/rdf-schema#label', 'Mentoring')

INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('PRNS_1.4', 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', 'http://www.w3.org/2002/07/owl#Class')

INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('PRNS_1.4', 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity', 'http://www.w3.org/2000/01/rdf-schema#label', 'MentoringJobOpportunity')

INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('PRNS_1.4', 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#hasMentoringJobOpportunity', 'http://www.w3.org/2000/01/rdf-schema#label', 'job opportunities')

INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('PRNS_1.4', 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#hasMentoringJobOpportunity', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', 'http://www.w3.org/2002/07/owl#ObjectProperty')

INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('PRNS_1.4', 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#hasMentoringJobOpportunity', 'http://www.w3.org/2000/01/rdf-schema#range', 'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity')

INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('PRNS_1.4', 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringJobOpportunityOf', 'http://www.w3.org/2000/01/rdf-schema#label', 'job opportunities for')

INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('PRNS_1.4', 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringJobOpportunityOf', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', 'http://www.w3.org/2002/07/owl#ObjectProperty')

INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('PRNS_1.4', 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringJobOpportunityOf', 'http://www.w3.org/2000/01/rdf-schema#domain', 'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity')


INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('PRNS_1.4', 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringOverview', 'http://www.w3.org/2000/01/rdf-schema#label', 'mentoring overview')

INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('PRNS_1.4', 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringOverview', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', 'http://www.w3.org/2002/07/owl#ObjectProperty')


EXEC [RDF.Stage].[LoadTriplesFromOntology] @Truncate = 1
EXEC [RDF.Stage].[ProcessTriples]
EXEC [Ontology.].[UpdateDerivedFields]


/*******
* Add the class group, property group and property group properties.
*******/

update [Ontology.].PropertyGroup set SortOrder = SortOrder + 1 where SortOrder > (select SortOrder from [Ontology.].PropertyGroup where PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview')
insert into [Ontology.].PropertyGroup (PropertyGroupURI, SortOrder) values ('http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupMentoring', (select SortOrder + 1 from [Ontology.].PropertyGroup where PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview'))

INSERT INTO [Ontology.].[ClassGroupClass] (ClassGroupURI, ClassURI, SortOrder) 
	VALUES ('http://profiles.catalyst.harvard.edu/ontology/prns#ClassGroupMentoring', 'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity',1)
GO

Insert into [Ontology.].PropertyGroupProperty (PropertyGroupURI, PropertyURI, SortOrder) values ('http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupMentoring', 'http://profiles.catalyst.harvard.edu/ontology/prns#hasMentoringJobOpportunity', 2)
Insert into [Ontology.].PropertyGroupProperty (PropertyGroupURI, PropertyURI, SortOrder) values ('http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupMentoring', 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringOverview', 1)

EXEC [Ontology.].[UpdateDerivedFields]
GO


/********
* Configure the Properties
********/

INSERT INTO [Ontology.].[ClassProperty] (ClassPropertyID, 
		Class, NetworkProperty, Property, 
		IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, 
		CustomDisplay, CustomEdit, ViewSecurityGroup, 
		EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, 
		MinCardinality, MaxCardinality, 
		CustomDisplayModule, CustomEditModule)
	VALUES (9999,
			'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity', NULL, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
			0, NULL, 1, 0, 0,
			0, 0, -1,
			-40, -40, -40, -40, -40, -40,
			0, NULL,
			NULL, NULL)

INSERT INTO [Ontology.].[ClassProperty] (ClassPropertyID, 
		Class, NetworkProperty, Property, 
		IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, 
		CustomDisplay, CustomEdit, ViewSecurityGroup, 
		EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, 
		MinCardinality, MaxCardinality, 
		CustomDisplayModule, CustomEditModule)
	VALUES (9998,
			'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity', NULL, 'http://www.w3.org/2000/01/rdf-schema#label',
			0, NULL, 0, 0, 1,
			0, 0, -1,
			-40, -40, -40, -40, -40, -40,
			0, NULL,
			NULL, NULL)

INSERT INTO [Ontology.].[ClassProperty] (ClassPropertyID, 
		Class, NetworkProperty, Property, 
		IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, 
		CustomDisplay, CustomEdit, ViewSecurityGroup, 
		EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, 
		MinCardinality, MaxCardinality, 
		CustomDisplayModule, CustomEditModule)
	VALUES (9997,
			'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity', NULL, 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringJobOpportunityOf',
			1, NULL, 0, 0, 1,
			0, 0, -1,
			-40, -40, -40, -40, -40, -40,
			0, NULL,
			NULL, NULL)

INSERT INTO [Ontology.].[ClassProperty] (ClassPropertyID, 
		Class, NetworkProperty, Property, 
		IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, 
		CustomDisplay, CustomEdit, ViewSecurityGroup, 
		EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, 
		MinCardinality, MaxCardinality, 
		CustomDisplayModule, CustomEditModule)
	VALUES (9996,
			'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity', NULL, 'http://vivoweb.org/ontology/core#overview',
			1, NULL, 0, 0, 1,
			0, 0, -1,
			-40, -40, -40, -40, -40, -40,
			0, NULL,
			NULL, NULL)

INSERT INTO [Ontology.].[ClassProperty] (ClassPropertyID, 
		Class, NetworkProperty, Property, 
		IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, 
		CustomDisplay, CustomEdit, ViewSecurityGroup, 
		EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, 
		MinCardinality, MaxCardinality, 
		CustomDisplayModule, CustomEditModule)
	VALUES (9995,
			'http://xmlns.com/foaf/0.1/Person', NULL, 'http://profiles.catalyst.harvard.edu/ontology/prns#hasMentoringJobOpportunity',
			1, NULL, 0, 0, 1,
			0, 0, -1,
			-20, -20, -20, -20, -20, -20,
			0, NULL,
			NULL, NULL)


INSERT INTO [Ontology.].[ClassProperty] (ClassPropertyID, 
		Class, NetworkProperty, Property, 
		IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, 
		CustomDisplay, CustomEdit, ViewSecurityGroup, 
		EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, 
		MinCardinality, MaxCardinality, 
		CustomDisplayModule, CustomEditModule)
	VALUES (9994,
			'http://xmlns.com/foaf/0.1/Person', NULL, 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringOverview',
			1, null, 0, 0, 1,
			0, 0, -1,
			-20, -20, -20, -20, -20, -20,
			0, 1,
			NULL, NULL)

EXEC [Ontology.].[UpdateDerivedFields]
GO


/********************
*
* Add to the datamap
*
*********************/
insert into [Ontology.].DataMap (DataMapID, DataMapGroup, IsAutoFeed, Graph, Class, Property, MapTable, sInternalType, sInternalID, oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
values (9000, 1, 1, 1, 'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity', null, '[Profile.Data].[Person.Mentoring.JobOpportunities]', 'MentoringJobOpportunity', 'OpportunityID', 0, 1, null, -1, -40)


insert into [Ontology.].DataMap (DataMapID, DataMapGroup, IsAutoFeed, Graph, Class, Property, MapTable, sInternalType, sInternalID, oValue, oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
values (9001, 1, 1, 1, 'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', '[Profile.Data].[Person.Mentoring.JobOpportunities]', 'MentoringJobOpportunity', 'OpportunityID', '''http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity''', 0, 1, null, -1, -40)

insert into [Ontology.].DataMap (DataMapID, DataMapGroup, IsAutoFeed, Graph, Class, Property, MapTable, sInternalType, sInternalID, oValue, oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
values (9002, 1, 1, 1, 'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity', 'http://www.w3.org/2000/01/rdf-schema#label', '[Profile.Data].[Person.Mentoring.JobOpportunities]', 'MentoringJobOpportunity', 'OpportunityID', 'Title', 1, 1, null, -1, -40)

insert into [Ontology.].DataMap (DataMapID, DataMapGroup, IsAutoFeed, Graph, Class, Property, MapTable, sInternalType, sInternalID, oValue, oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
values (9003, 1, 1, 1, 'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity', 'http://vivoweb.org/ontology/core#overview', '[Profile.Data].[Person.Mentoring.JobOpportunities]', 'MentoringJobOpportunity', 'OpportunityID', 'Description', 1, 1, null, -1, -40)

insert into [Ontology.].DataMap (DataMapID, DataMapGroup, IsAutoFeed, Graph, Class, Property, MapTable, sInternalType, sInternalID, oClass, oInternalType, oInternalID, oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
values (9004, 1, 1, 1, 'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity', 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringJobOpportunityOf', '[Profile.Data].[Person.Mentoring.JobOpportunities]', 'MentoringJobOpportunity', 'OpportunityID', 'http://xmlns.com/foaf/0.1/Person', 'Person', 'PersonID', 0, 1, 'SortOrder', -1, -40)

insert into [Ontology.].DataMap (DataMapID, DataMapGroup, IsAutoFeed, Graph, Class, Property, MapTable, sInternalType, sInternalID, oClass, oInternalType, oInternalID, oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
values (9005, 1, 1, 1, 'http://xmlns.com/foaf/0.1/Person', 'http://profiles.catalyst.harvard.edu/ontology/prns#hasMentoringJobOpportunity', '[Profile.Data].[Person.Mentoring.JobOpportunities]', 'Person', 'PersonID', 'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity', 'MentoringJobOpportunity', 'OpportunityID', 0, 1, 'SortOrder', -1, -40)

insert into [Ontology.].DataMap (DataMapID, DataMapGroup, IsAutoFeed, Graph, Class, Property, MapTable, sInternalType, sInternalID, oValue, oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
values (9006, 1, 1, 1, 'http://xmlns.com/foaf/0.1/Person', 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringOverview', '[Profile.Data].[Person.Mentoring.Overview]', 'Person', 'PersonID', 'OverviewText', 1, 1, null, -1, -40)

EXEC [Ontology.].UpdateDerivedFields
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 9000, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 9001, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 9002, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 9003, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 9004, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 9005, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 9006, @ShowCounts = 1


/*****************
*
* Map the edit and display modules
*
******************/

declare @PresentationID int
select @PresentationID = PresentationID from [Ontology.Presentation].XML where Type = 'P' and Subject = 'http://xmlns.com/foaf/0.1/Person' and Predicate is null and Object is null
declare @sortOrder int
select @sortOrder = isnull(max(SortOrder), 50) from [Display.].[ModuleMapping] where PresentationID = @PresentationID and tab = 'data' and GroupLabel = 'Mentoring'
if @sortOrder%10 = 9
BEGIN
	update [Display.].[ModuleMapping] set SortOrder = SortOrder + 10 where SortOrder > @sortOrder and PresentationID = @PresentationID and tab = 'data'
END
insert into [Display.].[ModuleMapping] (PresentationID, ClassProperty, DisplayModule, DataStoredProc, Tab, LayoutModule, GroupLabel, PropertyLabel, ToolTip, Panel, SortOrder, LayoutDataModule, PresentationType, PresentationSubject, PresentationPredicate, PresentationObject)
	values (@PresentationID, 'http://profiles.catalyst.harvard.edu/ontology/prns#hasMentoringJobOpportunity', 'Person.Mentoring.JobOpportunities', '[Display.Module].[Person.Mentoring.JobOpportunities]', 'data', 1, 'Mentoring', 'job opportunities', null, 'main', @sortOrder + 2, 0, 'P', 'http://xmlns.com/foaf/0.1/Person', null, null)
insert into [Display.].[ModuleMapping] (PresentationID, ClassProperty, DisplayModule, DataStoredProc, Tab, LayoutModule, GroupLabel, PropertyLabel, ToolTip, Panel, SortOrder, LayoutDataModule, PresentationType, PresentationSubject, PresentationPredicate, PresentationObject)
	values (@PresentationID, 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringOverview', 'Person.Mentoring.Overview', '[Display.Module].[Person.Mentoring.Overview]', 'data', 1, 'Mentoring', 'mentoring overview', null, 'main', @sortOrder + 1, 0, 'P', 'http://xmlns.com/foaf/0.1/Person', null, null)

update a set a._ClassPropertyID = b.NodeID from [Display.].[ModuleMapping] a join [RDF.].Node b on [RDF.].fnValueHash(null, null, ClassProperty) = ValueHash and a.ClassProperty is not null
GO

insert into [Edit.Module].[EditClassProperty] (Class, Property, AddUpdateStoredProcedure, GetDataStoredProcedure, _ClassNode, _PropertyNode)
	values ('http://xmlns.com/foaf/0.1/Person', 'http://profiles.catalyst.harvard.edu/ontology/prns#hasMentoringJobOpportunity', '[Edit.Module].[Person.Mentoring.JobOpportunities]', '[Edit.Module].[Person.Mentoring.JobOpportunities.getData]', [RDF.].fnURI2NodeID('http://xmlns.com/foaf/0.1/Person'), [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#hasMentoringJobOpportunity'))

insert into [Edit.Module].[EditClassProperty] (Class, Property, AddUpdateStoredProcedure, GetDataStoredProcedure, _ClassNode, _PropertyNode)
	values ('http://xmlns.com/foaf/0.1/Person', 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringOverview', '[Edit.Module].[Person.Mentoring.Overview]', '[Edit.Module].[Person.Mentoring.Overview.getData]', [RDF.].fnURI2NodeID('http://xmlns.com/foaf/0.1/Person'), [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#mentoringOverview'))


/******************************
*
*   Update all derived fields
*
******************************/
EXEC [Ontology.].[UpdateDerivedFields]
EXEC [Ontology.].[UpdateCounts]
EXEC [Ontology.].CleanUp @action='UpdateIDs'

GO