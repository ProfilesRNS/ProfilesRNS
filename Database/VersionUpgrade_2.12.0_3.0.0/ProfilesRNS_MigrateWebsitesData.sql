/*******************************
*
* Convert Websites Data. 
* If you did not have the open social websites app installed you can skip this script
*
* This Script is split into 3 sections
* 1. Convert website data to the new format
* 2. Convert security settings to the new nodes
* 3. Generate the RDF
*
* Run each step one at a time, and confirm that there were no errors before going on to the next step.
* After step 1, we recommend looking in the websites tables and confirming the websites are correct for a few people
* before progressing to step 2.
* 
* Ensure step 2 completes without errors before progressing to step 3. Any errors during steps 1 and 2 will be 
* pushed into the RDF data during step 3, and will be much harder to fix after running step 3
*
*******************************/

declare @appID int
select @appID = AppID from [ORNG.].[Apps] where Url = 'https://profiles.ucsf.edu/apps_2.6/Links.xml' 

create table #websites (
	nodeid bigint,
	link_name varchar(max),
	link_url varchar(max),
	sort_order int,
	PersonID int,
	GroupID int 
)

insert into #websites (nodeid, link_name, link_url, sort_order)
select NodeID, 
	SUBSTRING([Value], CHARINDEX('"name":"', [Value]) + 8, CHARINDEX('",', [Value], CHARINDEX('"name":"', [Value]) + 8)  - CHARINDEX('"name":"', [Value]) - 8),
	SUBSTRING([Value], CHARINDEX('"url":"', [Value]) + 7, CHARINDEX('"', [Value], CHARINDEX('"url":"', [Value]) + 7)  - CHARINDEX('"url":"', [Value]) - 7),
	substring(keyname, 6, len(keyname) - 5) + 1 as sortorder 
		from [ORNG.].[AppData] where AppID = @appID and Keyname <> 'links_count'


update t set t.PersonID = i.internalID from #websites t 
join [RDF.Stage].InternalNodeMap i on 
	t.NodeID = i.NodeID AND i.class='http://xmlns.com/foaf/0.1/Person'

update t set t.GroupID = i.internalID from #websites t 
join [RDF.Stage].InternalNodeMap i on 
	t.NodeID = i.NodeID AND i.class='http://xmlns.com/foaf/0.1/Group'


insert into [Profile.Data].[Person.Websites] (URLID, PersonID, WebPageTitle, URL,  SortOrder)
select newID(), PersonID, link_name, link_url, sort_order from #websites where personID is not null

insert into [Profile.Data].[Group.Websites] (URLID, GroupID, WebPageTitle, URL,  SortOrder)
select newID(), GroupID, link_name, link_url, sort_order from #websites where GroupID is not null

--select * from #websites

drop table #websites

/***********************
* End of Section 1
* Websites data has been converted to the new format, 
* This data can be inspected using the following queries:
*    select * from [Profile.Data].[Person.Websites]
*    select * from [Profile.Data].[Group.Websites]
* 
* If this section ran without errors, and the data looks good
* you can progress to section 2.
***********************/




declare @wNodeID bigint, @orngwNodeID bigint
select @wNodeID = NodeID from [RDF.].[Node] where value in ('http://vivoweb.org/ontology/core#webpage')
select @orngwNodeID = NodeID from [RDF.].[Node] where value in ('http://orng.info/ontology/orng#hasLinks')

insert into [RDF.Security].NodeProperty (NodeID, Property, ViewSecurityGroup)
select nodeID, @wNodeID, ViewSecurityGroup from [RDF.Security].NodeProperty where Property = @orngwNodeID

--update [RDF.].Triple set ViewSecurityGroup = -50 where Predicate = @orngwNodeID

update [Ontology.].ClassProperty set
	ViewSecurityGroup = -50,
	EditSecurityGroup = -50,
	EditPermissionsSecurityGroup = -50,
	EditExistingSecurityGroup = -50,
	EditAddNewSecurityGroup = -50,
	EditAddExistingSecurityGroup = -50,
	EditDeleteSecurityGroup = -50 
	where property = 'http://orng.info/ontology/orng#hasLinks'

/***********************
* End of Section 2
* Security groups should be correct at this point
*
* If this section ran correcty, you can run section 3
***********************/

declare @d1 int, @d2 int, @d3 int, @d4 int, @d5 int, @d6 int, @d7 int
select @d1 = DataMapID from [Ontology.].DataMap where class = 'http://vivoweb.org/ontology/core#URLLink' AND Property is null
select @d2 = DataMapID from [Ontology.].DataMap where class = 'http://vivoweb.org/ontology/core#URLLink' AND Property = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
select @d3 = DataMapID from [Ontology.].DataMap where class = 'http://vivoweb.org/ontology/core#URLLink' AND Property = 'http://www.w3.org/2000/01/rdf-schema#label'
select @d4 = DataMapID from [Ontology.].DataMap where class = 'http://vivoweb.org/ontology/core#URLLink' AND Property = 'http://profiles.catalyst.harvard.edu/ontology/prns#publicationDate'
select @d5 = DataMapID from [Ontology.].DataMap where class = 'http://vivoweb.org/ontology/core#URLLink' AND Property = 'http://vivoweb.org/ontology/core#linkAnchorText'
select @d6 = DataMapID from [Ontology.].DataMap where class = 'http://xmlns.com/foaf/0.1/Group' AND Property = 'http://vivoweb.org/ontology/core#webpage'
select @d7 = DataMapID from [Ontology.].DataMap where class = 'http://xmlns.com/foaf/0.1/Person' AND Property = 'http://vivoweb.org/ontology/core#webpage'

EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = @d1, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = @d2, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = @d3, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = @d4, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = @d5, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = @d6, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = @d7, @ShowCounts = 1


declare @webpageOldNodeID bigint, @webpageNewNodeID bigint, @mediaOldNodeID bigint, @mediaNewNodeID bigint
select @webpageOldNodeID = nodeID from [RDF.].Node where value = 'http://orng.info/ontology/orng#hasLinks'
select @webpageNewNodeID = nodeID from [RDF.].Node where value = 'http://vivoweb.org/ontology/core#webpag'
 
update t1 set t1.ViewSecurityGroup = isnull(t2.ViewSecurityGroup, 0) from [RDF.].Triple t1 
left join [RDF.].Triple t2
on t1.Subject = t2.Subject and t1.Predicate = @webpageNewNodeID and t2.Predicate = @webpageOldNodeID
where t1.Predicate = @webpageNewNodeID

update [RDF.].Triple set ViewSecurityGroup = -50 where Predicate = @webpageOldNodeID





/***********************
* End of Section 3
* Websites should be fully converted to the new websites module
***********************/