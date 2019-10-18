drop procedure [Profile.Module].[ProfilesDataAPI.GetPersonData] 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Module].[ProfilesDataAPI.GetPersonData] 
	@Param1name varchar(max) = null,
	@Param1value varchar(max) = null,
	@Param2name varchar(max) = null,
	@Param2value varchar(max) = null,
	@Param3name varchar(max) = null,
	@Param3value varchar(max) = null,
	@Param4name varchar(max) = null,
	@Param4value varchar(max) = null,
	@Param5name varchar(max) = null,
	@Param5value varchar(max) = null,
	@Param6name varchar(max) = null,
	@Param6value varchar(max) = null,
	@Param7name varchar(max) = null,
	@Param7value varchar(max) = null,
	@Param8name varchar(max) = null,
	@Param8value varchar(max) = null,
	@Param9name varchar(max) = null,
	@Param9value varchar(max) = null,
	@Param10name varchar(max) = null,
	@Param10value varchar(max) = null,
	@PersonList varchar(max) = null,
	@Institution varchar(max) = null,
	@InstitutionAbbr varchar(max) = null,
	@Department varchar(max) = null,
	@Division varchar(max) = null,
	@FacultyRank varchar(max) = null,
	@SearchString varchar(max) = null,
	@offset int = 0,
	@count int = 100,
	@IncludeSecondary int = 0,
	@columns varchar(max) = null
AS
BEGIN
SET nocount  ON;

	declare @years varchar(max)
	
	create table #params(
		n varchar(max),
		v varchar(max)
	)

	insert into #params (n,v) values (@param1name, @Param1value)
	insert into #params (n,v) values (@param2name, @Param2value)
	insert into #params (n,v) values (@param3name, @Param3value)
	insert into #params (n,v) values (@param4name, @Param4value)
	insert into #params (n,v) values (@param5name, @Param5value)
	insert into #params (n,v) values (@param6name, @Param6value)
	insert into #params (n,v) values (@param7name, @Param7value)
	insert into #params (n,v) values (@param8name, @Param8value)
	insert into #params (n,v) values (@param9name, @Param9value)
	insert into #params (n,v) values (@param10name, @Param10value)
