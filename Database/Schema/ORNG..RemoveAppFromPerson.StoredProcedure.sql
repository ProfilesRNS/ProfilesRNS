SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORNG.].[RemoveAppFromPerson]
@SubjectID BIGINT=NULL, @SubjectURI nvarchar(255)=NULL, @AppID INT, @SessionID UNIQUEIDENTIFIER=NULL, @Error BIT=NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ApplicationNodeID BIGINT
	DECLARE @TripleID BIGINT
	DECLARE @PersonID INT	
	DECLARE @PERSON_FILTER_ID INT
	DECLARE @InternalUserName nvarchar(50)
	DECLARE @PersonFilter nvarchar(50)

	IF (@SubjectID IS NULL)
		SET @SubjectID = [RDF.].fnURI2NodeID(@SubjectURI)
	
	--get the Application node, next find all ApplicationInstance SUBJECTS that have a Prediate 
	SELECT @ApplicationNodeID = t.[Subject] FROM [RDF.].Triple t Join
		[RDF.].Node n ON t.[Object] = n.nodeid WHERE t.Predicate IN (
			SELECT _PropertyNode FROM [Ontology.].[ClassProperty] WHERE
				Class = 'http://orng.info/ontology/orng#Application' and 
				Property = 'http://orng.info/ontology/orng#applicationId') 
		AND n.Value = CAST(@AppID as VARCHAR)	
			
	-- there is only ONE link from the person to the application object, so grab it	
	SELECT @TripleID = [TripleID] FROM [RDF.].Triple 
		WHERE [Subject] = @SubjectID
		AND [Object] IN (SELECT [Subject] FROM [RDF.].Triple 
		WHERE [Predicate] = [RDF.].fnURI2NodeID('http://orng.info/ontology/orng#applicationInstanceOfApplication')
		AND [Object] = @ApplicationNodeID)
		
	-- now delete it
	BEGIN TRAN

		EXEC [RDF.].DeleteTriple @TripleID = @TripleID, 
								 @SessionID = @SessionID, 
								 @Error = @Error

		-- remove any filters
		SELECT @PERSON_FILTER_ID = (SELECT PersonFilterID FROM Apps WHERE AppID = @AppID)
		IF (@PERSON_FILTER_ID IS NOT NULL) 
			BEGIN
				SELECT @PersonID = cast(InternalID as INT) FROM [RDF.Stage].[InternalNodeMap]
					WHERE [NodeID] = @SubjectID AND Class = 'http://xmlns.com/foaf/0.1/Person'

				SELECT @InternalUserName = InternalUserName FROM [Profile.Data].[Person] WHERE PersonID = @PersonID
				SELECT @PersonFilter = PersonFilter FROM [Profile.Data].[Person.Filter] WHERE PersonFilterID = @PERSON_FILTER_ID

				DELETE FROM [Profile.Import].[PersonFilterFlag] WHERE InternalUserName = @InternalUserName AND personfilter = @PersonFilter
				DELETE FROM [Profile.Data].[Person.FilterRelationship] WHERE PersonID = @PersonID AND personFilterId = @PERSON_FILTER_ID
			END
	COMMIT
END


GO
