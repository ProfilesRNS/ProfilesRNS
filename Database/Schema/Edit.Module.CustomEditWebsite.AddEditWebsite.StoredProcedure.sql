SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[CustomEditWebsite.AddEditWebsite]
	@ExistingURLID [varchar](50)=NULL
	, @NodeID bigint=NULL
	, @URL [varchar](max)=NULL
	, @WebPageTitle [varchar](max)=NULL
	, @PublicationDate [varchar](max)=NULL
	, @SortOrder int=NULL
	, @Delete bit=0
	, @Predicate [varchar](100)=NULL
AS
BEGIN
	DECLARE @InternalID INT, @InternalType NVARCHAR(300)
	DECLARE @DataMapID INT

	IF @ExistingURLID IS NOT NULL
	BEGIN
		DECLARE @ExistingOrder int

		IF EXISTS (SELECT 1 FROM [Profile.Data].[Person.Websites] WHERE UrlID = @ExistingURLID)
		BEGIN
			SELECT @InternalID = PersonID FROM [Profile.Data].[Person.Websites] WHERE UrlID = @ExistingURLID

			IF @DELETE=1 SELECT @SortOrder = MAX(SortOrder) FROM  [Profile.Data].[Person.Websites] WHERE PersonID = @InternalID

			IF @SortOrder IS NOT NULL
			BEGIN
				SELECT @SortOrder = CASE WHEN @SortOrder < 1 THEN 1 
						WHEN @SortOrder > (SELECT MAX(SortOrder) FROM  [Profile.Data].[Person.Websites] WHERE PersonID = @InternalID) THEN (SELECT MAX(SortOrder) FROM  [Profile.Data].[Person.Websites] WHERE PersonID = @InternalID)
						ELSE @SortOrder END
				
				SELECT @ExistingOrder = SortOrder FROM [Profile.Data].[Person.Websites] WHERE UrlID = @ExistingURLID

				IF @SortOrder < @ExistingOrder UPDATE [Profile.Data].[Person.Websites] SET SortOrder = SortOrder + 1 WHERE PersonID = @InternalID AND SortOrder >= @SortOrder AND SortOrder < @ExistingOrder
				ELSE IF @SortOrder > @ExistingOrder UPDATE [Profile.Data].[Person.Websites] SET SortOrder = SortOrder - 1 WHERE PersonID = @InternalID AND SortOrder <= @SortOrder AND SortOrder > @ExistingOrder			
				UPDATE [Profile.Data].[Person.Websites] SET SortOrder = @SortOrder WHERE UrlID = @ExistingURLID
			END

			IF @DELETE=1 DELETE FROM [Profile.Data].[Person.Websites] WHERE UrlID = @ExistingURLID
			ELSE UPDATE [Profile.Data].[Person.Websites] SET URL = ISNULL(@URL, URL), WebPageTitle = ISNULL(@WebPageTitle, WebPageTitle) WHERE UrlID = @ExistingURLID

			SELECT @DataMapID = DataMapID FROM [Ontology.].DataMap WHERE MapTable = '[Profile.Data].[Person.Websites]'
		END

		IF EXISTS (SELECT 1 FROM [Profile.Data].[Person.MediaLinks] WHERE UrlID = @ExistingURLID)
		BEGIN
			SELECT @InternalID = PersonID FROM [Profile.Data].[Person.MediaLinks] WHERE UrlID = @ExistingURLID

			IF @DELETE=1 SELECT @SortOrder = MAX(SortOrder) FROM  [Profile.Data].[Person.MediaLinks] WHERE PersonID = @InternalID

			IF @SortOrder IS NOT NULL
			BEGIN
				SELECT @SortOrder = CASE WHEN @SortOrder < 1 THEN 1 
						WHEN @SortOrder > (SELECT MAX(SortOrder) FROM  [Profile.Data].[Person.MediaLinks] WHERE PersonID = @InternalID) THEN (SELECT MAX(SortOrder) FROM  [Profile.Data].[Person.MediaLinks] WHERE PersonID = @InternalID)
						ELSE @SortOrder END
				SELECT @ExistingOrder = SortOrder FROM [Profile.Data].[Person.MediaLinks] WHERE UrlID = @ExistingURLID

				IF @SortOrder < @ExistingOrder UPDATE [Profile.Data].[Person.MediaLinks] SET SortOrder = SortOrder + 1 WHERE PersonID = @InternalID AND SortOrder >= @SortOrder AND SortOrder < @ExistingOrder
				ELSE IF @SortOrder > @ExistingOrder UPDATE [Profile.Data].[Person.MediaLinks] SET SortOrder = SortOrder - 1 WHERE PersonID = @InternalID AND SortOrder <= @SortOrder AND SortOrder > @ExistingOrder			
				UPDATE [Profile.Data].[Person.MediaLinks] SET SortOrder = @SortOrder WHERE UrlID = @ExistingURLID
			END

			IF @DELETE=1 DELETE FROM [Profile.Data].[Person.MediaLinks] WHERE UrlID = @ExistingURLID
			ELSE UPDATE [Profile.Data].[Person.MediaLinks] SET URL = ISNULL(@URL, URL), WebPageTitle = ISNULL(@WebPageTitle, WebPageTitle), PublicationDate = ISNULL(@PublicationDate, PublicationDate) WHERE UrlID = @ExistingURLID

			SELECT @DataMapID = DataMapID FROM [Ontology.].DataMap WHERE MapTable = '[Profile.Data].[Person.MediaLinks]'
		END

		IF EXISTS (SELECT 1 FROM [Profile.Data].[Group.Websites] WHERE UrlID = @ExistingURLID)
		BEGIN
			SELECT @InternalID = GroupID FROM [Profile.Data].[Group.Websites] WHERE UrlID = @ExistingURLID

			IF @DELETE=1 SELECT @SortOrder = MAX(SortOrder) FROM  [Profile.Data].[Group.Websites] WHERE GroupID = @InternalID

			IF @SortOrder IS NOT NULL
			BEGIN
				SELECT @SortOrder = CASE WHEN @SortOrder < 1 THEN 1 
						WHEN @SortOrder > (SELECT MAX(SortOrder) FROM  [Profile.Data].[Group.Websites] WHERE GroupID = @InternalID) THEN (SELECT MAX(SortOrder) FROM  [Profile.Data].[Group.Websites] WHERE GroupID = @InternalID)
						ELSE @SortOrder END
				
				SELECT @ExistingOrder = SortOrder FROM [Profile.Data].[Group.Websites] WHERE UrlID = @ExistingURLID

				IF @SortOrder < @ExistingOrder UPDATE [Profile.Data].[Group.Websites] SET SortOrder = SortOrder + 1 WHERE GroupID = @InternalID AND SortOrder >= @SortOrder AND SortOrder < @ExistingOrder
				ELSE IF @SortOrder > @ExistingOrder UPDATE [Profile.Data].[Group.Websites] SET SortOrder = SortOrder - 1 WHERE GroupID = @InternalID AND SortOrder <= @SortOrder AND SortOrder > @ExistingOrder			
				UPDATE [Profile.Data].[Group.Websites] SET SortOrder = @SortOrder WHERE UrlID = @ExistingURLID
			END

			IF @DELETE=1 DELETE FROM [Profile.Data].[Group.Websites] WHERE UrlID = @ExistingURLID
			ELSE UPDATE [Profile.Data].[Group.Websites] SET URL = ISNULL(@URL, URL), WebPageTitle = ISNULL(@WebPageTitle, WebPageTitle) WHERE UrlID = @ExistingURLID

			SELECT @DataMapID = DataMapID FROM [Ontology.].DataMap WHERE MapTable = '[Profile.Data].[Group.Websites]'
		END

		IF EXISTS (SELECT 1 FROM [Profile.Data].[Group.MediaLinks] WHERE UrlID = @ExistingURLID)
		BEGIN
			SELECT @InternalID = GroupID FROM [Profile.Data].[Group.MediaLinks] WHERE UrlID = @ExistingURLID

			IF @DELETE=1 SELECT @SortOrder = MAX(SortOrder) FROM  [Profile.Data].[Group.MediaLinks] WHERE GroupID = @InternalID

			IF @SortOrder IS NOT NULL
			BEGIN
				SELECT @SortOrder = CASE WHEN @SortOrder < 1 THEN 1 
						WHEN @SortOrder > (SELECT MAX(SortOrder) FROM  [Profile.Data].[Group.MediaLinks] WHERE GroupID = @InternalID) THEN (SELECT MAX(SortOrder) FROM  [Profile.Data].[Group.MediaLinks] WHERE GroupID = @InternalID)
						ELSE @SortOrder END
				SELECT @ExistingOrder = SortOrder FROM [Profile.Data].[Group.MediaLinks] WHERE UrlID = @ExistingURLID

				IF @SortOrder < @ExistingOrder UPDATE [Profile.Data].[Group.MediaLinks] SET SortOrder = SortOrder + 1 WHERE GroupID = @InternalID AND SortOrder >= @SortOrder AND SortOrder < @ExistingOrder
				ELSE IF @SortOrder > @ExistingOrder UPDATE [Profile.Data].[Group.MediaLinks] SET SortOrder = SortOrder - 1 WHERE GroupID = @InternalID AND SortOrder <= @SortOrder AND SortOrder > @ExistingOrder			
				UPDATE [Profile.Data].[Group.MediaLinks] SET SortOrder = @SortOrder WHERE UrlID = @ExistingURLID
			END

			IF @DELETE=1 DELETE FROM [Profile.Data].[Group.MediaLinks] WHERE UrlID = @ExistingURLID
			ELSE UPDATE [Profile.Data].[Group.MediaLinks] SET URL = ISNULL(@URL, URL), WebPageTitle = ISNULL(@WebPageTitle, WebPageTitle), PublicationDate = ISNULL(@PublicationDate, PublicationDate) WHERE UrlID = @ExistingURLID

			SELECT @DataMapID = DataMapID FROM [Ontology.].DataMap WHERE MapTable = '[Profile.Data].[Group.MediaLinks]'
		END
	END



	IF @NodeID IS NOT NULL AND @ExistingURLID IS NULL
	BEGIN 
		SELECT @InternalID = CAST(m.InternalID AS INT),
			@InternalType = InternalType
 			FROM [RDF.Stage].[InternalNodeMap] m
			WHERE m.Status = 3 AND m.NodeID = @NodeID

		SELECT @ExistingURLID = NEWID()
		
		IF @InternalType = 'Person' AND @Predicate = 'http://vivoweb.org/ontology/core#webpage'
		BEGIN
			INSERT INTO [Profile.Data].[Person.Websites] (UrlID, PersonID, URL, WebPageTitle, SortOrder) 
			VALUES(@ExistingURLID, @InternalID, @URL, @WebPageTitle, ISNULL((SELECT MAX(SortOrder) + 1 FROM  [Profile.Data].[Person.Websites] WHERE PersonID = @InternalID), 1))

			SELECT @DataMapID = DataMapID FROM [Ontology.].DataMap WHERE MapTable = '[Profile.Data].[Person.Websites]'
		END

		IF @InternalType = 'Person' AND @Predicate = 'http://profiles.catalyst.harvard.edu/ontology/prns#mediaLinks'
		BEGIN
			INSERT INTO [Profile.Data].[Person.MediaLinks] (UrlID, PersonID, URL, WebPageTitle, PublicationDate, SortOrder) 
			VALUES(@ExistingURLID, @InternalID, @URL, @WebPageTitle, @PublicationDate, ISNULL((SELECT MAX(SortOrder) + 1 FROM  [Profile.Data].[Person.MediaLinks] WHERE PersonID = @InternalID), 1))

			SELECT @DataMapID = DataMapID FROM [Ontology.].DataMap WHERE MapTable = '[Profile.Data].[Person.MediaLinks]'
		END

		IF @InternalType = 'Group' AND @Predicate = 'http://vivoweb.org/ontology/core#webpage'
		BEGIN
			INSERT INTO [Profile.Data].[Group.Websites] (UrlID, GroupID, URL, WebPageTitle, SortOrder) 
			VALUES(@ExistingURLID, @InternalID, @URL, @WebPageTitle, ISNULL((SELECT MAX(SortOrder) + 1 FROM  [Profile.Data].[Group.Websites] WHERE GroupID = @InternalID), 1))

			SELECT @DataMapID = DataMapID FROM [Ontology.].DataMap WHERE MapTable = '[Profile.Data].[Group.Websites]'
		END

		IF @InternalType = 'Group' AND @Predicate = 'http://profiles.catalyst.harvard.edu/ontology/prns#mediaLinks'
		BEGIN
			INSERT INTO [Profile.Data].[Group.MediaLinks] (UrlID, GroupID, URL, WebPageTitle, PublicationDate, SortOrder) 
			VALUES(@ExistingURLID, @InternalID, @URL, @WebPageTitle, @PublicationDate, ISNULL((SELECT MAX(SortOrder) + 1 FROM  [Profile.Data].[Group.MediaLinks] WHERE GroupID = @InternalID), 1))

			SELECT @DataMapID = DataMapID FROM [Ontology.].DataMap WHERE MapTable = '[Profile.Data].[Group.MediaLinks]'
		END
	END


	-- *******************************************************************
	-- *******************************************************************
	-- Update RDF
	-- *******************************************************************
	-- *******************************************************************

	CREATE TABLE #sql (
		i INT IDENTITY(0,1) PRIMARY KEY,
		s NVARCHAR(MAX)
	)
		INSERT INTO #sql (s)
		SELECT	'EXEC [RDF.Stage].ProcessDataMap '
					+'  @DataMapID = '+CAST(DataMapID AS VARCHAR(50))
					+', @InternalIdIn = '''''''+@ExistingURLID
					+''''''', @TurnOffIndexing=0, @SaveLog=0; '
		FROM [Ontology.].DataMap WHERE MapTable = '[Profile.Data].[vwURL]' ORDER BY DataMapID


		INSERT INTO #sql (s)
		SELECT	'EXEC [RDF.Stage].ProcessDataMap '
					+'  @DataMapID = '+CAST(@DataMapID AS VARCHAR(50))
					+', @InternalIdIn = '+CAST(@InternalID AS VARCHAR(50))
					+', @TurnOffIndexing=0, @SaveLog=0; '


	DECLARE @s NVARCHAR(MAX)
	WHILE EXISTS (SELECT * FROM #sql)
	BEGIN
		SELECT @s = s
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
		print @s
		EXEC sp_executesql @s
		DELETE
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
	END
END
GO