--        [Route("getPeople/Keyword/{keyword}/Institution/{inst}/Department/{dept}/Division/{div}/Count/{count:int}/Offset/{offset:int}/Columns/{cols}")]

	select @personList = isnull(v, @personList) from #params where n = 'PersonIDs'
	select @Institution = isnull(v, @Institution) from #params where n = 'Institution'
	select @InstitutionAbbr = isnull(v, @InstitutionAbbr) from #params where n = 'InstitutionAbbr'
	select @Department = isnull(v, @Department) from #params where n = 'Department'
	select @Division = isnull(v, @Division) from #params where n = 'Division'
	select @FacultyRank = isnull(v, @FacultyRank) from #params where n = 'FacultyRank'
	select @SearchString = isnull(v, @SearchString) from #params where n = 'Keyword'
	select @Offset = isnull(v, cast(@Offset as int)) from #params where n = 'Offset'
	select @count = isnull(v, cast(@count as int)) from #params where n = 'Count'
	select @IncludeSecondary = isnull(v, @IncludeSecondary) from #params where n = 'IncludeSecondary'
	select @columns = isnull(v, @columns) from #params where n = 'Columns'
	select @years = v from #params where n = 'Years'

	declare @overview varchar(max)
	select @overview = nodeID from [RDF.].Node where valuehash = [RDF.].fnValueHash(null, null, 'http://vivoweb.org/ontology/core#overview')

	declare @basePath varchar(max)
	select @basePath = Value from [Framework.].Parameter where ParameterID = 'basePath'

	declare @institutionID int, @DepartmentID int, @DivisionID int, @FacultyRankID int
	select @institutionID = InstitutionID from [Profile.Data].[Organization.Institution] where InstitutionName = @Institution OR InstitutionAbbreviation = @InstitutionAbbr OR InstitutionAbbreviation = @Institution
	select @DepartmentID = DepartmentID from [Profile.Data].[Organization.Department] where DepartmentName = @Department
	select @DivisionID = DivisionID from [Profile.Data].[Organization.Division] where DivisionName = @Division
	select @FacultyRankID = FacultyRankID from [Profile.Data].[Person.FacultyRank] where FacultyRank = @FacultyRank

	declare @includeAddress bit = 0, @includeAffiliation bit = 0, @includeOverview bit = 0, @includePublications bit = 0, @includeConcepts bit = 0
	if not exists (select 1 from #params)
	BEGIN
		set @includeAddress = 1
		set @includeAffiliation = 1
		set @includeOverview = 1
		set @includePublications = 1
	END
	if @columns is not null
	BEGIN
		if @columns like '%address%' set @includeAddress = 1
		if @columns like '%affiliation%' set @includeAffiliation = 1
		if @columns like '%overview%' set @includeOverview = 1
		if @columns like '%publications%' set @includePublications = 1
		if @columns like '%concepts%' set @includeConcepts = 1
	END
	CREATE TABLE #tmpPerson (
		PersonID int PRIMARY KEY,
		NodeID bigint,
		Name xml,
		LastName varchar(max),
		FirstName varchar(max),
		ShowPublications varchar(1),
		ShowNarrative varchar(1),
		Overview nvarchar(max),
		Address xml,
		Affiliation xml,
		PhotoURL nvarchar(max),
		ConnectionWeight float
	)
	
	CREATE TABLE #years (
		y int
	)
	if @years is not null
	begin
		if @years like '%-%'
		begin
			INSERT INTO #years (y) 
			select n from [Utility.Math].n where n >= cast(substring(@years, 1, 4) as int) and n <= cast(substring(@years, 6, 4) as int)
		end
		else
		begin
			INSERT INTO #years (y) 
			select z.value('.','int') y
				from (select cast('<x>'+replace(@years,',','</x><x>')+'</x>' as xml ) x) t cross apply x.nodes('x') as r(z)
		end
	end


	IF @PersonList is not null
	BEGIN
		INSERT INTO #tmpPerson (PersonID) 
		select z.value('.','int') PersonID
		 from (select cast('<x>'+replace(@PersonList,',','</x><x>')+'</x>' as xml ) x) t cross apply x.nodes('x') as r(z)
	END
	ELSE IF @SearchString is not null
	BEGIN
		declare @t table (SortOrder int, NodeID bigint, Paths int, Weight float)
		declare @searchFilters varchar(max)
		set @searchFilters = ''
		if @institutionID is not null
		BEGIN
			select @searchFilters = '<SearchFilter IsExclude="0" Property="http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition" Property2="http://vivoweb.org/ontology/core#positionInOrganization" MatchType="Exact">'
			+ @basePath + '/profile/' + cast(NodeID as varchar(max)) + '</SearchFilter>' from [RDF.Stage].InternalNodeMap where InternalID = cast(@institutionID as varchar(max)) AND InternalType = 'Institution'
		END
		if @DepartmentID is not null
		BEGIN
			select @searchFilters = @searchFilters + '<SearchFilter IsExclude="0" Property="http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition" Property2="http://profiles.catalyst.harvard.edu/ontology/prns#positionInDepartment" MatchType="Exact">'
			+ @basePath + '/profile/' + cast(NodeID as varchar(max)) + '</SearchFilter>' from [RDF.Stage].InternalNodeMap where InternalID = cast(@DepartmentID as varchar(max)) AND InternalType = 'Department'
		END
		if @DivisionID is not null
		BEGIN
			select @searchFilters = @searchFilters + '<SearchFilter IsExclude="0" Property="http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition" Property2="http://profiles.catalyst.harvard.edu/ontology/prns#positionInDivision" MatchType="Exact">'
			+ @basePath + '/profile/' + cast(NodeID as varchar(max)) + '</SearchFilter>' from [RDF.Stage].InternalNodeMap where InternalID = cast(@DivisionID as varchar(max)) AND InternalType = 'Division'
		END
		if @searchFilters <> ''
		BEGIN
			select @searchFilters = '<SearchFiltersList>' + @searchFilters + '</SearchFiltersList>'
		END
		declare @SearchOpts varchar(max)
		set @SearchOpts =
			'<SearchOptions>
				<MatchOptions>
					<SearchString ExactMatch="false">' + @SearchString + '</SearchString>'
					+ @searchFilters +
					'<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
				</MatchOptions>
				<OutputOptions/>
			</SearchOptions>'

		insert into @t (SortOrder, NodeID, Paths, Weight) EXEC [Search.].[GetNodes] @SearchOptions =@SearchOpts, @NoRDF=1

		INSERT INTO #tmpPerson (PersonID, ConnectionWeight)
		select InternalID, Weight from @t t
			join [RDF.Stage].InternalNodeMap i 
			on t.NodeID = i.NodeID AND Class = 'http://xmlns.com/foaf/0.1/Person' AND InternalType = 'Person'
			order by SortOrder offset @offset ROWS FETCH NEXT @count ROWS ONLY
	END
	ELSE
	BEGIN
		INSERT INTO #tmpPerson (PersonID, LastName, FirstName)
		SELECT DISTINCT p.PersonID, LastName, FirstName from [Profile.Cache].Person p
		JOIN [Profile.Data].[Person.Affiliation] a
			on p.PersonID = a.PersonID AND p.IsActive = 1
			AND isnull(@institutionID, InstitutionID) = InstitutionID
			AND isnull(@DepartmentID, DepartmentID) = DepartmentID
			AND isnull(@DivisionID, DivisionID) = DivisionID
			AND isnull(@FacultyRankID, FacultyRankID) = FacultyRankID
			AND IsPrimary >= 1 - @IncludeSecondary
			order by LastName, FirstName, p.PersonID offset @offset ROWS FETCH NEXT @count ROWS ONLY
	END


	UPDATE p SET p.NodeID = i.NodeID
		FROM #tmpPerson p join [RDF.Stage].InternalNodeMap i
		on p.PersonID = i.InternalID and i.Class = 'http://xmlns.com/foaf/0.1/Person'

	CREATE INDEX iNodeID ON #tmpPerson(NodeID)

	UPDATE p SET ShowNarrative = c.ShowNarrative, ShowPublications = c.ShowPublications,
			Name = CASE WHEN ShowAddress = 'Y' THEN REPLACE(REPLACE(CAST(PersonXML.query('//Name[1]') as varchar(max)), '<Name>', ''), '</Name>', '') ELSE NULL END,
			Address = CASE WHEN ShowAddress = 'Y' THEN REPLACE(REPLACE(CAST(PersonXML.query('//Address[1]') as varchar(max)), '<Address>', ''), '</Address>', '') ELSE NULL END,
			Affiliation = REPLACE(REPLACE(CAST(PersonXML.query('//AffiliationList[1]') as varchar(max)), '<AffiliationList Visible="true">', ''), '</AffiliationList>', ''),
			PhotoURL =  CASE WHEN ShowPhoto = 'Y' THEN  @basePath + '/profile/Modules/CustomViewPersonGeneralInfo/PhotoHandler.ashx?NodeID=' + CAST(NodeID as VARCHAR(max)) ELSE NULL END
		FROM #tmpPerson p join [Profile.Cache].Person c
		on p.PersonID = c.PersonID
		
	UPDATE p SET Overview = CASE WHEN ShowNarrative = 'Y' then nob.Value ELSE null END from 
		#tmpPerson p join [RDF.].Triple t  on p.NodeID = t.Subject and t.predicate = @overview
		join [RDF.].Node nob
		on t.Object = nob.NodeID

	create table #pubmedGeneral(
		PMID int not null,
		MPID nvarchar(50) not null,
		EntityID int,
		Authors varchar(4000),
		Title varchar(4000),
		Journal varchar(1000),
		PubDate varchar(255),
		IssueInfo varchar(1000)
		Primary key (pmid, mpid)
	)
	if @includePublications = 1
	BEGIN
		insert into #pubmedGeneral (PMID, MPID)
		select distinct pmid, '' from #tmpPerson p join [Profile.Data].[Publication.Person.Include] i on p.PersonID = i.PersonID AND i.PMID is not null AND p.ShowPublications = 'Y'

		update p set 
			Authors = case when right(g.Authors,5) = 'et al' then g.Authors+'. '
											when AuthorListCompleteYN = 'N' then g.Authors+', et al. '
											when g.Authors <> '' then g.Authors+'. '
											else '' end,
											Title = coalesce(ArticleTitle,''),
											Journal = coalesce(MedlineTA,''),
											PubDate = case when JournalYear is not null then rtrim(JournalYear + ' ' + coalesce(JournalMonth,'') + ' ' + coalesce(JournalDay,''))
										when MedlineDate is not null then MedlineDate
										when ArticleYear is not null then rtrim(ArticleYear + ' ' + coalesce(ArticleMonth,'') + ' ' + coalesce(ArticleDay,''))
									else '' end,
									IssueInfo = coalesce(Volume,'')
								+ (case when coalesce(Issue,'') <> '' then '('+Issue+')' else '' end)
								+ (case when (coalesce(MedlinePgn,'') <> '') and (coalesce(Volume,'')+coalesce(Issue,'') <> '') then ':' else '' end)
								+ coalesce(MedlinePgn,'')
								from #pubmedGeneral p
								join [Profile.Data].[Publication.PubMed.General] g on p.pmid = g.PMID
	
		insert into #pubmedGeneral (PMID, MPID, Authors, Title, Journal, PubDate, IssueInfo)
		     SELECT  0, MPID ,
					authors as Authors,
					left((case when IsNull(article,'')<>'' then article when IsNull(pub,'')<>'' then pub else 'Untitled Publication' end),4000) as Title,
					pub as Journal,
					y as PubDate,
					vip as IssueInfo
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
                                  FROM      [Profile.Data].[Publication.MyPub.General] MPG
                                  INNER JOIN [Profile.Data].[Publication.Person.Include] PL ON MPG.mpid = PL.mpid
                                                           AND PL.mpid NOT LIKE 'DASH%'
                                                           AND PL.mpid NOT LIKE 'ISI%'
                                                           AND PL.pmid IS NULL
                                                           AND PL.PersonID in (select PersonID from #tmpPerson WHERE ShowPublications = 'Y')
                                ) T0
                    ) T0

		if @years is not null
		begin
			delete from #pubmedGeneral where not exists (select 1 from #years where y = substring(pubdate, 1, 4))
		end

		update g set g.EntityID = i.EntityID
			from #pubmedGeneral g
			join [Profile.Data].[Publication.Entity.InformationResource] i
			on (i.PMID = g.PMID and g.MPID = '')

		update g set g.EntityID = i.EntityID
			from #pubmedGeneral g
			join [Profile.Data].[Publication.Entity.InformationResource] i
			on (g.pmid = 0 and i.MPID = g.MPID)

		create index idx_tmp_pubmedgeneral on #pubmedGeneral (EntityID)
	END
	select (
		select (
			select p.PersonID "@PersonID", p.ConnectionWeight "ConnectionWeight", p.Name "Name", 
			Case when @includeAddress = 1 then p.Address else null end "Address", 
			Case when @includeAffiliation = 1 then p.Affiliation else null end "AffiliationList", 
			Case when @includeOverview = 1 then p.Overview else null end "Overview", 
			p.PhotoUrl "PhotoUrl", (
				 select i.Source "Publication/@Source", i.pmid "Publication/@PMID", i.pmcid "Publication/@PMCID", CASE WHEN i.URL <> '' THEN i.URL ELSE null END "Publication/URL", i.Reference "Publication/PublicationReference"--, @basePath + '/profile/' + cast(inm.NodeID as varchar(max)) "PublicationID"
				 , g.Title "Publication/Title", g.Authors as "Publication/Authors", g.Journal as "Publication/Journal",
				 g.PubDate as "Publication/Date", g.IssueInfo as "Publication/IssueInfo"
				 from [Profile.Data].[Publication.Entity.Authorship] a
					 inner join [Profile.Data].[Publication.Entity.InformationResource] i
					 on a.InformationResourceID=i.EntityID
					 and a.PersonID=p.PersonID
					 join #pubmedGeneral g
					 on g.EntityID = i.EntityID
					 where i.IsActive = 1 and p.ShowPublications = 'Y'
					 order by i.EntityDate desc
					 for xml path(''), type
				) "PublicationList", 
				(select [MeshHeader]  "Concept/MeshHeader", NumPubsThis "Concept/NumPubs", Weight "Concept/Weight", FirstPubDate "Concept/FirstPubDate", LastPubDate "Concept/LastPubDate"
				from [Profile.Cache].[Concept.Mesh.Person]cmp
				where cmp.PersonID=p.PersonID and @includeConcepts = 1 order by Weight desc for xml path(''), type ) "ConceptList"
			from #tmpPerson p
			order by p.ConnectionWeight desc, p.Lastname, p.Firstname, p.PersonID
			for xml path('Person'), type
		) PersonList
		for xml path(''), type
	) x
