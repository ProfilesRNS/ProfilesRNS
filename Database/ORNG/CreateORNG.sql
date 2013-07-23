---------------------------------------------------------------------------------------------------------------------
--
--	Create Schema
--
---------------------------------------------------------------------------------------------------------------------

CREATE SCHEMA [ORNG.]
GO

/****** Object:  Table [ORNG.].[Visibility]    Script Date: 05/17/2013 13:23:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG.].[Visibility](
	[visibility] [nvarchar](50) NOT NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_ORNG.Visibility] PRIMARY KEY CLUSTERED 
(
	[visibility] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

---------------------------------------------------------------------------------------------------------------------
--
--	Create Tables and Indexes
--
---------------------------------------------------------------------------------------------------------------------
/****** Object:  Table [ORNG.].[Apps]    Script Date: 05/17/2013 13:22:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG.].[Apps](
	[appId] [int] NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[url] [nvarchar](255) NULL,
	[PersonFilterID] [int] NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK__app] PRIMARY KEY CLUSTERED 
(
	[appId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [ORNG.].[Apps] ADD  CONSTRAINT [DF_orng_apps_enabled]  DEFAULT ((1)) FOR [enabled]
GO

/****** Object:  Table [ORNG.].[AppViews]    Script Date: 05/17/2013 13:23:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG.].[AppViews](
	[appId] [int] NOT NULL,
	[page] [nvarchar](50) NULL,
	[view] [nvarchar](50) NULL,
	[chromeId] [nvarchar](50) NULL,
	[visibility] [nvarchar](50) NULL,
	[display_order] [int] NULL,
	[opt_params] [nvarchar](255) NULL
) ON [PRIMARY]

GO

ALTER TABLE [ORNG.].[AppViews]  WITH CHECK ADD  CONSTRAINT [FK_orng_app_views_apps] FOREIGN KEY([appId])
REFERENCES [ORNG.].[Apps] ([appId])
GO

ALTER TABLE [ORNG.].[AppViews] CHECK CONSTRAINT [FK_orng_app_views_apps]
GO

/****** Object:  Table [ORNG.].[AppRegistry]    Script Date: 05/17/2013 13:23:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG.].[AppRegistry](
	[nodeid] [bigint] NOT NULL,
	[appId] [int] NOT NULL,
	[visibility] [nvarchar](50) NULL,
	[createdDT] [datetime] NULL
) ON [PRIMARY]

GO

ALTER TABLE [ORNG.].[AppRegistry]  WITH CHECK ADD  CONSTRAINT [FK_AppRegistry_Visibility] FOREIGN KEY([visibility])
REFERENCES [ORNG.].[Visibility] ([visibility])
GO

ALTER TABLE [ORNG.].[AppRegistry] CHECK CONSTRAINT [FK_AppRegistry_Visibility]
GO

ALTER TABLE [ORNG.].[AppRegistry] ADD  CONSTRAINT [DF_orng_app_registry_createdDT]  DEFAULT (getdate()) FOR [createdDT]
GO

/****** Object:  Index [IX_AppRegistry_uri]    Script Date: 05/17/2013 13:26:51 ******/
CREATE CLUSTERED INDEX [IX_AppRegistry_uri] ON [ORNG.].[AppRegistry] 
(
	[nodeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Table [ORNG.].[AppData]    Script Date: 05/17/2013 13:24:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG.].[AppData](
	[nodeId] [bigint] NOT NULL,
	[appId] [int] NOT NULL,
	[keyname] [nvarchar](255) NOT NULL,
	[value] [nvarchar](4000) NULL,
	[createdDT] [datetime] NULL,
	[updatedDT] [datetime] NULL
) ON [PRIMARY]

GO

ALTER TABLE [ORNG.].[AppData] ADD  CONSTRAINT [DF_orng_appdata_createdDT]  DEFAULT (getdate()) FOR [createdDT]
GO

ALTER TABLE [ORNG.].[AppData] ADD  CONSTRAINT [DF_orng_appdata_updatedDT]  DEFAULT (getdate()) FOR [updatedDT]
GO

/****** Object:  Index [IDX_PersonApp]    Script Date: 05/17/2013 13:27:31 ******/
CREATE NONCLUSTERED INDEX [IDX_PersonApp] ON [ORNG.].[AppData] 
(
	[nodeid] ASC,
	[appId] ASC
)
INCLUDE ( [keyname],
[value]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Table [ORNG.].[Activity]    Script Date: 05/17/2013 13:24:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG.].[Activity](
	[activityId] [int] IDENTITY(1,1) NOT NULL,
	[nodeid] [bigint] NULL,
	[appId] [int] NULL,
	[createdDT] [datetime] NULL,
	[activity] [xml] NULL,
 CONSTRAINT [PK__activity] PRIMARY KEY CLUSTERED 
(
	[activityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [ORNG.].[Activity] ADD  CONSTRAINT [DF_orng_activity_createdDT]  DEFAULT (getdate()) FOR [createdDT]
GO

/****** Object:  Table [ORNG.].[Messages]    Script Date: 05/17/2013 13:25:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG.].[Messages](
	[msgId] [nvarchar](255) NOT NULL,
	[senderNodeId] [bigint] NULL,
	[recipientNodeId] [bigint] NULL,
	[coll] [nvarchar](255) NULL,
	[title] [nvarchar](255) NULL,
	[body] [nvarchar](4000) NULL,
	[createdDT] [datetime] NULL
) ON [PRIMARY]

GO

ALTER TABLE [ORNG.].[Messages] ADD  CONSTRAINT [DF_orng_messages_createdDT]  DEFAULT (getdate()) FOR [createdDT]
GO

---------------------------------------------------------------------------------------------------------------------
--
--	Create Stored Procedures
--
---------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [ORNG.].[ReadRegistry]    Script Date: 07/22/2013 11:10:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [ORNG.].[ReadRegistry](@uri nvarchar(255),@appId INT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @nodeid bigint
	
	SELECT @nodeid = [RDF.].[fnURI2NodeID](@uri);

	SELECT visibility from [ORNG.].AppRegistry where appId=@appId AND nodeId = @nodeid 
END

GO

/****** Object:  StoredProcedure [ORNG.].[RegisterAppPerson]    Script Date: 06/25/2013 13:36:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORNG.].[RegisterAppPerson](@uri nvarchar(255),@appId INT, @visibility nvarchar(50))
As
BEGIN
	SET NOCOUNT ON
		BEGIN TRAN		
			DECLARE @NodeID bigint
			DECLARE @PERSON_FILTER_ID INT
			DECLARE @PERSON_ID INT
				
			SELECT @NodeID = [RDF.].[fnURI2NodeID](@uri)
			SELECT @PERSON_FILTER_ID = (SELECT PersonFilterID FROM Apps WHERE appId = @appId)
			SELECT @PERSON_ID = cast(InternalID as INT) from [RDF.Stage].InternalNodeMap where
				NodeID = @NodeID

			IF ((SELECT COUNT(*) FROM AppRegistry WHERE nodeId= @nodeId AND appId = @appId) = 0)
				INSERT [ORNG.].[AppRegistry](nodeId, appid, [visibility]) values (@NodeID, @appId, @visibility)
			ELSE 
				UPDATE [ORNG.].[AppRegistry] set [visibility] = @visibility where nodeId = @NodeID and appId = @appId 
								
			IF (@PERSON_FILTER_ID IS NOT NULL) 
				BEGIN
					IF (@visibility = 'Public') 
						INSERT [Profile.Data].[Person.FilterRelationship](PersonID, personFilterId) values (@PERSON_ID, @PERSON_FILTER_ID)
					ELSE						
						DELETE FROM [Profile.Data].[Person.FilterRelationship] WHERE PersonID = @PERSON_ID AND personFilterId = @PERSON_FILTER_ID
				END
		COMMIT
END

GO

/****** Object:  StoredProcedure [ORNG.].[ReadAppData]    Script Date: 06/25/2013 13:38:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [ORNG.].[ReadAppData](@uri nvarchar(255),@appId INT, @keyname nvarchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @nodeid bigint
	
	SELECT @nodeid = [RDF.].[fnURI2NodeID](@uri);

	SELECT value from [ORNG.].AppData where appId=@appId AND nodeId = @nodeid AND keyName = @keyname
END
GO
/****** Object:  StoredProcedure [ORNG.].[DeleteAppData]    Script Date: 06/25/2013 13:39:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORNG.].[DeleteAppData](@uri nvarchar(255),@appId INT, @keyname nvarchar(255))
As
BEGIN
	SET NOCOUNT ON
	DECLARE @nodeid bigint
	
	SELECT @nodeid = [RDF.].[fnURI2NodeID](@uri);
	DELETE [ORNG.].[AppData] WHERE nodeId = @nodeId AND appId = @appId and keyname = @keyName
END		

GO
/****** Object:  StoredProcedure [ORNG.].[UpsertAppData]    Script Date: 06/25/2013 13:40:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORNG.].[UpsertAppData](@uri nvarchar(255),@appId INT, @keyname nvarchar(255),@value nvarchar(4000))
As
BEGIN
	SET NOCOUNT ON
	DECLARE @nodeid bigint
	
	SELECT @nodeid = [RDF.].[fnURI2NodeID](@uri);
	IF (SELECT COUNT(*) FROM AppData WHERE nodeId = @nodeId AND appId = @appId and keyname = @keyName) > 0
		UPDATE [ORNG.].[AppData] set [value] = @value, updatedDT = GETDATE() WHERE nodeId = @nodeId AND appId = @appId and keyname = @keyName
	ELSE
		INSERT [ORNG.].[AppData] (nodeId, appId, keyname, [value]) values (@nodeId, @appId, @keyname, @value)
END		
GO
/****** Object:  StoredProcedure [ORNG.].[ReadActivity]    Script Date: 06/25/2013 13:42:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [ORNG.].[ReadActivity](@uri nvarchar(255),@appId INT, @activityId INT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @nodeid bigint
	
	select @nodeid = [RDF.].[fnURI2NodeID](@uri);

	select activity from [ORNG.].Activity where nodeId = @nodeid AND appId=@appId AND activityId =@activityId
END
GO
/****** Object:  StoredProcedure [ORNG.].[ReadAllActivities]    Script Date: 06/25/2013 13:42:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [ORNG.].[ReadAllActivities](@uri nvarchar(255),@appId INT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @nodeid bigint
	
	select @nodeid = [RDF.].[fnURI2NodeID](@uri);

	IF (@appId IS NULL)
		select activity from [ORNG.].Activity where nodeId = @nodeid
	ELSE		
		select activity from [ORNG.].Activity where nodeId = @nodeid AND appId=@appId 
END
GO
/****** Object:  StoredProcedure [ORNG.].[DeleteActivity]    Script Date: 06/25/2013 13:43:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORNG.].[DeleteActivity](@uri nvarchar(255),@appId INT, @activityId int)
As
BEGIN
	SET NOCOUNT ON
	DECLARE @nodeid bigint
	
	select @nodeid = [RDF.].[fnURI2NodeID](@uri);	
	DELETE [ORNG.].[Activity] WHERE nodeId = @nodeId AND appId = @appId and activityId = @activityId
END		
GO
/****** Object:  StoredProcedure [ORNG.].[InsertActivity]    Script Date: 06/25/2013 13:43:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORNG.].[InsertActivity](@uri nvarchar(255),@appId INT, @activityId int, @activity XML)
As
BEGIN
	SET NOCOUNT ON
	DECLARE @nodeid bigint
	
	select @nodeid = [RDF.].[fnURI2NodeID](@uri);	
	IF (@activityId IS NULL OR @activityId < 0)
		INSERT [ORNG.].[Activity] (nodeId, appId, activity) values (@nodeid, @appId, @activity)
	ELSE 		
		INSERT [ORNG.].[Activity] (activityId, nodeId, appId, activity) values (@activityId, @nodeid, @appId, @activity)
END		
GO
/****** Object:  StoredProcedure [ORNG.].[ReadMessages]    Script Date: 06/25/2013 13:44:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [ORNG.].[ReadMessages](@recipientUri nvarchar(255),@coll nvarchar(255), @msgIds nvarchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @recipientNodeId bigint
	DECLARE @baseURI nvarchar(255)
	DECLARE @sql nvarchar(255)
	
	select @recipientNodeId = [RDF.].[fnURI2NodeID](@recipientUri)
	select @baseURI = [Value] FROM [Framework.].[Parameter] WHERE ParameterID = 'baseURI';
	
	SET @sql = 'SELECT msgId, coll, body, title, ''' + @baseURI  + '''+ senderNodeId , ''' + @baseURI + '''+ recipientNodeId ' +
		'FROM [ORNG.].[Messages] WHERE recipientNodeId = ' + @recipientNodeId
	IF (@coll IS NOT NULL)
		SET @sql = @sql + ' AND coll = ''' + @coll + '''';
	IF (@msgIds IS NOT NULL)
		SET @sql = @sql + ' AND msgId IN ' + @msgIds
		
	EXEC @sql;
END
GO
/****** Object:  StoredProcedure [ORNG.].[ReadMessageCollections]    Script Date: 06/25/2013 13:44:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [ORNG.].[ReadMessageCollections](@recipientUri nvarchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @recipientNodeId bigint
	
	select @recipientNodeId = [RDF.].[fnURI2NodeID](@recipientUri)

	SELECT DISTINCT coll	FROM [ORNG.].[Messages] WHERE recipientNodeId =  @recipientNodeId
END
GO
/****** Object:  StoredProcedure [ORNG.].[InsertMessage]    Script Date: 06/25/2013 13:45:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORNG.].[InsertMessage](@msgId nvarchar(255),@coll nvarchar(255), @title nvarchar(255), @body nvarchar(255),
										@senderUri nvarchar(255), @recipientUri nvarchar(255))
As
BEGIN
	SET NOCOUNT ON
	DECLARE @senderNodeId bigint
	DECLARE @recipientNodeId bigint
	
	select @senderNodeId = [RDF.].[fnURI2NodeID](@senderUri)
	select @recipientNodeId = [RDF.].[fnURI2NodeID](@recipientUri)
	
	INSERT [ORNG.].[Messages]  (msgId, coll, title, body, senderNodeId, recipientNodeId) 
			VALUES (@msgId, @coll, @title, @body, @senderNodeId, @recipientNodeId)
END		
GO

---------------------------------------------------------------------------------------------------------------------
--
--	Create Required Data
--
---------------------------------------------------------------------------------------------------------------------
INSERT [ORNG.].[Visibility] VALUES('IsRegistered','Visible if the viewer has an entry for this gadget in the AppRegistry table. Useful for powerful "limited use" gadgets.');
INSERT [ORNG.].[Visibility] VALUES('Nobody','Visible to nobody, not even the owner or proxies.');
INSERT [ORNG.].[Visibility] VALUES('Private','Visible only to the owner, their proxies and default proxies.');
INSERT [ORNG.].[Visibility] VALUES('Public','Visible to any viewer, including robots and anonymous.');
INSERT [ORNG.].[Visibility] VALUES('RegistryDefined','Visibility is determined by the owner, as defined by the visibility column in the AppRegistry table.');
INSERT [ORNG.].[Visibility] VALUES('Users','Only visible to logged in users.');


