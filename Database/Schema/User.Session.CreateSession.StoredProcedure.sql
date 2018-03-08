SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [User.Session].[CreateSession]
    @RequestIP VARCHAR(16),
    @UserAgent VARCHAR(500) = NULL,
    @UserID VARCHAR(200) = NULL,
	@SessionPersonNodeID BIGINT = NULL OUTPUT,
	@SessionPersonURI VARCHAR(400) = NULL OUTPUT,
	@SecurityGroupID BIGINT = NULL OUTPUT
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
	IF EXISTS (SELECT 1 FROM [Profile.Data].Person WHERE PersonID = @PersonID AND IsActive = 1)
	BEGIN
		SELECT @SessionPersonNodeID = m.NodeID, @SessionPersonURI = p.Value + CAST(m.NodeID AS VARCHAR(50))
			FROM [RDF.Stage].InternalNodeMap m, [Framework.].[Parameter] p
			WHERE m.InternalID = @PersonID
				AND m.InternalType = 'person'
				AND m.Class = 'http://xmlns.com/foaf/0.1/Person'
				AND p.ParameterID = 'baseURI'
	END


	-- Create a SessionID
    DECLARE @SessionID UNIQUEIDENTIFIER
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
	DECLARE @IsBot BIT
	SELECT @IsBot = 0
	SELECT @IsBot = 1
		WHERE @UserAgent IS NOT NULL AND EXISTS (SELECT * FROM [User.Session].[Bot] WHERE @UserAgent LIKE UserAgent)
	If (@IsBot = 1)
		UPDATE [User.Session].Session
			SET IsBot = 1
			WHERE SessionID = @SessionID

	-- Create a node if not a bot
	If (@IsBot = 0)
	BEGIN

		-- Get the BaseURI
		DECLARE @baseURI NVARCHAR(400)
		SELECT @baseURI = Value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

		-- Create the Node
		DECLARE @NodeID BIGINT
		DECLARE @NodeIDTable TABLE (nodeId BIGINT)
		DECLARE @TempValue varchar(50)
		SELECT @TempValue = '#NODE'+cast(NewID() as varchar(50))
		INSERT INTO [RDF.].[Node] (ViewSecurityGroup, EditSecurityGroup, Value, ObjectType, ValueHash)
			  OUTPUT Inserted.NodeID INTO @NodeIDTable
			  select 0, -50, @TempValue, 0,
					[RDF.].[fnValueHash](NULL,NULL,@TempValue)
		SELECT @NodeID = nodeId from @NodeIDTable
		UPDATE [RDF.].[Node]
			SET ViewSecurityGroup = @NodeID,
				Value = @baseURI+cast(@NodeID as nvarchar(50)),
				ValueHash = [RDF.].fnValueHash(null,null,@baseURI+cast(@NodeID as nvarchar(50)))
			WHERE NodeID = @NodeID

		-- Add properties to the node
		DECLARE @Error INT
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

		-- If no error, then assign the NodeID to the session
		IF (@Error = 0)
		BEGIN
			-- Update the Session record with the NodeID
			UPDATE [User.Session].Session
				SET NodeID = @NodeID
				WHERE SessionID = @SessionID
		END
	END

	-- Get the security group of the session
	EXEC [RDF.Security].[GetSessionSecurityGroup] @SessionID = @SessionID, @SecurityGroupID = @SecurityGroupID OUTPUT

    SELECT *, @SecurityGroupID SecurityGroupID
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID AND @SessionID IS NOT NULL
 
END
GO
