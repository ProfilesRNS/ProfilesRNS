SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdateSimilarConcept]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
  /* 
	create table dbo.cache_similar_concepts (
		MeshHeader nvarchar(255) not null,
		SortOrder int not null, 
		SimilarConcept nvarchar(255), 
		Weight float
	)
	alter table cache_similar_concepts add primary key (MeshHeader, SortOrder)
*/
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
 
	create table #cache_similar_concepts(meshheader nvarchar(255), sortorder int, similarconcept nvarchar(255), weight float)
 
	create table #cache_similar_concepts_tmp(m int, sortorder int, similarm int, weight float)
 
	select MeshHeader, Weight, row_number() over (order by MeshHeader) m 
		into #mesh2num
		from [Profile.Cache].[Concept.Mesh.Count]
	alter table #mesh2num add primary key (MeshHeader)
	create table #num2mesh (m int not null, MeshHeader nvarchar(255))
	insert into #num2mesh (m, MeshHeader) select m, MeshHeader from #mesh2num
	alter table #num2mesh add primary key (m)
 
	create table #cache_user_mesh (m int not null, personid int not null, weight float, meshweight float)
	insert into #cache_user_mesh (m, personid, weight, meshweight)
		select m.m, c.PersonID, c.Weight, m.Weight MeshWeight
		from [Profile.Cache].[Concept.Mesh.Person] c, #mesh2num m
		where c.meshheader = m.meshheader
	alter table #cache_user_mesh add primary key (m, personid)
 
	declare @maxp int
	declare @p int
	select @maxp = max(m) from #num2mesh
	set @p = 1
	while @p <= @maxp
	begin
		INSERT INTO #cache_similar_concepts_tmp(m,sortorder,similarm,weight)
			SELECT m, k, similarm, weight
			FROM (
				SELECT m, similarm, weight, row_number() over (partition by m order by weight desc) k
				FROM (
					SELECT a.m,
						b.m similarm,
						SUM(a.weight * b.weight * b.meshweight) weight
					FROM #cache_user_mesh a inner join #cache_user_mesh b 
						ON a.personid = b.personid 
							AND a.m <> b.m 
							AND a.m between @p and @p+999
					GROUP BY a.m, b.m
				) t
			) t
			WHERE k <= 60
		set @p = @p + 1000
	end
 
	insert into #cache_similar_concepts(meshheader, sortorder, similarconcept, weight)
		select a.meshheader, c.sortorder, b.meshheader, c.weight
		from #cache_similar_concepts_tmp c, #num2mesh a, #num2mesh b
		where c.m = a.m and c.similarm = b.m
 
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.SimilarConcept]
			INSERT INTO [Profile.Cache].[Concept.Mesh.SimilarConcept] (meshheader, sortorder, similarconcept, weight)
				SELECT meshheader, sortorder, similarconcept, weight FROM #cache_similar_concepts
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
