SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[GetStoreNode]
	-- Cat0
	@ExistingNodeID bigint = null,
	-- Cat1
	@Value nvarchar(max) = null,
	@Language nvarchar(255) = null,
	@DataType nvarchar(255) = null,
	@ObjectType bit = null,
	-- Cat2
	@Class nvarchar(400) = null,
	@InternalType nvarchar(100) = null,
	@InternalID nvarchar(100) = null,
	-- Cat3
	@TripleID bigint = null,
	-- Cat5, Cat6
	@StartTime nvarchar(100) = null,
	@EndTime nvarchar(100) = null,
	@TimePrecision nvarchar(100) = null,
	-- Cat7
	@DefaultURI bit = null,
	-- Cat8
	@EntityClassID bigint = null,
	@EntityClassURI varchar(400) = null,
	@Label nvarchar(max) = null,
	@ForceNewEntity bit = 0,
	-- Cat9
	@SubjectID bigint = null,
	@PredicateID bigint = null,
	@SortOrder int = null,
	-- Attributes
	@ViewSecurityGroup bigint = null,
	@EditSecurityGroup bigint = null,
	-- Security
	@SessionID uniqueidentifier = NULL,
	-- Output variables
	@Error bit = NULL OUTPUT,
	@NodeID bigint = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/* 
	The node can be defined in different ways:
		Cat 0: ExistingNodeID (a NodeID from [RDF.].Node)
		Cat 1: Value, Language, DataType, ObjectType (standard RDF literal [ObjectType=1], or just Value if URI [ObjectType=0])
		Cat 2: NodeType (primary VIVO type, http://xmlns.com/foaf/0.1/Person), InternalType (Profiles10 type, such as "Person"), InternalID (personID=32213)
		Cat 3: TripleID (from [RDF.].Triple -- a reitification)
		Cat 5: StartTime, EndTime, TimePrecision (VIVO's DateTimeInterval, DateTimeValue, and DateTimeValuePrecision classes)
		Cat 6: StartTime, TimePrecision (VIVO's DateTimeValue, and DateTimeValuePrecision classes)
		Cat 7: The default URI: baseURI+NodeID
		Cat 8: New entity with class (by node ID or URI) and label; ForceNewEntity=1 always creates a new node
		Cat 9: The object node of a triple given the SubjectID node, PredicateID node, and the triple sort order
	*/

	SELECT @Error = 0

	SELECT @ExistingNodeID = NULL WHERE @ExistingNodeID = 0
	SELECT @TripleID = NULL WHERE @TripleID = 0

 	IF (@EntityClassID IS NULL) AND (@EntityClassURI IS NOT NULL)
		SELECT @EntityClassID = [RDF.].fnURI2NodeID(@EntityClassURI)

	-- Determine the category
	DECLARE @Category INT
	SELECT @Category = (
		CASE
			WHEN (@ExistingNodeID IS NOT NULL) THEN 0
			WHEN (@Value IS NOT NULL) THEN 1
			WHEN ((@Class IS NOT NULL) AND (@InternalType IS NOT NULL) AND (@InternalID IS NOT NULL)) THEN 2
			WHEN (@TripleID IS NOT NULL) THEN 3
			WHEN ((@StartTime IS NOT NULL) AND (@EndTime IS NOT NULL) AND (@TimePrecision IS NOT NULL)) THEN 5
			WHEN ((@StartTime IS NOT NULL) AND (@TimePrecision IS NOT NULL)) THEN 6
			WHEN (@DefaultURI = 1) THEN 7
			WHEN ((@EntityClassID IS NOT NULL) AND (IsNull(@Label,'')<>'')) THEN 8
			WHEN ((@SubjectID IS NOT NULL) AND (@PredicateID IS NOT NULL) AND (@SortOrder IS NOT NULL)) THEN 9
			ELSE NULL END)

	IF @Category IS NULL
	BEGIN
		SELECT @Error = 1
		RETURN
	END

	-- Determine if the node already exists
	SELECT @NodeID = (CASE
		WHEN @Category = 0 THEN (
				SELECT NodeID
				FROM [RDF.].[Node]
				WHERE NodeID = @ExistingNodeID
			)
		WHEN @Category = 1 THEN (
				SELECT NodeID
				FROM [RDF.].[Node]
				WHERE ValueHash = [RDF.].[fnValueHash](@Language,@DataType,@Value)
			)
		WHEN @Category = 2 THEN (
				SELECT NodeID
				FROM [RDF.Stage].InternalNodeMap
				WHERE Class = @Class AND InternalType = @InternalType AND InternalID = @InternalID
			)
		WHEN @Category = 8 THEN (
				SELECT NodeID
				FROM [RDF.].Triple t, [RDF.].Triple v, [RDF.].Node n
				WHERE t.subject = v.subject
					AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
					AND t.object = @EntityClassID
					AND v.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')
					AND v.object = n.NodeID
					AND n.ValueHash = [RDF.].[fnValueHash](null,null,@Label)
					AND @ForceNewEntity = 0
			)
		WHEN @Category = 9 THEN (
				SELECT t.Object
				FROM [RDF.].[Triple] t
				WHERE t.subject = @SubjectID
					AND t.predicate = @PredicateID
					AND t.SortOrder = @SortOrder
			)
		ELSE NULL END)

	-- Update attributes of an existing node
	IF (@NodeID IS NOT NULL) AND (IsNull(@ViewSecurityGroup,@EditSecurityGroup) IS NOT NULL)
	BEGIN
		UPDATE [RDF.].Node
			SET ViewSecurityGroup = IsNull(@ViewSecurityGroup,ViewSecurityGroup),
				EditSecurityGroup = IsNull(@EditSecurityGroup,EditSecurityGroup)
			WHERE NodeID = @NodeID
	END

	-- Check that if a new node is needed, then all attributes are defined
	IF (@NodeID IS NULL)
	BEGIN
		SELECT	@ViewSecurityGroup = IsNull(@ViewSecurityGroup,-1),
				@EditSecurityGroup = IsNull(@EditSecurityGroup,-40)
		SELECT	@ObjectType = (CASE WHEN @Value LIKE 'http://%' or @Value LIKE 'https://%' THEN 0 ELSE 1 END)
			WHERE (@Category=1 AND @ObjectType IS NULL)
	END

	-- Create a new node if needed
	IF (@NodeID IS NULL)	
	BEGIN
		BEGIN TRY 
		BEGIN TRANSACTION

		-- Lookup the base URI
		DECLARE @baseURI NVARCHAR(400)
		SELECT @baseURI = Value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

		-- Create node based on category
		IF @Category = 1
			BEGIN
				INSERT INTO [RDF.].[Node] (ViewSecurityGroup, EditSecurityGroup, Language, DataType, Value, ObjectType, ValueHash)
					SELECT @ViewSecurityGroup, @EditSecurityGroup, @Language, @DataType, @Value, @ObjectType,
						[RDF.].[fnValueHash](@Language,@DataType,@Value)
				SET @NodeID = @@IDENTITY
			END
		IF @Category = 2
			BEGIN
				-- Create the InternalNodeMap record
				DECLARE @InternalNodeMapID BIGINT
				INSERT INTO [RDF.Stage].[InternalNodeMap] (InternalType, InternalID, NodeType, Status, InternalHash)
					SELECT @InternalType, @InternalID, @Class, 4, 
						[R DF.].fnValueHash(null,null,@Class+'^^'+@InternalType+'^^'+@InternalID)
				SET @InternalNodeMapID = @@IDENTITY
				-- Create the Node
				INSERT INTO [RDF.].[Node] (ViewSecurityGroup, EditSecurityGroup, InternalNodeMapID, ObjectType, Value, ValueHash)
					SELECT @ViewSecurityGroup, @EditSecurityGroup, @InternalNodeMapID, 0,
						'#INM'+cast(@InternalNodeMapID as nvarchar(50)),
						[RDF.].fnValueHash(null,null,'#INM'+cast(@InternalNodeMapID as nvarchar(50)))
				SET @NodeID = @@IDENTITY
				-- Update the InternalNodeMap, given the NodeID
				UPDATE [RDF.Stage].[InternalNodeMap]
					SET NodeID = @NodeID, Status = 0,
						ValueHash = [RDF.].fnValueHash(null,null,@baseURI+cast(@NodeID as nvarchar(50)))
					WHERE InternalNodeMapID = @InternalNodeMapID
				-- Update the Node, given the NodeID
				UPDATE [RDF.].[Node]
					SET Value = @baseURI+cast(@NodeID as nvarchar(50)),
						ValueHash = [RDF.].fnValueHash(null,null,@baseURI+cast(@NodeID as nvarchar(50)))
					WHERE NodeID = @NodeID
			END
		IF @Category = 7
			BEGIN
				-- Create the Node
				DECLARE @TempValue varchar(50)
				SELECT @TempValue = '#NODE'+cast(NewID() as varchar(50))
				INSERT INTO [RDF.].[Node] (ViewSecurityGroup, EditSecurityGroup, Value, ObjectType, ValueHash)
					SELECT @ViewSecurityGroup, @EditSecurityGroup, @TempValue, 0, [RDF.].[fnValueHash](NULL,NULL,@TempValue)
				SET @NodeID = @@IDENTITY
				-- Update the Node, given the NodeID
				UPDATE [RDF.].[Node]
					SET Value = @baseURI+cast(@NodeID as nvarchar(50)),
						ValueHash = [RDF.].fnValueHash(null,null,@baseURI+cast(@NodeID as nvarchar(50)))
					WHERE NodeID = @NodeID
			END
		IF @Category = 8
			BEGIN
				-- Create the new node
				EXEC [RDF.].GetStoreNode	@DefaultURI = 1,
											@ViewSecurityGroup = @ViewSecurityGroup,
											@EditSecurityGroup = @EditSecurityGroup,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT,
											@NodeID = @NodeID OUTPUT
				IF @Error = 1
				BEGIN
					RETURN
				END
				-- Convert URIs to NodeIDs
				DECLARE @TypeID BIGINT
				DECLARE @LabelID BIGINT
				DECLARE @ClassID BIGINT
				DECLARE @SubClassID BIGINT
				SELECT	@TypeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
						@LabelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label'),
						@ClassID = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#Class'),
						@SubClassID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#subClassOf')
				-- Add class(es) to new node
				DECLARE @TempClassID BIGINT
				SELECT @TempClassID = @EntityClassID
				WHILE (@TempClassID IS NOT NULL)
				BEGIN
					EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
												@PredicateID = @TypeID,
												@ObjectID = @TempClassID,
												@ViewSecurityGroup = -1,
												@Weight = 1,
												@SessionID = @SessionID,
												@Error = @Error OUTPUT
					IF @Error = 1
					BEGIN
						RETURN
					END
					-- Determine if there is a parent class
					SELECT @TempClassID = (
							SELECT TOP 1 t.object
							FROM [RDF.].Triple t, [RDF.].Triple c
							WHERE t.subject = @TempClassID
								AND t.predicate = @SubClassID
								AND c.subject = t.object
								AND c.predicate = @TypeID
								AND c.object = @ClassID
								AND NOT EXISTS (
									SELECT *
									FROM [RDF.].Triple v
									WHERE v.subject = @NodeID
										AND v.predicate = @TypeID
										AND v.object = t.object
								)
						)
				END
				-- Get node ID for label
				DECLARE @LabelNodeID BIGINT
				EXEC [RDF.].GetStoreNode	@Value = @Label,
											@ObjectType = 1,
											@ViewSecurityGroup = -1,
											@EditSecurityGroup = -40,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT,
											@NodeID = @LabelNodeID OUTPUT
				IF @Error = 1
				BEGIN
					RETURN
				END
				-- Add label to new node
				EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
											@PredicateID = @LabelID,
											@ObjectID = @LabelNodeID,
											@ViewSecurityGroup = -1,
											@Weight = 1,
											@SortOrder = 1,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT
				IF @Error = 1
				BEGIN
					RETURN
				END
			END
		IF @Category = 9
			BEGIN
				-- We can't create a new node in this case, so throw an error
				SELECT @Error = 1
			END

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK

		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)

	END CATCH		
	END

END
GO
