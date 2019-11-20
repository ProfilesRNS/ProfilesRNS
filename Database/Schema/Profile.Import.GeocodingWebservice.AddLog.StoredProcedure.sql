SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [Profile.Import].[GeocodingWebservice.AddLog] (@ErrorText nvarchar(max))
AS
BEGIN
	insert into [Profile.Import].[GeocodingWebservice.Log] (LogTime, ErrorText) values (getdate(), @ErrorText)
END
GO