END 











SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Search.Cache].[Public.GetNodes]
	@SearchOptions XML,
	@SessionID UNIQUEIDENTIFIER = NULL,
	@NoRDF BIT =0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

	/*
	
	EXEC [Search.].[GetNodes] @SearchOptions = '
	<SearchOptions>
		<MatchOptions>
			<SearchString ExactMatch="false">options for "lung cancer" treatment</SearchString>
			<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
			<SearchFiltersList>
				<SearchFilter Property="http://xmlns.com/foaf/0.1/lastName" MatchType="Left">Smit</SearchFilter>
			</SearchFiltersList>
		</MatchOptions>
		<OutputOptions>
			<Offset>0</Offset>
			<Limit>5</Limit>
			<SortByList>
				<SortBy IsDesc="1" Property="http://xmlns.com/foaf/0.1/firstName" />
				<SortBy IsDesc="0" Property="http://xmlns.com/foaf/0.1/lastName" />
			</SortByList>
		</OutputOptions>	
	</SearchOptions>
	'
		
	*/

	declare @MatchOptions xml
	declare @OutputOptions xml
	declare @SearchString varchar(500)
	declare @ClassGroupURI varchar(400)
	declare @ClassURI varchar(400)
	declare @SearchFiltersXML xml
	declare @offset bigint
	declare @limit bigint
	declare @SortByXML xml
	declare @DoExpandedSearch bit
	
	select	@MatchOptions = @SearchOptions.query('SearchOptions[1]/MatchOptions[1]'),
			@OutputOptions = @SearchOptions.query('SearchOptions[1]/OutputOptions[1]')
	
	select	@SearchString = @MatchOptions.value('MatchOptions[1]/SearchString[1]','varchar(500)'),
			@DoExpandedSearch = (case when @MatchOptions.value('MatchOptions[1]/SearchString[1]/@ExactMatch','varchar(50)') = 'true' then 0 else 1 end),
			@ClassGroupURI = @MatchOptions.value('MatchOptions[1]/ClassGroupURI[1]','varchar(400)'),
			@ClassURI = @MatchOptions.value('MatchOptions[1]/ClassURI[1]','varchar(400)'),
			@SearchFiltersXML = @MatchOptions.query('MatchOptions[1]/SearchFiltersList[1]'),
			@offset = @OutputOptions.value('OutputOptions[1]/Offset[1]','bigint'),
			@limit = @OutputOptions.value('OutputOptions[1]/Limit[1]','bigint'),
			@SortByXML = @OutputOptions.query('OutputOptions[1]/SortByList[1]')

	declare @baseURI nvarchar(400)
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'

	declare @d datetime
	declare @dd datetime
	select @d = GetDate()
	
	declare @IsBot bit
	if @SessionID is not null
		select @IsBot = IsBot
			from [User.Session].[Session]
			where SessionID = @SessionID
	select @IsBot = IsNull(@IsBot,0)

	select @limit = 100
		where (@limit is null) or (@limit > 100)
	
	declare @SearchHistoryQueryID int
	insert into [Search.].[History.Query] (StartDate, SessionID, IsBot, SearchOptions)
		select GetDate(), @SessionID, @IsBot, @SearchOptions
	select @SearchHistoryQueryID = @@IDENTITY

	-------------------------------------------------------
	-- Parse search string and convert to fulltext query
	-------------------------------------------------------
