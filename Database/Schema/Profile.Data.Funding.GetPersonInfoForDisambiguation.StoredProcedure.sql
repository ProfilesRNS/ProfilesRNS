SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Funding.GetPersonInfoForDisambiguation] 
	@startRow INT = 0,
	@nextRow INT OUTPUT
AS
BEGIN
SET nocount  ON;
 
 
	DECLARE  @search XML,
				@batchcount INT,
				@baseURI NVARCHAR(max),
				@orcidNodeID NVARCHAR(max)
				@rows INT,
				@batchSize INT

				
	SELECT @batchSize = 1000

	SELECT @baseURI = [Value] FROM [Framework.].[Parameter] WHERE [ParameterID] = 'baseURI'
	SELECT @orcidNodeID = NodeID from [RDF.].Node where Value = 'http://vivoweb.org/ontology/core#orcidId'
	
	SELECT personID, ROW_NUMBER() OVER (ORDER BY personID) AS rownum INTO #personIDs FROM [Profile.Data].Person 
	WHERE IsActive = 1

	SELECT @rows = count(*) FROM #personIDs
	SELECT @nextRow = CASE WHEN @rows > @startRow + @batchSize THEN @startRow + @batchSize ELSE -1 END

	SELECT (
		select p2.personid as PersonID, 
		ISNULL(RTRIM(firstname),'')  "Name/First",
		ISNULL(RTRIM(middlename),'') "Name/Middle",
		ISNULL(RTRIM(p2.lastname),'') "Name/Last",
		ISNULL(RTRIM(suffix),'')     "Name/Suffix",
		d.cnt "LocalDuplicateNames",
		(SELECT DISTINCT ISNULL(LTRIM(ISNULL(emailaddress,p2.emailaddr)),'') Email
				FROM [Profile.Data].[Person.Affiliation] pa
				WHERE pa.personid = p2.personid
			FOR XML PATH(''),TYPE) AS "EmailList",
		(SELECT Affiliation
				FROM [Profile.Data].[Publication.PubMed.DisambiguationAffiliation]
			FOR XML PATH(''),TYPE) AS "AffiliationList",
		(SELECT distinct Organization as Org FROM [Profile.Data].[Funding.DisambiguationOrganizationMapping] m
			JOIN [Profile.Data].[Person.Affiliation] pa
			on m.InstitutionID = pa.InstitutionID 
				or (m.InstitutionID is null and pa.IsPrimary = 1)
			where pa.PersonID = p2.PersonID
			FOR XML PATH(''),ROOT('OrgList'),TYPE),
		(SELECT PMID
				FROM [Profile.Data].[Publication.Person.Add]
				WHERE personid =p2.personid
			FOR XML PATH(''),ROOT('PMIDAddList'),TYPE),
		(SELECT PMID
			FROM [Profile.Data].[Publication.Person.Include]
				WHERE personid =p2.personid
			FOR XML PATH(''),ROOT('PMIDIncludeList'),TYPE),
		(SELECT PMID
			FROM [Profile.Data].[Publication.Person.Exclude]
				WHERE personid =p2.personid
			FOR XML PATH(''),ROOT('PMIDExcludeList'),TYPE),
		(SELECT FundingID FROM [Profile.Data].[Funding.Add] ad
			join [Profile.Data].[Funding.Agreement] ag
				on ad.FundingAgreementID = ag.FundingAgreementID
				and ag.Source = 'NIH'
				WHERE ad.PersonID = p2.PersonID
			FOR XML PATH(''),ROOT('GrantsAddList'),TYPE),
		(SELECT FundingID FROM [Profile.Data].[Funding.Add] ad
			join [Profile.Data].[Funding.Agreement] ag
				on ad.FundingAgreementID = ag.FundingAgreementID
				and ag.Source = 'NIH'
				WHERE ad.PersonID = p2.PersonID
			FOR XML PATH(''),ROOT('GrantsAddList'),TYPE),
		(SELECT FundingID FROM [Profile.Data].[Funding.Delete]
				WHERE Source = 'NIH' and PersonID = p2.PersonID
			FOR XML PATH(''),ROOT('GrantsDeleteList'),TYPE),
		(SELECT @baseURI + CAST(i.NodeID AS VARCHAR) 
			FOR XML PATH(''),ROOT('URI'),TYPE),
				(select n.Value as '*' from [RDF.].Node n join
				[RDF.].Triple t  on n.NodeID = t.Object
				and t.Subject = i.NodeID
				and t.Predicate = @orcidNodeID
			FOR XML PATH(''),ROOT('ORCID'),TYPE)
	FROM [Profile.Data].Person p2 
	  LEFT JOIN ( SELECT [Utility.NLP].[fnNamePart1](firstname)F,
			lastname,
			COUNT(*)cnt
			FROM [Profile.Data].Person 
			GROUP BY [Utility.NLP].[fnNamePart1](firstname), 
				lastname
			)d ON d.f = [Utility.NLP].[fnNamePart1](p2.firstname)
				AND d.lastname = p2.lastname
				AND p2.IsActive = 1 
		LEFT JOIN [RDF.Stage].[InternalNodeMap] i
			ON [InternalType] = 'Person' AND [Class] = 'http://xmlns.com/foaf/0.1/Person' AND [InternalID] = CAST(p2.personid AS VARCHAR(50))
	  for xml path('Person'), root('FindFunding'), type) as X
END


GO
