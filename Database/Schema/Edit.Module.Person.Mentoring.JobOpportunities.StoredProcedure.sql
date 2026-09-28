SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[Person.Mentoring.JobOpportunities]
	@Subject bigint=NULL
	,@PropertyURI [varchar](100)
	,@Json nvarchar(max)
	,@status varchar(50) OUTPUT
AS
BEGIN
	declare @personID int
	select @personID = personID from [Profile.Cache].Person where NodeID = @Subject

	declare @opportunities table (	
		SortOrder int not null,
		OpportunityID uniqueIdentifier not null,
		Title nvarchar(max),
		Description nvarchar(max),
		URL varchar(max),
		Students bit,
		Faculty bit,
		Fellows bit,
		Staff bit
		)

	;with a as (select j.[key] SortOrder, k.[Key] k, k.[Value] v  from openjson(@json) j cross apply openjson([value]) k)
	insert into @opportunities Select a1.SortOrder, a1.v OpportunityID, a2.v Title, a3.v as Description, a4.v as URL, case when a5.v = 'true' then 1 else 0 end as Students, case when a6.v = 'true' then 1 else 0 end as Faculty, case when a7.v = 'true' then 1 else 0 end as Fellows, case when a8.v = 'true' then 1 else 0 end as Staff 
		from a a1 
			join a a2 on a1.SortOrder = a2.SortOrder and a1.k = 'opportunityId' and a2.k = 'title'
			left join a a3 on a1.SortOrder = a3.SortOrder and a3.k = 'jobDescription'
			left join a a4 on a1.SortOrder = a4.SortOrder and a4.k = 'jobURL'
			left join a a5 on a1.SortOrder = a5.SortOrder and a5.k = 'categoryStudents'
			left join a a6 on a1.SortOrder = a6.SortOrder and a6.k = 'categoryFaculty'
			left join a a7 on a1.SortOrder = a7.SortOrder and a7.k = 'categoryFellowsAndPostDocs'
			left join a a8 on a1.SortOrder = a8.SortOrder and a8.k = 'categoryResearchStaff'

	BEGIN TRANSACTION
		delete from [Profile.Data].[Person.Mentoring.JobOpportunities] where personID = @PersonID
		insert into [Profile.Data].[Person.Mentoring.JobOpportunities] (PersonID, SortOrder, OpportunityID,	Title, Description, URL, Students, Faculty, Fellows, Staff) select @PersonID, * from @opportunities
	COMMIT TRANSACTION

	
	-- *******************************************************************
	-- *******************************************************************
	-- Update RDF
	-- *******************************************************************
	-- *******************************************************************

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
			SELECT *, '''SELECT CAST(OpportunityID AS VARCHAR(50)) FROM [Profile.Data].[Person.Mentoring.JobOpportunities] WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://profiles.catalyst.harvard.edu/ontology/prns#MentoringJobOpportunity'
					AND NetworkProperty IS NULL
					AND Property IS NULL
			UNION ALL
			SELECT *, '''' + CAST(@PersonID AS VARCHAR(50)) + '''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://xmlns.com/foaf/0.1/Person' 
					AND property = 'http://profiles.catalyst.harvard.edu/ontology/prns#hasMentoringJobOpportunity'
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

	select @status = '{"status":"SUCCESS"}'
END
GO
