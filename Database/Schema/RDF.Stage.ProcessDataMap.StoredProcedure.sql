SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.Stage].[ProcessDataMap]
	@DataMapID INT = NULL,
	@DataMapGroupMin INT = NULL,
	@DataMapGroupMax INT = NULL,
	@AutoFeedOnly BIT = 1,
	@InternalIdIn NVARCHAR(MAX) = NULL,
	@ShowCounts BIT = 0,
	@SaveLog BIT = 1,
	@TurnOffIndexing BIT = 1
AS
 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--*******************************************************************************************
	--*******************************************************************************************
	-- Create a queue of DataMap items to process
	--*******************************************************************************************
	--*******************************************************************************************

	CREATE TABLE #Queue(DataMapID  INT )
	IF @DataMapID IS NULL
	BEGIN
		INSERT INTO #Queue
		SELECT DataMapID			
			FROM [Ontology.].DataMap
			WHERE DataMapGroup >= IsNull(@DataMapGroupMin,DataMapGroup)
				AND DataMapGroup <= IsNull(@DataMapGroupMax,DataMapGroup)
				AND (@AutoFeedOnly = 0 OR IsAutoFeed = 1)
			ORDER BY DataMapID
	END 
	ELSE 
	BEGIN
		INSERT INTO #Queue
		SELECT @DataMapID  
	END

	--*******************************************************************************************
	--*******************************************************************************************
	-- Loop through each DataMap item in the queue
	--*******************************************************************************************
	--*******************************************************************************************

	-- Turn off real-time indexing
	IF @TurnOffIndexing = 1
		ALTER FULLTEXT INDEX ON [RDF.].Node SET CHANGE_TRACKING OFF 

	-- Do the loop	
	WHILE (SELECT COUNT(*) FROM #Queue) > 0
	BEGIN
		
		SELECT @DataMapID = (SELECT TOP 1 DataMapID FROM #Queue)
		
		DECLARE @StartDate DATETIME
		SELECT @StartDate = GetDate()

		DECLARE @NewNodes BIGINT
		DECLARE @UpdatedNodes BIGINT
		DECLARE @ExistingNodes BIGINT
		DECLARE @DeletedNodes BIGINT
		DECLARE @TotalNodes BIGINT
		DECLARE @NewTriples BIGINT
		DECLARE @UpdatedTriples BIGINT
		DECLARE @ExistingTriples BIGINT
		DECLARE @DeletedTriples BIGINT
		DECLARE @TotalTriples BIGINT

		SELECT	@NewNodes=0, @UpdatedNodes=0, @ExistingNodes=0, @DeletedNodes=0, @TotalNodes=0,
				@NewTriples=0, @UpdatedTriples=0, @ExistingTriples=0, @DeletedTriples=0, @TotalTriples=0

		DECLARE @s nvarchar(max)

		DECLARE @baseURI NVARCHAR(400)
		SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

		-- Determine the DataMapType and validate the record
		DECLARE @DataMapType INT
		SELECT @DataMapType = (CASE	WHEN (MapTable IS NULL) OR (Class IS NULL) OR (sInternalType IS NULL) OR (sInternalID IS NULL) THEN NULL
									WHEN Property IS NULL THEN 1
									WHEN (NetworkProperty IS NULL) 
											AND (oClass IS NOT NULL) AND (oInternalID IS NOT NULL) AND (oInternalID IS NOT NULL) THEN 2
									WHEN (NetworkProperty IS NULL) 
											AND (oValue IS NOT NULL) THEN 3
									WHEN (NetworkProperty IS NOT NULL) 
											AND (cInternalID IS NOT NULL) AND (cInternalID IS NOT NULL) AND (cInternalID IS NOT NULL) 
											AND (oClass IS NOT NULL) AND (oInternalID IS NOT NULL) AND (oInternalID IS NOT NULL) THEN 4
									WHEN (NetworkProperty IS NOT NULL) 
											AND (cInternalID IS NOT NULL) AND (cInternalID IS NOT NULL) AND (cInternalID IS NOT NULL) 
											AND (oValue IS NOT NULL) THEN 5
									ELSE NULL END)
			FROM [Ontology.].DataMap
			WHERE DataMapID = @DataMapID


		--*******************************************************************************************
		--*******************************************************************************************
		-- DataMapType = 1 (Nodes)
		--*******************************************************************************************
		--*******************************************************************************************

		IF @DataMapType = 1
		BEGIN

			SELECT @s = ''
					+'SELECT Class, InternalType, InternalID, '
					+'		coalesce(max(case when ViewSecurityGroup < 0 then ViewSecurityGroup else null end),max(ViewSecurityGroup),-1) ViewSecurityGroup, '
					+'		coalesce(max(case when EditSecurityGroup < 0 then EditSecurityGroup else null end),max(EditSecurityGroup),-40) EditSecurityGroup, '
					+'		NULL InternalHash '
					--+'		HASHBYTES(''sha1'',N''"''+CAST(replace(Class+N''^^''+InternalType+N''^^''+InternalID,N''"'',N''\"'') AS NVARCHAR(MAX))+N''"'') InternalHash '
					+'	FROM ('
					+'		SELECT '
					+'			'''+replace(Class,'''','')+''' Class,'
					+'			'''+replace(sInternalType,'''','')+''' InternalType,'
					+'			CAST('+sInternalID+' AS NVARCHAR(300)) InternalID,'
					+'			'+IsNull(ViewSecurityGroup,'NULL')+' ViewSecurityGroup,'
					+'			'+IsNull(EditSecurityGroup,'NULL')+' EditSecurityGroup'
					+'		FROM '+MapTable
					+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'WHERE '+sInternalID+' IN ('+@InternalIdIn+')' ELSE '' END)
					+'	) t'
					+'	WHERE Class IS NOT NULL AND InternalType IS NOT NULL AND InternalID IS NOT NULL '
					+'	GROUP BY Class, InternalType, InternalID '
				FROM [Ontology.].DataMap
				WHERE DataMapID = @DataMapID

			-- Get the nodes
			CREATE TABLE #Node (
				Class nvarchar(400),
				InternalType nvarchar(300),
				InternalID nvarchar(100),
				ViewSecurityGroup bigint,
				EditSecurityGroup bigint,
				InternalHash binary(20)
			)
			INSERT INTO #Node (Class, InternalType, InternalID, ViewSecurityGroup, EditSecurityGroup, InternalHash)
				EXEC sp_executesql @s
			SELECT @TotalNodes = @@ROWCOUNT

			CREATE NONCLUSTERED INDEX idx_ClassTypeID on #Node(Class,InternalType,InternalID)

			-- Update security groups of deleted nodes
			IF @InternalIdIn IS NULL
			BEGIN
				UPDATE n
					SET	n.ViewSecurityGroup = 0,
						n.EditSecurityGroup = -50
					FROM [RDF.Stage].InternalNodeMap m 
						INNER JOIN [Ontology.].DataMap o ON m.Class = o.Class AND m.InternalType = o.sInternalType and o.DataMapID = @DataMapID
						INNER JOIN [RDF.].Node n ON m.NodeID = n.NodeID
						LEFT OUTER JOIN #Node x ON m.Class = x.Class AND m.InternalType = x.InternalType and m.InternalID = x.InternalID
					WHERE x.Class IS NULL
			END
			SELECT @DeletedNodes = @@ROWCOUNT

			-- Update security groups of existing nodes if needed
			UPDATE n
				SET	n.ViewSecurityGroup = IsNull(x.ViewSecurityGroup,n.ViewSecurityGroup),
					n.EditSecurityGroup = IsNull(x.EditSecurityGroup,n.EditSecurityGroup)
				FROM [RDF.Stage].InternalNodeMap m 
					INNER JOIN #Node x ON m.Class = x.Class AND m.InternalType = x.InternalType and m.InternalID = x.InternalID
					INNER JOIN [RDF.].Node n ON m.NodeID = n.NodeID
						AND (n.ViewSecurityGroup <> IsNull(x.ViewSecurityGroup,n.ViewSecurityGroup)
								OR n.EditSecurityGroup <> IsNull(x.EditSecurityGroup,n.EditSecurityGroup))
			SELECT @UpdatedNodes = @@ROWCOUNT

			-- Create new nodes
			INSERT INTO [RDF.Stage].InternalNodeMap (Class, InternalType, InternalID, ViewSecurityGroup, EditSecurityGroup, Status, InternalHash)
				SELECT Class, InternalType, InternalID, IsNull(ViewSecurityGroup,-1), IsNull(EditSecurityGroup,-40), 0 Status,
						HASHBYTES('sha1',N'"'+CAST(replace(Class+N'^^'+InternalType+N'^^'+InternalID,N'"',N'\"') AS NVARCHAR(4000))+N'"') InternalHash
					FROM #Node x
					WHERE NOT EXISTS (
						SELECT *
						FROM [RDF.Stage].InternalNodeMap m
						WHERE m.Class = x.Class AND m.InternalType = x.InternalType and m.InternalID = x.InternalID
					)
			INSERT INTO [RDF.].Node (ValueHash, Language, DataType, Value, InternalNodeMapID, ObjectType, ViewSecurityGroup, EditSecurityGroup)
				SELECT InternalHash, NULL, NULL, Class+N'^^'+InternalType+N'^^'+InternalID, InternalNodeMapID, 0, ViewSecurityGroup, EditSecurityGroup
					FROM [RDF.Stage].InternalNodeMap
					WHERE Status = 0
			UPDATE m
				SET	m.NodeID = n.NodeID, 
					m.ValueHash = HASHBYTES('sha1',N'"'+@baseURI+CAST(n.NodeID AS NVARCHAR(50))+N'"')
				FROM [RDF.Stage].InternalNodeMap m, [RDF.].Node n
				WHERE m.Status = 0 AND m.InternalHash = n.ValueHash
			UPDATE n
				SET n.ValueHash = m.ValueHash, n.Value = @baseURI+CAST(n.NodeID AS NVARCHAR(50))
				FROM [RDF.Stage].InternalNodeMap m, [RDF.].Node n
				WHERE m.Status = 0 AND m.NodeID = n.NodeID
			UPDATE [RDF.Stage].InternalNodeMap
				SET ViewSecurityGroup = NULL, EditSecurityGroup = NULL, Status = 3
				WHERE Status = 0
			SELECT @NewNodes = @@ROWCOUNT
			
			SELECT @ExistingNodes = @TotalNodes - @NewNodes

			DROP TABLE #Node

		END

		--*******************************************************************************************
		--*******************************************************************************************
		-- DataMapType IN (2,3,4,5) (Triples)
		--*******************************************************************************************
		--*******************************************************************************************

		IF @DataMapType IN (2,3,4,5)
		BEGIN
			CREATE TABLE #Triple (
				Subject bigint,
				Predicate bigint,
				Object bigint,
				TripleID bigint,
				Language nvarchar(255),
				DataType nvarchar(255),
				Value nvarchar(max),
				ValueHash binary(20),
				Weight float,
				SortOrder int,
				ObjectType bit,
				ViewSecurityGroup bigint,
				EditSecurityGroup bigint,
				ReitificationTripleID bigint,
				Reitification bigint,
				TripleHash binary(20),
				Graph bigint,
				Status tinyint
			)
			CREATE NONCLUSTERED INDEX idx_status on #Triple(Status)

			/*
			Statuses:
			0 - Update triple
			1 - Delete triple
			2 - New triple from entity
			3 - New triple from value
			4 - New triple from reitification and entity
			5 - New triple from reitification and value
			*/		

			DECLARE @ObjectType BIT
			DECLARE @PropertyNode BIGINT
			SELECT @ObjectType = oObjectType, @PropertyNode = _PropertyNode
				FROM [Ontology.].DataMap
				WHERE DataMapID = @DataMapID
		
			SELECT @s = '
						SELECT 
							'''+replace(Class,'''','')+''' sClass,
							'''+replace(sInternalType,'''','')+''' sInternalType,
							CAST('+sInternalID+' AS NVARCHAR(300)) sInternalID,
							'+IsNull(cast(_NetworkPropertyNode as nvarchar(50)),'NULL')+' NetworkPredicate,
							'+cast(_PropertyNode as nvarchar(50))+' predicate,
							'+IsNull(''''+replace(cClass,'''','')+'''','NULL')+' cClass,
							'+IsNull(''''+replace(cInternalType,'''','')+'''','NULL')+' cInternalType,
							CAST('+IsNull(cInternalID,'NULL')+' AS NVARCHAR(300)) cInternalID,
							'+IsNull(''''+replace(oClass,'''','')+'''','NULL')+' oClass,
							'+IsNull(''''+replace(oInternalType,'''','')+'''','NULL')+' oInternalType,
							CAST('+IsNull(oInternalID,'NULL')+' AS NVARCHAR(300)) oInternalID,
							CAST('+IsNull(''''+replace(oLanguage,'''','')+'''','NULL')+' AS NVARCHAR(255)) Language,
							CAST('+IsNull(''''+replace(oDataType,'''','')+'''','NULL')+' AS NVARCHAR(255)) DataType,
							CAST('+IsNull(oValue,'NULL')+' AS NVARCHAR(MAX)) Value,
							'+IsNull(ViewSecurityGroup,'NULL')+' ViewSecurityGroup,
							'+IsNull(EditSecurityGroup,'NULL')+' EditSecurityGroup,
							IsNull('+IsNull(Weight,1)+',1) Weight,
							'+IsNull(cast(Graph as varchar(50)),'NULL')+' Graph,
							'+(CASE WHEN @DataMapType IN (3,5) THEN 'HASHBYTES(''sha1'',CONVERT(nvarchar(4000),N''"''+replace(isnull(CAST('+IsNull(oValue,'NULL')+' AS NVARCHAR(MAX)),N''''),N''"'',N''\"'')+''"''+IsNull(N''"@''+replace(CAST('+IsNull(''''+replace(oLanguage,'''','')+'''','NULL')+' AS NVARCHAR(255)),N''@'',N''''),N'''')+IsNull(N''"^^''+replace(CAST('+IsNull(''''+replace(oDataType,'''','')+'''','NULL')+' AS NVARCHAR(255)),N''^'',N''''),N''''))) ValueHash, ' ELSE '' END)+'
							ROW_NUMBER() OVER (PARTITION BY '+sInternalID+'
								ORDER BY '+IsNull(OrderBy+',','')+coalesce(oInternalID+',','IsNull('+oValue+',NULL),','')+sInternalID+IsNull(','+cInternalID,'')+') SortOrder
						FROM '+MapTable
						+(CASE	WHEN @InternalIdIn IS NOT NULL AND @DataMapType IN (3,5) 
									THEN ' WHERE ('+sInternalID+' IN ('+@InternalIdIn+')) AND (IsNull(CAST('+IsNull(oValue,'NULL')+' AS NVARCHAR(MAX)),'''') <> '''') ' 
								WHEN @InternalIdIn IS NOT NULL
									THEN ' WHERE '+sInternalID+' IN ('+@InternalIdIn+')'
								WHEN @DataMapType IN (3,5)
									THEN ' WHERE IsNull(CAST('+IsNull(oValue,'NULL')+' AS NVARCHAR(MAX)),'''') <> '''' '
								ELSE '' 
							END)
				FROM [Ontology.].DataMap
				WHERE DataMapID = @DataMapID


			IF @DataMapType = 200
				SELECT @s = '
					CREATE TABLE #Temp (
											sClass NVARCHAR(400),
											sInternalType NVARCHAR(300),
											sInternalID NVARCHAR(100),
											NetworkPredicate BIGINT,
											predicate BIGINT,
											cClass NVARCHAR(400),
											cInternalType NVARCHAR(300),
											cInternalID NVARCHAR(100),
											oClass NVARCHAR(400),
											oInternalType NVARCHAR(300),
											oInternalID NVARCHAR(100),
											Language NVARCHAR(255),
											DataType NVARCHAR(255),
											Value NVARCHAR(MAX),
											ViewSecurityGroup BIGINT,
											EditSecurityGroup BIGINT,
											Weight FLOAT,
											Graph BIGINT, 
											SortOrder INT
										)
					INSERT INTO #Temp
						' + @s + ' ;
					'+(CASE WHEN @InternalIdIn IS NOT NULL THEN '
					CREATE TABLE #Temp2 (NodeID BIGINT Primary Key)
					INSERT INTO #Temp2
						SELECT NodeID
							FROM [RDF.Stage].InternalNodeMap s
							WHERE s.Class='''+Class+''' AND s.InternalType='''+sInternalType+''' AND s.NodeID IS NOT NULL
								AND s.InternalID IN ('+@InternalIdIn+')
					' ELSE '' END)+'
					;WITH a AS (
						SELECT s.NodeID Subject, x.Predicate, o.NodeID Object, x.Weight, x.SortOrder, 
								IsNull(p.ViewSecurityGroup,x.ViewSecurityGroup) ViewSecurityGroup, x.Graph
						FROM #Temp x
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=x.sClass AND s.InternalType=x.sInternalType AND s.InternalID=x.sInternalID AND s.NodeID IS NOT NULL
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class=x.oClass AND o.InternalType=x.oInternalType AND o.InternalID=x.oInternalID AND o.NodeID IS NOT NULL
							LEFT OUTER JOIN [RDF.Security].NodeProperty p
								ON p.NodeID = s.NodeID AND p.Property = '+CAST(@PropertyNode as varchar(50))+'
					), b AS (
						SELECT t.*
						FROM '+(CASE WHEN @InternalIdIn IS NOT NULL THEN '#Temp2' ELSE '[RDF.Stage].InternalNodeMap' END)+' s
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class='''+oClass+''' AND o.InternalType='''+oInternalType+''' AND o.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = '+cast(_PropertyNode as varchar(50))+' AND t.Object = o.NodeID
						'+(CASE WHEN @InternalIdIn IS NOT NULL THEN '' ELSE 'WHERE s.Class='''+Class+''' AND s.InternalType='''+sInternalType+''' AND s.NodeID IS NOT NULL' END)+'
					)
					SELECT a.Subject, a.Predicate, a.Object, b.TripleID, 
							null Language, null DataType, null Value, null ValueHash,
							a.Weight, a.SortOrder, 0 ObjectType, a.ViewSecurityGroup, null EditSecurityGroup,
							null ReitificationTripleID, b.Reitification, b.TripleHash, a.Graph,
							(CASE	WHEN b.TripleID IS NULL THEN 2 
									WHEN a.Subject IS NULL THEN 1 
									ELSE 0 END) Status
						FROM a FULL OUTER JOIN b
								ON a.Subject = b.Subject AND a.Object = b.Object
						WHERE	a.Subject IS NULL
								OR b.TripleID IS NULL
								OR a.Weight <> b.Weight
								OR a.SortOrder <> b.SortOrder
								OR a.ViewSecurityGroup <> b.ViewSecurityGroup
					UNION ALL
					SELECT COUNT(*),NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,100 FROM #Temp
					'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'OPTION (FORCE ORDER)' ELSE '' END)	 
				FROM [Ontology.].DataMap
				WHERE DataMapID = @DataMapID



	 
			IF @DataMapType = 2
				SELECT @s = '
					CREATE TABLE #Temp (
											sClass NVARCHAR(400),
											sInternalType NVARCHAR(300),
											sInternalID NVARCHAR(100),
											NetworkPredicate BIGINT,
											predicate BIGINT,
											cClass NVARCHAR(400),
											cInternalType NVARCHAR(300),
											cInternalID NVARCHAR(100),
											oClass NVARCHAR(400),
											oInternalType NVARCHAR(300),
											oInternalID NVARCHAR(100),
											Language NVARCHAR(255),
											DataType NVARCHAR(255),
											Value NVARCHAR(MAX),
											ViewSecurityGroup BIGINT,
											EditSecurityGroup BIGINT,
											Weight FLOAT,
											Graph BIGINT, 
											SortOrder INT
										)
					INSERT INTO #Temp
						' + @s + ' ;
					;WITH a AS (
						SELECT s.NodeID Subject, x.Predicate, o.NodeID Object, x.Weight, x.SortOrder, 
								IsNull(p.ViewSecurityGroup,x.ViewSecurityGroup) ViewSecurityGroup, x.Graph
						FROM #Temp x
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=x.sClass AND s.InternalType=x.sInternalType AND s.InternalID=x.sInternalID AND s.NodeID IS NOT NULL
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class=x.oClass AND o.InternalType=x.oInternalType AND o.InternalID=x.oInternalID AND o.NodeID IS NOT NULL
							LEFT OUTER JOIN [RDF.Security].NodeProperty p
								ON p.NodeID = s.NodeID AND p.Property = '+CAST(@PropertyNode as varchar(50))+'
					), b AS (
						SELECT t.*
						FROM [RDF.Stage].InternalNodeMap s
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class='''+oClass+''' AND o.InternalType='''+oInternalType+''' AND o.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = '+cast(_PropertyNode as varchar(50))+' AND t.Object = o.NodeID
						WHERE s.Class='''+Class+''' AND s.InternalType='''+sInternalType+''' AND s.NodeID IS NOT NULL
							'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'
					)
					SELECT a.Subject, a.Predicate, a.Object, b.TripleID, 
							null Language, null DataType, null Value, null ValueHash,
							a.Weight, a.SortOrder, 0 ObjectType, a.ViewSecurityGroup, null EditSecurityGroup,
							null ReitificationTripleID, b.Reitification, b.TripleHash, a.Graph,
							(CASE	WHEN b.TripleID IS NULL THEN 2 
									WHEN a.Subject IS NULL THEN 1 
									ELSE 0 END) Status
						FROM a FULL OUTER JOIN b
								ON a.Subject = b.Subject AND a.Object = b.Object
						WHERE	a.Subject IS NULL
								OR b.TripleID IS NULL
								OR a.Weight <> b.Weight
								OR a.SortOrder <> b.SortOrder
								OR a.ViewSecurityGroup <> b.ViewSecurityGroup
					UNION ALL
					SELECT COUNT(*),NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,100 FROM #Temp
					'	 
				FROM [Ontology.].DataMap
				WHERE DataMapID = @DataMapID

/*
						SELECT t.*
						FROM [Ontology.].DataMap m
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=m.Class AND s.InternalType=m.sInternalType AND s.NodeID IS NOT NULL
									'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class=m.oClass AND o.InternalType=m.oInternalType AND o.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = m._PropertyNode AND t.Object = o.NodeID
						WHERE m.DataMapID = '+CAST(@DataMapID as varchar(50))+'
*/
	  
			IF @DataMapType = 3
				SELECT @s = '
					CREATE TABLE #Temp (
											sClass NVARCHAR(400),
											sInternalType NVARCHAR(300),
											sInternalID NVARCHAR(100),
											NetworkPredicate BIGINT,
											predicate BIGINT,
											cClass NVARCHAR(400),
											cInternalType NVARCHAR(300),
											cInternalID NVARCHAR(100),
											oClass NVARCHAR(400),
											oInternalType NVARCHAR(300),
											oInternalID NVARCHAR(100),
											Language NVARCHAR(255),
											DataType NVARCHAR(255),
											Value NVARCHAR(MAX),
											ViewSecurityGroup BIGINT,
											EditSecurityGroup BIGINT,
											Weight FLOAT,
											Graph BIGINT, 
											ValueHash BINARY(20), 
											SortOrder INT
										)
					INSERT INTO #Temp 
						' + @s + ';
					;WITH a AS (
						SELECT s.NodeID Subject, x.Predicate, o.NodeID Object, x.Weight, x.SortOrder, 
								IsNull(p.ViewSecurityGroup,x.ViewSecurityGroup) ViewSecurityGroup, x.Graph,
								x.Value, x.Language, x.DataType, x.ValueHash, x.EditSecurityGroup
						FROM #Temp x
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=x.sClass AND s.InternalType=x.sInternalType AND s.InternalID=x.sInternalID AND s.NodeID IS NOT NULL
							LEFT OUTER JOIN [RDF.].Node o
								ON o.ValueHash=x.ValueHash
							LEFT OUTER JOIN [RDF.Security].NodeProperty p
								ON p.NodeID = s.NodeID AND p.Property = '+CAST(@PropertyNode as varchar(50))+'
					), b AS (
						SELECT t.*
						FROM [Ontology.].DataMap m
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class='''+Class+''' AND s.InternalType='''+sInternalType+''' AND s.NodeID IS NOT NULL
									'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = m._PropertyNode AND t.ObjectType = '+CAST(@ObjectType as varchar(50))+'
						WHERE m.DataMapID = '+CAST(@DataMapID as varchar(50))+'
					)
					SELECT a.Subject, a.Predicate, a.Object, b.TripleID, 
							a.Language, a.DataType, a.Value, a.ValueHash,
							a.Weight, a.SortOrder, '+CAST(@ObjectType as varchar(50))+' ObjectType, a.ViewSecurityGroup, a.EditSecurityGroup,
							null ReitificationTripleID, b.Reitification, b.TripleHash, a.Graph,
							(CASE	WHEN b.TripleID IS NULL AND a.Object IS NULL THEN 3 
									WHEN b.TripleID IS NULL THEN 2 
									WHEN a.Subject IS NULL THEN 1
									ELSE 0 END) Status
						FROM a FULL OUTER JOIN b
								ON a.Subject = b.Subject AND a.Object = b.Object AND a.Object IS NOT NULL
						WHERE	a.Subject IS NULL
								OR b.TripleID IS NULL
								OR a.Weight <> b.Weight
								OR a.SortOrder <> b.SortOrder
								OR a.ViewSecurityGroup <> b.ViewSecurityGroup
					UNION ALL
					SELECT COUNT(*),NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,100 FROM #Temp
					'
				FROM [Ontology.].DataMap
				WHERE DataMapID = @DataMapID

/*
						SELECT t.*
						FROM [Ontology.].DataMap m
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=m.Class AND s.InternalType=m.sInternalType AND s.NodeID IS NOT NULL
									'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = m._PropertyNode AND t.ObjectType = '+CAST(@ObjectType as varchar(50))+'
						WHERE m.DataMapID = '+CAST(@DataMapID as varchar(50))+'

						SELECT t.*
						FROM [RDF.Stage].InternalNodeMap s
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = '+cast(_PropertyNode as varchar(50))+' AND t.ObjectType = '+CAST(@ObjectType as varchar(50))+'
						WHERE s.Class='''+Class+''' AND s.InternalType='''+sInternalType+''' AND s.NodeID IS NOT NULL
							'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'

*/
				 
			IF @DataMapType = 4
				SELECT @s = '
					WITH x AS (
						'+@s+'
					), a AS (
						SELECT t.Reitification Subject, x.Predicate, o.NodeID Object, x.Weight, x.SortOrder, 
								x.ViewSecurityGroup, x.Graph,
								x.NetworkPredicate, t.TripleID, v.TripleID ExistingTripleID
						FROM x
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=x.sClass AND s.InternalType=x.sInternalType AND s.InternalID=x.sInternalID AND s.NodeID IS NOT NULL
							INNER JOIN [RDF.Stage].InternalNodeMap c
								ON c.Class=x.cClass AND c.InternalType=x.cInternalType AND c.InternalID=x.cInternalID AND c.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = x.NetworkPredicate AND t.Object = c.NodeID
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class=x.oClass AND o.InternalType=x.oInternalType AND o.InternalID=x.oInternalID AND o.NodeID IS NOT NULL
							LEFT OUTER JOIN [RDF.].Triple v
								ON v.Subject = t.Reitification AND v.Predicate = x.Predicate AND v.Object = o.NodeID
									AND t.Reitification IS NOT NULL AND o.NodeID IS NOT NULL
					), b AS (
						SELECT v.*
						FROM [Ontology.].DataMap m
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=m.Class AND s.InternalType=m.sInternalType AND s.NodeID IS NOT NULL
									'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'
							INNER JOIN [RDF.Stage].InternalNodeMap c
								ON c.Class=m.cClass AND c.InternalType=m.cInternalType AND c.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = m._NetworkPropertyNode AND t.Object = c.NodeID AND t.Reitification IS NOT NULL
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class=m.oClass AND o.InternalType=m.oInternalType AND o.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple v
								ON v.Subject = t.Reitification AND v.Predicate = m._PropertyNode AND v.Object = o.NodeID
						WHERE m.DataMapID = '+CAST(@DataMapID as varchar(50))+'
					)
					SELECT a.Subject, a.Predicate, a.Object, b.TripleID, 
							null Language, null DataType, null Value, null ValueHash,
							a.Weight, a.SortOrder, 0 ObjectType, a.ViewSecurityGroup, null EditSecurityGroup,
							a.TripleID ReitificationTripleID, b.Reitification, b.TripleHash, a.Graph,
							(CASE	WHEN (b.TripleID IS NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NOT NULL) AND (a.ExistingTripleID IS NULL) AND (a.Subject IS NULL) THEN 4
									WHEN (b.TripleID IS NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NOT NULL) AND (a.ExistingTripleID IS NULL) AND (a.Subject IS NOT NULL) THEN 2
									WHEN (b.TripleID IS NOT NULL) AND ((a.TripleID IS NULL) OR (a.Object IS NULL)) THEN 1
									WHEN (b.TripleID IS NOT NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NOT NULL) AND (a.ExistingTripleID IS NOT NULL) THEN 0
									ELSE -1 END) Status
						FROM a FULL OUTER JOIN b
								ON a.Subject = b.Subject AND a.Object = b.Object
						WHERE	b.TripleID IS NULL
								OR a.TripleID IS NULL
								OR a.Object IS NULL
								OR a.Subject IS NULL
								OR a.ExistingTripleID IS NULL
								OR a.Weight <> b.Weight
								OR a.SortOrder <> b.SortOrder
								OR a.ViewSecurityGroup <> b.ViewSecurityGroup
					UNION ALL
					SELECT COUNT(*),NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,100 FROM x
					'

			IF @DataMapType = 5
				SELECT @s = ' CREATE TABLE #Temp (
											sClass NVARCHAR(400),
											sInternalType NVARCHAR(300),
											sInternalID NVARCHAR(100),
											NetworkPredicate BIGINT,
											predicate BIGINT,
											cClass NVARCHAR(400),
											cInternalType NVARCHAR(300),
											cInternalID NVARCHAR(100),
											oClass NVARCHAR(400),
											oInternalType NVARCHAR(300),
											oInternalID NVARCHAR(100),
											Language NVARCHAR(255),
											DataType NVARCHAR(255),
											Value NVARCHAR(MAX),
											ViewSecurityGroup BIGINT,
											EditSecurityGroup BIGINT,
											Weight FLOAT,
											Graph BIGINT, 
											ValueHash BINARY(20), 
											SortOrder INT
										)
					INSERT INTO #Temp 
						' + @s + ';
					 
						SELECT t.Reitification Subject, x.Predicate, o.NodeID Object, x.Weight, x.SortOrder, 
								x.ViewSecurityGroup, x.Graph,
								x.NetworkPredicate, t.TripleID, v.TripleID ExistingTripleID,
								x.Value, x.Language, x.DataType, x.ValueHash, x.EditSecurityGroup
						into #a
						FROM #Temp x
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=x.sClass AND s.InternalType=x.sInternalType AND s.InternalID=x.sInternalID AND s.NodeID IS NOT NULL
							INNER JOIN [RDF.Stage].InternalNodeMap c
								ON c.Class=x.cClass AND c.InternalType=x.cInternalType AND c.InternalID=x.cInternalID AND c.NodeID IS NOT NULL
							INNER hash JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = x.NetworkPredicate AND t.Object = c.NodeID
							LEFT OUTER JOIN [RDF.].Node o
								ON o.ValueHash=x.ValueHash
							LEFT OUTER JOIN [RDF.].Triple v
								ON v.Subject = t.Reitification AND v.Predicate = x.Predicate AND v.Object = o.NodeID
									AND t.Reitification IS NOT NULL AND o.NodeID IS NOT NULL
					 
						SELECT v.* INTO #b
						FROM [Ontology.].DataMap m
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=m.Class AND s.InternalType=m.sInternalType AND s.NodeID IS NOT NULL
									'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'
							INNER JOIN [RDF.Stage].InternalNodeMap c
								ON c.Class=m.cClass AND c.InternalType=m.cInternalType AND c.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = m._NetworkPropertyNode AND t.Object = c.NodeID AND t.Reitification IS NOT NULL
							INNER JOIN [RDF.].Triple v
								ON v.Subject = t.Reitification AND v.Predicate = m._PropertyNode AND v.ObjectType = '+CAST(@ObjectType as varchar(50))+'
						WHERE m.DataMapID = '+CAST(@DataMapID as varchar(50))+'
					 
					SELECT a.Subject, a.Predicate, a.Object, b.TripleID, 
							a.Language, a.DataType, a.Value, a.ValueHash,
							a.Weight, a.SortOrder, '+CAST(@ObjectType as varchar(50))+' ObjectType, a.ViewSecurityGroup, a.EditSecurityGroup,
							a.TripleID ReitificationTripleID, b.Reitification, b.TripleHash, a.Graph,
							(CASE	WHEN (b.TripleID IS NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NULL) AND (a.ExistingTripleID IS NULL) AND (a.Subject IS NULL) THEN 5
									WHEN (b.TripleID IS NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NOT NULL) AND (a.ExistingTripleID IS NULL) AND (a.Subject IS NULL) THEN 4
									WHEN (b.TripleID IS NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NULL) AND (a.ExistingTripleID IS NULL) AND (a.Subject IS NOT NULL) THEN 3
									WHEN (b.TripleID IS NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NOT NULL) AND (a.ExistingTripleID IS NULL) AND (a.Subject IS NOT NULL) THEN 2
									WHEN (b.TripleID IS NOT NULL) AND (a.TripleID IS NULL) THEN 1
									WHEN (b.TripleID IS NOT NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NOT NULL) AND (a.ExistingTripleID IS NOT NULL) THEN 0
									ELSE -1 END) Status
						FROM #a a FULL OUTER JOIN #b b
								ON a.Subject = b.Subject AND a.Object = b.Object AND a.Object IS NOT NULL
						WHERE	b.TripleID IS NULL
								OR a.TripleID IS NULL
								OR a.Object IS NULL
								OR a.Subject IS NULL
								OR a.ExistingTripleID IS NULL
								OR a.Weight <> b.Weight
								OR a.SortOrder <> b.SortOrder
								OR a.ViewSecurityGroup <> b.ViewSecurityGroup
					UNION ALL
					SELECT COUNT(*),NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,100 FROM #temp x
					'
--print @s return
			--declare @d datetime
			--select @d = getdate()					
			--select @datamapid, replace(@s,char(10),'NEWLINE')
			--return
			--select @DataMapType, @s
			
			INSERT INTO #Triple
				EXEC sp_executesql @s
			--select @datamapid, datediff(ms,@d,getdate()), (select count(*) from #Triple), replace(@s,char(10),'NEWLINE')
			--select * from #Triple
			--retrun
				
			SELECT @TotalTriples = IsNull((SELECT MAX(Subject) FROM #Triple WHERE Status = 100),0)
			
			---------------------------------------------------------------------
			-- Status 0 - Update triple
			---------------------------------------------------------------------
			
			UPDATE t
				SET	t.Weight = IsNull(x.Weight,t.Weight),
					t.SortOrder = IsNull(x.SortOrder,t.SortOrder),
					t.ObjectType = IsNull(x.ObjectType,t.ObjectType)
				FROM [RDF.].Triple t, #Triple x
				WHERE x.Status = 0
					AND t.TripleID = x.TripleID
			SELECT @UpdatedTriples = @@ROWCOUNT

			---------------------------------------------------------------------
			-- Status 1 - Delete triple
			---------------------------------------------------------------------

			CREATE TABLE #DeleteTriples (TripleID BIGINT PRIMARY KEY)
			CREATE TABLE #DeleteNodes (NodeID BIGINT PRIMARY KEY)
			CREATE TABLE #NewDeleteTriples (TripleID BIGINT PRIMARY KEY, Reitification BIGINT)
			CREATE TABLE #NewDeleteNodes (NodeID BIGINT PRIMARY KEY)
			DECLARE @NewDeletedTriples BIGINT
			-- Get triples that should be deleted
			INSERT INTO #NewDeleteTriples (TripleID, Reitification)
				SELECT TripleID, Reitification
					FROM #Triple
					WHERE Status = 1
			SELECT @NewDeletedTriples = @@ROWCOUNT
			WHILE @NewDeletedTriples > 0
			BEGIN
				-- Get reitification nodes
				INSERT INTO #DeleteNodes(NodeID)
					SELECT NodeID FROM #NewDeleteNodes
				TRUNCATE TABLE #NewDeleteNodes
				INSERT INTO #NewDeleteNodes (NodeID)
					SELECT DISTINCT Reitification 
						FROM #NewDeleteTriples 
						WHERE Reitification IS NOT NULL AND Reitification NOT IN (SELECT NodeID FROM #DeleteNodes)
				-- Get triples using reitification nodes
				INSERT INTO #DeleteTriples (TripleID)
					SELECT TripleID FROM #NewDeleteTriples
				TRUNCATE TABLE #NewDeleteTriples
				INSERT INTO #NewDeleteTriples (TripleID, Reitification)
					SELECT t.TripleID, t.Reitification
						FROM [RDF.].Triple t
						join  #NewDeleteNodes n on t.subject = n.NodeID 
											    or t.predicate = n.NodeID 
											    or t.object = n.NodeID
							where t.TripleID NOT IN (SELECT TripleID FROM #DeleteTriples)
					--SELECT t.TripleID, t.Reitification
					--	FROM [RDF.].Triple t, #NewDeleteNodes n
					--	WHERE t.subject = n.NodeID 
					--	   or t.predicate = n.NodeID 
					--	   or t.object = n.NodeID
					--		AND t.TripleID NOT IN (SELECT TripleID FROM #DeleteTriples)
				SELECT @NewDeletedTriples = @@ROWCOUNT
			END
			-- Delete triples and reitification nodes and triples
			DELETE 
				FROM [RDF.].Triple
				WHERE TripleID IN (SELECT TripleID FROM #DeleteTriples)
			SELECT @DeletedTriples = @@ROWCOUNT
			DELETE 
				FROM [RDF.].Node
				WHERE NodeID IN (SELECT NodeID FROM #DeleteNodes)
			SELECT @DeletedNodes = @@ROWCOUNT


			---------------------------------------------------------------------
			-- Status 4 & 5 - Create new reitifications
			---------------------------------------------------------------------

			UPDATE #Triple
				SET TripleHash = HASHBYTES('sha1',N'"#TRIPLE'+cast(ReitificationTripleID as nvarchar(50))+N'"')
				WHERE Status IN (4,5)
			INSERT INTO [RDF.].Node (ValueHash, Language, DataType, Value, ObjectType, ViewSecurityGroup, EditSecurityGroup)
				SELECT DISTINCT TripleHash, NULL, NULL, '#TRIPLE'+CAST(ReitificationTripleID AS VARCHAR(50)), 0, -1, -50
					FROM #Triple
					WHERE Status IN (4,5)
			SELECT @NewNodes = @NewNodes + @@ROWCOUNT
			UPDATE t
				SET	t.Subject = n.NodeID,
					t.TripleHash = (CASE WHEN t.Object IS NULL THEN t.TripleHash ELSE HASHBYTES('sha1',N'"<#'+convert(nvarchar(4000),n.NodeID)+N'> <#'+convert(nvarchar(4000),t.Predicate)+N'> <#'+convert(nvarchar(max),t.Object)+N'> ."^^http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement') END)
				FROM #Triple t, [RDF.].Node n
				WHERE t.Status IN (4,5) AND t.TripleHash = n.ValueHash
			UPDATE v
				SET v.Reitification = t.Subject
				FROM #Triple t, [RDF.].Triple v
				WHERE t.Status IN (4,5) AND t.ReitificationTripleID = v.TripleID
			UPDATE n
				SET n.Value = @baseURI+cast(n.NodeID as nvarchar(50)),
					n.ValueHash = HASHBYTES('sha1',N'"' + @baseURI + cast(n.NodeID as nvarchar(50)) + N'"')
				FROM #Triple t, [RDF.].Node n
				WHERE t.Status IN (4,5) AND t.Subject = n.NodeID
				
			---------------------------------------------------------------------
			-- Status 3 & 5 - Create new literals
			---------------------------------------------------------------------

			-- Create the new literals
			INSERT INTO [RDF.].Node (ValueHash, Language, DataType, Value, ObjectType, ViewSecurityGroup, EditSecurityGroup)
				SELECT ValueHash, MAX(Language), MAX(DataType), MAX(Value), MAX(ObjectType*1),
						IsNull(Min(ViewSecurityGroup),-1), IsNull(Min(EditSecurityGroup),-40)
					FROM #Triple
					WHERE Status IN (3,5)
					GROUP BY ValueHash
			SELECT @NewNodes = @NewNodes + @@ROWCOUNT
			-- Update #Triple with the NodeID of the new literals
			UPDATE t
				SET t.Object = n.NodeID
				FROM #Triple t, [RDF.].Node n
				WHERE t.Status IN (3,5)
					AND t.ValueHash = n.ValueHash
					
			---------------------------------------------------------------------
			-- Status 2, 3, 4, and 5 - Create new triple
			---------------------------------------------------------------------

			-- Create the new triples
			INSERT INTO [RDF.].Triple (Subject, Predicate, Object, TripleHash, Weight, ObjectType, SortOrder, ViewSecurityGroup, Graph)
				SELECT Subject, Predicate, Object, TripleHash, Max(Weight), Max(cast(ObjectType as Tinyint)), Min(SortOrder), Max(ViewSecurityGroup), Min(Graph)
					FROM (
						SELECT Subject, Predicate, Object,
							HASHBYTES('sha1',N'"<#'+convert(nvarchar(4000),Subject)+N'> <#'+convert(nvarchar(4000),Predicate)+N'> <#'+convert(nvarchar(4000),Object)+N'> ."^^http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement') TripleHash,
							IsNull(Weight,1) Weight, IsNull(ObjectType,1) ObjectType, IsNull(SortOrder,1) SortOrder, IsNull(ViewSecurityGroup,-1) ViewSecurityGroup,
							Graph
						FROM #Triple
						WHERE Status IN (2,3,4,5)
					) t
					GROUP BY Subject, Predicate, Object, TripleHash
			SELECT @NewTriples = @@ROWCOUNT

			DROP TABLE #DeleteTriples 
			DROP TABLE #DeleteNodes 
			DROP TABLE #NewDeleteTriples 
			DROP TABLE #NewDeleteNodes   
			
			DROP TABLE #Triple
			
		END


		--*******************************************************************************************
		--*******************************************************************************************
		-- Save Log
		--*******************************************************************************************
		--*******************************************************************************************

		INSERT INTO [RDF.Stage].[Log.DataMap] (DataMapID, StartDate, EndDate, RunTimeMS, DataMapType,
												NewNodes, UpdatedNodes, ExistingNodes, DeletedNodes, TotalNodes,
												NewTriples, UpdatedTriples, ExistingTriples, DeletedTriples, TotalTriples)
			SELECT	@DataMapID, @StartDate, GetDate(), DateDiff(ms,@StartDate,GetDate()), @DataMapType,
					@NewNodes, @UpdatedNodes, @ExistingNodes, @DeletedNodes, @TotalNodes,
					@NewTriples, @UpdatedTriples, @ExistingTriples, @DeletedTriples, @TotalTriples
				WHERE @SaveLog = 1

		IF @ShowCounts = 1
			SELECT * FROM [RDF.Stage].[Log.DataMap] WHERE LogID = @@IDENTITY

		DELETE FROM #Queue WHERE DataMapID = @DataMapID
			 
	END

	IF @TurnOffIndexing = 1
	BEGIN
		-- Turn on real-time indexing
		ALTER FULLTEXT INDEX ON [RDF.].Node SET CHANGE_TRACKING AUTO;
		-- Kick off population FT Catalog and index
		ALTER FULLTEXT INDEX ON [RDF.].Node START FULL POPULATION 
	END
	
	-- select * from [Ontology.].DataMap

END
GO
