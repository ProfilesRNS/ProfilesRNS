/*******************************
*
* Convert Twitter, YouTube and Slideshare data. 
* If you did not have the open social installed you can skip this script
*
*
*******************************/


declare @wNodeID bigint, @orngwNodeID bigint

select @wNodeID = NodeID from [RDF.].[Node] where value in ('http://profiles.catalyst.harvard.edu/ontology/plugins#FeaturedVideos')
select @orngwNodeID = NodeID from [RDF.].[Node] where value in ('http://orng.info/ontology/orng#hasYouTube')
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
	where property = 'http://orng.info/ontology/orng#hasYouTube'



GO

/****** Object:  Table [ORNG.].[AppData]    Script Date: 4/10/2020 4:44:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE #tmpVideos(
	[NodeID] [bigint] NOT NULL,
	[AppID] [int] NOT NULL,
	[Keyname] [nvarchar](255) NOT NULL,
	[Value] [nvarchar](max) NULL,
	[CreatedDT] [datetime] NULL,
	[UpdatedDT] [datetime] NULL
) ON [PRIMARY]


declare @youtubeAppID int
SELECT @youtubeAppID = appID from [ORNG.].Apps where Name = 'Featured Videos'
insert into #tmpVideos select * from [ORNG.].[AppData] where AppID = @youtubeAppID
delete from #tmpVideos where [Value] = '---DATA CHUNKED BY ORNG SYSTEM---'

update b set b.Value = isnull(b.Value, '') + isnull (c.value, '') + isnull(d.value, '') + isnull (e.value, '') + isnull(f.value, '') + isnull (g.value, '') + isnull(h.value, '') + isnull (i.value, '') + isnull(j.value, '') + isnull (k.value, '') from #tmpVideos b 
	join #tmpVideos c on b.nodeid = c.nodeid and c.keyname = 'videos.1' and b.Keyname = 'videos.0'
	left join #tmpVideos d on b.nodeid = d.nodeid and d.keyname = 'videos.2'
	left join #tmpVideos e on b.nodeid = e.nodeid and e.keyname = 'videos.3'
	left join #tmpVideos f on b.nodeid = f.nodeid and f.keyname = 'videos.4'
	left join #tmpVideos g on b.nodeid = g.nodeid and g.keyname = 'videos.5'
	left join #tmpVideos h on b.nodeid = h.nodeid and h.keyname = 'videos.6'
	left join #tmpVideos i on b.nodeid = i.nodeid and i.keyname = 'videos.7'
	left join #tmpVideos j on b.nodeid = j.nodeid and j.keyname = 'videos.8'
	left join #tmpVideos k on b.nodeid = k.nodeid and k.keyname = 'videos.9'

update #tmpVideos set Keyname = 'videos' where keyname = 'videos.0'

delete from #tmpVideos where keyname <> 'videos'


select @wNodeID = NodeID from [RDF.].[Node] where value in ('http://profiles.catalyst.harvard.edu/ontology/plugins#Twitter')
select @orngwNodeID = NodeID from [RDF.].[Node] where value in ('http://orng.info/ontology/orng#hasTwitter')
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
	where property = 'http://orng.info/ontology/orng#hasTwitter'


select @wNodeID = NodeID from [RDF.].[Node] where value in ('http://profiles.catalyst.harvard.edu/ontology/plugins#FeaturedPresentations')
select @orngwNodeID = NodeID from [RDF.].[Node] where value in ('http://orng.info/ontology/orng#hasSlideShare')
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
	where property = 'http://orng.info/ontology/orng#hasSlideShare'

GO

DECLARE @NodeID BIGINT
DECLARE @tValue nvarchar(max)
DECLARE @tAppID int
SELECT @tAppID = appID from [ORNG.].Apps where Name = 'Twitter'
DECLARE @curTwitter CURSOR
SET @curTwitter = CURSOR FOR select NodeID, [Value] from [ORNG.].[AppData] where appID = @tAppID
OPEN @curTwitter
	FETCH NEXT
	FROM @curTwitter INTO @NodeID, @tValue
	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec [Profile.Module].[GenericRDF.AddEditPluginData] @name='Twitter',@NodeID=@NodeID,@Data=@tValue,@SearchableData=@tValue
		FETCH NEXT
		FROM @curTwitter INTO @NodeID, @tValue
	END
CLOSE @curTwitter
DEALLOCATE @curTwitter
GO

DECLARE @vNodeID BIGINT
DECLARE @vValue nvarchar(max)
DECLARE @vAppID int
SELECT @vAppID = appID from [ORNG.].Apps where Name = 'Featured Videos'
DECLARE @curVideos CURSOR
SET @curVideos = CURSOR FOR select NodeID, [Value] from #tmpVideos where appID = @vAppID
OPEN @curVideos
	FETCH NEXT
	FROM @curVideos INTO @vNodeID, @vValue
	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec [Profile.Module].[GenericRDF.AddEditPluginData] @name='FeaturedVideos',@NodeID=@vNodeID,@Data=@vValue,@SearchableData=''
		FETCH NEXT
		FROM @curVideos INTO @vNodeID, @vValue
	END
CLOSE @curVideos
DEALLOCATE @curVideos
GO

drop table #tmpVideos

DECLARE @sNodeID BIGINT
DECLARE @sValue nvarchar(max)
DECLARE @sAppID int
SELECT @sAppID = appID from [ORNG.].Apps where Name = 'Featured Presentations'
DECLARE @curSlideShare CURSOR
SET @curSlideShare = CURSOR FOR select NodeID, [Value] from [ORNG.].[AppData] where appID = 101
OPEN @curSlideShare
	FETCH NEXT
	FROM @curSlideShare INTO @sNodeID, @sValue
	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec [Profile.Module].[GenericRDF.AddEditPluginData] @name='FeaturedPresentations',@NodeID=@sNodeID,@Data=@sValue,@SearchableData=''
		FETCH NEXT
		FROM @curSlideShare INTO @sNodeID, @sValue
	END
CLOSE @curSlideShare
DEALLOCATE @curSlideShare
GO


declare @videoOldNodeID bigint, @videoNewNodeID bigint, @slideshareOldNodeID bigint, @slideshareNewNodeID bigint, @twitterOldNodeID bigint, @twitterNewNodeID bigint
select @twitterNewNodeID = nodeID from [RDF.].Node where value = 'http://profiles.catalyst.harvard.edu/ontology/plugins#Twitter'
select @slideshareNewNodeID = nodeID from [RDF.].Node where value = 'http://profiles.catalyst.harvard.edu/ontology/plugins#FeaturedPresentations'
select @videoNewNodeID = nodeID from [RDF.].Node where value = 'http://profiles.catalyst.harvard.edu/ontology/plugins#FeaturedVideos'
select @twitterOldNodeID = nodeID from [RDF.].Node where value = 'http://orng.info/ontology/orng#hasTwitter'
select @slideshareOldNodeID = nodeID from [RDF.].Node where value = 'http://orng.info/ontology/orng#hasSlideShare'
select @videoOldNodeID = nodeID from [RDF.].Node where value = 'http://orng.info/ontology/orng#hasYouTube'

update t1 set t1.ViewSecurityGroup = isnull(t2.ViewSecurityGroup, 0) from [RDF.].Triple t1 
left join [RDF.].Triple t2
on t1.Subject = t2.Subject and t1.Predicate = @twitterNewNodeID and t2.Predicate = @twitterOldNodeID
where t1.Predicate = @twitterNewNodeID

update [RDF.].Triple set ViewSecurityGroup = -50 where Predicate = @twitterOldNodeID

update t1 set t1.ViewSecurityGroup = isnull(t2.ViewSecurityGroup, 0) from [RDF.].Triple t1 
left join [RDF.].Triple t2
on t1.Subject = t2.Subject and t1.Predicate = @slideshareNewNodeID and t2.Predicate = @slideshareOldNodeID
where t1.Predicate = @slideshareNewNodeID
 
update [RDF.].Triple set ViewSecurityGroup = -50 where Predicate = @slideshareOldNodeID

update t1 set t1.ViewSecurityGroup = isnull(t2.ViewSecurityGroup, 0) from [RDF.].Triple t1 
left join [RDF.].Triple t2
on t1.Subject = t2.Subject and t1.Predicate = @videoNewNodeID and t2.Predicate = @videoOldNodeID
where t1.Predicate = @videoNewNodeID

update [RDF.].Triple set ViewSecurityGroup = -50 where Predicate = @videoOldNodeID
