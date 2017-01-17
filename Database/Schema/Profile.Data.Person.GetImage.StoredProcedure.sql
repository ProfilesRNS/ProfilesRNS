/****** Object:  StoredProcedure [Profile.Data].[Person.GetImages]    Script Date: 1/17/17 4:16:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [Profile.Data].[Person.GetImages](@NodeID bigINT, @photoNum bigint=1)
AS
BEGIN

DECLARE @PersonID INT

    SELECT @PersonID = CAST(m.InternalID AS INT)
        FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
        WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
       
    SELECT  photo,
            p.PhotoID       
        FROM [Profile.Data].[Person.Images] p WITH(NOLOCK)
     WHERE PersonID=@PersonID and photoNum=@photoNum
END


GO


