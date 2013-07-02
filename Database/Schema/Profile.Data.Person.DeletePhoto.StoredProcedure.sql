SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Person.DeletePhoto](@PhotoID INT)
AS
BEGIN

	-- Delete the triple
	DECLARE @NodeID BIGINT
	SELECT @NodeID = PersonNodeID
		FROM [Profile.Data].[vwPerson.Photo]
		WHERE PhotoID = @PhotoID
	IF (@NodeID IS NOT NULL)
		EXEC [RDF.].[DeleteTriple] @SubjectID = @NodeID, @PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#mainImage'

	-- Delete the photo
	DELETE 
		FROM [Profile.Data].[Person.Photo]
		WHERE PhotoID=@PhotoID 

END
GO
