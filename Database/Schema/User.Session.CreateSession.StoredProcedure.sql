SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [User.Session].[CreateSession]
    @RequestIP VARCHAR(16),
    @UserAgent VARCHAR(500) = NULL,
    @UserID VARCHAR(200) = NULL,
	@SessionPersonNodeID BIGINT = NULL OUTPUT,
	@SessionPersonURI VARCHAR(400) = NULL OUTPUT
AS 
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON ;

	-- See if there is a PersonID associated with the user	
	DECLARE @PersonID INT
	IF @UserID IS NOT NULL
		SELECT @PersonID = PersonID
			FROM [User.Account].[User]
			WHERE UserID = @UserID

	-- Get the NodeID and URI of the PersonID
	IF @PersonID IS NOT NULL
	BEGIN
		SELECT @SessionPersonNodeID = m.NodeID, @SessionPersonURI = p.Value + CAST(m.NodeID AS VARCHAR(50))
			FROM [RDF.Stage].InternalNodeMap m, [Framework.].[Parameter] p
			WHERE m.InternalID = @PersonID
				AND m.InternalType = 'person'
				AND m.Class = 'http://xmlns.com/foaf/0.1/Person'
				AND p.ParameterID = 'baseURI'
	END

 
    DECLARE @SessionID UNIQUEIDENTIFIER
 BEGIN TRY 
	BEGIN TRANSACTION
 
		-- Create a SessionID
		SELECT @SessionID = NEWID()
 
		-- Create the Session table record
		INSERT INTO [User.Session].Session
			(	SessionID,
				CreateDate,
				LastUsedDate,
				LoginDate,
				LogoutDate,
				RequestIP,
				UserID,
				UserNode,
				PersonID,
				UserAgent,
				IsBot
			)
            SELECT  @SessionID ,
                    GETDATE() ,
                    GETDATE() ,
                    CASE WHEN @UserID IS NULL THEN NULL
                         ELSE GETDATE()
                    END ,
                    NULL ,
                    @RequestIP ,
                    @UserID ,
					(SELECT NodeID FROM [User.Account].[User] WHERE UserID = @UserID AND @UserID IS NOT NULL),
                    @PersonID,
                    @UserAgent,
                    0
                    
        -- Check if bot
        IF @UserAgent IS NOT NULL AND EXISTS (SELECT * FROM [User.Session].[Bot] WHERE @UserAgent LIKE UserAgent)
			UPDATE [User.Session].Session
				SET IsBot = 1
				WHERE SessionID = @SessionID

		-- Create a node
		DECLARE @Error INT
		DECLARE @NodeID BIGINT
		EXEC [RDF.].[GetStoreNode]	@DefaultURI = 1,
									@SessionID = @SessionID,
									@ViewSecurityGroup = 0,
									@EditSecurityGroup = -50,
									@Error = @Error OUTPUT,
									@NodeID = @NodeID OUTPUT

		-- If no error...
		IF (@Error = 0) AND (@NodeID IS NOT NULL)
		BEGIN
			-- Update the Session record with the NodeID
			UPDATE [User.Session].Session
				SET NodeID = @NodeID
				WHERE SessionID = @SessionID

			-- Update the ViewSecurityGroup of the session node
			UPDATE [RDF.].Node
				SET ViewSecurityGroup = @NodeID
				WHERE NodeID = @NodeID
 
			-- Add properties to the node
			DECLARE @TypeID BIGINT
			DECLARE @SessionClass BIGINT
			DECLARE @TripleID BIGINT
			SELECT	@TypeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
					@SessionClass = [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#Session')
			EXEC [RDF.].[GetStoreTriple]	@SubjectID = @NodeID,
											@PredicateID = @TypeID,
											@ObjectID = @SessionClass,
											@ViewSecurityGroup = @NodeID,
											@Weight = 1,
											@SortOrder = 1,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT,
											@TripleID = @TripleID OUTPUT
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

 
    SELECT *
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID AND @SessionID IS NOT NULL
 
END
GO
