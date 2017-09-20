SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Direct.Framework].[UpdateLogOutgoing]
	@FSID uniqueidentifier,
	@ResponseState int,
	@ResponseStatus int = NULL,
	@ResultText varchar(4000) = NULL,
	@ResultCount varchar(10) = NULL,
	@ResultDetailsURL varchar(1000) = NULL
AS
BEGIN
	UPDATE [Direct.].LogOutgoing SET ResponseTime = datediff(ms,SentDate,GetDate()),
	ResponseState = @ResponseState,
	ResponseStatus = ISNULL(@ResponseStatus, ResponseStatus),
	ResultText = ISNULL(@ResultText, ResultText),
	ResultCount = ISNULL(@ResultCount, ResultCount),
	ResultDetailsURL = ISNULL(@ResultDetailsURL, ResultDetailsURL)
	WHERE FSID = @FSID
END
GO