select @d = GetDate()
/*
	declare @NumberOfPhrases INT
	declare @CombinedSearchString VARCHAR(8000)
	declare @SearchPhraseXML XML
	declare @SearchPhraseFormsXML XML
	declare @ParseProcessTime INT

	EXEC [Search.].[ParseSearchString]	@SearchString = @SearchString,
										@NumberOfPhrases = @NumberOfPhrases OUTPUT,
										@CombinedSearchString = @CombinedSearchString OUTPUT,
										@SearchPhraseXML = @SearchPhraseXML OUTPUT,
										@SearchPhraseFormsXML = @SearchPhraseFormsXML OUTPUT,
										@ProcessTime = @ParseProcessTime OUTPUT

*/

	declare @NumberOfPhrases INT
	declare @CombinedSearchString VARCHAR(8000)
	declare @SearchString1 VARCHAR(8000)
	declare @SearchString2 VARCHAR(8000)
	declare @SearchString3 VARCHAR(8000)
	declare @SearchPhraseXML XML
	declare @SearchPhraseFormsXML XML
	declare @ParseProcessTime INT

	EXEC [Search.].[ParseSearchString]	@SearchString = @SearchString,
										@NumberOfPhrases = @NumberOfPhrases OUTPUT,
										@CombinedSearchString = @CombinedSearchString OUTPUT,
										@SearchString1 = @SearchString1 OUTPUT,
										@SearchString2 = @SearchString2 OUTPUT,
										@SearchString3 = @SearchString3 OUTPUT,
										@SearchPhraseXML = @SearchPhraseXML OUTPUT,
										@SearchPhraseFormsXML = @SearchPhraseFormsXML OUTPUT,
										@ProcessTime = @ParseProcessTime OUTPUT

	declare @PhraseList table (PhraseID int, Phrase varchar(max), ThesaurusMatch bit, Forms varchar(max))
	insert into @PhraseList (PhraseID, Phrase, ThesaurusMatch, Forms)
	select	x.value('@ID','INT'),
			x.value('.','VARCHAR(MAX)'),
			x.value('@ThesaurusMatch','BIT'),
			x.value('@Forms','VARCHAR(MAX)')
		from @SearchPhraseFormsXML.nodes('//SearchPhrase') as p(x)

	--SELECT @NumberOfPhrases, @CombinedSearchString, @SearchPhraseXML, @SearchPhraseFormsXML, @ParseProcessTime
	--SELECT * FROM @PhraseList
	--select datediff(ms,@d,GetDate())
--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'parse search string', datediff(ms,@d,GetDate()), @CombinedSearchString
select @d = GetDate()

	-------------------------------------------------------
	-- Parse search filters
	-------------------------------------------------------

	create table #SearchFilters (
		SearchFilterID int identity(0,1) primary key,
		IsExclude bit,
		PropertyURI varchar(400),
		PropertyURI2 varchar(400),
		MatchType varchar(100),
		Value varchar(750),
		Predicate bigint,
		Predicate2 bigint
	)
	
	insert into #SearchFilters (IsExclude, PropertyURI, PropertyURI2, MatchType, Value, Predicate, Predicate2)	
		select t.IsExclude, t.PropertyURI, t.PropertyURI2, t.MatchType, t.Value,
				--left(t.Value,750)+(case when t.MatchType='Left' then '%' else '' end),
				t.Predicate, t.Predicate2
			from (
				select IsNull(IsExclude,0) IsExclude, PropertyURI, PropertyURI2, MatchType, Value,
					[RDF.].fnURI2NodeID(PropertyURI) Predicate,
					[RDF.].fnURI2NodeID(PropertyURI2) Predicate2
				from (
					select distinct S.x.value('@IsExclude','bit') IsExclude,
							S.x.value('@Property','varchar(400)') PropertyURI,
							S.x.value('@Property2','varchar(400)') PropertyURI2,
							S.x.value('@MatchType','varchar(100)') MatchType,
							--S.x.value('.','nvarchar(max)') Value
							(case when cast(S.x.query('./*') as nvarchar(max)) <> '' then cast(S.x.query('./*') as nvarchar(max)) else S.x.value('.','nvarchar(max)') end) Value
					from @SearchFiltersXML.nodes('//SearchFilter') as S(x)
				) t
			) t
			where t.Value IS NOT NULL and t.Value <> ''
			
	declare @NumberOfIncludeFilters int
	select @NumberOfIncludeFilters = IsNull((select count(*) from #SearchFilters where IsExclude=0),0)

--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'parse search filters', datediff(ms,@d,GetDate()), cast(@NumberOfIncludeFilters as varchar(max))
select @d = GetDate()

	-------------------------------------------------------
	-- Parse sort by options
	-------------------------------------------------------

	create table #SortBy (
		SortByID int identity(1,1) primary key,
		IsDesc bit,
		PropertyURI varchar(400),
		PropertyURI2 varchar(400),
		PropertyURI3 varchar(400),
		Predicate bigint,
		Predicate2 bigint,
		Predicate3 bigint
	)
	
	insert into #SortBy (IsDesc, PropertyURI, PropertyURI2, PropertyURI3, Predicate, Predicate2, Predicate3)	
		select IsNull(IsDesc,0), PropertyURI, PropertyURI2, PropertyURI3,
				[RDF.].fnURI2NodeID(PropertyURI) Predicate,
				[RDF.].fnURI2NodeID(PropertyURI2) Predicate2,
				[RDF.].fnURI2NodeID(PropertyURI3) Predicate3
			from (
				select S.x.value('@IsDesc','bit') IsDesc,
						S.x.value('@Property','varchar(400)') PropertyURI,
						S.x.value('@Property2','varchar(400)') PropertyURI2,
						S.x.value('@Property3','varchar(400)') PropertyURI3
				from @SortByXML.nodes('//SortBy') as S(x)
			) t

--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'parse sort by options', datediff(ms,@d,GetDate()), null
select @d = GetDate()
	-------------------------------------------------------
	-- Get initial list of matching nodes (before filters)
	-------------------------------------------------------

	create table #FullNodeMatch (
		NodeID bigint not null,
		Paths bigint,
		Weight float
	)

	if @CombinedSearchString <> ''
	begin

select @dd=GetDate()

		-- Get nodes that match separate phrases
		create table #PhraseNodeMatch (
			PhraseID int not null,
			NodeID bigint not null,
			Paths bigint,
			Weight float
		)
		if (@NumberOfPhrases > 1) and (@DoExpandedSearch = 1)
		begin
			declare @PhraseSearchString varchar(8000)
			declare @loop int
			select @loop = 1
			while @loop <= @NumberOfPhrases
			begin
				select @PhraseSearchString = Forms
					from @PhraseList
					where PhraseID = @loop
				select * into #NodeRankTemp from containstable ([RDF.].[vwLiteral], value, @PhraseSearchString, 100000)
				alter table #NodeRankTemp add primary key ([Key])
				insert into #PhraseNodeMatch (PhraseID, NodeID, Paths, Weight)
					select @loop, s.NodeID, count(*) Paths, 1-exp(sum(log(case when s.Weight*(m.[Rank]*0.000999+0.001) > 0.999999 then 0.000001 else 1-s.Weight*(m.[Rank]*0.000999+0.001) end))) Weight
						from #NodeRankTemp m
							inner loop join [Search.Cache].[Public.NodeMap] s
								on s.MatchedByNodeID = m.[Key]
						group by s.NodeID
				drop table #NodeRankTemp
				select @loop = @loop + 1
			end
			--create clustered index idx_n on #PhraseNodeMatch(NodeID)
		end

