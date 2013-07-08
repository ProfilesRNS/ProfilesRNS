SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	 procedure [Profile.Data].[Publication.Pubmed.AddOneAuthorPosition]
	@PersonID INT,
	@pmid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select distinct @pmid pmid, p.personid, p.lastname, p.firstname, '' middlename,
			left(p.lastname,1) ln, left(p.firstname,1) fn, left('',1) mn
		into #pmid_person_name
		from [Profile.Cache].Person p
		where p.personid = @personid
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
			from [Profile.Data].[Publication.PubMed.Author]	 a inner join #pmid_person_name p 
				on a.pmid = p.pmid and a.validyn = 'Y' and left(a.lastname,1) = p.ln
		) t
		where k = 1
	create unique clustered index idx_ap on #authorid_personid(pmid, personid, pmpubsauthorid)

	select pmid, min(pmpubsauthorid) a, max(pmpubsauthorid) b
		into #pmid_authorid_range
		from [Profile.Data].[Publication.PubMed.Author]
		group by pmid
	create unique clustered index idx_p on #pmid_authorid_range(pmid)

	select PersonID, pmid, a AuthorPosition, 
			(case when a in ('F','L','S') then 1.00
				when a in ('M') then 0.25
				else 0.50 end) AuthorWeight
		into #cache_author_position
		from (
			select pmid, personid, a, row_number() over (partition by pmid, personid order by k) k
			from (
				select a.pmid, a.personid,
						(case when a.pmpubsauthorid = r.a then 'F'
							when a.pmpubsauthorid = r.b then 'L'
							else 'M'
							end) a,
						(case when a.pmpubsauthorid = r.a then 1
							when a.pmpubsauthorid = r.b then 2
							else 3
							end) k
					from #authorid_personid a, #pmid_authorid_range r
					where a.pmid = r.pmid and r.b <> r.a
				union all
				select p.pmid, p.personid, 'S' a, 0 k
					from #pmid_person_name p, #pmid_authorid_range r
					where p.pmid = r.pmid and r.a = r.b
				union all
				select pmid, personid, 'U' a, 9 k
					from #pmid_person_name
			) t
		) t
		where k = 1
	create clustered index idx_pmid on #cache_author_position(pmid)

	select PersonID, a.pmid, AuthorPosition, AuthorWeight, g.PubDate, year(g.PubDate) PubYear,
			(case when g.PubDate = '1900-01-01 00:00:00.000' then 0.5
				else power(cast(0.5 as float),cast(datediff(d,g.PubDate,GetDate()) as float)/365.25/10)
				end) YearWeight
		into #cache_pm_author_position
		from #cache_author_position a, [Profile.Data].[Publication.PubMed.General] g
		where a.pmid = g.pmid
	update #cache_pm_author_position
		set PubYear = Year(GetDate()), YearWeight = 1
		where YearWeight > 1

	delete t
		from #cache_pm_author_position t, [Profile.Cache].[Publication.PubMed.AuthorPosition] c
		where t.personid = c.personid and t.pmid = c.pmid

	INSERT INTO [Profile.Cache].[Publication.PubMed.AuthorPosition]
	         (PersonID, pmid, AuthorPosition, AuthorWeight, PubDate, PubYear, YearWeight)
		SELECT PersonID, pmid, AuthorPosition, AuthorWeight, PubDate, PubYear, YearWeight 
		FROM #cache_pm_author_position

END
GO
