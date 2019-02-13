SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Module].[ProfilesDataAPI.GetPersonData] 
	@PersonList varchar(max) = null,
	@Institution varchar(max) = null,
	@InstitutionAbbr varchar(max) = null,
	@Department varchar(max) = null,
	@Division varchar(max) = null,
	@FacultyRank varchar(max) = null,
	@SearchString varchar(max) = null,
	@offset int = 0,
	@count int = 100,
	@IncludeSecondary int = 0
AS
BEGIN
SET nocount  ON;

	declare @overview varchar(max)
	select @overview = nodeID from [RDF.].Node where valuehash = [RDF.].fnValueHash(null, null, 'http://vivoweb.org/ontology/core#overview')

	declare @basePath varchar(max)
	select @basePath = Value from [Framework.].Parameter where ParameterID = 'basePath'

	declare @institutionID int, @DepartmentID int, @DivisionID int, @FacultyRankID int
	select @institutionID = InstitutionID from [Profile.Data].[Organization.Institution] where InstitutionName = @Institution OR InstitutionAbbreviation = @InstitutionAbbr OR InstitutionAbbreviation = @Institution
	select @DepartmentID = DepartmentID from [Profile.Data].[Organization.Department] where DepartmentName = @Department
	select @DivisionID = DivisionID from [Profile.Data].[Organization.Division] where DivisionName = @Division
	select @FacultyRankID = FacultyRankID from [Profile.Data].[Person.FacultyRank] where FacultyRank = @FacultyRank

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

	IF @PersonList is not null
	BEGIN
		INSERT INTO #tmpPerson (PersonID) 
		select z.value('.','int') PersonID
		 from (select cast('<x>'+replace(@PersonList,',','</x><x>')+'</x>' as xml ) x) t cross apply x.nodes('x') as r(z)
	END
	ELSE IF @SearchString is not null
	BEGIN
		declare @t table (x xml)
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
		select @count = case when @count > 100 then 100 else @count end
		declare @SearchOpts varchar(max)
		set @SearchOpts =
			'<SearchOptions>
				<MatchOptions>
					<SearchString ExactMatch="false">' + @SearchString + '</SearchString>'
					+ @searchFilters +
					'<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
				</MatchOptions>
				<OutputOptions>
					<Offset>' + cast(@offset as varchar(max)) + '</Offset>
					<Limit>' + cast(@count as varchar(max)) + '</Limit>
				</OutputOptions>	
			</SearchOptions>'

		insert into @t (x) EXEC [Search.].[GetNodes] @SearchOptions =@SearchOpts

		;WITH XMLNAMESPACES('http://www.w3.org/1999/02/22-rdf-syntax-ns#' AS rdf,
						'http://www.w3.org/2000/01/rdf-schema#' AS rdfs,
						'http://profiles.catalyst.harvard.edu/ontology/prns#' AS prns)
		SELECT 
			p.value('(./@rdf:about[1])', 'VARCHAR(8000)') AS about,
			p.value('(./rdf:type[1]/@rdf:resource[1])', 'VARCHAR(8000)') AS type,
			p.value('(./prns:connectionWeight[1])', 'VARCHAR(8000)') AS connectionWeight,
			p.value('(./prns:sortOrder[1])', 'VARCHAR(8000)') AS sortOrder,
			p.value('(./rdf:object[1]/@rdf:resource[1])', 'VARCHAR(8000)') AS obj,
			p.value('(./prns:personId[1])', 'VARCHAR(8000)') AS personID
			into #tmp
			FROM @t cross apply x.nodes('/rdf:RDF/rdf:Description')  as t(p)

		INSERT INTO #tmpPerson (PersonID, ConnectionWeight)
		select t2.personID, t1.connectionWeight from #tmp t1 
			join #tmp t2 
			on t1.type='http://profiles.catalyst.harvard.edu/ontology/prns#Connection'
			AND t2.type = 'http://xmlns.com/foaf/0.1/Agent'
			AND t1.obj = t2.about
			ORDER by t1.connectionWeight desc
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
		
	UPDATE p SET Overview = CASE WHEN ShowPublications = 'Y' then nob.Value ELSE null END from 
		#tmpPerson p join [RDF.].Triple t  on p.NodeID = t.Subject and t.predicate = @overview
		join [RDF.].Node nob
		on t.Object = nob.NodeID
			 
	;with pubmedGeneral as
	(
		select g.PMID,
			case when right(Authors,5) = 'et al' then Authors+'. '
											when AuthorListCompleteYN = 'N' then Authors+', et al. '
											when Authors <> '' then Authors+'. '
											else '' end as Authors
											, coalesce(ArticleTitle,'') AS Title, coalesce(MedlineTA,'') as Journal,
											case when JournalYear is not null then rtrim(JournalYear + ' ' + coalesce(JournalMonth,'') + ' ' + coalesce(JournalDay,''))
										when MedlineDate is not null then MedlineDate
										when ArticleYear is not null then rtrim(ArticleYear + ' ' + coalesce(ArticleMonth,'') + ' ' + coalesce(ArticleDay,''))
									else '' end AS PubDate,
									coalesce(Volume,'')
								+ (case when coalesce(Issue,'') <> '' then '('+Issue+')' else '' end)
								+ (case when (coalesce(MedlinePgn,'') <> '') and (coalesce(Volume,'')+coalesce(Issue,'') <> '') then ':' else '' end)
								+ coalesce(MedlinePgn,'') as IssueInfo
								from #tmpPerson p join [Profile.Data].[Publication.Person.Include] i on p.PersonID = i.PersonID AND i.PMID is not null AND p.ShowPublications = 'Y'
								join [Profile.Data].[Publication.PubMed.General] g on i.pmid = g.PMID
	), customGeneral as
	(
	            SELECT  MPID ,
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
	)
	select (
		select (
			select p.PersonID "@PersonID", p.ConnectionWeight "ConnectionWeight", p.Name "Name", p.Address "Address", p.Affiliation "AffiliationList", p.Overview "Overview", p.PhotoUrl "PhotoUrl", (
				 select i.Source "Publication/@Source", i.pmid "Publication/@PMID", i.pmcid "Publication/@PMCID", CASE WHEN i.URL <> '' THEN i.URL ELSE null END "Publication/URL", i.Reference "Publication/PublicationReference"--, @basePath + '/profile/' + cast(inm.NodeID as varchar(max)) "PublicationID"
				 ,isnull(g.Title, mg.Title) "Publication/Title", isnull(g.Authors, mg.Authors) as "Publication/Authors", isnull(g.Journal, mg.Journal) as "Publication/Journal",
				 isnull(g.PubDate, mg.PubDate) as "Publication/Date", isnull(g.IssueInfo, mg.IssueInfo) as "Publication/IssueInfo"
				 from [Profile.Data].[Publication.Entity.Authorship] a
					 inner join [Profile.Data].[Publication.Entity.InformationResource] i
					 on a.InformationResourceID=i.EntityID
					 and a.PersonID=p.PersonID
					 --join [RDF.stage].[InternalNodeMap] inm
					 --on i.EntityID = inm.InternalID AND inm.Class = 'http://vivoweb.org/ontology/core#InformationResource' AND inm.InternalType = 'InformationResource'
					 left join pubmedGeneral g
					 on i.PMID = g.PMID
					 left join customGeneral mg
					 on i.MPID = mg.MPID
					 where i.IsActive = 1
					 order by i.EntityDate desc
					 for xml path(''), type
				) "PublicationList"
			from #tmpPerson p
			order by p.ConnectionWeight desc, p.Lastname, p.Firstname, p.PersonID
			for xml path('Person'), type
		) PersonList
		for xml path(''), type
	) x

END 