SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Direct.Framework].[AddLogIncoming]
	@Details bit,
	@RequestIP varchar(16),
	@QueryString varchar(1000)
AS
BEGIN
	INSERT INTO [Direct.].LogIncoming(Details,ReceivedDate,RequestIP,QueryString)
	values (@Details, GETDATE(), @RequestIP, @QueryString)
END

GO
