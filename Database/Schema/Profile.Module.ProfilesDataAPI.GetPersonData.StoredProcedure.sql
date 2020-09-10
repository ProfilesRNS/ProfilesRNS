SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Module].[ProfilesDataAPI.GetPersonData] 
	@Format varchar(5) = 'XML',
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
	@Param11name varchar(max) = null,
	@Param11value varchar(max) = null,
	@Param12name varchar(max) = null,
	@Param12value varchar(max) = null,
	@Param13name varchar(max) = null,
	@Param13value varchar(max) = null,
	@Param14name varchar(max) = null,
	@Param14value varchar(max) = null,
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

	/*****************************
	*
	* Handle the Parameters
	*
	*****************************/

	declare @years varchar(max), @key varchar(max), @LastUpdated datetime, @OtherOptions varchar(max)
	declare @huidList varchar(max), @includeHUID int -- Harvard Specific

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
	insert into #params (n,v) values (@param11name, @Param11value)
	insert into #params (n,v) values (@param12name, @Param12value)
	insert into #params (n,v) values (@param13name, @Param13value)
	insert into #params (n,v) values (@param14name, @Param14value)
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
	select @key = v from #params where n = 'Key'
	select @LastUpdated = v from #params where n = 'LastUpdated'
	select @OtherOptions = v from #params where n = 'OtherOptions'

	declare @authenticated int = 0
	select @authenticated = 1 from [Profile.Module].[ProfilesDataAPI.Users] where KeyValue = @key

	declare @basePath varchar(max)
	select @basePath = Value from [Framework.].Parameter where ParameterID = 'basePath'

	declare @institutionID int, @DepartmentID int, @DivisionID int, @FacultyRankID int
	select @institutionID = InstitutionID from [Profile.Data].[Organization.Institution] where InstitutionName = @Institution OR InstitutionAbbreviation = @InstitutionAbbr OR InstitutionAbbreviation = @Institution
	select @DepartmentID = DepartmentID from [Profile.Data].[Organization.Department] where DepartmentName = @Department
	select @DivisionID = DivisionID from [Profile.Data].[Organization.Division] where DivisionName = @Division
	select @FacultyRankID = FacultyRankID from [Profile.Data].[Person.FacultyRank] where FacultyRank = @FacultyRank

	declare @includeAddress bit = 0, @includeAffiliation bit = 0, @includeOverview bit = 0, @includePublications bit = 0, @includeConcepts bit = 0, @includeTwitter bit = 0, @includeFeaturedVideos bit = 0, @includeFeaturedPresentations bit = 0, @includeWebsites bit = 0, @includeMediaLinks bit = 0, @includeFunding bit = 0, @includeAwards bit = 0, @includeEducation bit = 0
	if not exists (select 1 from #params)
	BEGIN
		set @includeAddress = 1
		set @includeAffiliation = 1
		set @includeOverview = 1
		set @includePublications = 1
	END
	if @columns is not null
	BEGIN
		if @columns = 'all' select @includeAddress = 1, @includeAffiliation = 1, @includeOverview = 1, @includePublications = 1,
									@includeConcepts = 1, @includeTwitter = 1, @includeFeaturedVideos = 1, @includeFeaturedPresentations = 1,
									@includeWebsites = 1, @includeMediaLinks = 1, @includeFunding = 1, @includeAwards = 1, @includeEducation = 1

		if @columns like '%address%' set @includeAddress = 1
		if @columns like '%affiliation%' set @includeAffiliation = 1
		if @columns like '%overview%' set @includeOverview = 1
		if @columns like '%publications%' set @includePublications = 1
		if @columns like '%concepts%' set @includeConcepts = 1
		if @columns like '%twitter%' set @includeTwitter = 1
		if @columns like '%youtube%' set @includeFeaturedVideos = 1
		if @columns like '%slideshare%' set @includeFeaturedPresentations = 1
		if @columns like '%websites%' set @includeWebsites = 1
		if @columns like '%medialinks%' set @includeMediaLinks = 1
		if @columns like '%funding%' set @includeFunding = 1
		if @columns like '%awards%' set @includeAwards = 1
		if @columns like '%education%' set @includeEducation = 1
	END

	/*****************************
	*
	* Identify the People
	*
	*****************************/

	CREATE TABLE #tmpPerson (
		PersonID int PRIMARY KEY,
		NodeID bigint,
		IncludeDetails bit not null default 1,
		ShowPublications varchar(1),
		ShowNarrative bit,
		ShowPhoto bit,
		ShowFeaturedVideos bit,
		ShowTwitter bit,
		ShowFeaturedPresentations bit,
		ShowWebsites bit,
		ShowMediaLinks bit,
		ShowAwards bit,
		ShowEducation bit,
		ShowFunding bit,
		Name xml,
		LastName varchar(max),
		FirstName varchar(max),
		emailAddr varchar(max),
		Overview nvarchar(max),
		Address xml,
		Affiliation xml,
		PhotoURL nvarchar(max),
		FeaturedVideos nvarchar(max),
		Twitter nvarchar(max),
		FeaturedPresentations nvarchar(max),
		ConnectionWeight float
	)
	



	IF @PersonList is not null
	BEGIN
		INSERT INTO #tmpPerson (PersonID) 
		select z.value('.','int') PersonID
		 from (select cast('<x>'+replace(@PersonList,',','</x><x>')+'</x>' as xml ) x) t cross apply x.nodes('x') as r(z)

		 --Delete from #tmpPerson where PersonID not in (select PersonID from [Profile.Data].Person where IsActive = 0)
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



	if @LastUpdated is not null
	BEGIN
		select personID, max(createdDT) as lastUpdated
			into #tmpPersonLastUpdated
			from [Framework.].[Log.Activity] where methodname <> 'Profiles.Login.Utilities.DataIO.UserLogin' and personID in (select PersonID from #tmpPerson)
			group by PersonID
		update #tmpPerson set IncludeDetails = 0 where personID not in (select PersonID from #tmpPersonLastUpdated u where u.lastUpdated > @LastUpdated)
	END 


	UPDATE p SET p.NodeID = i.NodeID
		FROM #tmpPerson p join [RDF.Stage].InternalNodeMap i
		on p.PersonID = i.InternalID and i.Class = 'http://xmlns.com/foaf/0.1/Person'

	CREATE INDEX iNodeID ON #tmpPerson(NodeID)

	/*****************************
	*
	* Load Overview, Address, Affiliation and Photo
	*
	*****************************/


	UPDATE p SET ShowPublications = c.ShowPublications,
			Name = CASE WHEN ShowAddress = 'Y' THEN REPLACE(REPLACE(CAST(PersonXML.query('//Name[1]') as varchar(max)), '<Name>', ''), '</Name>', '') ELSE NULL END,
			Address = CASE WHEN ShowAddress = 'Y' THEN REPLACE(REPLACE(CAST(PersonXML.query('//Address[1]') as varchar(max)), '<Address>', ''), '</Address>', '') ELSE NULL END,
			Affiliation = REPLACE(REPLACE(CAST(PersonXML.query('//AffiliationList[1]') as varchar(max)), '<AffiliationList Visible="true">', ''), '</AffiliationList>', ''),
			--PhotoURL =  CASE WHEN ShowPhoto = 'Y' THEN  @basePath + '/profile/Modules/CustomViewPersonGeneralInfo/PhotoHandler.ashx?NodeID=' + CAST(NodeID as VARCHAR(max)) ELSE NULL END,
			emailAddr = case when @authenticated = 1 then c.emailAddr else null end
		FROM #tmpPerson p join [Profile.Cache].Person c
		on p.PersonID = c.PersonID and p.IncludeDetails = 1

	declare @mainImage varchar(max)
	select @mainImage = nodeID from [RDF.].Node where valuehash = [RDF.].fnValueHash(null, null, 'http://profiles.catalyst.harvard.edu/ontology/prns#mainImage')
	update p set p.ShowPhoto = case when (s.ViewSecurityGroup = -1 or s.ViewSecurityGroup is null) and p.IncludeDetails = 1 then 1 else 0 end from #tmpPerson p left join [RDF.Security].[NodeProperty] s on p.NodeID = s.NodeID and s.Property = @mainImage
	UPDATE p SET PhotoURL = CASE WHEN ShowPhoto = 1 then nob.Value ELSE null END from 
		#tmpPerson p join [RDF.].Triple t  on p.NodeID = t.Subject and t.predicate = @mainImage and p.IncludeDetails = 1
		join [RDF.].Node nob
		on t.Object = nob.NodeID

	if @includeOverview  = 1
	BEGIN
		declare @overview varchar(max)
		select @overview = nodeID from [RDF.].Node where valuehash = [RDF.].fnValueHash(null, null, 'http://vivoweb.org/ontology/core#overview')
		update p set p.ShowNarrative = case when (s.ViewSecurityGroup = -1 or s.ViewSecurityGroup is null) and p.IncludeDetails = 1 then 1 else 0 end from #tmpPerson p left join [RDF.Security].[NodeProperty] s on p.NodeID = s.NodeID and s.Property = @overview
		UPDATE p SET Overview = CASE WHEN ShowNarrative = 1 then nob.Value ELSE null END from 
			#tmpPerson p join [RDF.].Triple t  on p.NodeID = t.Subject and t.predicate = @overview and p.IncludeDetails = 1
			join [RDF.].Node nob
			on t.Object = nob.NodeID
	END

	/*****************************
	*
	* Load Videos, Twitter and Slideshare
	*
	*****************************/
	if @includeFeaturedVideos = 1
	begin
		declare @youtube bigint
		select @youtube= nodeID from [RDF.].Node where valuehash = [RDF.].fnValueHash(null, null, 'http://profiles.catalyst.harvard.edu/ontology/plugins#FeaturedVideos')
		update p set p.ShowFeaturedVideos = case when (s.ViewSecurityGroup = -1 or s.ViewSecurityGroup is null) and p.IncludeDetails = 1 then 1 else 0 end from #tmpPerson p left join [RDF.Security].[NodeProperty] s on p.NodeID = s.NodeID and s.Property = @youtube

		update p set p.FeaturedVideos = d.Data from #tmpPerson p join [Profile.Module].[GenericRDF.Data] d on p.NodeID = d.NodeID and p.ShowFeaturedVideos = 1 and d.Name = 'FeaturedVideos'
	end

	if @includeTwitter = 1
	begin
		declare @twitter bigint
		select @twitter = nodeID from [RDF.].Node where valuehash = [RDF.].fnValueHash(null, null, 'http://profiles.catalyst.harvard.edu/ontology/plugins#Twitter')

		update p set p.ShowTwitter = case when (s.ViewSecurityGroup = -1 or s.ViewSecurityGroup is null) and p.IncludeDetails = 1 then 1 else 0 end from #tmpPerson p left join [RDF.Security].[NodeProperty] s on p.NodeID = s.NodeID and s.Property = @twitter

		update p set p.Twitter = d.Data from #tmpPerson p join [Profile.Module].[GenericRDF.Data] d on p.NodeID = d.NodeID and p.ShowTwitter = 1 and d.Name = 'Twitter'
	end

	if @includeFeaturedPresentations = 1
	begin
		declare @slideshare bigint
		select @slideshare= nodeID from [RDF.].Node where valuehash = [RDF.].fnValueHash(null, null, 'http://profiles.catalyst.harvard.edu/ontology/plugins#FeaturedPresentations')
		
		update p set p.ShowFeaturedPresentations = case when (s.ViewSecurityGroup = -1 or s.ViewSecurityGroup is null) and p.IncludeDetails = 1 then 1 else 0 end from #tmpPerson p left join [RDF.Security].[NodeProperty] s on p.NodeID = s.NodeID and s.Property = @slideshare

		update p set p.FeaturedPresentations = d.Data from #tmpPerson p join [Profile.Module].[GenericRDF.Data] d on p.NodeID = d.NodeID and p.ShowFeaturedPresentations = 1 and d.Name = 'FeaturedPresentations'
	end

	if @includeWebsites = 1
	begin
		declare @websites bigint
		select @websites= nodeID from [RDF.].Node where valuehash = [RDF.].fnValueHash(null, null, 'http://vivoweb.org/ontology/core#webpage')
		update p set p.ShowWebsites = case when (s.ViewSecurityGroup = -1 or s.ViewSecurityGroup is null) and p.IncludeDetails = 1 then 1 else 0 end from #tmpPerson p left join [RDF.Security].[NodeProperty] s on p.NodeID = s.NodeID and s.Property = @websites
	end

	if @includeMediaLinks = 1
	begin
		declare @links bigint
		select @links = nodeID from [RDF.].Node where valuehash = [RDF.].fnValueHash(null, null, 'http://profiles.catalyst.harvard.edu/ontology/prns#mediaLinks')
		update p set p.ShowMediaLinks = case when (s.ViewSecurityGroup = -1 or s.ViewSecurityGroup is null) and p.IncludeDetails = 1 then 1 else 0 end from #tmpPerson p left join [RDF.Security].[NodeProperty] s on p.NodeID = s.NodeID and s.Property = @links
	end


	/*****************************
	*
	* Awards and Honors 
	*
	*****************************/
	create table #awards(
		PersonNodeID bigint not null,
		AwardNodeID bigint not null,
		StartYear varchar(100) null,
		EndYear varchar(100) null,
		AwardName varchar(1000) null,
		Institution varchar(1000) null,
		CONSTRAINT PK_tmp_awards PRIMARY KEY CLUSTERED (PersonNodeID, AwardNodeID)
	)

	if @includeAwards = 1
	begin
		declare @awards bigint
		select @awards= nodeID from [RDF.].Node where valuehash = [RDF.].fnValueHash(null, null, 'http://vivoweb.org/ontology/core#awardOrHonor')
		update p set p.ShowAwards = case when (s.ViewSecurityGroup = -1 or s.ViewSecurityGroup is null) and p.IncludeDetails = 1 then 1 else 0 end from #tmpPerson p left join [RDF.Security].[NodeProperty] s on p.NodeID = s.NodeID and s.Property = @awards

		insert into #awards (PersonNodeID, AwardNodeID)
		select Subject, Object from [RDF.].[Triple] t join #tmpPerson p on t.Subject = p.NodeID and p.IncludeDetails = 1 and p.ShowAwards = 1 and Predicate = @awards and ViewSecurityGroup = -1


		update a set a.AwardName = nn.Value, a.Institution = ni.Value, a.StartYear = ns.Value, a.EndYear = ne.Value
			from #awards a left join [RDF.].Triple tn on a.AwardNodeID = tn.Subject and tn.Predicate = [RDF.].[fnURI2NodeID] ('http://www.w3.org/2000/01/rdf-schema#label') and tn.ViewSecurityGroup = -1
			left join [RDF.].Node nn on tn.Object = nn.NodeID and nn.ViewSecurityGroup = -1
			left join [RDF.].Triple ti on a.AwardNodeID = ti.Subject and ti.Predicate = [RDF.].[fnURI2NodeID] ('http://profiles.catalyst.harvard.edu/ontology/prns#awardConferredBy') and ti.ViewSecurityGroup = -1
			left join [RDF.].Node ni on ti.Object = ni.NodeID and ni.ViewSecurityGroup = -1
			left join [RDF.].Triple ts on a.AwardNodeID = ts.Subject and ts.Predicate = [RDF.].[fnURI2NodeID] ('http://profiles.catalyst.harvard.edu/ontology/prns#startDate') and ts.ViewSecurityGroup = -1
			left join [RDF.].Node ns on ts.Object = ns.NodeID and ns.ViewSecurityGroup = -1
			left join [RDF.].Triple te on a.AwardNodeID = te.Subject and te.Predicate = [RDF.].[fnURI2NodeID] ('http://profiles.catalyst.harvard.edu/ontology/prns#endDate') and te.ViewSecurityGroup = -1
			left join [RDF.].Node ne on te.Object = ne.NodeID and ne.ViewSecurityGroup = -1
	end


	/*****************************
	* 
	* Education and Training
	*
	*****************************/

	create table #education(
		PersonNodeID bigint not null,
		EducationNodeID bigint not null,
		Institution varchar(1000) null,
		Location varchar(1000) null,
		Degree varchar(1000) null,
		CompletionDate varchar(100) null,
		Field varchar(1000) null,
		
		CONSTRAINT PK_tmp_education PRIMARY KEY CLUSTERED (PersonNodeID, EducationNodeID)
	)

	if @includeEducation = 1
	begin
		declare @education varchar(max)
		select @education= nodeID from [RDF.].Node where valuehash = [RDF.].fnValueHash(null, null, 'http://vivoweb.org/ontology/core#educationalTraining')
		update p set p.ShowEducation = case when (s.ViewSecurityGroup = -1 or s.ViewSecurityGroup is null) and p.IncludeDetails = 1 then 1 else 0 end from #tmpPerson p left join [RDF.Security].[NodeProperty] s on p.NodeID = s.NodeID and s.Property = @education

		insert into #education (PersonNodeID, EducationNodeID)
		select Subject, Object from [RDF.].[Triple] t join #tmpPerson p on t.Subject = p.NodeID and p.IncludeDetails = 1 and p.ShowAwards = 1 and Predicate = @education and ViewSecurityGroup = -1

		update a set a.Field = nn.Value, a.Institution = ni.Value, a.Location = nl.Value, a.Degree = nd.Value, a.CompletionDate = ne.Value
			from #education a left join [RDF.].Triple tn on a.EducationNodeID = tn.Subject and tn.Predicate = [RDF.].[fnURI2NodeID] ('http://vivoweb.org/ontology/core#majorField') and tn.ViewSecurityGroup = -1
			left join [RDF.].Node nn on tn.Object = nn.NodeID and nn.ViewSecurityGroup = -1
			left join [RDF.].Triple ti on a.EducationNodeID = ti.Subject and ti.Predicate = [RDF.].[fnURI2NodeID] ('http://profiles.catalyst.harvard.edu/ontology/prns#trainingAtOrganization') and ti.ViewSecurityGroup = -1
			left join [RDF.].Node ni on ti.Object = ni.NodeID and ni.ViewSecurityGroup = -1
			left join [RDF.].Triple tl on a.EducationNodeID = tl.Subject and tl.Predicate = [RDF.].[fnURI2NodeID] ('http://profiles.catalyst.harvard.edu/ontology/prns#trainingLocation') and tl.ViewSecurityGroup = -1
			left join [RDF.].Node nl on tl.Object = nl.NodeID and nl.ViewSecurityGroup = -1
			left join [RDF.].Triple td on a.EducationNodeID = td.Subject and td.Predicate = [RDF.].[fnURI2NodeID] ('http://vivoweb.org/ontology/core#degreeEarned') and td.ViewSecurityGroup = -1
			left join [RDF.].Node nd on td.Object = nd.NodeID and nd.ViewSecurityGroup = -1
			left join [RDF.].Triple te on a.EducationNodeID = te.Subject and te.Predicate = [RDF.].[fnURI2NodeID] ('http://profiles.catalyst.harvard.edu/ontology/prns#endDate') and te.ViewSecurityGroup = -1
			left join [RDF.].Node ne on te.Object = ne.NodeID and ne.ViewSecurityGroup = -1
	end
	
	--select * from [RDF.].Triple where Predicate =  [RDF.].[fnURI2NodeID]('http://vivoweb.org/ontology/core#educationalTraining')
	--select t.*, np.Value, n.Value from [RDF.].Triple t join [RDF.].Node n on t.Object = n.NodeID and Subject = 966044 join [RDF.].Node np on t.Predicate = np.NodeID 
	--select * From [Ontology.].ClassProperty where EditSecurityGroup =-20

	/*****************************
	* 
	* Funding
	*
	*****************************/
	if @includeFunding = 1
	begin
		declare @funding varchar(max)
		select @funding = nodeID from [RDF.].Node where valuehash = [RDF.].fnValueHash(null, null, 'http://vivoweb.org/ontology/core#educationalTraining')
		update p set p.ShowFunding = case when (s.ViewSecurityGroup = -1 or s.ViewSecurityGroup is null) and p.IncludeDetails = 1 then 1 else 0 end from #tmpPerson p left join [RDF.Security].[NodeProperty] s on p.NodeID = s.NodeID and s.Property = @funding

	end

	/*****************************
	*
	* Load the Publications
	*
	*****************************/

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
		select distinct pmid, '' from #tmpPerson p join [Profile.Data].[Publication.Person.Include] i on p.IncludeDetails = 1 and p.PersonID = i.PersonID AND i.PMID is not null AND p.ShowPublications = 'Y'

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


	/*****************************
	*
	* Generate XML
	*
	*****************************/
	
	if exists (select top 1 1 from #tmpPerson)
	BEGIN
		select (
			select getDate() as "PersonList/@Date",  (
				select p.PersonID "@PersonID", 
				Case when p.IncludeDetails = 0 then 'false' else null end "@ChangedSinceLastUpdated", 
				p.ConnectionWeight "ConnectionWeight", 
				Case when p.IncludeDetails = 1 then p.Name else null end "Name", 
				Case when p.IncludeDetails = 1 then p.emailAddr else null end "emailAddr", 
				Case when p.IncludeDetails = 1  and @includeAddress = 1 then p.Address else null end "Address", 
				Case when p.IncludeDetails = 1  and @includeAffiliation = 1 then p.Affiliation else null end "AffiliationList", 
				Case when p.IncludeDetails = 1  and @includeOverview = 1 then p.Overview else null end "Overview", 
				Case when p.IncludeDetails = 1 and ShowPhoto = 1 then p.PhotoUrl else null end "PhotoUrl", 
				Case when p.IncludeDetails = 1 then p.Twitter else null end "Twitter", 
				Case when p.IncludeDetails = 1 then p.FeaturedPresentations else null end "Slideshare", 
				Case when p.IncludeDetails = 1 then p.FeaturedVideos else null end "FeaturedVideos", 
				Case when p.IncludeDetails = 1 and ShowWebsites = 1 then (
					select [URL] "Website/URL", WebPageTitle "Website/Title" ,SortOrder "Website/SortOrder" from [Profile.Data].[Person.Websites] w where w.PersonID = p.PersonID order by sortorder for xml path(''), type
				) else null end "Websites", 
				Case when p.IncludeDetails = 1 and ShowMediaLinks = 1 then (
					select [URL] "MediaLink/URL", WebPageTitle "MediaLink/Title" ,SortOrder "MediaLink/SortOrder", PublicationDate "MediaLink/PublicationDate" from [Profile.Data].[Person.MediaLinks] w where w.PersonID = p.PersonID order by sortorder for xml path(''), type
				) else null end "MediaLinks", 
				Case when p.IncludeDetails = 1 and ShowAwards = 1 then (
					select w.AwardName "Award/Title", w.Institution "Award/AwardingInstitution" ,w.StartYear "Award/StartDate", w.EndYear "Award/EndDate" from #awards w where w.PersonNodeID = p.NodeID order by StartYear for xml path(''), type
				) else null end "AwardAndHonors", 
				Case when p.IncludeDetails = 1 and ShowEducation = 1 then (
					select w.Institution "Education/TrainingAtOrganization", w.Location "Education/TrainingLocation", w.Degree "Education/DegreeEarned", w.CompletionDate "Education/CompletionDate", w.Field "Education/MajorField" from #education w where w.PersonNodeID = p.NodeID order by CompletionDate for xml path(''), type
				) else null end "EducationAndTraining", 
				Case when p.IncludeDetails = 1 and ShowEducation = 1 then (
					select r.RoleLabel "Funding/RoleLabel", r.RoleDescription "Funding/RoleDescription", a.AgreementLabel "Funding/AgreementLabel", a.GrantAwardedBy "Funding/GrantAwardedBy" ,StartDate "Funding/StartDate", EndDate "Funding/EndDate", a.PrincipalInvestigatorName "Funding/PrincipalInvestigatorName", a.Abstract "Funding/Abstract" from [Profile.Data].[Funding.Role] r
						join [Profile.Data].[Funding.Agreement] a on r.FundingAgreementID = a.FundingAgreementID 
						and r.PersonID = p.PersonID 
						order by StartDate 
						for xml path(''), type
				) else null end "FundingList", 
				Case when p.IncludeDetails = 1 then (
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
					) else null end "PublicationList", 
					Case when p.IncludeDetails = 1 then (select [MeshHeader]  "Concept/MeshHeader", NumPubsThis "Concept/NumPubs", Weight "Concept/Weight", FirstPubDate "Concept/FirstPubDate", LastPubDate "Concept/LastPubDate"
					from [Profile.Cache].[Concept.Mesh.Person]cmp
					where cmp.PersonID=p.PersonID and @includeConcepts = 1 order by Weight desc for xml path(''), type ) else null end "ConceptList"
				from #tmpPerson p
				order by p.ConnectionWeight desc, p.Lastname, p.Firstname, p.PersonID
				for xml path('Person'), type
			) PersonList
			for xml path(''), type
		) x
	END
	ELSE 
		select '<PersonList></PersonList>'
END 
GO
