SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Publication.Entity.UpdateEntityOneGroup]
	@GroupID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 
	-- *******************************************************************
	-- *******************************************************************
	-- Update InformationResource entities
	-- *******************************************************************
	-- *******************************************************************

	CREATE TABLE #tmpEntityIDs(EntityID int primary key)
	insert into #tmpEntityIDs
	select EntityID from [Profile.Data].[Publication.Entity.InformationResource]
		where PMID in (	SELECT PMID 
						FROM [Profile.Data].[Publication.Group.Include]
						WHERE PMID IS NOT NULL AND GroupID = @GroupID)
			and IsActive = 0

	update [Profile.Data].[Publication.Entity.InformationResource] set IsActive = 1 
		where EntityID in (select EntityID from #tmpEntityIDs)

 
	----------------------------------------------------------------------
	-- Get a list of current publications
	----------------------------------------------------------------------
 
	CREATE TABLE #Publications
	(
		PMID INT NULL ,
		MPID NVARCHAR(50) NULL ,
		PMCID NVARCHAR(55) NULL,
		doi [varchar](100) NULL,				  
		EntityDate DATETIME NULL ,
		Authors NVARCHAR(4000) NULL,					  
		Reference NVARCHAR(MAX) NULL ,
		Source VARCHAR(25) NULL ,
		URL VARCHAR(1000) NULL ,
		Title NVARCHAR(4000) NULL
				   
	)
 
	-- Add PMIDs to the publications temp table
	INSERT  INTO #Publications
            ( PMID ,
			  PMCID,
              EntityDate ,
			  Authors,
              Reference ,
              Source ,
              URL ,
              Title
            )
            SELECT -- Get Pub Med pubs
                    PG.PMID ,
					PG.PMCID,
                    EntityDate = PG.PubDate,
					authors = case when right(PG.Authors,5) = 'et al' then PG.Authors+'. '
								when PG.AuthorListCompleteYN = 'N' then PG.Authors+', et al. '
								when PG.Authors <> '' then PG.Authors+'. '
								else '' end,				  
                    Reference = REPLACE([Profile.Cache].[fnPublication.Pubmed.General2Reference](PG.PMID,
                                                              PG.ArticleDay,
                                                              PG.ArticleMonth,
                                                              PG.ArticleYear,
                                                              PG.ArticleTitle,
                                                              PG.Authors,
                                                              PG.AuthorListCompleteYN,
                                                              PG.Issue,
                                                              PG.JournalDay,
                                                              PG.JournalMonth,
                                                              PG.JournalYear,
                                                              PG.MedlineDate,
                                                              PG.MedlinePgn,
                                                              PG.MedlineTA,
                                                              PG.Volume, 0),
                                        CHAR(11), '') ,
                    Source = 'PubMed',
                    URL = 'http://www.ncbi.nlm.nih.gov/pubmed/' + CAST(ISNULL(PG.pmid, '') AS VARCHAR(20)),
                    Title = left((case when IsNull(PG.ArticleTitle,'') <> '' then PG.ArticleTitle else 'Untitled Publication' end),4000)
            FROM    [Profile.Data].[Publication.PubMed.General] PG
			WHERE	PG.PMID IN (
						SELECT PMID 
						FROM [Profile.Data].[Publication.Group.Include]
						WHERE PMID IS NOT NULL AND GroupID = @GroupID
					)
					AND PG.PMID NOT IN (
						SELECT PMID
						FROM [Profile.Data].[Publication.Entity.InformationResource]
						WHERE PMID IS NOT NULL
					)
 
	-- Add MPIDs to the publications temp table
	INSERT  INTO #Publications
            ( MPID ,
              EntityDate ,
			  Authors,
			  Reference ,
			  Source ,
              URL ,
              Title
            )
            SELECT  MPID ,
                    EntityDate ,
					Authors = REPLACE(authors, CHAR(11), '') ,
 
                    Reference = REPLACE( (CASE WHEN IsNull(article,'') <> '' THEN article + '. ' ELSE '' END)
										+ (CASE WHEN IsNull(pub,'') <> '' THEN pub + '. ' ELSE '' END)
										+ y
                                        + CASE WHEN y <> ''
                                                    AND vip <> '' THEN '; '
                                               ELSE ''
                                          END + vip
                                        + CASE WHEN y <> ''
                                                    OR vip <> '' THEN '.'
                                               ELSE ''
                                          END, CHAR(11), '') ,
                    Source = 'Custom' ,
                    URL = url,
                    Title = left((case when IsNull(article,'')<>'' then article when IsNull(pub,'')<>'' then pub else 'Untitled Publication' end),4000)
            FROM    ( SELECT    MPID ,
                                EntityDate ,
                                url ,
                                authors = CASE WHEN authors = '' THEN ''
                                               WHEN RIGHT(authors, 1) = '.'
                                               THEN LEFT(authors,
                                                         LEN(authors) - 1)
                                               ELSE authors
                                          END ,
                                article = CASE WHEN article = '' THEN ''
                                               WHEN RIGHT(article, 1) = '.'
                                               THEN LEFT(article,
                                                         LEN(article) - 1)
                                               ELSE article
                                          END ,
                                pub = CASE WHEN pub = '' THEN ''
                                           WHEN RIGHT(pub, 1) = '.'
                                           THEN LEFT(pub, LEN(pub) - 1)
                                           ELSE pub
                                      END ,
                                y ,
                                vip
                      FROM      ( SELECT    MPG.mpid ,
                                            EntityDate = MPG.publicationdt ,
                                            authors = CASE WHEN RTRIM(LTRIM(COALESCE(MPG.authors,
                                                              ''))) = ''
                                                           THEN ''
                                                           WHEN RIGHT(COALESCE(MPG.authors,
                                                              ''), 1) = '.'
                                                            THEN  COALESCE(MPG.authors,
                                                              '') + ' '
                                                           ELSE COALESCE(MPG.authors,
                                                              '') + '. '
                                                      END ,
                                            url = CASE WHEN COALESCE(MPG.url,
                                                              '') <> ''
                                                            AND LEFT(COALESCE(MPG.url,
                                                              ''), 4) = 'http'
                                                       THEN MPG.url
                                                       WHEN COALESCE(MPG.url,
                                                              '') <> ''
                                                       THEN 'http://' + MPG.url
                                                       ELSE ''
                                                  END ,
                                            article = LTRIM(RTRIM(COALESCE(MPG.articletitle,
                                                              ''))) ,
                                            pub = LTRIM(RTRIM(COALESCE(MPG.pubtitle,
                                                              ''))) ,
                                            y = CASE WHEN MPG.publicationdt > '1/1/1901'
                                                     THEN CONVERT(VARCHAR(50), YEAR(MPG.publicationdt))
                                                     ELSE ''
                                                END ,
                                            vip = COALESCE(MPG.volnum, '')
                                            + CASE WHEN COALESCE(MPG.issuepub,
                                                              '') <> ''
                                                   THEN '(' + MPG.issuepub
                                                        + ')'
                                                   ELSE ''
                                              END
                                            + CASE WHEN ( COALESCE(MPG.paginationpub,
                                                              '') <> '' )
                                                        AND ( COALESCE(MPG.volnum,
                                                              '')
                                                              + COALESCE(MPG.issuepub,
                                                              '') <> '' )
                                                   THEN ':'
                                                   ELSE ''
                                              END + COALESCE(MPG.paginationpub,
                                                             '')
                                  FROM      [Profile.Data].[Publication.Group.MyPub.General] MPG
                                  INNER JOIN [Profile.Data].[Publication.Group.Include] PL ON MPG.mpid = PL.mpid
                                                           AND PL.mpid NOT LIKE 'DASH%'
                                                           AND PL.mpid NOT LIKE 'ISI%'
                                                           AND PL.pmid IS NULL
                                                           AND PL.GroupID = @GroupID
																 
									WHERE MPG.MPID NOT IN (
										SELECT MPID
										FROM [Profile.Data].[Publication.Entity.InformationResource]
										WHERE (MPID IS NOT NULL)
									)
                                ) T0
                    ) T0
 
	CREATE NONCLUSTERED INDEX idx_pmid on #publications(pmid)
	CREATE NONCLUSTERED INDEX idx_mpid on #publications(mpid)

	declare @baseURI varchar(255)
	select @baseURI = Value From [Framework.].Parameter where ParameterID = 'baseURI'
	select a.PmPubsAuthorID, a.pmid, a2p.personID, isnull(Lastname + ' ' + Initials, CollectiveName) as Name, case when nodeID is not null then'<a href="' + @baseURI + cast(i.nodeID as varchar(55)) + '">'+ Lastname + ' ' + Initials + '</a>' else isnull(Lastname + ' ' + Initials, CollectiveName) END as link into #tmpAuthorLinks from [Profile.Data].[Publication.PubMed.Author] a 
		join #publications p on a.pmid = p.pmid
		left outer join [Profile.Data].[Publication.PubMed.Author2Person] a2p on a.PmPubsAuthorID = a2p.PmPubsAuthorID
		left outer join [RDF.Stage].InternalNodeMap i on a2p.PersonID = i.InternalID and i.class = 'http://xmlns.com/foaf/0.1/Person'

	select pmid, [Profile.Data].[fnPublication.Pubmed.ShortenAuthorLengthString](replace(replace(isnull(cast((
		select ', '+ link
		from #tmpAuthorLinks q
		where q.pmid = p.pmid
		order by PmPubsAuthorID
		for xml path(''), type
		) as nvarchar(max)),''), '&lt;' , '<'), '&gt;', '>')) s
		into #tmpPublicationLinks from #publications p where pmid is not null

	update g set g.Authors = t.s from #publications g
		join #tmpPublicationLinks t on g.PMID = t.PMID 							  
							  
	----------------------------------------------------------------------
	-- Update the Publication.Entity.InformationResource table
	----------------------------------------------------------------------

	DECLARE @maxEntityId AS INT
	select @maxEntityId = MAX(cast(InternalID as int)) from [RDF.Stage].InternalNodeMap where class = 'http://vivoweb.org/ontology/core#InformationResource'  AND InternalType = 'InformationResource'
  
	-- Insert new publications
	INSERT INTO [Profile.Data].[Publication.Entity.InformationResource] (
			PMID,
			PMCID,
			MPID,
			EntityName,
			EntityDate,
		    Authors,
			Reference,
			Source,
			URL,
			IsActive,
			PubYear,
			YearWeight		   
		)
		SELECT 	PMID,
				PMCID,
				MPID,
				Title,
				EntityDate,
				Authors,			
				Reference,
				Source,
				URL,
				1 IsActive,
				PubYear = year(EntityDate),
				YearWeight = (case when EntityDate is null then 0.5
								when year(EntityDate) <= 1901 then 0.5
								else power(cast(0.5 as float),cast(datediff(d,EntityDate,GetDate()) as float)/365.25/10)
								end)
		FROM #publications

	-- *******************************************************************
	-- *******************************************************************
	-- Update RDF
	-- *******************************************************************
	-- *******************************************************************
	--------------------------------------------------------------
	-- Version 3 : Create stub RDF
	--------------------------------------------------------------
	CREATE TABLE #sql (
		i INT IDENTITY(0,1) PRIMARY KEY,
		s NVARCHAR(MAX)
	)
	INSERT INTO #sql (s)
		SELECT	'EXEC [RDF.Stage].ProcessDataMap '
					+'  @DataMapID = '+CAST(DataMapID AS VARCHAR(50))
					+', @InternalIdIn = '+InternalIdIn
					+', @TurnOffIndexing=0, @SaveLog=0; '
		FROM (
		  	SELECT DataMapID, '''SELECT CAST (EntityID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.InformationResource] WHERE EntityID > ' + CAST(@maxEntityId AS VARCHAR(50)) + '''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#InformationResource' 
					AND property IS NULL
					AND NetworkProperty IS NULL
			UNION ALL
			SELECT (Select DataMapID FROM [Ontology.].DataMap WHERE class = 'http://vivoweb.org/ontology/core#InformationResource' AND property IS NULL	AND NetworkProperty IS NULL) DataMapID,
				'''SELECT CAST (EntityID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.InformationResource] WHERE EntityID = ' + CAST(EntityID AS VARCHAR(50)) + '''' InternalIdIn
				FROM #tmpEntityIDs
			UNION ALL
			SELECT DataMapID, '''' + CAST(@GroupID AS VARCHAR(50)) + '''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://xmlns.com/foaf/0.1/Group'
					AND property = 'http://profiles.catalyst.harvard.edu/ontology/prns#associatedInformationResource'
					AND NetworkProperty IS NULL
		) t
		ORDER BY DataMapID

	DECLARE @s NVARCHAR(MAX)
	WHILE EXISTS (SELECT * FROM #sql)
	BEGIN
		SELECT @s = s
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
		print @s
		EXEC sp_executesql @s
		DELETE
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
	END
END
GO
