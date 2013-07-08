SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Person.UpdateSimilarPerson]
AS
BEGIN

	 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	create table #cache_similar_people (personid int, similarpersonid int, weight float, coauthor bit, numberOfSubjectAreas int)
 
 
 
	-- minutes
	select * into #cache_user_mesh from [Profile.Cache].[Concept.Mesh.Person]
	create unique clustered index idx_pm on #cache_user_mesh(personid,meshheader)
	declare @maxp int
	declare @p int
	select @maxp = max(personid) from [Profile.Cache].[Concept.Mesh.Person]
	set @p = 1
	while @p <= @maxp
	begin
		INSERT INTO #cache_similar_people(personid,similarpersonid,weight,coauthor,numberOfSubjectAreas)
			SELECT personid, similarpersonid, weight, 0 coauthor, numberOfSubjectAreas
			FROM (
				SELECT personid, similarpersonid, weight, numberOfSubjectAreas,
						row_number() over (partition by personid order by weight desc) k
				FROM (
					SELECT a.personid,
						b.personid similarpersonid,
						SUM(a.weight * b.weight) weight,
						count(*) numberOfSubjectAreas
					FROM #cache_user_mesh a inner join #cache_user_mesh b 
						ON a.meshheader = b.meshheader 
							AND a.personid <> b.personid 
							AND a.personid between @p and @p+999
					GROUP BY a.personid, b.personid
				) t
			) t
			WHERE k <= 60
		set @p = @p + 1000
	end
 
 
 
 
	-- Set CoAuthor Flag
	create unique clustered index idx_ps on #cache_similar_people(personid,similarpersonid)
	select distinct a.personid a, b.personid b
		into #coauthors
		from [Profile.Data].[Publication.Person.Include] a, [Profile.Data].[Publication.Person.Include] b
		where a.pmid = b.pmid and a.personid <> b.personid
	create unique clustered index idx_ab on #coauthors(a,b)
	update t 
		set coauthor = 1
		from #cache_similar_people t, #coauthors c
		where t.personid = c.a and t.similarpersonid = c.b
 
	BEGIN TRY
		BEGIN TRAN
			truncate table [Profile.Cache].[Person.SimilarPerson]
			insert into [Profile.Cache].[Person.SimilarPerson](PersonID, SimilarPersonID, Weight, CoAuthor, numberOfSubjectAreas)
				select PersonID, SimilarPersonID, Weight, CoAuthor, numberOfSubjectAreas
				from #cache_similar_people
			select @rows = @@ROWCOUNT
		COMMIT
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
