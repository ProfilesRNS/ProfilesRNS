SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.PubMed.GetPersonInfoForDisambiguation] 
AS
BEGIN
SET nocount  ON;
 
 
DECLARE  @search XML,
		 @batchID UNIQUEIDENTIFIER,
		 @batchcount INT,
		 @threshold FLOAT
 
--SET Custom Threshold based on internal Institutional Logic, default is .98
SELECT @threshold = .98
 
SELECT @batchID=NEWID()
 
SELECT personid, 
			 (SELECT ISNULL(RTRIM(firstname),'')  "Name/First",
							 ISNULL(RTRIM(middlename),'') "Name/Middle",
							 ISNULL(RTRIM(p.lastname),'') "Name/Last",
							 ISNULL(RTRIM(suffix),'')     "Name/Suffix",
							 CASE 
								 WHEN a.n is not null or b.n is not null 
									    /*  Below is example of a custom piece of logic to alter the disambiguation by telling the disambiguation service
										to Require First Name usage in the algorithm for faculty who are lower in rank */
									or facultyranksort > 4 
									THEN 'true'
								 ELSE 'false'
							 END "RequireFirstName",
							 d.cnt													"LocalDuplicateNames",
							 @threshold												"MatchThreshold",
							 (SELECT DISTINCT ISNULL(LTRIM(ISNULL(emailaddress,p.emailaddr)),'') Email
									FROM [Profile.Data].[Person.Affiliation] pa
								 WHERE pa.personid = p.personid
								FOR XML PATH(''),TYPE) AS "EmailList",
							 (SELECT Affiliation
									FROM [Profile.Data].[Publication.PubMed.DisambiguationAffiliation]
								FOR XML PATH(''),TYPE) AS "AffiliationList",
							(SELECT PMID
							   FROM [Profile.Data].[Publication.Person.Add]
							  WHERE personid =p2.personid
						    FOR XML PATH(''),ROOT('PMIDAddList'),TYPE),
							(SELECT PMID
							   FROM [Profile.Data].[Publication.Person.Exclude]
							  WHERE personid =p2.personid
						    FOR XML PATH(''),ROOT('PMIDExcludeList'),TYPE)
					FROM [Profile.Data].Person p
						   LEFT JOIN ( 
								
									   --case 1
										SELECT LEFT(firstname,1)  f,
													 LEFT(middlename,1) m,
													 lastname,
													 COUNT(* )          n
										  FROM [Profile.Data].Person
										 GROUP BY LEFT(firstname,1),
													 LEFT(middlename,1),
													 lastname
										HAVING COUNT(* ) > 1
									)A ON a.lastname = p.lastname
									  and a.f=left(firstname,1)
									  and a.m = left(middlename,1)
					LEFT JOIN (			  
 
									--case 2
									SELECT LEFT(firstname,1) f,
												 lastname,
												 COUNT(* )         n
									  FROM [Profile.Data].Person
									 GROUP BY LEFT(firstname,1),
												 lastname
									HAVING COUNT(* ) > 1
												 AND SUM(CASE 
																	 WHEN middlename = '' THEN 1
																	 ELSE 0
																 END) > 0
																
								)B on b.f = left(firstname,1)
								  and b.lastname = p.lastname
					 LEFT JOIN ( SELECT [Utility.NLP].[fnNamePart1](firstname)F,
															lastname,
															COUNT(*)cnt
													 from [Profile.Data].Person 
												 GROUP BY [Utility.NLP].[fnNamePart1](firstname), 
															lastname
											)d on d.f = [Utility.NLP].[fnNamePart1](p2.firstname)
												and d.lastname = p2.lastname
 
										 
				 WHERE p.personid = p2.personid
				 
				FOR XML PATH(''),ROOT('FindPMIDs')) XML--as xml)
  INTO #batch
  FROM [Profile.Data].vwperson  p2
  
   
SELECT @batchcount=@@ROWCOUNT
 
SELECT @BatchID,@batchcount,*
  FROM #batch 
END
GO
