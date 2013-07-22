SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[SNA.Coauthor.UpdateSummary]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	DECLARE @date DATETIME,@auditid UNIQUEIDENTIFIER, @rows int
	 
	select p.personid, --(case when numpublications > 0 then 1 else 0 end) 
	0 HasPublications,
			(case when isnull(s.clustersize,0)>1000 then 1 else 0 end) HasSNA,
			isnull(d.NumPeople,0) Reach1,
			isnull(r.NumPeople,0) Reach2,
			isnull(c.Closeness,0) Closeness,
			isnull(b.b,0) Betweenness
		into #cache_sna
		from [Profile.Cache].Person p
			left outer join (select * from [Profile.Cache].[SNA.Coauthor.Reach] where distance = 1) d on p.personid = d.personid
			left outer join (select * from [Profile.Cache].[SNA.Coauthor.Reach] where distance = 2) r on p.personid = r.personid
			left outer join (select personid, sum(cast(NumPeople as float)*Distance)/sum(cast(NumPeople as float)) closeness from [Profile.Cache].[SNA.Coauthor.Reach] where distance < 99 group by personid) c on p.personid = c.personid
			left outer join (select personid, sum(cast(NumPeople as int)) clustersize from [Profile.Cache].[SNA.Coauthor.Reach] where distance < 99 group by personid) s on p.personid = s.personid
			left outer join (select * from [Profile.Cache].[SNA.Coauthor.Betweenness]) b on p.personid = b.personid
	alter table #cache_sna add primary key (personid)

	BEGIN TRY
		BEGIN TRAN
			update p
				set p.HasPublications = s.HasPublications,
					p.HasSNA = s.HasSNA,
					p.Reach1 = s.Reach1,
					p.Reach2 = s.Reach2,
					p.Closeness = s.Closeness,
					p.Betweenness = s.Betweenness
				from [Profile.Cache].Person p inner join #cache_sna s on p.personid = s.personid
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
	 
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

	 
END
GO
