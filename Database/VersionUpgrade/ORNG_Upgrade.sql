/****** Object:  StoredProcedure [ORNG.].[IsRegistered]    Script Date: 03/10/2015 11:10:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ORNG.].[IsRegistered]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ORNG.].[IsRegistered]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_orng_app_registry_createdDT]') AND type = 'D')
BEGIN
ALTER TABLE [ORNG.].[AppRegistry] DROP CONSTRAINT [DF_orng_app_registry_createdDT]
END

GO

/****** Object:  Table [ORNG.].[AppRegistry]    Script Date: 03/10/2015 11:11:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ORNG.].[AppRegistry]') AND type in (N'U'))
DROP TABLE [ORNG.].[AppRegistry]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Apps__RequiresRe__1699586C]') AND type = 'D')
BEGIN
ALTER TABLE [ORNG.].[Apps] DROP CONSTRAINT [DF__Apps__RequiresRe__1699586C]
END
GO

/****** Object:  Table [ORNG.].[Apps]    Script Date: 03/10/2015 11:11:22 ******/
IF EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'RequiresRegistration' AND [object_id] = OBJECT_ID(N'[ORNG.].[Apps]'))
BEGIN
	ALTER TABLE [ORNG.].[Apps] DROP COLUMN RequiresRegistration
END
GO

IF EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'UnavailableMessage' AND [object_id] = OBJECT_ID(N'[ORNG.].[Apps]'))
BEGIN
	ALTER TABLE [ORNG.].[Apps] DROP COLUMN UnavailableMessage
END
GO
/****** Object:  StoredProcedure [ORNG.].[RemoveAppFromPerson]    Script Date: 03/10/2015 11:17:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [ORNG.].[RemoveAppFromPerson]
@SubjectID BIGINT=NULL, @SubjectURI NVARCHAR(255)=NULL, @AppID INT, @DeleteType tinyint = 1, @SessionID UNIQUEIDENTIFIER=NULL, @Error BIT=NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ApplicationInstanceNodeID  BIGINT
	DECLARE @TripleID BIGINT
	DECLARE @PersonID INT	
	DECLARE @PERSON_FILTER_ID INT
	DECLARE @InternalUserName NVARCHAR(50)
	DECLARE @PersonFilter NVARCHAR(50)

	IF (@SubjectID IS NULL)
		SET @SubjectID = [RDF.].fnURI2NodeID(@SubjectURI)
	
	-- Lookup the PersonID
	SELECT @PersonID = CAST(InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap]
		WHERE Class = 'http://xmlns.com/foaf/0.1/Person' AND InternalType = 'Person' AND NodeID = @SubjectID

	-- Lookup the App Instance's NodeID
	SELECT @ApplicationInstanceNodeID  = NodeID
		FROM [RDF.Stage].[InternalNodeMap]
		WHERE Class = 'http://orng.info/ontology/orng#ApplicationInstance' AND InternalType = 'ORNG Application Instance'
			AND InternalID = CAST(@PersonID AS VARCHAR(50)) + '-' + CAST(@AppID AS VARCHAR(50))
	
		
	-- there is only ONE link from the person to the application object, so grab it	
	SELECT @TripleID = [TripleID] FROM [RDF.].Triple 
		WHERE [Subject] = @SubjectID
		AND [Object] = @ApplicationInstanceNodeID

	-- now delete it
	BEGIN TRAN

		EXEC [RDF.].DeleteTriple @TripleID = @TripleID, 
								 @SessionID = @SessionID, 
								 @Error = @Error

		IF (@DeleteType = 0) -- true delete, remove the now orphaned application instance
		BEGIN
			EXEC [RDF.].DeleteNode @NodeID = @ApplicationInstanceNodeID, 
							   @DeleteType = @DeleteType,
							   @SessionID = @SessionID, 
							   @Error = @Error OUTPUT
		END							   

		-- remove any filters
		SELECT @PERSON_FILTER_ID = (SELECT PersonFilterID FROM Apps WHERE AppID = @AppID)
		IF (@PERSON_FILTER_ID IS NOT NULL) 
			BEGIN
				SELECT @PersonID = CAST(InternalID AS INT) FROM [RDF.Stage].[InternalNodeMap]
					WHERE [NodeID] = @SubjectID AND Class = 'http://xmlns.com/foaf/0.1/Person'

				SELECT @InternalUserName = InternalUserName FROM [Profile.Data].[Person] WHERE PersonID = @PersonID
				SELECT @PersonFilter = PersonFilter FROM [Profile.Data].[Person.Filter] WHERE PersonFilterID = @PERSON_FILTER_ID

				DELETE FROM [Profile.Import].[PersonFilterFlag] WHERE InternalUserName = @InternalUserName AND personfilter = @PersonFilter
				DELETE FROM [Profile.Data].[Person.FilterRelationship] WHERE PersonID = @PersonID AND personFilterId = @PERSON_FILTER_ID
			END
	COMMIT
END



GO


/******* Update the default apps, keep protocol the same *******/
UPDATE [ORNG.].[Apps] SET [Url] = REPLACE(Url, '://profiles.ucsf.edu/apps_2.1/', '://profiles.ucsf.edu/apps_2.5/')

/*************  Add some new ones? **************/

/************** Need to remove the old ones and add them back to set the security flags appropriately  *****************/
UPDATE [ORNG.].Apps SET [Enabled] = 1

EXEC [ORNG.].RemoveAppFromOntology @AppID = 112;
EXEC [ORNG.].AddAppToOntology @AppID = 112;

EXEC [ORNG.].RemoveAppFromOntology @AppID = 101;
EXEC [ORNG.].AddAppToOntology @AppID = 101;

EXEC [ORNG.].RemoveAppFromOntology @AppID = 103;
EXEC [ORNG.].AddAppToOntology @AppID = 103;

EXEC [ORNG.].RemoveAppFromOntology @AppID = 114;
EXEC [ORNG.].AddAppToOntology @AppID = 114;