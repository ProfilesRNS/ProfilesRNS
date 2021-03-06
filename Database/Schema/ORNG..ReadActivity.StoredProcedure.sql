SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [ORNG.].[ReadActivity](@Uri nvarchar(255),@AppID INT, @ActivityID INT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @NodeID bigint
	
	select @NodeID = [RDF.].[fnURI2NodeID](@Uri);

	select Activity from [ORNG.].Activity where NodeID = @NodeID AND AppID=@AppID AND ActivityID =@ActivityID
END

GO
