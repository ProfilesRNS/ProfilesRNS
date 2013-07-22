SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[SNA.Coauthor.UpdateDistance]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	insert into [Profile.Cache].[SNA.Coauthor.DistanceLog] (x,d) values ('Start',getdate())
 
	create table #sna_distance(PersonID1 int, PersonID2 int, Distance tinyint, NumPaths smallint) 
 
	--create a copy of sna_coauthors so we don't lock up that table
	select PersonID1, PersonID2
		into #sna_coauthors
		from [Profile.Cache].[SNA.Coauthor]
	alter table #sna_coauthors add primary key (PersonID1, PersonID2)
 
	select i, row_number() over (order by i) k
		into #p
		from (select distinct PersonID1 i from #sna_coauthors) t
	create unique clustered index idx_k on #p(k)
	create unique nonclustered index idx_i on #p(i)
 
	DECLARE @d INT
 
	declare @maxp int
	declare @p int
	select @maxp = max(k) from #p
	set @p = 1
	while @p <= @maxp
	begin
 
		insert into [Profile.Cache].[SNA.Coauthor.DistanceLog] (x,d) values ('Started p = '+cast(@p as varchar(50)),getdate())
 
		--create empty table
		;with a as (
			select distinct personid1 i from #sna_coauthors
		)
		select a.i, b.i j, cast(99 as tinyint) d, cast(0 as smallint) s
			into #z
			from (select i from #p where k between @p and @p+999) a, #p b
			where a.i <> b.i
		set @p = @p + 1000
 
		CREATE UNIQUE CLUSTERED INDEX idx_ij ON #z(i,j)
		
		--seed table (i.e. coauthors) with default distances, num_paths
		UPDATE z 
			SET d = 1, s = 1
			FROM #z z INNER JOIN #sna_coauthors y ON z.i = y.PersonID1 and z.j = y.PersonID2
 
		
		--iterate over network by distance level, derive distances and number of paths
		SELECT @d = 1
		WHILE @d < 15 --Max depth that we will search
		BEGIN
			
			SELECT z.i, y.PersonID2 j, sum(z.s) t
				INTO #x
				FROM #z z  	   
        JOIN #sna_coauthors y ON z.d = @d AND z.j = y.PersonID1
	      JOIN #z w ON w.i = z.i AND w.j = y.PersonID2 AND w.d = 99
				GROUP BY z.i, y.PersonID2
				--OPTION(RECOMPILE)
			CREATE UNIQUE CLUSTERED INDEX idx_ij on #x(i,j)
			SELECT @d = @d + 1
			UPDATE z 
				SET d = @d, s = t
				FROM #z z  
			  JOIN #x t ON z.i = t.i AND z.j = t.j
			DROP TABLE #x
		END
 
	 
		INSERT INTO #sna_distance(PersonID1,PersonID2,Distance,NumPaths)
			SELECT i,j,d,s FROM #z
 
		drop table #z
 
	end
 
	insert into [Profile.Cache].[SNA.Coauthor.DistanceLog]  (x,d) values ('Finished loops',getdate())
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[SNA.Coauthor.Distance]
				INSERT INTO [Profile.Cache].[SNA.Coauthor.Distance] (PersonID1,PersonID2,Distance,NumPaths)
					SELECT PersonID1,PersonID2,Distance,NumPaths FROM #sna_distance
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
 
	insert INTO [Profile.Cache].[SNA.Coauthor.DistanceLog] (x,d) values ('Completed Insert',getdate())
 
END
GO
