SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Person.GetPhotos](@NodeID bigINT)
AS
BEGIN

DECLARE @InternalID INT, @InternalType NVARCHAR(300)

    SELECT @InternalID = CAST(m.InternalID AS INT),
		@InternalType = InternalType
 		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID

	IF @InternalType = 'Person'
	BEGIN
		SELECT  photo,
				p.PhotoID		
			FROM [Profile.Data].[Person.Photo] p WITH(NOLOCK)
		 WHERE PersonID=@InternalID  
	 END

	ELSE IF @InternalType = 'Group' 
	BEGIN
		SELECT  photo,
				p.PhotoID		
			FROM [Profile.Data].[Group.Photo] p WITH(NOLOCK)
		 WHERE GroupID=@InternalID  
	 END
END
GO
