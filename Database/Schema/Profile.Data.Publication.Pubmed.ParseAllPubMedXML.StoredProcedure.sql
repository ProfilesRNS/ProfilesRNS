SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.Pubmed.ParseALLPubMedXML]
AS
BEGIN
	SET NOCOUNT ON;

/*
	UPDATE [Profile.Data].[Publication.PubMed.AllXML] set ParseDT = GetDate() where pmid = @pmid


	delete from [Profile.Data].[Publication.PubMed.Author] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Investigator] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.PubType] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Chemical] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Databank] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Accession] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Keyword] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Grant] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Mesh] where pmid = @pmid
	*/
	
	--*** general ***
	truncate table [Profile.Data].[Publication.PubMed.General.Stage]
	insert into [Profile.Data].[Publication.PubMed.General.Stage] (pmid, Owner, Status, PubModel, Volume, Issue, MedlineDate, JournalYear, JournalMonth, JournalDay, JournalTitle, ISOAbbreviation, MedlineTA, ArticleTitle, MedlinePgn, AbstractText, ArticleDateType, ArticleYear, ArticleMonth, ArticleDay, Affiliation, AuthorListCompleteYN, GrantListCompleteYN,PMCID)
		select pmid, 
			nref.value('@Owner[1]','varchar(max)') Owner,
			nref.value('@Status[1]','varchar(max)') Status,
			nref.value('Article[1]/@PubModel','varchar(max)') PubModel,
			nref.value('Article[1]/Journal[1]/JournalIssue[1]/Volume[1]','varchar(max)') Volume,
			nref.value('Article[1]/Journal[1]/JournalIssue[1]/Issue[1]','varchar(max)') Issue,
			nref.value('Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/MedlineDate[1]','varchar(max)') MedlineDate,
			nref.value('Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/Year[1]','varchar(max)') JournalYear,
			nref.value('Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/Month[1]','varchar(max)') JournalMonth,
			nref.value('Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/Day[1]','varchar(max)') JournalDay,
			nref.value('Article[1]/Journal[1]/Title[1]','varchar(max)') JournalTitle,
			nref.value('Article[1]/Journal[1]/ISOAbbreviation[1]','varchar(max)') ISOAbbreviation,
			nref.value('MedlineJournalInfo[1]/MedlineTA[1]','varchar(max)') MedlineTA,
			nref.value('Article[1]/ArticleTitle[1]','varchar(max)') ArticleTitle,
			nref.value('Article[1]/Pagination[1]/MedlinePgn[1]','varchar(max)') MedlinePgn,
			nref.value('Article[1]/Abstract[1]/AbstractText[1]','varchar(max)') AbstractText,
			nref.value('Article[1]/ArticleDate[1]/@DateType[1]','varchar(max)') ArticleDateType,
			nref.value('Article[1]/ArticleDate[1]/Year[1]','varchar(max)') ArticleYear,
			nref.value('Article[1]/ArticleDate[1]/Month[1]','varchar(max)') ArticleMonth,
			nref.value('Article[1]/ArticleDate[1]/Day[1]','varchar(max)') ArticleDay,
			Affiliation = COALESCE(nref.value('Article[1]/AuthorList[1]/Author[1]/AffiliationInfo[1]/Affiliation[1]','varchar(max)'),
				nref.value('Article[1]/AuthorList[1]/Author[1]/Affiliation[1]','varchar(max)'),
				nref.value('Article[1]/Affiliation[1]','varchar(max)')) ,
			nref.value('Article[1]/AuthorList[1]/@CompleteYN[1]','varchar(max)') AuthorListCompleteYN,
			nref.value('Article[1]/GrantList[1]/@CompleteYN[1]','varchar(max)') GrantListCompleteYN,
			PMCID=COALESCE(nref.value('(OtherID[@Source="NLM" and text()[contains(.,"PMC")]])[1]', 'varchar(max)'), nref.value('(OtherID[@Source="NLM"][1])','varchar(max)'))
		from [Profile.Data].[Publication.PubMed.AllXML] cross apply x.nodes('//MedlineCitation[1]') as R(nref)
		where ParseDT is null and x is not null

		update [Profile.Data].[Publication.PubMed.General.Stage]
		set PubDate = [Profile.Data].[fnPublication.Pubmed.GetPubDate](medlinedate,journalyear,journalmonth,journalday,articleyear,articlemonth,articleday)


	--*** authors ***
	truncate table [Profile.Data].[Publication.PubMed.Author.Stage]
	insert into [Profile.Data].[Publication.PubMed.Author.Stage] (pmid, ValidYN, LastName, FirstName, ForeName, Suffix, Initials, Affiliation)
		select pmid, 
			nref.value('@ValidYN','varchar(max)') ValidYN, 
			nref.value('LastName[1]','varchar(max)') LastName, 
			nref.value('FirstName[1]','varchar(max)') FirstName,
			nref.value('ForeName[1]','varchar(max)') ForeName,
			nref.value('Suffix[1]','varchar(max)') Suffix,
			nref.value('Initials[1]','varchar(max)') Initials,
			COALESCE(nref.value('AffiliationInfo[1]/Affiliation[1]','varchar(max)'),
				nref.value('Affiliation[1]','varchar(max)')) Affiliation
		from [Profile.Data].[Publication.PubMed.AllXML] cross apply x.nodes('//AuthorList/Author') as R(nref)
		where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
		


	--*** general (authors) ***

	create table #a (pmid int primary key, authors varchar(4000))
	insert into #a(pmid,authors)
		select pmid,
			(case	when len(s) < 3990 then s
					when charindex(',',reverse(left(s,3990)))>0 then
						left(s,3990-charindex(',',reverse(left(s,3990))))+', et al'
					else left(s,3990)
					end) authors
		from (
			select pmid, substring(s,3,len(s)) s
			from (
				select pmid, isnull(cast((
					select ', '+lastname+' '+initials
					from [Profile.Data].[Publication.PubMed.Author.Stage] q
					where q.pmid = p.pmid
					order by PmPubsAuthorID
					for xml path(''), type
				) as nvarchar(max)),'') s
				from [Profile.Data].[Publication.PubMed.General.Stage] p
			) t
		) t

	--[10132 in 00:00:01]
	update g
		set g.authors = isnull(a.authors,'')
		from [Profile.Data].[Publication.PubMed.General.Stage] g, #a a
		where g.pmid = a.pmid
	update [Profile.Data].[Publication.PubMed.General.Stage]
		set authors = ''
		where authors is null

	delete from [Profile.Data].[Publication.PubMed.General] where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
	insert into [Profile.Data].[Publication.PubMed.General] select * from [Profile.Data].[Publication.PubMed.General.Stage]
	delete from [Profile.Data].[Publication.PubMed.Author] where pmid in (select pmid from [Profile.Data].[Publication.PubMed.Author.Stage])
	insert into [Profile.Data].[Publication.PubMed.Author] select * from [Profile.Data].[Publication.PubMed.Author.Stage]


	--*** investigators ***
	insert into [Profile.Data].[Publication.PubMed.Investigator] (pmid, LastName, FirstName, ForeName, Suffix, Initials, Affiliation)
		select pmid, 
			nref.value('LastName[1]','varchar(max)') LastName, 
			nref.value('FirstName[1]','varchar(max)') FirstName,
			nref.value('ForeName[1]','varchar(max)') ForeName,
			nref.value('Suffix[1]','varchar(max)') Suffix,
			nref.value('Initials[1]','varchar(max)') Initials,
			COALESCE(nref.value('AffiliationInfo[1]/Affiliation[1]','varchar(max)'),
				nref.value('Affiliation[1]','varchar(max)')) Affiliation
		from [Profile.Data].[Publication.PubMed.AllXML] cross apply x.nodes('//InvestigatorList/Investigator') as R(nref)
		where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
		

	--*** pubtype ***
	insert into [Profile.Data].[Publication.PubMed.PubType] (pmid, PublicationType)
		select * from (
			select distinct pmid, nref.value('.','varchar(max)') PublicationType
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//PublicationTypeList/PublicationType') as R(nref)
			where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
		) t where PublicationType is not null


	--*** chemicals
	insert into [Profile.Data].[Publication.PubMed.Chemical] (pmid, NameOfSubstance)
		select * from (
			select distinct pmid, nref.value('.','varchar(max)') NameOfSubstance
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//ChemicalList/Chemical/NameOfSubstance') as R(nref)
			where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
		) t where NameOfSubstance is not null


	--*** databanks ***
	insert into [Profile.Data].[Publication.PubMed.Databank] (pmid, DataBankName)
		select * from (
			select distinct pmid, 
				nref.value('.','varchar(max)') DataBankName
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//DataBankList/DataBank/DataBankName') as R(nref)
			where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
		) t where DataBankName is not null


	--*** accessions ***
	insert into [Profile.Data].[Publication.PubMed.Accession] (pmid, DataBankName, AccessionNumber)
		select * from (
			select distinct pmid, 
				nref.value('../../DataBankName[1]','varchar(max)') DataBankName,
				nref.value('.','varchar(max)') AccessionNumber
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//DataBankList/DataBank/AccessionNumberList/AccessionNumber') as R(nref)
			where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
		) t where DataBankName is not null and AccessionNumber is not null


	--*** keywords ***
	insert into [Profile.Data].[Publication.PubMed.Keyword] (pmid, Keyword, MajorTopicYN)
		select pmid, Keyword, max(MajorTopicYN)
		from (
			select pmid, 
				nref.value('.','varchar(max)') Keyword,
				nref.value('@MajorTopicYN','varchar(max)') MajorTopicYN
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//KeywordList/Keyword') as R(nref)
			where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
		) t where Keyword is not null
		group by pmid, Keyword


	--*** grants ***
	insert into [Profile.Data].[Publication.PubMed.Grant] (pmid, GrantID, Acronym, Agency)
		select pmid, GrantID, max(Acronym), max(Agency)
		from (
			select pmid, 
				nref.value('GrantID[1]','varchar(max)') GrantID, 
				nref.value('Acronym[1]','varchar(max)') Acronym,
				nref.value('Agency[1]','varchar(max)') Agency
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//GrantList/Grant') as R(nref)
			where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
		) t where GrantID is not null
		group by pmid, GrantID


	--*** mesh ***
	insert into [Profile.Data].[Publication.PubMed.Mesh] (pmid, DescriptorName, QualifierName, MajorTopicYN)
		select pmid, DescriptorName, IsNull(QualifierName,''), max(MajorTopicYN)
		from (
			select pmid, 
				nref.value('@MajorTopicYN[1]','varchar(max)') MajorTopicYN, 
				nref.value('.','varchar(max)') DescriptorName,
				null QualifierName
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//MeshHeadingList/MeshHeading/DescriptorName') as R(nref)
			where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
			union all
			select pmid, 
				nref.value('@MajorTopicYN[1]','varchar(max)') MajorTopicYN, 
				nref.value('../DescriptorName[1]','varchar(max)') DescriptorName,
				nref.value('.','varchar(max)') QualifierName
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//MeshHeadingList/MeshHeading/QualifierName') as R(nref)
			where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
		) t where DescriptorName is not null
		group by pmid, DescriptorName, QualifierName


	--******************************************************************
	--******************************************************************
	--*** Update parse date
	--******************************************************************
	--******************************************************************

	update [Profile.Data].[Publication.PubMed.AllXML] set ParseDT = GetDate() where pmid in (select pmid from [Profile.Data].[Publication.PubMed.General.Stage])
END
GO
