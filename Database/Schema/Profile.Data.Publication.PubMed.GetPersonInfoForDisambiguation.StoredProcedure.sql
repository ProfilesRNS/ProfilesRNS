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
            @threshold FLOAT,
            @baseURI NVARCHAR(max),
			@orcidNodeID NVARCHAR(max)

--SET Custom Threshold based on internal Institutional Logic, default is .98
SELECT @threshold = .98

SELECT @batchID=NEWID()

SELECT @baseURI = [Value] FROM [Framework.].[Parameter] WHERE [ParameterID] = 'baseURI'
SELECT @orcidNodeID = NodeID from [RDF.].Node where Value = 'http://vivoweb.org/ontology/core#orcidId'

SELECT personid, 
                   (SELECT ISNULL(RTRIM(firstname),'')  "Name/First",
                                          ISNULL(RTRIM(middlename),'') "Name/Middle",
                                          ISNULL(RTRIM(p.lastname),'') "Name/Last",
                                          ISNULL(RTRIM(suffix),'')     "Name/Suffix",
                                          CASE 
                                                 WHEN a.n IS NOT NULL OR b.n IS NOT NULL 
                                                          /*  Below is example of a custom piece of logic to alter the disambiguation by telling the disambiguation service
                                                            to Require First Name usage in the algorithm for faculty who are lower in rank */
                                                      OR facultyranksort > 4 
                                                      THEN 'true'
                                                ELSE 'false'
                                          END "RequireFirstName",
                                          d.cnt                                                                              "LocalDuplicateNames",
                                          @threshold                                                                   "MatchThreshold",
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
                                        FOR XML PATH(''),ROOT('PMIDExcludeList'),TYPE),
                                          (SELECT @baseURI + CAST(i.NodeID AS VARCHAR) 
                                        FOR XML PATH(''),ROOT('URI'),TYPE),
										  (select n.Value as '*' from [RDF.].Node n join
											[RDF.].Triple t  on n.NodeID = t.Object
											and t.Subject = i.NodeID
											and t.Predicate = @orcidNodeID
										FOR XML PATH(''),ROOT('ORCID'),TYPE)
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
                                                        AND a.f=LEFT(firstname,1)
                                                        AND a.m = LEFT(middlename,1)
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
                                                                                                
                                                )B ON b.f = LEFT(firstname,1)
                                                  AND b.lastname = p.lastname
                              LEFT JOIN ( SELECT [Utility.NLP].[fnNamePart1](firstname)F,
                                                                                          lastname,
                                                                                          COUNT(*)cnt
                                                                              FROM [Profile.Data].Person 
                                                                         GROUP BY [Utility.NLP].[fnNamePart1](firstname), 
                                                                                          lastname
                                                                  )d ON d.f = [Utility.NLP].[fnNamePart1](p2.firstname)
                                                                        AND d.lastname = p2.lastname

                              LEFT JOIN [RDF.Stage].[InternalNodeMap] i
								 ON [InternalType] = 'Person' AND [Class] = 'http://xmlns.com/foaf/0.1/Person' AND [InternalID] = CAST(p2.personid AS VARCHAR(50))                             
                         WHERE p.personid = p2.personid
                        
                        FOR XML PATH(''),ROOT('FindPMIDs')) XML--as xml)
  INTO #batch
  FROM [Profile.Data].vwperson  p2
  
   
SELECT @batchcount=@@ROWCOUNT

SELECT @BatchID,@batchcount,*
  FROM #batch 
END

GO
