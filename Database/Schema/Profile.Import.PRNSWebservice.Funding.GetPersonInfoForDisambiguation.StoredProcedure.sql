SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[PRNSWebservice.Funding.GetPersonInfoForDisambiguation] 
	@Job varchar(55),
	@BatchID varchar(100)
AS
BEGIN
	SET NOCOUNT ON;
	CREATE TABLE #tmp (LogID INT, BatchID VARCHAR(100), RowID INT, HttpMethod VARCHAR(10), URL VARCHAR(500), PostData xml) 

	DECLARE  --@search XML,
				@batchcount INT,
				--@threshold FLOAT,
				@baseURI NVARCHAR(max),
				@orcidNodeID NVARCHAR(max),
				@BatchSize int,
				@URL varchar(500),
				@logLevel int,
				@rows int,
				@rowsCount int

	select @URL = URL, @BatchSize = batchSize, @logLevel = logLevel from [Profile.Import].[PRNSWebservice.Options] where job = @Job

	SELECT @baseURI = [Value] FROM [Framework.].[Parameter] WHERE [ParameterID] = 'baseURI'
	SELECT @orcidNodeID = NodeID from [RDF.].Node where Value = 'http://vivoweb.org/ontology/core#orcidId'
	
	SELECT personID, ROW_NUMBER() OVER (ORDER BY personID) AS rownum INTO #personIDs FROM [Profile.Data].Person p
	WHERE IsActive = 1 and not exists (select 1 from [Profile.Data].[Funding.DisambiguationSettings] s where s.PersonID = p.PersonID and enabled = 0)

	SELECT @rows = count(*) FROM #personIDs

	insert into #tmp(LogID, BatchID, RowID, HttpMethod, URL, PostData)
	select -1, @batchID batchID, n, 'POST', @URL, (
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
			(SELECT distinct Organization as Org FROM [Profile.Data].[Funding.DisambiguationOrganizationMapping] m
				JOIN [Profile.Data].[Person.Affiliation] pa
				on m.InstitutionID = pa.InstitutionID 
					or m.InstitutionID is null
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
				JOIN #personIDs p3 on p2.personID = p3.personID
		  order by p3.PersonID offset n * @BatchSize ROWS FETCH NEXT @BatchSize ROWS ONLY for xml path('Person'), root('FindFunding'), type) as X
	  ) x
	from [Utility.Math].N where n <= @rows / @BatchSize

	select @rowsCount = @@ROWCOUNT

	Update [Profile.Import].[PRNSWebservice.Log.Summary]  set RecordsCount = @rows, RowsCount = @rowsCount where BatchID = @BatchID

	DECLARE @LogIDTable TABLE (LogID int, RowID int)
	IF @logLevel = 1
	BEGIN
		INSERT INTO [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID, HttpMethod, URL)
		OUTPUT inserted.LogID, Inserted.RowID into @LogIDTable
		SELECT @job, BatchID, RowID, HttpMethod, URL FROM #tmp
		UPDATE t SET t.LogID = l.LogID FROM #tmp t JOIN @LogIDTable l ON t.RowID = l.RowID
	END
	ELSE IF @logLevel = 2
	BEGIN
		INSERT INTO [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID, HttpMethod, URL, PostData)
		OUTPUT inserted.LogID, Inserted.RowID into @LogIDTable
		SELECT @job, BatchID, RowID, HttpMethod, URL, convert(varchar(max), PostData) FROM #tmp
		UPDATE t SET t.LogID = l.LogID FROM #tmp t JOIN @LogIDTable l ON t.RowID = l.RowID
	END

	Truncate table [Profile.Data].[Funding.DisambiguationResults]
	SELECT LogID, BatchID, RowID, HttpMethod, URL, convert(varchar(max), PostData) FROM #tmp
END
GO
