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
update [RDF.].Triple set ViewSecurityGroup = -50 where Predicate = @orngwNodeID

select @wNodeID = NodeID from [RDF.].[Node] where value in ('http://profiles.catalyst.harvard.edu/ontology/plugins#Twitter')
select @orngwNodeID = NodeID from [RDF.].[Node] where value in ('http://orng.info/ontology/orng#hasTwitter')
insert into [RDF.Security].NodeProperty (NodeID, Property, ViewSecurityGroup)
	select nodeID, @wNodeID, ViewSecurityGroup from [RDF.Security].NodeProperty where Property = @orngwNodeID
update [RDF.].Triple set ViewSecurityGroup = -50 where Predicate = @orngwNodeID

select @wNodeID = NodeID from [RDF.].[Node] where value in ('http://profiles.catalyst.harvard.edu/ontology/plugins#FeaturedPresentations')
select @orngwNodeID = NodeID from [RDF.].[Node] where value in ('http://orng.info/ontology/orng#hasSlideShare')
insert into [RDF.Security].NodeProperty (NodeID, Property, ViewSecurityGroup)
	select nodeID, @wNodeID, ViewSecurityGroup from [RDF.Security].NodeProperty where Property = @orngwNodeID
update [RDF.].Triple set ViewSecurityGroup = -50 where Predicate = @orngwNodeID
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
SET @curVideos = CURSOR FOR select NodeID, [Value] from [ORNG.].[AppData] where appID = @vAppID
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