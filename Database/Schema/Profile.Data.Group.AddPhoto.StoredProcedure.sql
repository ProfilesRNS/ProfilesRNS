SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Group.AddPhoto]
	@GroupID INT=NULL,
	@GroupNodeID BIGINT=NULL,
	@Photo VARBINARY(MAX)=NULL,
	@PhotoLink NVARCHAR(MAX)=NULL
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@GroupID IS NULL) AND (@GroupNodeID IS NOT NULL)
	SELECT @GroupID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @GroupNodeID

	-- Only one custom photo per user, so replace any existing custom photos
	IF EXISTS (SELECT 1 FROM [Profile.Data].[Group.Photo] WHERE GroupID = @Groupid)
		BEGIN 
			UPDATE [Profile.Data].[Group.Photo] SET photo = @photo, PhotoLink = @PhotoLink WHERE GroupID = @Groupid 
		END
	ELSE 
		BEGIN 
			INSERT INTO [Profile.Data].[Group.Photo](GroupID ,Photo,PhotoLink) VALUES(@GroupID,@Photo,@PhotoLink)
		END 
	
	DECLARE @NodeID BIGINT
	DECLARE @URI VARCHAR(400)
	DECLARE @URINodeID BIGINT
	SELECT @NodeID = GroupNodeID, @URI = URI
		FROM [Profile.Data].[vwGroup.Photo]
		WHERE GroupID = @GroupID
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
