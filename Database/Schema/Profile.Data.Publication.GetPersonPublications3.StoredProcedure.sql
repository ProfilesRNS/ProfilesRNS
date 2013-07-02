SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [Profile.Data].[Publication.GetPersonPublications3](@UserID INT,@UserID2 INT, @Keyword Varchar(2000), @ExactKeyword BIT, @Pubs XML OUTPUT)
 as
BEGIN
DECLARE  @encode_html INT
declare  @dash_url varchar(max) 
select @dash_url = ISNULL('http://dash.harvard.edu/handle/1/','')
SELECT @encode_html = 0; 
 

	 SELECT 
						category																																									"Publication/@CustomCategory" ,
					  CAST(pubid AS VARCHAR(50))																																"Publication/PublicationID",
						PUBLICATIONS   																																								"Publication/PublicationReference",
						t.pmid																	 																									"Publication/PublicationSourceList/PublicationSource/@ID",
					  CASE WHEN frompubmed=1 THEN 'http://www.ncbi.nlm.nih.gov/pubmed/'+CAST(ISNULL(t.pmid,'')AS VARCHAR(20))ELSE URL END"Publication/PublicationSourceList/PublicationSource/@URL",
						 'true'																																											"Publication/PublicationSourceList/PublicationSource/@Primary",
					  sourcename    															"Publication/PublicationSourceList/PublicationSource/@Name" ,
						 null																	 "Publication/PublicationDetails" 
																		 
					 FROM (SELECT  DISTINCT 
												 p.pmid,
												 NULL                                              AS mpid,
												 [Profile.Cache].[fnPublication.Pubmed.General2Reference]	(p.pmid ,ArticleDay,ArticleMonth,ArticleYear,ArticleTitle,Authors,AuthorListCompleteYN,Issue,JournalDay,JournalMonth,JournalYear,MedlineDate,MedlinePgn,MedlineTA,Volume,0) AS publications,
												 1                                                 AS frompubmed,
												 [Profile.Data].[fnPublication.Pubmed.GetPubDate]( MedlineDate,JournalYear,JournalMonth,JournalDay,ArticleYear,ArticleMonth,ArticleDay)                                           AS publication_dt,
												 i.pubid,
												 NULL                                              category,
												 NULL                                              url,
												 'PubMed'										   sourcename
									 FROM  [Profile.Data].[Publication.Person.Include] i    
									 JOIN [Profile.Data].[Publication.Person.Include] i2 ON i2.PMID = i.PMID AND i2.PersonID = @userid2
									 JOIN [Profile.Data].[Publication.PubMed.General] p ON i.pmid = p.pmid
									WHERE  i.personid = @UserID
									  AND p.pmid IS NOT NULL
								 UNION ALL
								 SELECT  DISTINCT 
												 m.pmid,
												 m.mpid,
												 --dbo.fn_GetPubli ' cations			,
												 (SELECT authors + 
																(CASE 
																	WHEN url < > ''
 
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
														     FROM (SELECT (CASE 
																									WHEN RTRIM(LTRIM(COALESCE(authors,''))) = '' THEN ''
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
																 i.pubid,
																 hmspubcategory,
																 url,
																'Custom'										   sourcename
									  FROM [Profile.Data].[Publication.MyPub.General] m
								    JOIN [Profile.Data].[Publication.Person.Include] i  	 ON i.mpid = m.mpid
								    JOIN [Profile.Data].[Publication.Person.Include] i2  	 ON i2.mpid = i.mpid AND i2.PersonID = @userid2
								   WHERE m.personid = @UserID	
								     AND i.mpid IS NOT NULL
		 						
anD 
i.mpid NOT LIKE 'DASH%'
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
		 			     
								     ) t 
OUTER APPLY (SELECT DISTINCT pmid 
			  from [Search.Cache].APIQueryMatchedPublication c where  c.personid=@UserID AND c.keywordstring = @keyword AND c.pmid=t.pmid and c.exactkeyword = ISNULL(@exactkeyword,0)) c 								
where CASE WHEN ISNULL(@Keyword,'')<>''  THEN c.pmid ELSE '' END IS NOT NULL 									
ORDER BY publication_dt DESC
 	
END
GO