--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'initial list (PhraseMatch)', datediff(ms,@dd,GetDate()), cast(@NumberOfPhrases as varchar(50))
select @dd = GetDate()

		-- Get nodes that match the combined search string
		create table #TempMatchNodes (
			NodeID bigint,
			MatchedByNodeID bigint,
			Distance int,
			Paths int,
			Weight float,
			mWeight float
		)
		-- Run each search string
		if @SearchString1 <> ''
				select * into #CombinedSearch1 from containstable ([RDF.].[vwLiteral], value, @SearchString1, 100000) t
		if @SearchString2 <> ''
				select * into #CombinedSearch2 from containstable ([RDF.].[vwLiteral], value, @SearchString2, 100000) t
		if @SearchString3 <> ''
				select * into #CombinedSearch3 from containstable ([RDF.].[vwLiteral], value, @SearchString3, 100000) t
		-- Combine each search string
		create table #CombinedSearch ([key] bigint primary key, [rank] int)
		if IsNull(@SearchString1,'') <> '' and IsNull(@SearchString2,'') = '' and IsNull(@SearchString3,'') = ''
			insert into #CombinedSearch select [key], max([rank]) [rank] from #CombinedSearch1 t group by [key]
		if IsNull(@SearchString1,'') <> '' and IsNull(@SearchString2,'') <> '' and IsNull(@SearchString3,'') = ''
			insert into #CombinedSearch select [key], max([rank]) [rank] from (select * from #CombinedSearch1 union all select * from #CombinedSearch2) t group by [key]
		if IsNull(@SearchString1,'') <> '' and IsNull(@SearchString2,'') <> '' and IsNull(@SearchString3,'') <> ''
			insert into #CombinedSearch select [key], max([rank]) [rank] from (select * from #CombinedSearch1 union all select * from #CombinedSearch2 union all select * from #CombinedSearch3) t group by [key]
		-- Get the TempMatchNodes
		insert into #TempMatchNodes (NodeID, MatchedByNodeID, Distance, Paths, Weight, mWeight)
			select s.*, m.[Rank]*0.000999+0.001 mWeight
				from #CombinedSearch m
					inner loop join [Search.Cache].[Public.NodeMap] s
						on s.MatchedByNodeID = m.[key]
--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'initial list (TempMatch Contains)', datediff(ms,@dd,GetDate()), cast(@@ROWCOUNT as varchar(50)) + ': ' + @CombinedSearchString
		-- Delete temp tables
		if @SearchString1 <> ''
				drop table #CombinedSearch1
		if @SearchString2 <> ''
				drop table #CombinedSearch2
		if @SearchString3 <> ''
				drop table #CombinedSearch3
		drop table #CombinedSearch


--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'initial list (TempMatch)', datediff(ms,@dd,GetDate()), @CombinedSearchString
select @dd = GetDate()

		-- Get nodes that match either all phrases or the combined search string
		insert into #FullNodeMatch (NodeID, Paths, Weight)
			select IsNull(a.NodeID,b.NodeID) NodeID, IsNull(a.Paths,b.Paths) Paths,
					(case when a.weight is null or b.weight is null then IsNull(a.Weight,b.Weight) else 1-(1-a.Weight)*(1-b.Weight) end) Weight
				from (
					select NodeID, exp(sum(log(Paths))) Paths, exp(sum(log(Weight))) Weight
						from #PhraseNodeMatch
						group by NodeID
						having count(*) = @NumberOfPhrases
				) a full outer join (
					select NodeID, count(*) Paths, 1-exp(sum(log(case when Weight*mWeight > 0.999999 then 0.000001 else 1-Weight*mWeight end))) Weight
						from #TempMatchNodes
						group by NodeID
				) b on a.NodeID = b.NodeID
		--select 'Text Matches Found', datediff(ms,@d,getdate())

--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'initial list (FullMatch)', datediff(ms,@dd,GetDate()), cast(@@ROWCOUNT as varchar(50))
select @dd = GetDate()

	end
	else if (@NumberOfIncludeFilters > 0)
	begin
		insert into #FullNodeMatch (NodeID, Paths, Weight)
			select t1.Subject, 1, 1
				from #SearchFilters f
					inner join [RDF.].Triple t1
						on f.Predicate is not null
							and t1.Predicate = f.Predicate 
							and t1.ViewSecurityGroup = -1
					left outer join [Search.Cache].[Public.NodePrefix] n1
						on n1.NodeID = t1.Object
					left outer join [RDF.].Triple t2
						on f.Predicate2 is not null
							and t2.Subject = n1.NodeID
							and t2.Predicate = f.Predicate2
							and t2.ViewSecurityGroup = -1
					left outer join [Search.Cache].[Public.NodePrefix] n2
						on n2.NodeID = t2.Object
				where f.IsExclude = 0
					and 1 = (case	when (f.Predicate2 is not null) then
										(case	when f.MatchType = 'Left' then
													(case when n2.Prefix like f.Value+'%' then 1 else 0 end)
												when f.MatchType = 'In' then
													(case when n2.Prefix in (select r.x.value('.','varchar(max)') v from (select cast(f.Value as xml) x) t cross apply x.nodes('//Item') as r(x)) then 1 else 0 end)
												else
													(case when n2.Prefix = f.Value then 1 else 0 end)
												end)
									else
										(case	when f.MatchType = 'Left' then
													(case when n1.Prefix like f.Value+'%' then 1 else 0 end)
												when f.MatchType = 'In' then
													(case when n1.Prefix in (select r.x.value('.','varchar(max)') v from (select cast(f.Value as xml) x) t cross apply x.nodes('//Item') as r(x)) then 1 else 0 end)
												else
													(case when n1.Prefix = f.Value then 1 else 0 end)
												end)
									end)
					--and (case when f.Predicate2 is not null then n2.Prefix else n1.Prefix end)
					--	like f.Value
				group by t1.Subject
				having count(distinct f.SearchFilterID) = @NumberOfIncludeFilters
		delete from #SearchFilters where IsExclude = 0
		select @NumberOfIncludeFilters = 0
	end
	else if (IsNull(@ClassGroupURI,'') <> '' or IsNull(@ClassURI,'') <> '')
	begin
		insert into #FullNodeMatch (NodeID, Paths, Weight)
			select distinct n.NodeID, 1, 1
				from [Search.Cache].[Public.NodeClass] n, [Ontology.].ClassGroupClass c
				where n.Class = c._ClassNode
					and ((@ClassGroupURI is null) or (c.ClassGroupURI = @ClassGroupURI))
					and ((@ClassURI is null) or (c.ClassURI = @ClassURI))
		select @ClassGroupURI = null, @ClassURI = null
	end

