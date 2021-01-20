SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [Profile.Data].[Publication.Pubmed.UpdateAuthor2Person]
AS 
BEGIN
	create table #tmp (
		PMPubsAuthorID int,
		PersonID int not null,
		PMID int not null)

	ALTER TABLE #tmp add primary key (PersonID, PMID)

	insert into #tmp (personID, PMID) select distinct PersonID, PMID from [Profile.Data].[Publication.Person.Include] where pmid is not null

	update b set b.PMPubsAuthorID = a.PMPubsAuthorID from [Profile.Data].[Publication.PubMed.Author] a 
		join #tmp b
		on a.PMID = b.PMID
		and b.PMPubsAuthorID is null
		join [Profile.Data].Person c
		on b.PersonID = c.PersonID
		and a.LastName = c.LastName
		and a.ForeName = c.FirstName + ' ' + MiddleName
		and c.IsActive = 1

	update b set b.PMPubsAuthorID = a.PMPubsAuthorID from [Profile.Data].[Publication.PubMed.Author] a 
		join #tmp b
		on a.PMID = b.PMID
		and b.PMPubsAuthorID is null
		join [Profile.Data].Person c
		on b.PersonID = c.PersonID
		and a.LastName = c.LastName
		and a.ForeName = c.FirstName
		and (substring(Initials,2,1) = substring(c.MiddleName, 1, 1))
		and c.IsActive = 1

	update b set b.PMPubsAuthorID = a.PMPubsAuthorID from [Profile.Data].[Publication.PubMed.Author] a 
		join #tmp b
		on a.PMID = b.PMID
		and b.PMPubsAuthorID is null
		join [Profile.Data].Person c
		on b.PersonID = c.PersonID
		and a.LastName = c.LastName
		and (substring(forename, 1, 1) = substring(c.firstname, 1, 1) )
		and (substring(Initials,2,1) = substring(c.MiddleName, 1, 1))
		and c.IsActive = 1

	update b set b.PMPubsAuthorID = a.PMPubsAuthorID from [Profile.Data].[Publication.PubMed.Author] a 
		join #tmp b
		on a.PMID = b.PMID
		and b.PMPubsAuthorID is null
		join [Profile.Data].Person c
		on b.PersonID = c.PersonID
		and a.LastName = c.LastName
		and (substring(forename, 1, 1) = substring(c.firstname, 1, 1) )
		and (len(initials) = 1 or MiddleName = '')
		and c.IsActive = 1

	truncate table [Profile.Data].[Publication.PubMed.Author2Person]
	insert into [Profile.Data].[Publication.PubMed.Author2Person] (PMPubsAuthorID, PersonID ) select PMPubsAuthorID, PersonID from #tmp where PMPubsAuthorID is not null

	declare @baseURI varchar(255)
	select @baseURI = Value From [Framework.].Parameter where ParameterID = 'baseURI'
	select a.PmPubsAuthorID, a.pmid, a2p.personID, Lastname + ' ' + Initials as Name, case when nodeID is not null then'<a href="' + @baseURI + cast(i.nodeID as varchar(55)) + '">'+ Lastname + ' ' + Initials + '</a>' else Lastname + ' ' + Initials END as link into  #tmp3 from [Profile.Data].[Publication.PubMed.Author] a 
		left outer join [Profile.Data].[Publication.PubMed.Author2Person] a2p on a.PmPubsAuthorID = a2p.PmPubsAuthorID
		left outer join [RDF.Stage].InternalNodeMap i on a2p.PersonID = i.InternalID and i.class = 'http://xmlns.com/foaf/0.1/Person'

	select pmid, [Profile.Data].[fnPublication.Pubmed.ShortenAuthorLengthString](replace(replace(isnull(cast((
		select ', '+ link
		from #tmp3 q
		where q.pmid = p.pmid
		order by PmPubsAuthorID
		for xml path(''), type
		) as nvarchar(max)),''), '&lt;' , '<'), '&gt;', '>')) s
		into #tmp2 from [Profile.Data].[Publication.PubMed.General] p where pmid is not null

	update g set g.Authors = t.s from [Profile.Data].[Publication.PubMed.General] g
		join #tmp2 t on g.PMID = t.PMID 
END
GO
