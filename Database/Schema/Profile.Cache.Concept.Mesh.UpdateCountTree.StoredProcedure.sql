SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdateCountTree]
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
 
 
	select m.meshheader,
			count(*) num_publications,
			count(distinct a.personid) num_faculty,
			cast(0 as float) weight,
			sum( (case when m.majortopicyn = 'Y' then 1 else 0.25 end) * a.authorweight * a.yearweight ) rawweight
		into #cache_mesh_count
		from [Profile.Cache].[Publication.PubMed.AuthorPosition] a, [Profile.Data].[vwPublication.Pubmed.Mesh.Descriptor] m
		where a.pmid = m.pmid
		group by m.meshheader
	update #cache_mesh_count set weight = 10/sqrt(100 + rawweight)
	create unique clustered index idx_m on #cache_mesh_count(meshheader)
 
 
	SELECT *
		INTO #m
		FROM (
			SELECT m.treenumber mesh_code,
				m.descriptorname meshheader,
				COALESCE(c.numpublications,0) num_publications,
				COALESCE(c.numfaculty,0) num_faculty,
				COALESCE(c.weight,0) weight
			FROM [Profile.Data].[Concept.Mesh.TreeTop] m
				LEFT JOIN [Profile.Cache].[Concept.Mesh.Count] c
				ON m.descriptorname = c.meshheader
		) t
	CREATE UNIQUE CLUSTERED INDEX idx_pk ON #m (mesh_code)
 
	SELECT *,
				 (SELECT SUM(num_publications)
						FROM #m n
					 WHERE n.mesh_code LIKE m.mesh_code + '%') tot_publications,
				 (SELECT SUM(weight)
						FROM #m n
					 WHERE n.mesh_code LIKE m.mesh_code + '%') tot_weight
		INTO #n
		FROM #m m
	CREATE UNIQUE CLUSTERED INDEX idx_pk ON #n (mesh_code)
 
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.Count]
			INSERT INTO [Profile.Cache].[Concept.Mesh.Count](meshheader, numpublications, numfaculty, weight, rawweight)
				SELECT meshheader, num_publications, num_faculty, weight, rawweight
				FROM #cache_mesh_count
			TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.Tree]
			INSERT INTO [Profile.Cache].[Concept.Mesh.Tree](meshcode, meshheader, numpublications, numfaculty, weight, totpublications, totweight)
				SELECT mesh_code, meshheader, num_publications, num_faculty, weight, tot_publications, tot_weight
				FROM #n
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
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName ='Concept.Mesh.UpdateCountTree',@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
