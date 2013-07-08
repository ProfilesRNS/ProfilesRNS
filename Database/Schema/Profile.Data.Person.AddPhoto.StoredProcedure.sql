SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Person.AddPhoto]
	@PersonID INT,
	@Photo VARBINARY(MAX)=NULL,
	@PhotoLink NVARCHAR(MAX)=NULL
AS
BEGIN
	
	SET NOCOUNT ON;

	-- Only one custom photo per user, so replace any existing custom photos

	IF EXISTS (SELECT 1 FROM [Profile.Data].[Person.Photo] WHERE PersonID = @personid)
		BEGIN 
			UPDATE [Profile.Data].[Person.Photo] SET photo = @photo, PhotoLink = @PhotoLink WHERE PersonID = @personid 
		END
	ELSE 
		BEGIN 
			INSERT INTO [Profile.Data].[Person.Photo](PersonID ,Photo,PhotoLink) VALUES(@PersonID,@Photo,@PhotoLink)
		END 
	
	DECLARE @NodeID BIGINT
	DECLARE @URI VARCHAR(400)
	DECLARE @URINodeID BIGINT
	SELECT @NodeID = PersonNodeID, @URI = URI
		FROM [Profile.Data].[vwPerson.Photo]
		WHERE PersonID = @PersonID
	IF (@NodeID IS NOT NULL AND @URI IS NOT NULL)
		BEGIN
			EXEC [RDF.].[GetStoreNode] @Value = @URI, @NodeID = @URINodeID OUTPUT
			IF (@URINodeID IS NOT NULL)
				EXEC [RDF.].[GetStoreTriple]	@SubjectID = @NodeID,
												@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#mainImage',
												@ObjectID = @URINodeID
		END
 
END
GO
