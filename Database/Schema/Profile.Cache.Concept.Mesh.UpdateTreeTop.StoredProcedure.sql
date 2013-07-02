SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Cache].[Concept.Mesh.UpdateTreeTop]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	DECLARE @proc VARCHAR(200)
	SELECT @proc = OBJECT_NAME(@@PROCID)
	DECLARE @date DATETIME,@auditid UNIQUEIDENTIFIER, @rows int
	SELECT @date=GETDATE() 
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
 	select r.TreeNumber FullTreeNumber, 
			(case when len(r.TreeNumber)=1 then '' else left(r.TreeNumber,len(r.TreeNumber)-4) end) ParentTreeNumber,
			r.DescriptorName, IsNull(t.TreeNumber,r.TreeNumber) TreeNumber, t.DescriptorUI
		into #TreeTop
		from [Profile.Data].[Concept.Mesh.TreeTop] r
			left outer join [Profile.Data].[Concept.Mesh.Tree] t
				on t.TreeNumber = substring(r.TreeNumber,3,999)
			left outer join [Framework.].[Parameter] f
				on f.ParameterID = 'baseURI'
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.TreeTop]
			INSERT INTO [Profile.Cache].[Concept.Mesh.TreeTop] (FullTreeNumber, ParentTreeNumber, TreeNumber, DescriptorName, DescriptorUI)
				SELECT FullTreeNumber, ParentTreeNumber, TreeNumber, DescriptorName, DescriptorUI
				FROM #TreeTop
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName ='Concept.Mesh.UpdateTreeTop',@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
