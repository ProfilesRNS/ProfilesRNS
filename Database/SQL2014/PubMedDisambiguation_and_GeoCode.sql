USE [msdb]
GO

/****** Object:  Job [PubMedDisambiguation_GetPubs_10]    Script Date: 02/07/2013 12:48:47 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 02/07/2013 12:48:48 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'$(YourProfilesDatabaseName)_PubMedDisambiguation_and_GeoCode', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [PubMedDisambiguation_GetPubs]    Script Date: 02/07/2013 12:48:49 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PubMedDisambiguation_GetPubs0', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'C:\Program Files\Microsoft SQL Server\120\DTS\Binn\DTEXEC.EXE /SQL "\PubMedDisambiguation_GetPubs" /SERVER $(YourProfilesServerName)  /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /SET "\Package.Variables[ServerName].Value";$(YourProfilesServerName) /SET "\Package.Variables[DatabaseName].Value";$(YourProfilesDatabaseName) /SET "\Package.Variables[HMSPubMedWebService].Value";http://profiles.catalyst.harvard.edu/services/GetPMIDs/default.asp /SET "\Package.Variables[HMSPubMedXMLWebService].Value";http://profiles.catalyst.harvard.edu/services/GetPMIDs/GetPubMedXML.asp /REPORTING E', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [PubMedDisambiguation_GetPubMEDXML]    Script Date: 02/07/2013 12:48:49 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PubMedDisambiguation_GetPubMEDXML', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'C:\Program Files\Microsoft SQL Server\120\DTS\Binn\DTEXEC.EXE /SQL "\PubMedDisambiguation_GetPubMEDXML" /SERVER $(YourProfilesServerName)  /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /SET "\Package.Variables[ServerName].Value";$(YourProfilesServerName) /SET "\Package.Variables[DatabaseName].Value";$(YourProfilesDatabaseName) /SET "\Package.Variables[GetOnlyNewXML].Value";"TRUE" /SET "\Package.Variables[HMSPubMedWebService].Value";http://profiles.catalyst.harvard.edu/services/GetPMIDs/default.asp /SET "\Package.Variables[HMSPubMedXMLWebService].Value";http://profiles.catalyst.harvard.edu/services/GetPMIDs/GetPubMedXML.asp /REPORTING E', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Load Pubs]    Script Date: 02/07/2013 12:48:49 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Load Pubs', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec  [Profile.Data].[Publication.Pubmed.LoadDisambiguationResults]', 
		@database_name=N'$(YourProfilesDatabaseName)', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [GeoCode]    Script Date: 02/07/2013 12:48:49 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Geocode', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=N'/SQL "\ProfilesGeoCode" /SERVER $(YourProfilesServerName) /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /SET "\Package.Variables[ServerName].Value";$(YourProfilesServerName) /SET "\Package.Variables[DatabaseName].Value";$(YourProfilesDatabaseName) /REPORTING E', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Run Jobs]    Script Date: 02/07/2013 12:48:49 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run Jobs', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [Framework.].[RunJobGroup] @JobGroup = 7
EXEC [Framework.].[RunJobGroup] @JobGroup = 8
EXEC [Framework.].[RunJobGroup] @JobGroup = 9
EXEC [Framework.].[RunJobGroup] @JobGroup = 3', 
		@database_name=N'$(YourProfilesDatabaseName)', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO