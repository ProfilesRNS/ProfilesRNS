SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [Profile.Data].[Publication.Pubmed.UpdateAuthor2Person]
	@UseStagePMIDs bit = 0,
	@PMID int = null
AS 
BEGIN
	create table #tmp (
		PMPubsAuthorID int,
		PersonID int not null,
		PMID int not null)
	ALTER TABLE #tmp add primary key (PersonID, PMID)

	if @pmid is not null
		insert into #tmp (personID, PMID) select distinct PersonID, PMID from [Profile.Data].[Publication.Person.Include] where pmid = @PMID
	else if @UseStagePMIDs = 1
		insert into #tmp (personID, PMID) select distinct PersonID, PMID from [Profile.Data].[Publication.Person.Include] where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
	else 
		insert into #tmp (personID, PMID) select distinct PersonID, PMID from [Profile.Data].[Publication.Person.Include] where pmid is not null

	create table #t (PMPubsAuthorID int primary key not null)
	insert into #t select PMPubsAuthorID from [Profile.Data].[Publication.PubMed.Author] 

	update b set b.PMPubsAuthorID = a.PMPubsAuthorID from [Profile.Data].[Publication.PubMed.Author] a 
		join #t i on a.PmPubsAuthorID = i.PMPubsAuthorID
		join #tmp b
		on a.PMID = b.PMID
		and b.PMPubsAuthorID is null
		join [Profile.Data].Person c
		on b.PersonID = c.PersonID
		and a.LastName = c.LastName
		and a.ForeName = c.FirstName + ' ' + MiddleName
		and c.IsActive = 1

	delete from #t where PMPubsAuthorID in (select PMPubsAuthorID from #tmp)

	update b set b.PMPubsAuthorID = a.PMPubsAuthorID from [Profile.Data].[Publication.PubMed.Author] a 
		join #t i on a.PmPubsAuthorID = i.PMPubsAuthorID
		join #tmp b
		on a.PMID = b.PMID
		and b.PMPubsAuthorID is null
		join [Profile.Data].Person c
		on b.PersonID = c.PersonID
		and a.LastName = c.LastName
		and a.ForeName = c.FirstName
		and (substring(Initials,2,1) = substring(c.MiddleName, 1, 1))
		and c.IsActive = 1

	delete from #t where PMPubsAuthorID in (select PMPubsAuthorID from #tmp)

	update b set b.PMPubsAuthorID = a.PMPubsAuthorID from [Profile.Data].[Publication.PubMed.Author] a 
		join #t i on a.PmPubsAuthorID = i.PMPubsAuthorID
		join #tmp b
		on a.PMID = b.PMID
		and b.PMPubsAuthorID is null
		join [Profile.Data].Person c
		on b.PersonID = c.PersonID
		and a.LastName = c.LastName
		and (substring(forename, 1, 1) = substring(c.firstname, 1, 1) )
		and (substring(Initials,2,1) = substring(c.MiddleName, 1, 1))
		and c.IsActive = 1

	delete from #t where PMPubsAuthorID in (select PMPubsAuthorID from #tmp)

	update b set b.PMPubsAuthorID = a.PMPubsAuthorID from [Profile.Data].[Publication.PubMed.Author] a 
		join #t i on a.PmPubsAuthorID = i.PMPubsAuthorID
		join #tmp b
		on a.PMID = b.PMID
		and b.PMPubsAuthorID is null
		join [Profile.Data].Person c
		on b.PersonID = c.PersonID
		and a.LastName = c.LastName
		and (substring(forename, 1, 1) = substring(c.firstname, 1, 1) )
		and (len(initials) = 1 or MiddleName = '')
		and c.IsActive = 1

	delete from #t where PMPubsAuthorID in (select PMPubsAuthorID from #tmp)

	update b set b.PMPubsAuthorID = a.PMPubsAuthorID from [Profile.Data].[Publication.PubMed.Author] a 
		join #t i on a.PmPubsAuthorID = i.PMPubsAuthorID
		join #tmp b
		on a.PMID = b.PMID
		and b.PMPubsAuthorID is null
		join [Profile.Data].Person c
		on b.PersonID = c.PersonID
		and a.LastName = c.LastName
		and c.IsActive = 1

	if @pmid is not null
	BEGIN
		delete a from [Profile.Data].[Publication.PubMed.Author2Person] a 
			join [Profile.Data].[Publication.PubMed.Author] b on a.PmPubsAuthorID = b.PmPubsAuthorID and b.pmid = @PMID
		insert into [Profile.Data].[Publication.PubMed.Author2Person] (PMPubsAuthorID, PersonID ) select PMPubsAuthorID, PersonID from #tmp where PMPubsAuthorID is not null
	END
	else if @UseStagePMIDs = 1
	BEGIN
		delete a from [Profile.Data].[Publication.PubMed.Author2Person] a 
			join [Profile.Data].[Publication.PubMed.Author] b on a.PmPubsAuthorID = b.PmPubsAuthorID
			join [Profile.Data].[Publication.PubMed.General.Stage] s on b.PMID = s.PMID
		insert into [Profile.Data].[Publication.PubMed.Author2Person] (PMPubsAuthorID, PersonID ) select PMPubsAuthorID, PersonID from #tmp where PMPubsAuthorID is not null
	END
	else 
	BEGIN
		truncate table [Profile.Data].[Publication.PubMed.Author2Person]
		insert into [Profile.Data].[Publication.PubMed.Author2Person] (PMPubsAuthorID, PersonID ) select PMPubsAuthorID, PersonID from #tmp where PMPubsAuthorID is not null
	END
END
GO
