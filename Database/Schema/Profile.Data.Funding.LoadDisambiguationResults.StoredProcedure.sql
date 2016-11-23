SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Funding.LoadDisambiguationResults]
AS
BEGIN
	--------------------------------------------------------------
	-- Get existing and deleted NIH grants
	--------------------------------------------------------------

	SELECT DISTINCT ISNULL(r.PersonID,0) PersonID, ISNULL(a.FundingID2,'') CORE_PROJECT_NUM
		INTO #ExistingRoles
		FROM [Profile.Data].[Funding.Role] r
			INNER JOIN [Profile.Data].[Funding.Agreement] a
				ON r.FundingAgreementID = a.FundingAgreementID
		WHERE a.Source = 'NIH' AND a.FundingID2 <> ''

	ALTER TABLE #ExistingRoles ADD PRIMARY KEY (PersonID, CORE_PROJECT_NUM)


	SELECT DISTINCT ISNULL(PersonID,0) PersonID, ISNULL(FundingID2,'') CORE_PROJECT_NUM
		INTO #DeletedRoles
		FROM [Profile.Data].[Funding.Delete]
		WHERE Source = 'NIH' AND FundingID2 <> ''

	ALTER TABLE #DeletedRoles ADD PRIMARY KEY (PersonID, CORE_PROJECT_NUM)

	--------------------------------------------------------------
	-- Get a list of agreements
	--------------------------------------------------------------

	SELECT 
			ISNULL(NEWID(),'00000000-0000-0000-0000-000000000000') FundingAgreementID,
			ISNULL(FundingID,'') FundingID,
			AgreementLabel,
			GrantAwardedBy,
			StartDate,
			EndDate,
			PrincipalInvestigatorName,
			NULLIF(Abstract,'') Abstract,
			Source,
			FundingID2
		INTO #Agreement
		FROM (
			SELECT *, ROW_NUMBER() OVER (PARTITION BY FundingID ORDER BY PersonID) k
			FROM [Profile.Data].[Funding.DisambiguationResults] e
			WHERE NOT EXISTS (
				SELECT * 
				FROM #DeletedRoles d 
				WHERE d.PersonID=e.PersonID AND d.CORE_PROJECT_NUM=e.FundingID2
			)
		) t
		WHERE k = 1

	ALTER TABLE #Agreement ADD PRIMARY KEY (FundingAgreementID)
	CREATE UNIQUE NONCLUSTERED INDEX idx_FundingID ON #Agreement(FundingID)

	-- Use the current FundingAgreementID if one exists
	UPDATE a
		SET a.FundingAgreementID = h.FundingAgreementID
		FROM #Agreement a
			INNER JOIN [Profile.Data].[Funding.Agreement] h
				ON a.FundingID = h.FundingID
					AND a.FundingID = h.FundingID2
					AND h.Source = 'NIH'

	--------------------------------------------------------------
	-- Get a list of new roles
	--------------------------------------------------------------

	SELECT ISNULL(NEWID(),'00000000-0000-0000-0000-000000000000') FundingRoleID, 
			e.PersonID, a.FundingAgreementID, e.RoleLabel RoleLabel, NULL RoleDescription
		INTO #Role
		FROM [Profile.Data].[Funding.DisambiguationResults] e
			INNER JOIN #Agreement a ON e.FundingID = a.FundingID
		WHERE NOT EXISTS (
			SELECT * 
			FROM #DeletedRoles d 
			WHERE d.PersonID=e.PersonID AND d.CORE_PROJECT_NUM=e.FundingID
		) AND NOT EXISTS (
			SELECT * 
			FROM #ExistingRoles a 
			WHERE a.PersonID=e.PersonID AND a.CORE_PROJECT_NUM=e.FundingID
		)

	ALTER TABLE #Role ADD PRIMARY KEY (FundingRoleID)
	CREATE UNIQUE NONCLUSTERED INDEX idx_PersonAgreement ON #Role(PersonID,FundingAgreementID)


	--------------------------------------------------------------
	-- Update actual tables
	--------------------------------------------------------------

	-- Update agreement information
	UPDATE h
		SET h.AgreementLabel = a.AgreementLabel,
			h.GrantAwardedBy = a.GrantAwardedBy,
			h.StartDate = a.StartDate,
			h.EndDate = a.EndDate,
			h.PrincipalInvestigatorName = a.PrincipalInvestigatorName,
			h.Abstract = a.Abstract
		FROM [Profile.Data].[Funding.Agreement] h
			INNER JOIN #Agreement a 
				ON h.FundingAgreementID = a.FundingAgreementID
		WHERE h.AgreementLabel <> a.AgreementLabel
			OR h.GrantAwardedBy <> a.GrantAwardedBy
			OR h.StartDate <> a.StartDate
			OR h.EndDate <> a.EndDate
			OR h.PrincipalInvestigatorName <> a.PrincipalInvestigatorName
			OR h.Abstract <> a.Abstract

	-- Insert new agreements
	INSERT INTO [Profile.Data].[Funding.Agreement]
		SELECT FundingAgreementID, FundingID, AgreementLabel, GrantAwardedBy, StartDate, EndDate, PrincipalInvestigatorName, Abstract, Source, FundingID2
		FROM #Agreement a
		WHERE FundingAgreementID NOT IN (SELECT FundingAgreementID FROM [Profile.Data].[Funding.Agreement])

	-- Insert new roles
	INSERT INTO [Profile.Data].[Funding.Role]
		SELECT FundingRoleID, PersonID, FundingAgreementID, RoleLabel, RoleDescription
		FROM #Role

		
	INSERT INTO [Framework.].[Log.Activity] (userId, personId, methodName, property, privacyCode, param1, param2) 
		SELECT 0, PersonID, '[Profile.Data].[Funding.LoadDisambiguationResults]', 'http://vivoweb.org/ontology/core#ResearcherRole', null, FundingRoleID, null 
		FROM #Role
	

	--******************************************************************
	--******************************************************************
	--*** Update RDF
	--******************************************************************
	--******************************************************************


	CREATE TABLE #DataMapID (DataMapID INT PRIMARY KEY)

	INSERT INTO #DataMapID (DataMapID)
		SELECT DataMapID
			FROM [Ontology.].[DataMap]
			WHERE Class IN ('http://vivoweb.org/ontology/core#Grant','http://vivoweb.org/ontology/core#ResearcherRole')
				AND Property IS NULL
				AND NetworkProperty IS NULL 
		UNION ALL
		SELECT DataMapID
			FROM [Ontology.].[DataMap]
			WHERE Class = 'http://vivoweb.org/ontology/core#Grant'
				AND Property IS NOT NULL
				AND NetworkProperty IS NULL 
		UNION ALL
		SELECT DataMapID
			FROM [Ontology.].[DataMap]
			WHERE Class = 'http://vivoweb.org/ontology/core#ResearcherRole'
				AND Property IS NOT NULL
				AND NetworkProperty IS NULL 
		UNION ALL
		SELECT DataMapID
			FROM [Ontology.].[DataMap]
			WHERE Class = 'http://xmlns.com/foaf/0.1/Person'
				AND Property = 'http://vivoweb.org/ontology/core#hasResearcherRole'
				AND NetworkProperty IS NULL 

	DECLARE @DataMapID INT

	WHILE EXISTS (SELECT * FROM #DataMapID)
	BEGIN
		SELECT @DataMapID = (SELECT TOP 1 DataMapID FROM #DataMapID ORDER BY DataMapID)

		EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = @DataMapID, @TurnOffIndexing = 0

		DELETE FROM #DataMapID WHERE DataMapID = @DataMapID
	END
END
GO