--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'initial list of nodes', datediff(ms,@d,GetDate()), cast(@NumberOfIncludeFilters as varchar(max))
select @d = GetDate()

	-------------------------------------------------------
	-- Run the actual search
	-------------------------------------------------------
	create table #Node (
		SortOrder bigint identity(0,1) primary key,
		NodeID bigint,
		Paths bigint,
		Weight float
	)

	insert into #Node (NodeID, Paths, Weight)
		select s.NodeID, s.Paths, s.Weight
			from #FullNodeMatch s
				inner join [Search.Cache].[Public.NodeSummary] n on
					s.NodeID = n.NodeID
					and ( IsNull(@ClassGroupURI,@ClassURI) is null or s.NodeID in (
							select NodeID
								from [Search.Cache].[Public.NodeClass] x, [Ontology.].ClassGroupClass c
								where x.Class = c._ClassNode
									and c.ClassGroupURI = IsNull(@ClassGroupURI,c.ClassGroupURI)
									and c.ClassURI = IsNull(@ClassURI,c.ClassURI)
						) )
					and ( @NumberOfIncludeFilters =
							(select count(distinct f.SearchFilterID)
								from #SearchFilters f
									inner join [RDF.].Triple t1
										on f.Predicate is not null
											and t1.Subject = s.NodeID
											and t1.Predicate = f.Predicate 
											and t1.ViewSecurityGroup = -1
									left outer join [Search.Cache].[Public.NodePrefix] n1
										on n1.NodeID = t1.Object
									left outer join [RDF.].Triple t2
										on f.Predicate2 is not null
											and t2.Subject = n1.NodeID
											and t2.Predicate = f.Predicate2
											and t2.ViewSecurityGroup = -1
									left outer join [Search.Cache].[Public.NodePrefix] n2
										on n2.NodeID = t2.Object
								where f.IsExclude = 0
									and 1 = (case	when (f.Predicate2 is not null) then
														(case	when f.MatchType = 'Left' then
																	(case when n2.Prefix like f.Value+'%' then 1 else 0 end)
																when f.MatchType = 'In' then
																	(case when n2.Prefix in (select r.x.value('.','varchar(max)') v from (select cast(f.Value as xml) x) t cross apply x.nodes('//Item') as r(x)) then 1 else 0 end)
																else
																	(case when n2.Prefix = f.Value then 1 else 0 end)
																end)
													else
														(case	when f.MatchType = 'Left' then
																	(case when n1.Prefix like f.Value+'%' then 1 else 0 end)
																when f.MatchType = 'In' then
																	(case when n1.Prefix in (select r.x.value('.','varchar(max)') v from (select cast(f.Value as xml) x) t cross apply x.nodes('//Item') as r(x)) then 1 else 0 end)
																else
																	(case when n1.Prefix = f.Value then 1 else 0 end)
																end)
													end)
									--and (case when f.Predicate2 is not null then n2.Prefix else n1.Prefix end)
									--	like f.Value
							)
						)
					and not exists (
							select *
								from #SearchFilters f
									inner join [RDF.].Triple t1
										on f.Predicate is not null
											and t1.Subject = s.NodeID
											and t1.Predicate = f.Predicate 
											and t1.ViewSecurityGroup = -1
									left outer join [Search.Cache].[Public.NodePrefix] n1
										on n1.NodeID = t1.Object
									left outer join [RDF.].Triple t2
										on f.Predicate2 is not null
											and t2.Subject = n1.NodeID
											and t2.Predicate = f.Predicate2
											and t2.ViewSecurityGroup = -1
									left outer join [Search.Cache].[Public.NodePrefix] n2
										on n2.NodeID = t2.Object
								where f.IsExclude = 1
									and 1 = (case	when (f.Predicate2 is not null) then
														(case	when f.MatchType = 'Left' then
																	(case when n2.Prefix like f.Value+'%' then 1 else 0 end)
																when f.MatchType = 'In' then
																	(case when n2.Prefix in (select r.x.value('.','varchar(max)') v from (select cast(f.Value as xml) x) t cross apply x.nodes('//Item') as r(x)) then 1 else 0 end)
																else
																	(case when n2.Prefix = f.Value then 1 else 0 end)
																end)
													else
														(case	when f.MatchType = 'Left' then
																	(case when n1.Prefix like f.Value+'%' then 1 else 0 end)
																when f.MatchType = 'In' then
																	(case when n1.Prefix in (select r.x.value('.','varchar(max)') v from (select cast(f.Value as xml) x) t cross apply x.nodes('//Item') as r(x)) then 1 else 0 end)
																else
																	(case when n1.Prefix = f.Value then 1 else 0 end)
																end)
													end)
									--and (case when f.Predicate2 is not null then n2.Prefix else n1.Prefix end)
									--	like f.Value
						)
				outer apply (
					select	max(case when SortByID=1 then AscSortBy else null end) AscSortBy1,
							max(case when SortByID=2 then AscSortBy else null end) AscSortBy2,
							max(case when SortByID=3 then AscSortBy else null end) AscSortBy3,
							max(case when SortByID=1 then DescSortBy else null end) DescSortBy1,
							max(case when SortByID=2 then DescSortBy else null end) DescSortBy2,
							max(case when SortByID=3 then DescSortBy else null end) DescSortBy3
						from (
							select	SortByID,
									(case when f.IsDesc = 1 then null
											when f.Predicate3 is not null then n3.Value
											when f.Predicate2 is not null then n2.Value
											else n1.Value end) AscSortBy,
									(case when f.IsDesc = 0 then null
											when f.Predicate3 is not null then n3.Value
											when f.Predicate2 is not null then n2.Value
											else n1.Value end) DescSortBy
								from #SortBy f
									inner join [RDF.].Triple t1
										on f.Predicate is not null
											and t1.Subject = s.NodeID
											and t1.Predicate = f.Predicate 
											and t1.ViewSecurityGroup = -1
									left outer join [RDF.].Node n1
										on n1.NodeID = t1.Object
											and n1.ViewSecurityGroup = -1
									left outer join [RDF.].Triple t2
										on f.Predicate2 is not null
											and t2.Subject = n1.NodeID
											and t2.Predicate = f.Predicate2
											and t2.ViewSecurityGroup = -1
									left outer join [RDF.].Node n2
										on n2.NodeID = t2.Object
											and n2.ViewSecurityGroup = -1
									left outer join [RDF.].Triple t3
										on f.Predicate3 is not null
											and t3.Subject = n2.NodeID
											and t3.Predicate = f.Predicate3
											and t3.ViewSecurityGroup = -1
									left outer join [RDF.].Node n3
										on n3.NodeID = t3.Object
											and n3.ViewSecurityGroup = -1
							) t
					) o
			order by	(case when o.AscSortBy1 is null then 1 else 0 end),
						o.AscSortBy1,
						(case when o.DescSortBy1 is null then 1 else 0 end),
						o.DescSortBy1 desc,
						(case when o.AscSortBy2 is null then 1 else 0 end),
						o.AscSortBy2,
						(case when o.DescSortBy2 is null then 1 else 0 end),
						o.DescSortBy2 desc,
						(case when o.AscSortBy3 is null then 1 else 0 end),
						o.AscSortBy3,
						(case when o.DescSortBy3 is null then 1 else 0 end),
						o.DescSortBy3 desc,
						s.Weight desc,
						n.ShortLabel,
						n.NodeID

	if @NoRDF = 1
	BEGIN
		SELECT * FROM #Node
		return 
	END

	--select 'Search Nodes Found', datediff(ms,@d,GetDate())

	-------------------------------------------------------
	-- Get network counts
	-------------------------------------------------------

	declare @NumberOfConnections as bigint
	declare @MaxWeight as float
	declare @MinWeight as float

	select @NumberOfConnections = count(*), @MaxWeight = max(Weight), @MinWeight = min(Weight) 
		from #Node

