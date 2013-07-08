SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  function [Profile.Data].[fnPublication.Person.GetPublications](@UserID INT)
RETURNS  @p  TABLE(
										RowNum VARCHAR(10),
										Reference NVARCHAR(MAX),
										FromPubMed BIT,
										PubId NVARCHAR(50),
										pmid INT,
										mpid VARCHAR(50),
										category NVARCHAR(60),
										url			VARCHAR(1000),
									  pubdate DATETIME
									)
AS
BEGIN
DECLARE  @encode_html INT,
@pubmed_url VARCHAR(200)
declare @dash_url varchar(max)
select @dash_url = ISNULL('http://dash.harvard.edu/handle/1/',''),
			@pubmed_url='http://www.ncbi.nlm.nih.gov/pubmed/'
SELECT @encode_html = 0;
 
WITH cte
		 AS (SELECT CONVERT(VARCHAR,ROW_NUMBER() OVER(ORDER BY publication_dt desc, publications)) + '. ' AS rownum,
								publications,
								frompubmed,
								pubid,
								pmid,
								mpid,
								category,
								url,publication_dt
					 FROM (SELECT  DISTINCT 
												 p.pmid,
												 NULL                                              AS mpid,
													[Profile.Cache].[fnPublication.Pubmed.General2Reference]	(p.pmid ,ArticleDay,ArticleMonth,ArticleYear,ArticleTitle,Authors,AuthorListCompleteYN,Issue,JournalDay,JournalMonth,JournalYear,MedlineDate,MedlinePgn,MedlineTA,Volume,0) AS publications,
												 1                                                 AS frompubmed,
												 [Profile.Data].[fnPublication.Pubmed.GetPubDate]( MedlineDate,JournalYear,JournalMonth,JournalDay,ArticleYear,ArticleMonth,ArticleDay)                                           AS publication_dt,
												 pubid,
												 NULL                                              category,
												 @pubmed_url + CAST(ISNULL(p.pmid,'') AS VARCHAR(20))	     url,
												 'PubMed'										   sourcename
									 FROM [Profile.Data].[Publication.Person.Include] i    
									 JOIN [Profile.Data].[Publication.PubMed.General] p ON i.pmid = p.pmid
									WHERE  i.personid = @UserID
									  AND p.pmid IS NOT NULL
								 UNION ALL
								 SELECT  DISTINCT 
												 m.pmid,
												 m.mpid,
												 --dbo.fn_GetPublicationReference(m.mpid,'mpid',1)	AS Publications			,
 	
				 (SELECT authors + 
																(CASE 
																	WHEN url <> ''
																			 AND article <> ''
																			 AND pub <> '' THEN url + article + '</a>. ' + pub + '. '
																	WHEN url <> ''
																			 AND article <> '' THEN url + article + '</a>. '
																	WHEN url <> ''
																			 AND pub <> '' THEN url + pub + '</a>. '
																	WHEN article <> ''
																			 AND pub <> '' THEN article + '. ' + pub + '. '
																	WHEN article <> '' THEN article + '. '
																	WHEN pub <> '' THEN pub + '. '
																	ELSE ''
																END) + 
																y + 
															 (CASE 
																	 WHEN y <> ''
																				AND vip <> '' THEN '; '
																	 ELSE ''
																END) + 
																vip + 
																(CASE 
																	WHEN y <> ''
																				OR vip <> '' THEN '.'
																	ELSE ''
																END)
													FROM (SELECT url,
																			 (CASE 
																					WHEN authors = '' THEN ''
																					WHEN RIGHT(authors,1) = '.' THEN LEFT(authors,LEN(authors) - 1)
																					ELSE authors
																				END) authors,
																			 (CASE 
																					WHEN article = '' THEN ''
																					WHEN RIGHT(article,1) = '.' THEN LEFT(article,LEN(article) - 1)
																					ELSE article
																				END) article,
																			 (CASE 
																					WHEN pub = '' THEN ''
																					WHEN RIGHT(pub,1) = '.' THEN LEFT(pub,LEN(pub) - 1)
																					ELSE pub
																				END) pub,
																			 y,
																			 vip,
																			 frompubmed,
																			 publicationdt
														       		  FROM (SELECT ( 		case													WHEN RTRIM(LTRIM(COALESCE(authors,''))) = '' THEN ''
																									WHEN RIGHT(COALESCE(authors,''),1) = '.' THEN COALESCE(authors,'') + ' '
																									ELSE COALESCE(authors,'') + '. '
																								END) authors,
																							 (CASE 
																									WHEN COALESCE(url,'') <> ''
																											 AND LEFT(COALESCE(url,''),4) = 'http' THEN '<a href="' + url + '" target="_blank">'
																									WHEN COALESCE(url,'') <> '' THEN '<a href="http://' + url + '" target="_blank">'
																									ELSE ''
																								END) url,
																							 LTRIM(RTRIM(COALESCE(articletitle,'')))     article,
																							 LTRIM(RTRIM(COALESCE(pubtitle,'')))         pub,
																							 (CASE 
																									WHEN publicationdt > '1/1/1901' THEN CONVERT(VARCHAR(50),YEAR(publicationdt))
																									ELSE ''
																								END) y,
																							 COALESCE(volnum,'') + 
																							(CASE 
																									WHEN COALESCE(issuepub,'') <> '' THEN '(' + issuepub + ')'
																									ELSE ''
																								END) +	
																							(CASE 
																								WHEN (COALESCE(paginationpub,'') <> '') AND (COALESCE(volnum,'') + COALESCE(issuepub,'') <> '') THEN ':'
																								ELSE ''
																						  END) + 
																							COALESCE(paginationpub,'') vip,
																							0                                           AS frompubmed,
																							publicationdt
																			FROM		[Profile.Data].[Publication.MyPub.General] m2
																	   WHERE		m2.mpid = m.mpid) t) 
																 t) AS publications,
																 0,
																 publicationdt,
																 pubid,
																 hmspubcategory,
																 url,
																'Custom'										   sourcename
									FROM [Profile.Data].[Publication.MyPub.General] m
								    JOIN [Profile.Data].[Publication.Person.Include] i 	ON i.mpid = m.mpid
			 
 WHERE m.personid = @UserID	
								     AND i.mpid IS NOT NULL
								     AND i.mpid NOT LIKE 'DASH%'
								     AND i.mpid NOT LIKE 'ISI%'
								     AND i.pmid IS NULL 
									UNION ALL 
									SELECT		null as pmid, 
										p.mpid,
										g.BibliographicCitation publications, 
										0 as FromPubMed, 
										m.publicationdt,
										pubid,
										m.hmspubcategory,
										@dash_url+cast(g.dashid as varchar(10)) url,
										'DASH' sourcename
									FROM	[Profile.Data].[Publication.MyPub.General] m, [Profile.Data].[Publication.Person.Include] p, [Profile.Data].[Publication.DSpace.MPID] d, [Profile.Data].[Publication.DSpace.PubGeneral] g
									WHERE	p.personid = @UserID
										and m.mpid = p.mpid
										and p.mpid is not null and p.pmid is null
										and p.mpid like 'DASH%' 
										and p.mpid = d.mpid and d.dashid = g.dashid
									UNION ALL
									SELECT 
										null as pmid, 
										p.mpid,
										(g.authors + '. ' 
										+ g.itemtitle + (case when right(g.itemtitle,1) not in ('.','?','!') then '. ' else ' ' end) 
										+ coalesce(g.sourceabbrev, g.sourcetitle) 
										+ '. ' + g.bibid + '.')
										publications,
										0 as FromPubMed, 
										m.publicationdt,
										pubid,
										m.hmspubcategory,
										'http://dx.doi.org/' + doi url,
										'DOI' sourcename
									FROM [Profile.Data].[Publication.MyPub.General] m,[Profile.Data].[Publication.Person.Include] p, [Profile.Data].[Publication.ISI.MPID] d, [Profile.Data].[Publication.ISI.PubGeneral] g
									where p.personid = @UserID
										and m.mpid = p.mpid
										and p.mpid is not null and p.pmid is null
										and p.mpid like 'ISI%' 
										and p.mpid = d.mpid and d.recid = g.recid
		 			     
								    ) t)
INSERT INTO @p
SELECT * 
	FROM cte
 ORDER BY CONVERT(INT,REPLACE(rownum,'.',''))
 
RETURN
END
GO
