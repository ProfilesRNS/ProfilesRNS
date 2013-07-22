SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdateWord2MeshAll]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
 
 
	select distinct nref.value('.','varchar(max)') word, m mesh_header 
		into #cwm
		from (
			select m, cast(replace(
				'<x><w>'+replace(v,' ','</w><w>')+'</w></x>',
				'<w></w>','') as xml) x
			from (select m, 
				replace(
				replace(
				replace(
				replace(
				replace(
				replace(m,
					nchar(11),' '),
					',',' '),
					'-',' '),
					'&','&amp;'),
					'<','&lt;'),
					'>','&gt;') v 
				from (
					select distinct DescriptorName m from [Profile.Data].[Concept.Mesh.Descriptor]
				) t
			) t
		) t
		cross apply x.nodes('//w') as R(nref)
 
	select distinct word, TermName mesh_term, DescriptorName as mesh_header, 0 num_words
		into #cwm3
		from [Profile.Data].[Concept.Mesh.Term]
			cross apply [Utility.NLP].fnNormalizeSplitStem(termname)
	create nonclustered index idx_ht on #cwm3(mesh_header, mesh_term)
	update c
		set c.num_words = t.n
		from #cwm3 c, (
			select mesh_header, mesh_term, count(*) n
			from #cwm3
			group by mesh_header, mesh_term
		) t
		where c.mesh_header = t.mesh_header and c.mesh_term = t.mesh_term
 
	select distinct word, mesh_header
		into #cwm2
		from #cwm3
 BEGIN TRY
	begin transaction
 
		delete FROM [Profile.Cache].[Concept.Mesh.Word2meshAll]
		insert into [Profile.Cache].[Concept.Mesh.Word2meshAll] (word, mesh_header)
			select word, mesh_header from #cwm
 
		delete from [Profile.Cache].[Concept.Mesh.Word2mesh2All]
		insert into [Profile.Cache].[Concept.Mesh.Word2mesh2All] (word, mesh_header)
			select word, mesh_header from #cwm2
 
		delete from [Profile.Cache].[Concept.Mesh.Word2Mesh3All]
		insert into [Profile.Cache].[Concept.Mesh.Word2Mesh3All] (word, mesh_term, mesh_header, num_words)
			select word, mesh_term, mesh_header, num_words from #cwm3
 
	commit transaction
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@error = 1,@insert_new_record=0
		-- Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
