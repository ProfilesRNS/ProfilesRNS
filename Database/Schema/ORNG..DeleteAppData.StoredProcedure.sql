SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORNG.].[DeleteAppData](@Uri nvarchar(255),@AppID INT, @Keyname nvarchar(255))
As
BEGIN
	SET NOCOUNT ON
	DECLARE @NodeID bigint
	
	SELECT @NodeID = [RDF.].[fnURI2NodeID](@Uri);
	DELETE [ORNG.].[AppData] WHERE NodeID = @NodeID AND AppID = @AppID and Keyname = @Keyname
END		


GO
