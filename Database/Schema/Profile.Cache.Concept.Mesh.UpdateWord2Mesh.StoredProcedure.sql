SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdateWord2Mesh]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	select a.word, a.mesh_header
		into #cache_word2mesh
		from [Profile.Cache].[Concept.Mesh.Word2mesh2All] a, [Profile.Cache].[Concept.Mesh.Count] c
		where a.mesh_header = c.meshheader
	select a.word, a.mesh_header
		into #cache_word2mesh2
		from [Profile.Cache].[Concept.Mesh.Word2mesh2All] a, [Profile.Cache].[Concept.Mesh.Count] c
		where a.mesh_header = c.meshheader
	select a.word, a.mesh_term, a.mesh_header, a.num_words
		into #cache_word2mesh3
		from [Profile.Cache].[Concept.Mesh.Word2Mesh3All] a, [Profile.Cache].[Concept.Mesh.Count] c
		where a.mesh_header = c.meshheader
 
	BEGIN TRY
		BEGIN TRAN
			truncate TABLE [Profile.Cache].[Concept.Mesh.Word2mesh]
			insert into [Profile.Cache].[Concept.Mesh.Word2mesh](word, meshheader)
				select word, mesh_header from #cache_word2mesh
			truncate table [Profile.Cache].[Concept.Mesh.Word2mesh2]
			insert into [Profile.Cache].[Concept.Mesh.Word2mesh2](word, mesh_header)
				select word, mesh_header from #cache_word2mesh2
			truncate table [Profile.Cache].[Concept.Mesh.Word2mesh3]
			insert into [Profile.Cache].[Concept.Mesh.Word2mesh3](word, meshterm, meshheader, numwords)
				select word, mesh_term, mesh_header, num_words from #cache_word2mesh3
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
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
