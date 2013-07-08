SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Person.GetPhotos](@NodeID bigINT)
AS
BEGIN

DECLARE @PersonID INT 

    SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
		
	SELECT  photo,
			p.PhotoID		
		FROM [Profile.Data].[Person.Photo] p WITH(NOLOCK)
	 WHERE PersonID=@PersonID  
END
GO
