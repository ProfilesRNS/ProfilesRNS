SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Framework.].[RunJobGroup]
	@JobGroup INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Exit if there is an error
	IF EXISTS (SELECT * FROM [Framework.].[Job] WHERE IsActive = 1 AND Status = 'ERROR')
	BEGIN
		RETURN
	END
	
	CREATE TABLE #Job (
		Step INT IDENTITY(0,1) PRIMARY KEY,
		JobID INT,
		Script NVARCHAR(MAX)
	)
	
	-- Get the list of job steps
	INSERT INTO #Job (JobID, Script)
		SELECT JobID, Script
			FROM [Framework.].[Job]
			WHERE JobGroup = @JobGroup AND IsActive = 1
			ORDER BY Step, JobID

	DECLARE @Step INT
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @LogID INT
	DECLARE @JobStart DATETIME
	DECLARE @JobEnd DATETIME
	DECLARE @JobID INT
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	DECLARE @date DATETIME,@auditid UNIQUEIDENTIFIER, @rows INT
	SELECT @date=GETDATE() 
	
	-- Loop through all steps
	WHILE EXISTS (SELECT * FROM #Job)
	BEGIN
		-- Get the next step
		SELECT @Step = (SELECT MIN(Step) FROM #Job)
		
		-- Get the SQL
		SELECT @SQL = Script, @JobID = JobID
			FROM #Job
			WHERE Step = @Step

		-- Wait until other jobs are complete
		WHILE EXISTS (SELECT *
						FROM [Framework.].[Job] o, #Job j
						WHERE o.JobID = j.JobID AND o.Status = 'PROCESSING')
		BEGIN
			WAITFOR DELAY '00:00:30'
		END

		-- Update the status
		SELECT @JobStart = GetDate()
		UPDATE o
			SET o.Status = 'PROCESSING', o.LastStart = @JobStart, o.LastEnd = NULL, o.ErrorCode = NULL, o.ErrorMsg = NULL
			FROM [Framework.].[Job] o, #Job j
			WHERE o.JobID = j.JobID AND j.Step = @Step
		INSERT INTO [Framework.].[Log.Job] (JobID, JobGroup, Step, Script, JobStart, Status)
			SELECT @JobID, @JobGroup, @Step, @SQL, @JobStart, 'PROCESSING'
		SELECT @LogID = @@IDENTITY
			
		
		-- Log Step Execution
		--SELECT @date=GETDATE()
		--EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@SQL,@ProcessStartDate=@date,@insert_new_record=1
		
		BEGIN TRY 
			-- Run the step
			EXEC sp_executesql @SQL
		END TRY 
		BEGIN CATCH
			--Check success
			IF @@TRANCOUNT > 0
				ROLLBACK
				
			--SELECT @date=GETDATE()
			--EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@SQL,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
			-- Log error 
			-- Update the status
			SELECT @JobEnd = GetDate()
			SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
			UPDATE o
				SET o.Status = 'JOB FAILED', o.LastEnd = GetDate(), o.ErrorCode = @ErrSeverity, o.ErrorMsg = @ErrMsg
				FROM [Framework.].[Job] o, #Job j
				WHERE o.JobID = j.JobID AND j.Step = @Step
			UPDATE [Framework.].[Log.Job]
				SET JobEnd = @JobEnd, Status = 'JOB FAILED', ErrorCode = @ErrSeverity, ErrorMsg = @ErrMsg
				WHERE LogID = @LogID
			--Raise an error with the details of the exception

			RAISERROR(@ErrMsg, @ErrSeverity, 1)
			RETURN
		END CATCH
		
		-- Log Step Execution
		--SELECT @date=GETDATE()
		--EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@SQL,@ProcessStartDate=@date,@insert_new_record=0
		
		
		-- Update the status
		SELECT @JobEnd = GetDate()
		UPDATE o
			SET o.Status = 'COMPLETED', o.LastEnd = GetDate(), o.ErrorCode = NULL, o.ErrorMsg = NULL
			FROM [Framework.].[Job] o, #Job j
			WHERE o.JobID = j.JobID AND j.Step = @Step
		UPDATE [Framework.].[Log.Job]
			SET JobEnd = @JobEnd, Status = 'COMPLETED'
			WHERE LogID = @LogID

		-- Remove the first step from the list
		DELETE j
			FROM #Job j
			WHERE Step = @Step
	END

END
GO