--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'run search', datediff(ms,@d,GetDate()), cast(@NumberOfConnections as varchar(max))
select @d = GetDate()


	-------------------------------------------------------
	-- Get matching class groups and classes
	-------------------------------------------------------

	declare @MatchesClassGroups nvarchar(max)

/*
	select c.ClassGroupURI, c.ClassURI, n.NodeID
		into #NodeClass
		from #Node n, [Search.Cache].[Public.NodeClass] s, [Ontology.].ClassGroupClass c
		where n.NodeID = s.NodeID and s.Class = c._ClassNode
*/

	select n.NodeID, s.Class
		into #NodeClassTemp
		from #Node n
			inner join [Search.Cache].[Public.NodeClass] s
				on n.NodeID = s.NodeID
	select c.ClassGroupURI, c.ClassURI, n.NodeID
		into #NodeClass
		from #NodeClassTemp n
			inner join [Ontology.].ClassGroupClass c
				on n.Class = c._ClassNode

	;with a as (
		select ClassGroupURI, count(distinct NodeID) NumberOfNodes
			from #NodeClass s
			group by ClassGroupURI
	), b as (
		select ClassGroupURI, ClassURI, count(distinct NodeID) NumberOfNodes
			from #NodeClass s
			group by ClassGroupURI, ClassURI
	)
	select @MatchesClassGroups = replace(cast((
			select	g.ClassGroupURI "@rdf_.._resource", 
				g._ClassGroupLabel "rdfs_.._label",
				'http://www.w3.org/2001/XMLSchema#int' "prns_.._numberOfConnections/@rdf_.._datatype",
				a.NumberOfNodes "prns_.._numberOfConnections",
				g.SortOrder "prns_.._sortOrder",
				(
					select	c.ClassURI "@rdf_.._resource",
							c._ClassLabel "rdfs_.._label",
							'http://www.w3.org/2001/XMLSchema#int' "prns_.._numberOfConnections/@rdf_.._datatype",
							b.NumberOfNodes "prns_.._numberOfConnections",
							c.SortOrder "prns_.._sortOrder"
						from b, [Ontology.].ClassGroupClass c
						where b.ClassGroupURI = c.ClassGroupURI and b.ClassURI = c.ClassURI
							and c.ClassGroupURI = g.ClassGroupURI
						order by c.SortOrder
						for xml path('prns_.._matchesClass'), type
				)
			from a, [Ontology.].ClassGroup g
			where a.ClassGroupURI = g.ClassGroupURI and g.IsVisible = 1
			order by g.SortOrder
			for xml path('prns_.._matchesClassGroup'), type
		) as nvarchar(max)),'_.._',':')

