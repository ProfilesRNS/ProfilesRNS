SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[PRNSWebservice.ImportData]
	@Job varchar(55),
	@BatchID varchar(100) = '',
	@RowID int = -1,
	@HttpResponseCode int = -1,
	@LogID int = -1,
	@URL varchar (500) = '',
	@Data varchar(max)
AS
BEGIN
	if EXISTS (SELECT 1 FROM [Profile.Import].[PRNSWebservice.Options] WHERE job = @Job AND logLevel = 2) OR @HttpResponseCode <> 200
	begin
		if @LogID > 0
		begin
			select @LogID = isnull(@LogID, -1) from [Profile.Import].[PRNSWebservice.Log] where BatchID = @BatchID and RowID = @RowID
		end

		if @LogID > 0
			update [Profile.Import].[PRNSWebservice.Log] set HttpResponseCode = @HttpResponseCode, 
															 HttpResponse = @Data, 
															 Success = Case when @HttpResponseCode = 200 then null else 0 end 
				where LogID = @LogID
		else
			insert into [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID, URL, HttpResponseCode, HttpResponse, Success) Values (@Job, @BatchID, @RowID, @URL, @HttpResponseCode, @Data, Case when @HttpResponseCode = 200 then null else 0 end)
	end


	if @HttpResponseCode = 200
	begin
		declare @proc varchar(100), @sql nvarchar(2000)
		select @proc = ImportDataProc from [Profile.Import].[PRNSWebservice.Options] where job = @job
		if @proc is null
		BEGIN
			RAISERROR('Job doesn''t exist', 16, -1)
			return
		END

		exec @proc @data=@data, @URL=@URL, @BatchID=@BatchID, @RowID=@RowID, @LogID=@LogID, @Job=@Job
	END
END

GO
