SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  PROCEDURE [Profile.Data].[Publication.GetPersonSharedPublicationsKeyword]
    (
      @UserID INT ,
      @UserID2 INT ,
      @Keyword VARCHAR(2000) ,
      @ExactKeyword BIT
    )
AS 
    BEGIN

        IF @Keyword IS NOT NULL 
            BEGIN	
                EXEC [Search.Execute].[GetMatchingKeywords] @Keyword, NULL, 0,
                    @ExactKeyword							
                INSERT  INTO [Search.History].Keyword
                        ( Keyword, ExactKeyword, SearchDate )
                VALUES  ( @Keyword, @ExactKeyword, GETDATE() )

 
                INSERT  INTO [Search.Cache].APIQueryMatchedPublication
                        SELECT DISTINCT
                                personid ,
                                pmid ,
                                meshheader ,
                                phrase ,
                                keywordstring ,
                                ISNULL(@ExactKeyword, 0) ,
                                searchphrase ,
                                searchweight * meshweight ,
                                searchweight ,
                                uniquenessweight ,
                                topicweight ,
                                authorweight ,
                                yearweight ,
                                GETDATE() searchdate
                        FROM    [Profile.Cache].[Concept.Mesh.PersonPublication] c
                                JOIN ( SELECT DISTINCT
                                                KeywordString ,
                                                SearchPhrase ,
                                                Phrase ,
                                                PublicationPhrase ,
                                                SearchWeight ,
                                                ExactKeyword
                                       FROM     [Search.Cache].MatchingKeyword
                                       WHERE    KeywordString = @Keyword
                                                AND ExactKeyword = ISNULL(@ExactKeyword,
                                                              0)
                                     ) a ON a.PublicationPhrase = c.meshheader
                        WHERE   c.personid = @UserID
                                AND NOT EXISTS ( SELECT pmid
                                                 FROM   [Search.Cache].APIQueryMatchedPublication a2
                                                 WHERE  a2.personid = c.personid
                                                        AND a2.pmid = c.pmid
                                                        AND a2.meshheader = c.meshheader
                                                        AND a2.phrase = A.phrase
                                                        AND a2.keywordstring = a.keywordstring
                                                        AND a2.exactkeyword = ISNULL(@ExactKeyword,
                                                              0) )
            END
											  
        DECLARE @encode_html INT
        DECLARE @dash_url VARCHAR(MAX) 
        SELECT  @dash_url = ISNULL('http://dash.harvard.edu/handle/1/', '')
        SELECT  @encode_html = 0 ; 
 

        SELECT  category "CustomCategory" ,
                CAST(pubid AS VARCHAR(50)) "PublicationID" ,
                PUBLICATIONS "PublicationReference" ,
                t.pmid pmid ,
                CASE WHEN frompubmed = 1
                     THEN 'http://www.ncbi.nlm.nih.gov/pubmed/'
                          + CAST(ISNULL(t.pmid, '') AS VARCHAR(20))
                     ELSE URL
                END "URL" ,
                'true' "Primary" ,
                sourcename "Name" ,
                NULL "PublicationDetails"
        FROM    ( SELECT  DISTINCT
                            p.pmid ,
                            NULL AS mpid ,
                            [Profile.Cache].[fnPublication.Pubmed.General2Reference](p.pmid,
                                                              ArticleDay,
                                                              ArticleMonth,
                                                              ArticleYear,
                                                              ArticleTitle,
                                                              Authors,
                                                              AuthorListCompleteYN,
                                                              Issue,
                                                              JournalDay,
                                                              JournalMonth,
                                                              JournalYear,
                                                              MedlineDate,
                                                              MedlinePgn,
                                                              MedlineTA,
                                                              Volume, 0) AS publications ,
                            1 AS frompubmed ,
                            [Profile.Data].[fnPublication.Pubmed.GetPubDate](MedlineDate,
                                                              JournalYear,
                                                              JournalMonth,
                                                              JournalDay,
                                                              ArticleYear,
                                                              ArticleMonth,
                                                              ArticleDay) AS publication_dt ,
                            i.pubid ,
                            NULL category ,
                            NULL url ,
                            'PubMed' sourcename
                  FROM      [Profile.Data].[Publication.Person.Include] i
                            JOIN [Profile.Data].[Publication.Person.Include] i2 ON i2.PMID = i.PMID
                                                              AND i2.PersonID = ISNULL(@userid2,
                                                              i2.PersonID)
                            JOIN [Profile.Data].[Publication.PubMed.General] p ON i.pmid = p.pmid
                  WHERE     i.personid = @UserID
                            AND p.pmid IS NOT NULL
                  UNION ALL
                  SELECT  DISTINCT
                            m.pmid ,
                            m.mpid ,
												 --dbo.fn_GetPubli ' cations			,
                            ( SELECT    authors
                                        + ( CASE WHEN url < > ''
                                                      AND article <> ''
                                                      AND pub <> ''
                                                 THEN url + article + '</a>. '
                                                      + pub + '. '
                                                 WHEN url <> ''
                                                      AND article <> ''
                                                 THEN url + article + '</a>. '
                                                 WHEN url <> ''
                                                      AND pub <> ''
                                                 THEN url + pub + '</a>. '
                                                 WHEN article <> ''
                                                      AND pub <> ''
                                                 THEN article + '. ' + pub
                                                      + '. '
                                                 WHEN article <> ''
                                                 THEN article + '. '
                                                 WHEN pub <> ''
                                                 THEN pub + '. '
                                                 ELSE ''
                                            END ) + y
                                        + ( CASE WHEN y <> ''
                                                      AND vip <> '' THEN '; '
                                                 ELSE ''
                                            END ) + vip
                                        + ( CASE WHEN y <> ''
                                                      OR vip <> '' THEN '.'
                                                 ELSE ''
                                            END )
                              FROM      ( SELECT    url ,
                                                    ( CASE WHEN authors = ''
                                                           THEN ''
                                                           WHEN RIGHT(authors,
                                                              1) = '.'
                                                           THEN LEFT(authors,
                                                              LEN(authors) - 1)
                                                           ELSE authors
                                                      END ) authors ,
                                                    ( CASE WHEN article = ''
                                                           THEN ''
                                                           WHEN RIGHT(article,
                                                              1) = '.'
                                                           THEN LEFT(article,
                                                              LEN(article) - 1)
                                                           ELSE article
                                                      END ) article ,
                                                    ( CASE WHEN pub = ''
                                                           THEN ''
                                                           WHEN RIGHT(pub, 1) = '.'
                                                           THEN LEFT(pub,
                                                              LEN(pub) - 1)
                                                           ELSE pub
                                                      END ) pub ,
                                                    y ,
                                                    vip ,
                                                    frompubmed ,
                                                    publicationdt
                                          FROM      ( SELECT  ( CASE
                                                              WHEN RTRIM(LTRIM(COALESCE(authors,
                                                              ''))) = ''
                                                              THEN ''
                                                              WHEN RIGHT(COALESCE(authors,
                                                              ''), 1) = '.'
                                                              THEN COALESCE(authors,
                                                              '') + ' '
                                                              ELSE COALESCE(authors,
                                                              '') + '. '
                                                              END ) authors ,
                                                              ( CASE
                                                              WHEN COALESCE(url,
                                                              '') <> ''
                                                              AND LEFT(COALESCE(url,
                                                              ''), 4) = 'http'
                                                              THEN '<a href="'
                                                              + url
                                                              + '" target="_blank">'
                                                              WHEN COALESCE(url,
                                                              '') <> ''
                                                              THEN '<a href="http://'
                                                              + url
                                                              + '" target="_blank">'
                                                              ELSE ''
                                                              END ) url ,
                                                              LTRIM(RTRIM(COALESCE(articletitle,
                                                              ''))) article ,
                                                              LTRIM(RTRIM(COALESCE(pubtitle,
                                                              ''))) pub ,
                                                              ( CASE
                                                              WHEN publicationdt > '1/1/1901'
                                                              THEN CONVERT(VARCHAR(50), YEAR(publicationdt))
                                                              ELSE ''
                                                              END ) y ,
                                                              COALESCE(volnum,
                                                              '')
                                                              + ( CASE
                                                              WHEN COALESCE(issuepub,
                                                              '') <> ''
                                                              THEN '('
                                                              + issuepub + ')'
                                                              ELSE ''
                                                              END )
                                                              + ( CASE
                                                              WHEN ( COALESCE(paginationpub,
                                                              '') <> '' )
                                                              AND ( COALESCE(volnum,
                                                              '')
                                                              + COALESCE(issuepub,
                                                              '') <> '' )
                                                              THEN ':'
                                                              ELSE ''
                                                              END )
                                                              + COALESCE(paginationpub,
                                                              '') vip ,
                                                              0 AS frompubmed ,
                                                              publicationdt
                                                      FROM    [Profile.Data].[Publication.MyPub.General] m2
                                                      WHERE   m2.mpid = m.mpid
                                                    ) t
                                        ) t
                            ) AS publications ,
                            0 ,
                            publicationdt ,
                            i.pubid ,
                            hmspubcategory ,
                            url ,
                            'Custom' sourcename
                  FROM      [Profile.Data].[Publication.MyPub.General] m
                            JOIN [Profile.Data].[Publication.Person.Include] i ON i.mpid = m.mpid
                            JOIN [Profile.Data].[Publication.Person.Include] i2 ON i2.mpid = i.mpid
                                                              AND i2.PersonID = ISNULL(@userid2,
                                                              i2.PersonID)
                  WHERE     m.personid = @UserID
                            AND i.mpid IS NOT NULL
                            AND i.mpid NOT LIKE 'DASH%'
                            AND i.mpid NOT LIKE 'ISI%'
                            AND i.pmid IS NULL
                  UNION ALL
                  SELECT    NULL AS pmid ,
                            p.mpid ,
                            g.BibliographicCitation publications ,
                            0 AS FromPubMed ,
                            m.publicationdt ,
                            pubid ,
                            m.hmspubcategory ,
                            @dash_url + CAST(g.dashid AS VARCHAR(10)) url ,
                            'DASH' sourcename
                  FROM      [Profile.Data].[Publication.MyPub.General] m ,
                            [Profile.Data].[Publication.Person.Include] p ,
                            [Profile.Data].[Publication.DSpace.MPID] d ,
                            [Profile.Data].[Publication.DSpace.PubGeneral] g
                  WHERE     p.personid = @UserID
                            AND m.mpid = p.mpid
                            AND p.mpid IS NOT NULL
                            AND p.pmid IS NULL
                            AND p.mpid LIKE 'DASH%'
                            AND p.mpid = d.mpid
                            AND d.dashid = g.dashid
                  UNION ALL
                  SELECT    NULL AS pmid ,
                            p.mpid ,
                            ( g.authors + '. ' + g.itemtitle
                              + ( CASE WHEN RIGHT(g.itemtitle, 1) NOT IN ( '.',
                                                              '?', '!' )
                                       THEN '. '
                                       ELSE ' '
                                  END ) + COALESCE(g.sourceabbrev,
                                                   g.sourcetitle) + '. '
                              + g.bibid + '.' ) publications ,
                            0 AS FromPubMed ,
                            m.publicationdt ,
                            pubid ,
                            m.hmspubcategory ,
                            'http://dx.doi.org/' + doi url ,
                            'DOI' sourcename
                  FROM      [Profile.Data].[Publication.MyPub.General] m ,
                            [Profile.Data].[Publication.Person.Include] p ,
                            [Profile.Data].[Publication.ISI.MPID] d ,
                            [Profile.Data].[Publication.ISI.PubGeneral] g
                  WHERE     p.personid = @UserID
                            AND m.mpid = p.mpid
                            AND p.mpid IS NOT NULL
                            AND p.pmid IS NULL
                            AND p.mpid LIKE 'ISI%'
                            AND p.mpid = d.mpid
                            AND d.recid = g.recid
                ) t
                OUTER APPLY ( SELECT DISTINCT
                                        pmid
                              FROM      [Search.Cache].APIQueryMatchedPublication c
                              WHERE     c.personid = @UserID
                                        AND c.keywordstring = @keyword
                                        AND c.pmid = t.pmid
                                        AND c.exactkeyword = ISNULL(@exactkeyword,
                                                              0)
                            ) c
        WHERE   CASE WHEN ISNULL(@Keyword, '') <> '' THEN c.pmid
                     ELSE ''
                END IS NOT NULL
        ORDER BY publication_dt DESC
 	
    END
GO
