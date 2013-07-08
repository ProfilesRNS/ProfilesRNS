SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Proxy.DeleteDesignatedProxy]
	@SessionID UNIQUEIDENTIFIER,
	@UserID VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;


	-- Get the UserID of the SessionID. Exit if not found.
	DECLARE @SessionUserID INT
	SELECT @SessionUserID = UserID
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID
	IF @SessionUserID IS NULL
		RETURN
	
	-- Add the designated proxy
	DELETE
		FROM [User.Account].[DesignatedProxy]
		WHERE UserID = @UserID AND ProxyForUserID = @SessionUserID

END
GO
