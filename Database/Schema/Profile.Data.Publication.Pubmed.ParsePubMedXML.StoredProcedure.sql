SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.Pubmed.ParsePubMedXML]
	@pmid int
AS
BEGIN
	SET NOCOUNT ON;

	CREATE TABLE #General(
		[PMID] [int] NOT NULL,
		[PMCID] [nvarchar](55) NULL,
		[Owner] [varchar](50) NULL,
		[Status] [varchar](50) NULL,
		[PubModel] [varchar](50) NULL,
		[Volume] [varchar](255) NULL,
		[Issue] [varchar](255) NULL,
		[MedlineDate] [varchar](255) NULL,
		[JournalYear] [varchar](50) NULL,
		[JournalMonth] [varchar](50) NULL,
		[JournalDay] [varchar](50) NULL,
		[JournalTitle] [varchar](1000) NULL,
		[ISOAbbreviation] [varchar](100) NULL,
		[MedlineTA] [varchar](1000) NULL,
		[ArticleTitle] [varchar](4000) NULL,
		[MedlinePgn] [varchar](255) NULL,
		[AbstractText] [text] NULL,
		[ArticleDateType] [varchar](50) NULL,
		[ArticleYear] [varchar](10) NULL,
		[ArticleMonth] [varchar](10) NULL,
		[ArticleDay] [varchar](10) NULL,
		[Affiliation] [varchar](8000) NULL,
		[AuthorListCompleteYN] [varchar](1) NULL,
		[GrantListCompleteYN] [varchar](1) NULL,
		[PubDate] [datetime] NULL,
		[Authors] [varchar](4000) NULL,
		[doi] [varchar](100) NULL,
	PRIMARY KEY CLUSTERED 
	(
		[PMID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


	CREATE TABLE #Author(
		[PmPubsAuthorID] [int] IDENTITY(1,1) NOT NULL,
		[PMID] [int] NOT NULL,
		[ValidYN] [varchar](1) NULL,
		[LastName] [varchar](100) NULL,
		[FirstName] [varchar](100) NULL,
		[ForeName] [varchar](100) NULL,
		[Suffix] [varchar](20) NULL,
		[Initials] [varchar](20) NULL,
		[Affiliation] [varchar](8000) NULL,
		[CollectiveName] [nvarchar](1000) NULL,
		[ORCID] [varchar](50) NULL,
		[ExistingPmPubsAuthorID] [int] NULL,
		[ValueHash] [varbinary](32) NULL,
		PRIMARY KEY CLUSTERED 
	(
		[PmPubsAuthorID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]


	CREATE TABLE #Mesh(
		[PMID] [int] NOT NULL,
		[DescriptorName] [varchar](255) NOT NULL,
		[QualifierName] [varchar](255) NOT NULL,
		[MajorTopicYN] [char](1) NULL,
	PRIMARY KEY CLUSTERED 
	(
		[PMID] ASC,
		[DescriptorName] ASC,
		[QualifierName] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]


	
	--*** general ***
	insert into #General (pmid, Owner, Status, PubModel, Volume, Issue, MedlineDate, JournalYear, JournalMonth, JournalDay, JournalTitle, ISOAbbreviation, MedlineTA, ArticleTitle, MedlinePgn, AbstractText, ArticleDateType, ArticleYear, ArticleMonth, ArticleDay, Affiliation, AuthorListCompleteYN, GrantListCompleteYN,PMCID, DOI)
		select pmid, 
			nref.value('MedlineCitation[1]/@Owner[1]','varchar(50)') Owner,
			nref.value('MedlineCitation[1]/@Status[1]','varchar(50)') Status,
			nref.value('MedlineCitation[1]/Article[1]/@PubModel','varchar(50)') PubModel,
			nref.value('MedlineCitation[1]/Article[1]/Journal[1]/JournalIssue[1]/Volume[1]','varchar(255)') Volume,
			nref.value('MedlineCitation[1]/Article[1]/Journal[1]/JournalIssue[1]/Issue[1]','varchar(255)') Issue,
			nref.value('MedlineCitation[1]/Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/MedlineDate[1]','varchar(255)') MedlineDate,
			nref.value('MedlineCitation[1]/Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/Year[1]','varchar(50)') JournalYear,
			nref.value('MedlineCitation[1]/Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/Month[1]','varchar(50)') JournalMonth,
			nref.value('MedlineCitation[1]/Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/Day[1]','varchar(50)') JournalDay,
			nref.value('MedlineCitation[1]/Article[1]/Journal[1]/Title[1]','varchar(1000)') JournalTitle,
			nref.value('MedlineCitation[1]/Article[1]/Journal[1]/ISOAbbreviation[1]','varchar(100)') ISOAbbreviation,
			nref.value('MedlineCitation[1]/MedlineJournalInfo[1]/MedlineTA[1]','varchar(1000)') MedlineTA,
			nref.value('MedlineCitation[1]/Article[1]/ArticleTitle[1]','nvarchar(4000)') ArticleTitle,
			nref.value('MedlineCitation[1]/Article[1]/Pagination[1]/MedlinePgn[1]','varchar(255)') MedlinePgn,
			nref.value('MedlineCitation[1]/Article[1]/Abstract[1]/AbstractText[1]','varchar(max)') AbstractText,
			nref.value('MedlineCitation[1]/Article[1]/ArticleDate[1]/@DateType[1]','varchar(50)') ArticleDateType,
			NULLIF(nref.value('MedlineCitation[1]/Article[1]/ArticleDate[1]/Year[1]','varchar(10)'),'') ArticleYear,
			NULLIF(nref.value('MedlineCitation[1]/Article[1]/ArticleDate[1]/Month[1]','varchar(10)'),'') ArticleMonth,
			NULLIF(nref.value('MedlineCitation[1]/Article[1]/ArticleDate[1]/Day[1]','varchar(10)'),'') ArticleDay,
			Affiliation = COALESCE(nref.value('MedlineCitation[1]/Article[1]/AuthorList[1]/Author[1]/AffiliationInfo[1]/Affiliation[1]','varchar(8000)'),
				nref.value('MedlineCitation[1]/Article[1]/AuthorList[1]/Author[1]/Affiliation[1]','varchar(8000)'),
				nref.value('MedlineCitation[1]/Article[1]/Affiliation[1]','varchar(8000)')) ,
			nref.value('MedlineCitation[1]/Article[1]/AuthorList[1]/@CompleteYN[1]','varchar(1)') AuthorListCompleteYN,
			nref.value('MedlineCitation[1]/Article[1]/GrantList[1]/@CompleteYN[1]','varchar(1)') GrantListCompleteYN,
			--PMCID=COALESCE(nref.value('(OtherID[@Source="NLM" and text()[contains(.,"PMC")]])[1]', 'varchar(55)'), nref.value('(OtherID[@Source="NLM"][1])','varchar(55)'))
			nref.value('PubmedData[1]/ArticleIdList[1]/ArticleId[@IdType="pmc"][1]', 'varchar(100)') pmcid,
			nref.value('PubmedData[1]/ArticleIdList[1]/ArticleId[@IdType="doi"][1]', 'varchar(100)') doi
		from [Profile.Data].[Publication.PubMed.AllXML] cross apply x.nodes('//PubmedArticle[1]') as R(nref)
		where PMID = @pmid

		update #General
		set MedlineDate = (case when right(MedlineDate,4) like '20__' then ltrim(rtrim(right(MedlineDate,4)+' '+left(MedlineDate,len(MedlineDate)-4))) else null end)
		where MedlineDate is not null and MedlineDate not like '[0-9][0-9][0-9][0-9]%'

		
		update #General
		set PubDate = [Profile.Data].[fnPublication.Pubmed.GetPubDate](medlinedate,journalyear,journalmonth,journalday,articleyear,articlemonth,articleday)


	--*** authors ***
	insert into #Author (pmid, ValidYN, LastName, FirstName, ForeName, CollectiveName, Suffix, Initials, ORCID, Affiliation)
		select pmid, 
			nref.value('@ValidYN','varchar(1)') ValidYN, 
			nref.value('LastName[1]','nvarchar(100)') LastName, 
			nref.value('FirstName[1]','nvarchar(100)') FirstName,
			nref.value('ForeName[1]','nvarchar(100)') ForeName,
			nref.value('CollectiveName[1]', 'nvarchar(100)') CollectiveName,
			nref.value('Suffix[1]','nvarchar(20)') Suffix,
			nref.value('Initials[1]','nvarchar(20)') Initials,
			nref.value('Identifier[@Source="ORCID"][1]', 'varchar(50)') ORCID,
			COALESCE(nref.value('AffiliationInfo[1]/Affiliation[1]','varchar(1000)'),
				nref.value('Affiliation[1]','varchar(max)')) Affiliation

		from [Profile.Data].[Publication.PubMed.AllXML] cross apply x.nodes('//AuthorList/Author') as R(nref)
		where PMID = @pmid
		

	
		update #Author set orcid = replace(ORCID, 'http://orcid.org/', '')
		update #Author set orcid = replace(ORCID, 'https://orcid.org/', '')
		update #Author SET ORCID =  SUBSTRING(ORCID, 1, 4) + '-' + SUBSTRING(ORCID, 5, 4) + '-' + SUBSTRING(ORCID, 9, 4) + '-' + SUBSTRING(ORCID, 13, 4) where ORCID is not null and len(ORCID) = 16
		update #Author SET ORCID = LTRIM(RTRIM(ORCID))

		update #Author set valueHash = HASHBYTES('SHA1', cast(pmid as varchar(100)) + '|||' + isnull(LastName, '') + '|||' + isnull(ValidYN, '') + '|||' + isnull(FirstName, '') + '|||' + isnull(ForeName, '') + '|||' + isnull(Suffix, '') + '|||' + isnull(Initials, '') + '|||' + isnull(CollectiveName, '') + '|||' + isnull(ORCID, '') + '|||' + isnull(Affiliation, ''))

	--*** general (authors) ***

	create table #a (pmid int primary key, authors nvarchar(4000))
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
					select isnull(', '+lastname+' '+initials, ', '+CollectiveName)
					from #Author q
					where q.pmid = p.pmid
					order by PmPubsAuthorID
					for xml path(''), type
				) as nvarchar(max)),'') s
				from #General p
			) t
		) t

	--[10132 in 00:00:01]
	update g
		set g.authors = isnull(a.authors,'')
		from #General g, #a a
		where g.pmid = a.pmid
	update #General
		set authors = ''
		where authors is null
		
		
		
	--*** mesh ***
	insert into #Mesh (pmid, DescriptorName, QualifierName, MajorTopicYN)
		select pmid, DescriptorName, IsNull(QualifierName,''), max(MajorTopicYN)
		from (
			select pmid, 
				nref.value('@MajorTopicYN[1]','varchar(1)') MajorTopicYN, 
				nref.value('.','varchar(255)') DescriptorName,
				null QualifierName
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//MeshHeadingList/MeshHeading/DescriptorName') as R(nref)
			where PMID = @pmid
			union all
			select pmid, 
				nref.value('@MajorTopicYN[1]','varchar(1)') MajorTopicYN, 
				nref.value('../DescriptorName[1]','varchar(255)') DescriptorName,
				nref.value('.','varchar(255)') QualifierName
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//MeshHeadingList/MeshHeading/QualifierName') as R(nref)
			where PMID = @pmid
		) t where DescriptorName is not null
		group by pmid, DescriptorName, QualifierName

		
	--******************************************************************
	--******************************************************************
	--*** Update General
	--******************************************************************
	--******************************************************************

	update g
		set 
			g.pmid=a.pmid,
			g.pmcid=a.pmcid,
			g.doi = a.doi,
			g.Owner=a.Owner,
			g.Status=a.Status,
			g.PubModel=a.PubModel,
			g.Volume=a.Volume,
			g.Issue=a.Issue,
			g.MedlineDate=a.MedlineDate,
			g.JournalYear=a.JournalYear,
			g.JournalMonth=a.JournalMonth,
			g.JournalDay=a.JournalDay,
			g.JournalTitle=a.JournalTitle,
			g.ISOAbbreviation=a.ISOAbbreviation,
			g.MedlineTA=a.MedlineTA,
			g.ArticleTitle=a.ArticleTitle,
			g.MedlinePgn=a.MedlinePgn,
			g.AbstractText=a.AbstractText,
			g.ArticleDateType=a.ArticleDateType,
			g.ArticleYear=a.ArticleYear,
			g.ArticleMonth=a.ArticleMonth,
			g.ArticleDay=a.ArticleDay,
			g.Affiliation=a.Affiliation,
			g.AuthorListCompleteYN=a.AuthorListCompleteYN,
			g.GrantListCompleteYN=a.GrantListCompleteYN,
			g.PubDate = a.PubDate,
			g.Authors = a.Authors
		from [Profile.Data].[Publication.PubMed.General] (nolock) g
			inner join #General a
				on g.pmid = a.pmid
				
	insert into [Profile.Data].[Publication.PubMed.General] (pmid, pmcid, Owner, Status, PubModel, Volume, Issue, MedlineDate, JournalYear, JournalMonth, JournalDay, JournalTitle, ISOAbbreviation, MedlineTA, ArticleTitle, MedlinePgn, AbstractText, ArticleDateType, ArticleYear, ArticleMonth, ArticleDay, Affiliation, AuthorListCompleteYN, GrantListCompleteYN, PubDate, Authors)
		select pmid, pmcid, Owner, Status, PubModel, Volume, Issue, MedlineDate, JournalYear, JournalMonth, JournalDay, JournalTitle, ISOAbbreviation, MedlineTA, ArticleTitle, MedlinePgn, AbstractText, ArticleDateType, ArticleYear, ArticleMonth, ArticleDay, Affiliation, AuthorListCompleteYN, GrantListCompleteYN, PubDate, Authors
			from #General
			where pmid not in (select pmid from [Profile.Data].[Publication.PubMed.General])
	
	
	--******************************************************************
	--******************************************************************
	--*** Update Authors
	--******************************************************************
	--******************************************************************
	update a set a.ExistingPmPubsAuthorID = b.PmPubsAuthorID 
		from #Author a 
			join [Profile.Data].[Publication.PubMed.Author] b
			on a.ValueHash = b.ValueHash

	select PmPubsAuthorID into #DeletedAuthors from [Profile.Data].[Publication.PubMed.Author] where PMID = @pmid
		and PmPubsAuthorID not in (select ExistingPmPubsAuthorID from #Author)

	delete from [Profile.Data].[Publication.PubMed.Author2Person] where PmPubsAuthorID in (select PmPubsAuthorID from #DeletedAuthors)

	delete from [Profile.Data].[Publication.PubMed.Author] where PmPubsAuthorID in (select PmPubsAuthorID from #DeletedAuthors)
	insert into [Profile.Data].[Publication.PubMed.Author] (pmid, ValidYN, LastName, FirstName, ForeName, CollectiveName, Suffix, Initials, ORCID, Affiliation, ValueHash)
		select pmid, ValidYN, LastName, FirstName, ForeName, CollectiveName, Suffix, Initials, ORCID, Affiliation, ValueHash
		from #Author where ExistingPmPubsAuthorID is null
		order by PmPubsAuthorID

	exec [Profile.Data].[Publication.Pubmed.UpdateAuthor2Person] @pmid = @pmid
	
	--******************************************************************
	--******************************************************************
	--*** Update MeSH
	--******************************************************************
	--******************************************************************


	--*** mesh ***
	delete from [Profile.Data].[Publication.PubMed.Mesh] where pmid = @pmid
	--[16593 in 00:00:11]
	insert into [Profile.Data].[Publication.PubMed.Mesh]
		select * from #Mesh
	--[86375 in 00:00:17]

		
		
		
	--*** investigators ***
	delete from [Profile.Data].[Publication.PubMed.Investigator] where pmid = @pmid
	insert into [Profile.Data].[Publication.PubMed.Investigator] (pmid, LastName, FirstName, ForeName, Suffix, Initials, Affiliation)
		select pmid, 
			nref.value('LastName[1]','varchar(100)') LastName, 
			nref.value('FirstName[1]','varchar(100)') FirstName,
			nref.value('ForeName[1]','varchar(100)') ForeName,
			nref.value('Suffix[1]','varchar(20)') Suffix,
			nref.value('Initials[1]','varchar(20)') Initials,
			COALESCE(nref.value('AffiliationInfo[1]/Affiliation[1]','varchar(1000)'),
				nref.value('Affiliation[1]','varchar(1000)')) Affiliation
		from [Profile.Data].[Publication.PubMed.AllXML] cross apply x.nodes('//InvestigatorList/Investigator') as R(nref)
		where pmid = @pmid
		

	--*** pubtype ***
	delete from [Profile.Data].[Publication.PubMed.PubType] where pmid = @pmid
	insert into [Profile.Data].[Publication.PubMed.PubType] (pmid, PublicationType)
		select * from (
			select distinct pmid, nref.value('.','varchar(100)') PublicationType
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//PublicationTypeList/PublicationType') as R(nref)
			where pmid = @pmid
		) t where PublicationType is not null


	--*** chemicals
	delete from [Profile.Data].[Publication.PubMed.Chemical] where pmid = @pmid
	insert into [Profile.Data].[Publication.PubMed.Chemical] (pmid, NameOfSubstance)
		select * from (
			select distinct pmid, nref.value('.','varchar(255)') NameOfSubstance
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//ChemicalList/Chemical/NameOfSubstance') as R(nref)
			where pmid = @pmid
		) t where NameOfSubstance is not null


	--*** databanks ***
	delete from [Profile.Data].[Publication.PubMed.Databank] where pmid = @pmid
	insert into [Profile.Data].[Publication.PubMed.Databank] (pmid, DataBankName)
		select * from (
			select distinct pmid, 
				nref.value('.','varchar(100)') DataBankName
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//DataBankList/DataBank/DataBankName') as R(nref)
			where pmid = @pmid
		) t where DataBankName is not null


	--*** accessions ***
	delete from [Profile.Data].[Publication.PubMed.Accession] where pmid = @pmid
	insert into [Profile.Data].[Publication.PubMed.Accession] (pmid, DataBankName, AccessionNumber)
		select * from (
			select distinct pmid, 
				nref.value('../../DataBankName[1]','varchar(100)') DataBankName,
				nref.value('.','varchar(50)') AccessionNumber
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//DataBankList/DataBank/AccessionNumberList/AccessionNumber') as R(nref)
			where pmid = @pmid
		) t where DataBankName is not null and AccessionNumber is not null


	--*** keywords ***
	delete from [Profile.Data].[Publication.PubMed.Keyword] where pmid = @pmid
	insert into [Profile.Data].[Publication.PubMed.Keyword] (pmid, Keyword, MajorTopicYN)
		select pmid, Keyword, max(MajorTopicYN)
		from (
			select pmid, 
				nref.value('.','varchar(895)') Keyword,
				nref.value('@MajorTopicYN','varchar(1)') MajorTopicYN
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//KeywordList/Keyword') as R(nref)
			where pmid = @pmid
		) t where Keyword is not null
		group by pmid, Keyword


	--*** grants ***
	delete from [Profile.Data].[Publication.PubMed.Grant] where pmid = @pmid
	insert into [Profile.Data].[Publication.PubMed.Grant] (pmid, GrantID, Acronym, Agency)
		select pmid, GrantID, max(Acronym), max(Agency)
		from (
			select pmid, 
				nref.value('GrantID[1]','varchar(100)') GrantID, 
				nref.value('Acronym[1]','varchar(50)') Acronym,
				nref.value('Agency[1]','varchar(1000)') Agency
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//GrantList/Grant') as R(nref)
			where pmid = @pmid
		) t where GrantID is not null
		group by pmid, GrantID


	--******************************************************************
	--******************************************************************
	--*** Update parse date
	--******************************************************************
	--******************************************************************

	update [Profile.Data].[Publication.PubMed.AllXML] set ParseDT = GetDate() where pmid = @pmid
END
GO
