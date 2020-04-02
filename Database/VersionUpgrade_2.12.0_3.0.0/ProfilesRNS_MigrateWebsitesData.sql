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
select * into #websites from [ORNG.].[AppData] where AppID = @appID

update b set b.Value = isnull(b.Value, '') + isnull (c.value, '') + isnull(d.value, '') + isnull (e.value, '') + isnull(f.value, '') + isnull (g.value, '') + isnull(h.value, '') + isnull (i.value, '') + isnull(j.value, '') + isnull (k.value, '') from #websites b 
			--on a.nodeid = b.nodeid and a.keyname = 'links' and b.keyname = 'links.0'
	left join #websites c on b.nodeid = c.nodeid and c.keyname = 'link_1' and b.Keyname = 'link_0'
	left join #websites d on b.nodeid = d.nodeid and d.keyname = 'link_2'
	left join #websites e on b.nodeid = e.nodeid and e.keyname = 'link_3'
	left join #websites f on b.nodeid = f.nodeid and f.keyname = 'link_4'
	left join #websites g on b.nodeid = g.nodeid and g.keyname = 'link_5'
	left join #websites h on b.nodeid = h.nodeid and h.keyname = 'link_6'
	left join #websites i on b.nodeid = i.nodeid and i.keyname = 'link_7'
	left join #websites j on b.nodeid = j.nodeid and j.keyname = 'link_8'
	left join #websites k on b.nodeid = k.nodeid and k.keyname = 'link_9'

delete from #websites where keyname <> 'link_0'

delete from #websites where value = '[]'

--select * from #websites


 ;WITH tmp(NodeID, AppID, DataItem, String, ordering) AS
(
    SELECT
        NodeID,
        AppID,
        LEFT(Value, CHARINDEX('},{', Value + '},{') - 1),
        STUFF(Value, 1, CHARINDEX('},{', Value + '},{'), ''), 0 - len(value)
    FROM #websites
    UNION all

    SELECT
        NodeID,
        AppID,
        LEFT(String, CHARINDEX('},{', String + '},{') - 1),
        STUFF(String, 1, CHARINDEX('},{', String + '},{'), ''), 0 - len(string)
    FROM tmp
    WHERE
        String > ''
		)

SELECT
    NodeID,
    AppID,
    DataItem,
	ordering
	into #tmp2
FROM tmp
ORDER BY NodeID

-- drop table #tmp2

ALTER TABLE #tmp2 ADD link_name varchar(max)
ALTER TABLE #tmp2 ADD link_url varchar(max)
--ALTER TABLE #tmp2 ADD link_date varchar(max)
ALTER TABLE #tmp2 ADD PersonID int 
ALTER TABLE #tmp2 ADD GroupID int 


update #tmp2 set link_name =
SUBSTRING(DataItem, CHARINDEX('"name":"', DataItem) + 8, CHARINDEX('",', DataItem, CHARINDEX('"name":"', DataItem) + 8)  - CHARINDEX('"name":"', DataItem) - 8)
where CHARINDEX('"name":"', DataItem) > 0 AND CHARINDEX('",', DataItem, CHARINDEX('"name":"', DataItem) + 8) > 0

update #tmp2 set link_url =
SUBSTRING(DataItem, CHARINDEX('"url":"', DataItem) + 7, CHARINDEX('"', DataItem, CHARINDEX('"url":"', DataItem) + 7)  - CHARINDEX('"url":"', DataItem) - 7) from #tmp2
where CHARINDEX('"url":"', DataItem) > 0 AND CHARINDEX('"', DataItem, CHARINDEX('"url":"', DataItem) + 7) > 0
/**
update #tmp2 set link_date =
SUBSTRING(DataItem, CHARINDEX('"link_date":"', DataItem) + 13, CHARINDEX('"', DataItem, CHARINDEX('"link_date":"', DataItem) + 13)  - CHARINDEX('"link_date":"', DataItem) - 13) from #tmp2
where CHARINDEX('"link_date":"', DataItem) > 0 AND CHARINDEX('"', DataItem, CHARINDEX('"link_date":"', DataItem) + 13) > 0
**/

update t set t.PersonID = i.internalID from #tmp2 t 
join [RDF.Stage].InternalNodeMap i on 
	t.NodeID = i.NodeID AND i.class='http://xmlns.com/foaf/0.1/Person'

update t set t.GroupID = i.internalID from #tmp2 t 
join [RDF.Stage].InternalNodeMap i on 
	t.NodeID = i.NodeID AND i.class='http://xmlns.com/foaf/0.1/Group'


insert into [Profile.Data].[Person.Websites] (URLID, PersonID, WebPageTitle, URL,  SortOrder)
select newID(), PersonID, link_name, link_url, Row_Number() over (partition by nodeID order by ordering) from #tmp2 where personID is not null

insert into [Profile.Data].[Group.Websites] (URLID, GroupID, WebPageTitle, URL,  SortOrder)
select newID(), GroupID, link_name, link_url, Row_Number() over (partition by nodeID order by ordering) from #tmp2 where GroupID is not null

--select * from #websites
--select * from #tmp2

drop table #websites
drop table #tmp2

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

update [RDF.].Triple set ViewSecurityGroup = -50 where Predicate = @orngwNodeID

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

/***********************
* End of Section 3
* Websites should be fully converted to the new websites module
***********************/
