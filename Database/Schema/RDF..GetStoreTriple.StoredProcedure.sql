SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [RDF.].[GetStoreTriple]
	-- Define the triple
	@ExistingTripleID bigint = null,
	@SubjectID bigint = null,
	@PredicateID bigint = null,
	@ObjectID bigint = null,
	@SubjectURI varchar(400) = NULL,
	@PredicateURI varchar(400) = NULL,
	@ObjectURI varchar(400) = NULL,
	-- Attributes
	@ViewSecurityGroup bigint = null,
	@Weight float = null,
	@SortOrder int = null,
	@MoveUpOne bit = null,
	@MoveDownOne bit = null,
	-- Inverse predicate triple
	@StoreInverse bit = 0,
	@InverseViewSecurityGroup bigint = null,
	@InverseWeight float = null,
	-- Other
	@OldObjectID bigint = null,
	@OldObjectURI varchar(400) = NULL,
	-- Security
	@SessionID uniqueidentifier = NULL,
	-- Output variables
	@Error bit = NULL OUTPUT,
	@TripleID bigint = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	SELECT @Error = 0
	SELECT @TripleID = NULL

	DECLARE @OldTripleID BIGINT
	SELECT @OldTripleID = NULL

	DECLARE @OldSortOrder BIGINT
	DECLARE @NewSortOrder BIGINT
	DECLARE @MaxSortOrder BIGINT

	SELECT @ExistingTripleID = NULL WHERE @ExistingTripleID = 0
	SELECT @SubjectID = NULL WHERE @SubjectID = 0
	SELECT @PredicateID = NULL WHERE @PredicateID = 0
	SELECT @ObjectID = NULL WHERE @ObjectID = 0
	SELECT @OldObjectID = NULL WHERE @OldObjectID = 0

	IF (@SortOrder IS NOT NULL)
		SELECT @MoveUpOne = NULL, @MoveDownOne = NULL

	-- Convert URIs to NodeIDs
 	IF (@SubjectID IS NULL) AND (@SubjectURI IS NOT NULL)
		SELECT @SubjectID = [RDF.].fnURI2NodeID(@SubjectURI)
 	IF (@PredicateID IS NULL) AND (@PredicateURI IS NOT NULL)
		SELECT @PredicateID = [RDF.].fnURI2NodeID(@PredicateURI)
 	IF (@ObjectID IS NULL) AND (@ObjectURI IS NOT NULL)
		SELECT @ObjectID = [RDF.].fnURI2NodeID(@ObjectURI)
 	IF (@OldObjectID IS NULL) AND (@OldObjectURI IS NOT NULL)
		SELECT @OldObjectID = [RDF.].fnURI2NodeID(@OldObjectURI)
 
	-- Confirm ExistingTripleID exists
	IF (@ExistingTripleID IS NOT NULL)
		SELECT @TripleID = TripleID, @SubjectID = subject, @PredicateID = predicate, @ObjectID = object
			FROM [RDF.].Triple
			WHERE TripleID = @ExistingTripleID

	-- Make sure required parameters are defined
	IF (@SubjectID IS NULL OR @PredicateID IS NULL OR @ObjectID IS NULL)
	BEGIN
		SELECT @Error = 1
		RETURN
	END	
	SELECT @Error = 1
		WHERE NOT EXISTS (SELECT * FROM [RDF.].Node WHERE NodeID = @SubjectID)
			OR NOT EXISTS (SELECT * FROM [RDF.].Node WHERE NodeID = @PredicateID)
			OR NOT EXISTS (SELECT * FROM [RDF.].Node WHERE NodeID = @ObjectID)
	IF (@SubjectID IS NULL OR @PredicateID IS NULL OR @ObjectID IS NULL)
	BEGIN
		SELECT @Error = 1
		RETURN
	END	

	-- Determine if a triple already exitsts
	IF (@TripleID IS NULL)
		SELECT @TripleID = TripleID
			FROM [RDF.].Triple
			WHERE subject = @SubjectID AND predicate = @PredicateID AND object = @ObjectID
	
	-- Handle the case where there is an OldObjectID
	IF (@OldObjectID IS NOT NULL) AND (@OldObjectID <> @ObjectID)
	BEGIN
		SELECT @OldTripleID = TripleID,
				@ViewSecurityGroup = IsNull(@ViewSecurityGroup,ViewSecurityGroup),
				@Weight = IsNull(@Weight,Weight),
				@OldSortOrder = SortOrder
			FROM [RDF.].Triple
			WHERE subject = @SubjectID AND predicate = @PredicateID AND object = @OldObjectID
		IF @OldTripleID IS NOT NULL
		BEGIN
			SELECT @SortOrder = @OldSortOrder, @TripleID = @OldTripleID
			UPDATE [RDF.].Triple
				SET object = @ObjectID
				WHERE TripleID = @TripleID
			/*
			DELETE 
				FROM [RDF.].Triple
				WHERE TripleID = @OldTripleID
			UPDATE [RDF.].Triple
				SET SortOrder = SortOrder - 1
				WHERE subject = @SubjectID AND predicate = @PredicateID AND SortOrder >= @OldSortOrder
			SELECT @OldTripleID = NULL
			*/
		END
	END

	-- Incremental SortOrders
	IF (@MoveUpOne = 1 OR @MoveDownOne = 1)
	BEGIN
		IF (@OldSortOrder IS NOT NULL)
			SELECT @SortOrder = @OldSortOrder + (CASE WHEN @MoveUpOne = 1 THEN 1 WHEN @MoveDownOne = 1 THEN -1 ELSE 0 END)
		ELSE IF (@TripleID IS NOT NULL)
			SELECT @SortOrder = SortOrder + (CASE WHEN @MoveUpOne = 1 THEN 1 WHEN @MoveDownOne = 1 THEN -1 ELSE 0 END)
				FROM [RDF.].Triple
				WHERE TripleID = @TripleID
	END

	-- Set SortOrder variables
	IF @TripleID IS NOT NULL
		SELECT @OldSortOrder = SortOrder
			FROM [RDF.].Triple
			WHERE TripleID = @TripleID
	SELECT @MaxSortOrder = MAX(SortOrder)
		FROM [RDF.].Triple
		WHERE subject = @SubjectID AND predicate = @PredicateID
	SELECT @MaxSortOrder = IsNull(@MaxSortOrder,0)
	SELECT @NewSortOrder = (CASE WHEN @MaxSortOrder = 0 THEN 1
								WHEN @SortOrder < 1 THEN 1
								WHEN @SortOrder <= @MaxSortOrder THEN @SortOrder
								WHEN @TripleID IS NOT NULL THEN @MaxSortOrder
								ELSE @MaxSortOrder + 1 END)
 
	-- Update attributes if a triple already exists
	IF (@TripleID IS NOT NULL)
	BEGIN
		IF @ViewSecurityGroup IS NOT NULL
			UPDATE [RDF.].Triple
				SET ViewSecurityGroup = @ViewSecurityGroup
				WHERE TripleID = @TripleID
		IF @Weight IS NOT NULL
			UPDATE [RDF.].Triple
				SET Weight = @Weight
				WHERE TripleID = @TripleID
		IF (@SortOrder IS NOT NULL) AND (@SortOrder <> @OldSortOrder)
			UPDATE [RDF.].Triple
				SET SortOrder = (CASE
									WHEN TripleID = @TripleID 
										THEN @NewSortOrder
									WHEN (@NewSortOrder > @OldSortOrder) AND (SortOrder > @OldSortOrder) AND (SortOrder <= @NewSortOrder)
										THEN SortOrder - 1
									WHEN (@NewSortOrder < @OldSortOrder) AND (SortOrder < @OldSortOrder) AND (SortOrder >= @NewSortOrder)
										THEN SortOrder + 1
									ELSE SortOrder END)
				WHERE subject = @SubjectID AND predicate = @PredicateID 
					AND (SortOrder >= @NewSortOrder OR SortOrder >= @OldSortOrder)
					AND (SortOrder <= @NewSortOrder OR SortOrder <= @OldSortOrder)
	END
 
	-- Create a new triple if needed
	IF (@TripleID IS NULL)
	BEGIN
		-- Get ObjectType
		DECLARE @ObjectType BIT
		SELECT @ObjectType = ObjectType
			FROM [RDF.].[Node]
			WHERE NodeID = @ObjectID
		-- Shift SortOrders of existing triples
		IF @NewSortOrder <= @MaxSortOrder
			UPDATE [RDF.].Triple
				SET SortOrder = SortOrder + 1
				WHERE subject = @SubjectID AND predicate = @PredicateID
					AND SortOrder >= @NewSortOrder
		-- Get default @ViewSecurityGroup
		IF @ViewSecurityGroup IS NULL
		BEGIN
			SELECT @ViewSecurityGroup = MAX(IsNull(p.ViewSecurityGroup,c.ViewSecurityGroup))
				FROM [RDF.].Triple t
						INNER JOIN [Ontology.].ClassProperty c
							ON t.subject = @SubjectID
								AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
								AND t.object = c._ClassNode
								AND c._PropertyNode = @PredicateID
								AND c._NetworkPropertyNode IS NULL
						LEFT OUTER JOIN [RDF.Security].NodeProperty p
							ON p.NodeID = @SubjectID
								AND p.Property = @PredicateID
			SELECT @ViewSecurityGroup = IsNull(@ViewSecurityGroup,-1)
		END
		-- Create the triple
		INSERT INTO [RDF.].[Triple] (ViewSecurityGroup, Subject, Predicate, Object, ObjectType, Weight, SortOrder, TripleHash)
			SELECT @ViewSecurityGroup, @SubjectID, @PredicateID, @ObjectID, @ObjectType, IsNull(@Weight,1), @NewSortOrder,
					[RDF.].fnTripleHash(@SubjectID, @PredicateID, @ObjectID) 
		SET @TripleID = @@IDENTITY
		-- Create the inverse triple
		IF (@StoreInverse IS NOT NULL)
		BEGIN	
			-- Determine if there is an inverse property
			DECLARE @InversePredicateID BIGINT
			SELECT @InversePredicateID = object
				FROM [RDF.].Triple
				WHERE subject = @PredicateID
					AND predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#inverseOf')
			IF @InversePredicateID IS NOT NULL
			BEGIN
				-- Get default @InverseWeight
				SELECT @InverseWeight = IsNull(@InverseWeight,@Weight)
				-- Create the inverse triple
				EXEC [RDF.].GetStoreTriple	@SubjectID = @ObjectID,
											@PredicateID = @InversePredicateID,
											@ObjectID = @SubjectID,
											@ViewSecurityGroup = @InverseViewSecurityGroup,
											@Weight = @InverseWeight,
											@SortOrder = NULL,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT
			END
		END
	END

END
GO
