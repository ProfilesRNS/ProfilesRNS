SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procedure [Profile.Cache].[Publication.PubMed.UpdateAuthorPosition]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	  /* 
		drop table cache_pm_author_position
		create table dbo.cache_pm_author_position (
			PersonID int not null,
			pmid int not null,
			AuthorPosition char(1),
			AuthorWeight float,
			PubDate datetime,
			PubYear int,
			YearWeight float
		)
		alter table cache_pm_author_position add primary key (PersonID, pmid)
	*/
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	select distinct i.pmid, p.personid, p.lastname, p.firstname, '' middlename,
			left(p.lastname,1) ln, left(p.firstname,1) fn, left('',1) mn
		into #pmid_person_name
		from [Profile.Data].[Publication.Person.Include] i, [Profile.Cache].Person p
		where i.personid = p.personid and i.pmid is not null
	create unique clustered index idx_pu on #pmid_person_name(pmid,personid)
 
	select distinct pmid, personid, pmpubsauthorid
		into #authorid_personid
		from (
			select a.pmid, a.PmPubsAuthorID, p.personid, dense_rank() over (partition by a.pmid, p.personid order by 
				(case when a.lastname = p.lastname and (a.forename like p.firstname + left(p.middlename,1) + '%') then 1
					when a.lastname = p.lastname and (a.forename like p.firstname + '%') and len(p.firstname) > 1 then 2
					when a.lastname = p.lastname and a.initials = p.fn+p.mn then 3
					when a.lastname = p.lastname and left(a.initials,1) = p.fn then 4
					when a.lastname = p.lastname then 5
					else 6 end) ) k
			from [Profile.Data].[Publication.PubMed.Author] a inner join #pmid_person_name p 
				on a.pmid = p.pmid and a.validyn = 'Y' and left(a.lastname,1) = p.ln
		) t
		where k = 1
	create unique clustered index idx_ap on #authorid_personid(pmid, personid, pmpubsauthorid)
 
	select pmid, min(pmpubsauthorid) a, max(pmpubsauthorid) b, count(*) numberOfAuthors
		into #pmid_authorid_range
		from [Profile.Data].[Publication.PubMed.Author]
		group by pmid
	create unique clustered index idx_p on #pmid_authorid_range(pmid)
 
	select PersonID, pmid, a AuthorPosition, 
			(case when a in ('F','L','S') then 1.00
				when a in ('M') then 0.25
				else 0.50 end) AuthorWeight,
			pmpubsauthorid,
			cast(null as int) authorRank,
			cast(null as int) numberOfAuthors,
			cast(null as varchar(255)) authorNameAsListed
		into #cache_author_position
		from (
			select pmid, personid, a, pmpubsauthorid, row_number() over (partition by pmid, personid order by k, pmpubsauthorid) k
			from (
				select a.pmid, a.personid,
						(case when a.pmpubsauthorid = r.a then 'F'
							when a.pmpubsauthorid = r.b then 'L'
							else 'M'
							end) a,
						(case when a.pmpubsauthorid = r.a then 1
							when a.pmpubsauthorid = r.b then 2
							else 3
							end) k,
						a.pmpubsauthorid
					from #authorid_personid a, #pmid_authorid_range r
					where a.pmid = r.pmid and r.b <> r.a
				union all
				select p.pmid, p.personid, 'S' a, 0 k, r.a pmpubsauthorid
					from #pmid_person_name p, #pmid_authorid_range r
					where p.pmid = r.pmid and r.a = r.b
				union all
				select pmid, personid, 'U' a, 9 k, null pmpubsauthorid
					from #pmid_person_name
			) t
		) t
		where k = 1
	create clustered index idx_pmid on #cache_author_position(pmid)
	create nonclustered index idx_pmpubsauthorid on #cache_author_position(pmpubsauthorid)
 
	update a
		set a.numberOfAuthors = r.numberOfAuthors
		from #cache_author_position a, #pmid_authorid_range r
		where a.pmid = r.pmid
 
	select pmpubsauthorid, 
			isnull(LastName,'') 
			+ (case when isnull(LastName,'')<>'' and (isnull(ForeName,'')+isnull(Suffix,''))<>'' then ', ' else '' end)
			+ isnull(ForeName,'')
			+ (case when isnull(ForeName,'')<>'' and isnull(Suffix,'')<>'' then ' ' else '' end)
			+ isnull(Suffix,'') authorNameAsListed,
			row_number() over (partition by pmid order by pmpubsauthorid) authorRank
		into #pmpubsauthorid_authorRank
		from [Profile.Data].[Publication.PubMed.Author]
	create unique clustered index idx_p on #pmpubsauthorid_authorRank(pmpubsauthorid)
 
	update a
		set a.authorRank = r.authorRank, a.authorNameAsListed = r.authorNameAsListed
		from #cache_author_position a, #pmpubsauthorid_authorRank r
		where a.pmpubsauthorid = r.pmpubsauthorid
 
	select PersonID, a.pmid, AuthorPosition, AuthorWeight, g.PubDate, year(g.PubDate) PubYear,
			(case when g.PubDate = '1900-01-01 00:00:00.000' then 0.5
				else power(cast(0.5 as float),cast(datediff(d,g.PubDate,GetDate()) as float)/365.25/10)
				end) YearWeight,
			authorRank, numberOfAuthors, authorNameAsListed
		into #cache_pm_author_position
		from #cache_author_position a, [Profile.Data].[Publication.PubMed.General] g
		where a.pmid = g.pmid
	update #cache_pm_author_position
		set PubYear = Year(GetDate()), YearWeight = 1
		where YearWeight > 1
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Publication.PubMed.AuthorPosition]
			INSERT INTO [Profile.Cache].[Publication.PubMed.AuthorPosition] (PersonID, pmid, AuthorPosition, AuthorWeight, PubDate, PubYear, YearWeight, authorRank, numberOfAuthors, authorNameAsListed)
				SELECT PersonID, pmid, AuthorPosition, AuthorWeight, PubDate, PubYear, YearWeight, authorRank, numberOfAuthors, authorNameAsListed
				FROM #cache_pm_author_position
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
