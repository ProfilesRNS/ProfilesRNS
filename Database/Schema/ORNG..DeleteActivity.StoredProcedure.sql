SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORNG.].[DeleteActivity](@Uri nvarchar(255),@AppID INT, @ActivityID int)
As
BEGIN
	SET NOCOUNT ON
	DECLARE @NodeID bigint
	
	select @NodeID = [RDF.].[fnURI2NodeID](@Uri);	
	DELETE [ORNG.].[Activity] WHERE NodeID = @NodeID AND AppID = @AppID and ActivityID = @ActivityID
END		

GO