--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'matching class groups', datediff(ms,@d,GetDate()), null
select @d = GetDate()

	-------------------------------------------------------
	-- Get RDF of search results objects
	-------------------------------------------------------

	declare @ObjectNodesRDF nvarchar(max)

	if @NumberOfConnections > 0
	begin
		/*
			-- Alternative methods that uses GetDataRDF to get the RDF
			declare @NodeListXML xml
			select @NodeListXML = (
					select (
							select NodeID "@ID"
							from #Node
							where SortOrder >= IsNull(@offset,0) and SortOrder < IsNull(IsNull(@offset,0)+@limit,SortOrder+1)
							order by SortOrder
							for xml path('Node'), type
							)
					for xml path('NodeList'), type
				)
			exec [RDF.].GetDataRDF @NodeListXML = @NodeListXML, @expand = 1, @showDetails = 0, @returnXML = 0, @dataStr = @ObjectNodesRDF OUTPUT
		*/
		create table #OutputNodes (
			NodeID bigint primary key,
			k int
		)
		insert into #OutputNodes (NodeID,k)
			SELECT DISTINCT  NodeID,0
			from #Node
			where SortOrder >= IsNull(@offset,0) and SortOrder < IsNull(IsNull(@offset,0)+@limit,SortOrder+1)
		declare @k int
		select @k = 0
		while @k < 10
		begin
			insert into #OutputNodes (NodeID,k)
				select distinct e.ExpandNodeID, @k+1
				from #OutputNodes o, [Search.Cache].[Public.NodeExpand] e
				where o.k = @k and o.NodeID = e.NodeID
					and e.ExpandNodeID not in (select NodeID from #OutputNodes)
			if @@ROWCOUNT = 0
				select @k = 10
			else
				select @k = @k + 1
		end
		select @ObjectNodesRDF = replace(replace(cast((
				select r.RDF + ''
				from #OutputNodes n, [Search.Cache].[Public.NodeRDF] r
				where n.NodeID = r.NodeID
				order by n.NodeID
				for xml path(''), type
			) as nvarchar(max)),'_TAGLT_','<'),'_TAGGT_','>')
	end

--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'get rdf of nodes', datediff(ms,@d,GetDate()), null
select @d = GetDate()

	-------------------------------------------------------
	-- Form search results RDF
	-------------------------------------------------------

	declare @results nvarchar(max)

	select @results = ''
			+'<rdf:Description rdf:nodeID="SearchResults">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Network" />'
			+'<rdfs:label>Search Results</rdfs:label>'
			+'<prns:numberOfConnections rdf:datatype="http://www.w3.org/2001/XMLSchema#int">'+cast(IsNull(@NumberOfConnections,0) as nvarchar(50))+'</prns:numberOfConnections>'
			+'<prns:offset rdf:datatype="http://www.w3.org/2001/XMLSchema#int"' + IsNull('>'+cast(@offset as nvarchar(50))+'</prns:offset>',' />')
			+'<prns:limit rdf:datatype="http://www.w3.org/2001/XMLSchema#int"' + IsNull('>'+cast(@limit as nvarchar(50))+'</prns:limit>',' />')
			+'<prns:maxWeight rdf:datatype="http://www.w3.org/2001/XMLSchema#float"' + IsNull('>'+cast(@MaxWeight as nvarchar(50))+'</prns:maxWeight>',' />')
			+'<prns:minWeight rdf:datatype="http://www.w3.org/2001/XMLSchema#float"' + IsNull('>'+cast(@MinWeight as nvarchar(50))+'</prns:minWeight>',' />')
			+'<vivo:overview rdf:parseType="Literal">'
			+IsNull(cast(@SearchOptions as nvarchar(max)),'')
			+'<SearchDetails>'+IsNull(cast(@SearchPhraseXML as nvarchar(max)),'')+'</SearchDetails>'
			+IsNull('<prns:matchesClassGroupsList>'+@MatchesClassGroups+'</prns:matchesClassGroupsList>','')
			+'</vivo:overview>'
			+IsNull((select replace(replace(cast((
					select '_TAGLT_prns:hasConnection rdf:nodeID="C'+cast(SortOrder as nvarchar(50))+'" /_TAGGT_'
					from #Node
					where SortOrder >= IsNull(@offset,0) and SortOrder < IsNull(IsNull(@offset,0)+@limit,SortOrder+1)
					order by SortOrder
					for xml path(''), type
				) as nvarchar(max)),'_TAGLT_','<'),'_TAGGT_','>')),'')
			+'</rdf:Description>'
			+IsNull((select replace(replace(cast((
					select ''
						+'_TAGLT_rdf:Description rdf:nodeID="C'+cast(x.SortOrder as nvarchar(50))+'"_TAGGT_'
						+'_TAGLT_prns:connectionWeight_TAGGT_'+cast(x.Weight as nvarchar(50))+'_TAGLT_/prns:connectionWeight_TAGGT_'
						+'_TAGLT_prns:sortOrder_TAGGT_'+cast(x.SortOrder as nvarchar(50))+'_TAGLT_/prns:sortOrder_TAGGT_'
						+'_TAGLT_rdf:object rdf:resource="'+replace(n.Value,'"','')+'"/_TAGGT_'
						+'_TAGLT_rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Connection" /_TAGGT_'
						+'_TAGLT_rdfs:label_TAGGT_'+(case when s.ShortLabel<>'' then ltrim(rtrim(s.ShortLabel)) else 'Untitled' end)+'_TAGLT_/rdfs:label_TAGGT_'
						+IsNull(+'_TAGLT_vivo:overview_TAGGT_'+s.ClassName+'_TAGLT_/vivo:overview_TAGGT_','')
						+'_TAGLT_/rdf:Description_TAGGT_'
					from #Node x, [RDF.].Node n, [Search.Cache].[Public.NodeSummary] s
					where x.SortOrder >= IsNull(@offset,0) and x.SortOrder < IsNull(IsNull(@offset,0)+@limit,x.SortOrder+1)
						and x.NodeID = n.NodeID
						and x.NodeID = s.NodeID
					order by x.SortOrder
					for xml path(''), type
				) as nvarchar(max)),'_TAGLT_','<'),'_TAGGT_','>')),'')
			+IsNull(@ObjectNodesRDF,'')

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + @results + '</rdf:RDF>'
	select cast(@x as xml) RDF

--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'form search rdf', datediff(ms,@d,GetDate()), null
select @d = GetDate()

	-------------------------------------------------------
	-- Log results
	-------------------------------------------------------

	update [Search.].[History.Query]
		set EndDate = GetDate(),
			DurationMS = datediff(ms,StartDate,GetDate()),
			NumberOfConnections = IsNull(@NumberOfConnections,0)
		where SearchHistoryQueryID = @SearchHistoryQueryID
	
	insert into [Search.].[History.Phrase] (SearchHistoryQueryID, PhraseID, ThesaurusMatch, Phrase, EndDate, IsBot, NumberOfConnections)
		select	@SearchHistoryQueryID,
				PhraseID,
				ThesaurusMatch,
				Phrase,
				GetDate(),
				@IsBot,
				IsNull(@NumberOfConnections,0)
			from @PhraseList

--insert into [Search.Cache].[Public.DebugLog] (SearchHistoryQueryID,Step,DurationMS,Notes) select @SearchHistoryQueryID, 'log results', datediff(ms,@d,GetDate()), null
select @d = GetDate()

END










SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Search.].[GetNodes]
	@SearchOptions XML,
	@SessionID UNIQUEIDENTIFIER = NULL,
	@Lookup BIT = 0,
	@UseCache VARCHAR(50) = 'Public',
	@NoRDF BIT =0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*
	
	EXEC [Search.].[GetNodes] @SearchOptions = '
	<SearchOptions>
		<MatchOptions>
			<SearchString ExactMatch="false">options for "lung cancer" treatment</SearchString>
			<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
			<SearchFiltersList>
				<SearchFilter Property="http://xmlns.com/foaf/0.1/lastName" MatchType="Left">Smit</SearchFilter>
			</SearchFiltersList>
		</MatchOptions>
		<OutputOptions>
			<Offset>0</Offset>
			<Limit>5</Limit>
			<SortByList>
				<SortBy IsDesc="1" Property="http://xmlns.com/foaf/0.1/firstName" />
				<SortBy IsDesc="0" Property="http://xmlns.com/foaf/0.1/lastName" />
			</SortByList>
		</OutputOptions>	
	</SearchOptions>
	'
		
	*/
	
	-- Select either a lookup or a full search
	IF @Lookup = 1
	BEGIN
		-- Run a lookup
		EXEC [Search.].[LookupNodes] @SearchOptions = @SearchOptions, @SessionID = @SessionID
	END
	ELSE
	BEGIN
		-- Run a full search
		-- Determine the cache type if set to auto
		IF IsNull(@UseCache,'Auto') IN ('','Auto')
		BEGIN
			DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT
			EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
			SELECT @UseCache = (CASE WHEN @SecurityGroupID <= -30 THEN 'Private' ELSE 'Public' END)
		END
		-- Run the search based on the cache type
		IF @UseCache = 'Public'
			EXEC [Search.Cache].[Public.GetNodes] @SearchOptions = @SearchOptions, @SessionID = @SessionID, @NoRDF=@NoRDF
		ELSE IF @UseCache = 'Private'
			EXEC [Search.Cache].[Private.GetNodes] @SearchOptions = @SearchOptions, @SessionID = @SessionID
	END

END
