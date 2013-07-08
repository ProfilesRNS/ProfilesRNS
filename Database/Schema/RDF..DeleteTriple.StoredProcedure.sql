SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [RDF.].[DeleteTriple]
	@TripleID bigint = NULL,
	@SubjectID bigint = NULL,
	@PredicateID bigint = NULL,
	@ObjectID bigint = NULL,
	@SubjectURI varchar(400) = NULL,
	@PredicateURI varchar(400) = NULL,
	@ObjectURI varchar(400) = NULL,
	@DeleteInverse bit = 0,
	@DeleteType tinyint = 0,
	@SessionID uniqueidentifier = NULL,
	-- Output variables
	@Error bit = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	SELECT @Error = 0

	SELECT @TripleID = NULL WHERE @TripleID = 0
	SELECT @SubjectID = NULL WHERE @SubjectID = 0
	SELECT @PredicateID = NULL WHERE @PredicateID = 0
	SELECT @ObjectID = NULL WHERE @ObjectID = 0
	
	-- Convert URIs to NodeIDs
	
 	IF (@SubjectID IS NULL) AND (@SubjectURI IS NOT NULL)
	BEGIN
		SELECT @SubjectID = [RDF.].fnURI2NodeID(@SubjectURI)
		IF @SubjectID IS NULL
			SELECT @Error = 1
	END
		
 	IF (@PredicateID IS NULL) AND (@PredicateURI IS NOT NULL)
	BEGIN
		SELECT @PredicateID = [RDF.].fnURI2NodeID(@PredicateURI)
		IF @PredicateID IS NULL
			SELECT @Error = 1
	END

 	IF (@ObjectID IS NULL) AND (@ObjectURI IS NOT NULL)
	BEGIN
		SELECT @ObjectID = [RDF.].fnURI2NodeID(@ObjectURI)
		IF @ObjectID IS NULL
			SELECT @Error = 1
	END

	IF Coalesce(@TripleID, @SubjectID, @PredicateID, @ObjectID) IS NULL
		SELECT @Error = 1

	IF @Error = 1
	BEGIN
		RETURN
	END

	-- Determine if there is an inverse predicate
	DECLARE @InversePredicateID BIGINT
	SELECT @InversePredicateID = NULL
	IF (@DeleteInverse IS NOT NULL) AND (@TripleID IS NOT NULL) AND (@PredicateID IS NULL)
		SELECT @PredicateID = predicate
			FROM [RDF.].Triple
			WHERE TripleID = @TripleID
	IF (@DeleteInverse IS NOT NULL) AND (@PredicateID IS NOT NULL)
		SELECT @InversePredicateID = object
			FROM [RDF.].Triple
			WHERE subject = @PredicateID
				AND predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#inverseOf')
BEGIN TRY
	BEGIN TRANSACTION
 
		-- Get a list of TripleIDs to delete
		CREATE TABLE #DeleteTriples (
			TripleID bigint primary key,
			subject bigint,
			predicate bigint
		)
		DECLARE @sql NVARCHAR(max)
		SELECT @sql = ''
			+ 'SELECT TripleID, subject, predicate '
			+ 'FROM [RDF.].[Triple] '
			+ 'WHERE 1=1 '
			+ (CASE WHEN @TripleID IS NOT NULL THEN ' AND TripleID = '+CAST(@TripleID AS VARCHAR(50)) ELSE '' END)
			+ (CASE WHEN @SubjectID IS NOT NULL THEN ' AND Subject = '+CAST(@SubjectID AS VARCHAR(50)) ELSE '' END)
			+ (CASE WHEN @PredicateID IS NOT NULL THEN ' AND Predicate = '+CAST(@PredicateID AS VARCHAR(50)) ELSE '' END)
			+ (CASE WHEN @ObjectID IS NOT NULL THEN ' AND Object = '+CAST(@ObjectID AS VARCHAR(50)) ELSE '' END)
		INSERT INTO #DeleteTriples
			EXEC sp_executesql @sql
		
		-- Add inverse triples to list
		IF @InversePredicateID IS NOT NULL
			INSERT INTO #DeleteTriples (TripleID, subject, predicate)
				SELECT t.TripleID, t.subject, t.predicate
					FROM [RDF.].Triple t, [RDF.].Triple v, #DeleteTriples d
					WHERE	t.subject = v.object
						and t.predicate = @InversePredicateID
						and t.object = v.subject
						and v.TripleID = d.TripleID
						and t.TripleID not in (select TripleID from #DeleteTriples)
		
		-- Delete triples
 
		IF @DeleteType = 0 -- True delete
		BEGIN
			-- Delete triples
			DELETE FROM [RDF.].[Triple] WHERE TripleID IN (SELECT TripleID FROM #DeleteTriples)
			-- Update sort orders
			UPDATE t
				SET t.SortOrder = x.SortOrder
				FROM [RDF.].[Triple] t
					INNER JOIN (
						SELECT v.TripleID, row_number() over (partition by v.subject, v.predicate order by v.sortorder) SortOrder
						FROM [RDF.].[Triple] v
							INNER JOIN (
								SELECT DISTINCT subject, predicate
									FROM #DeleteTriples
							) w
							ON v.subject = w.subject AND v.predicate = w.predicate
					) x ON t.TripleID = x.TripleID AND t.SortOrder <> x.SortOrder 
			-- TODO: Delete reitification 
		END
 
		IF @DeleteType = 1 -- Change security groups
		BEGIN
			UPDATE [RDF.].[Triple] SET ViewSecurityGroup = 0 WHERE TripleID IN (SELECT TripleID FROM #DeleteTriples)
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
GO
