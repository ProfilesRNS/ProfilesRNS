SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Direct.Framework].[AddLogOutgoing]
	@FSID uniqueidentifier,
	@SiteID int,
	@Details bit
AS
BEGIN
	INSERT INTO [Direct.].LogOutgoing(FSID, SiteID, Details, SentDate)
	values (@FSID, @SiteID, @Details, GETDATE())
END
GO
