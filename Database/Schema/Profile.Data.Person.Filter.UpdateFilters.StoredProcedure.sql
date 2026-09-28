SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Person.Filter.UpdateFilters]
AS
BEGIN
	CREATE TABLE #FilterRelationship (PersonID int,PersonFilterid int) 
	declare @FilterID int
	set @FilterID = 0

	/************
	* Mentoring *
	************/
	--Get personIDs of people with mentoring records.
	if exists (select 1 from [Profile.Data].[Person.Filter] where ETLProcedure = '[Profile.Data].[Person.Filter.UpdateFilters]/Mentoring')
	begin
		declare @MentoringPeople table(NodeID bigint, PersonID int) 
		insert into @MentoringPeople (NodeID) select distinct subject from [RDF.].Triple where predicate = [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#hasMentoringJobOpportunity') and ViewSecurityGroup in (-10, -1)
		update a set a.PersonID = b.PersonID From @MentoringPeople a join [Profile.Cache].Person b on a.NodeID = b.NodeID

		select @FilterID = PersonFilterID from [Profile.Data].[Person.Filter] where ETLProcedure = '[Profile.Data].[Person.Filter.UpdateFilters]/Mentoring' and ETLParams = 'Students'
		if @FilterID > 0
		begin
			insert into #FilterRelationship select distinct a.personID, @FilterID From @MentoringPeople a join [Profile.Data].[Person.Mentoring.JobOpportunities] b on a.PersonID = b.PersonID and b.Students =1
		end

		set @FilterID = 0
		select @FilterID = PersonFilterID from [Profile.Data].[Person.Filter] where ETLProcedure = '[Profile.Data].[Person.Filter.UpdateFilters]/Mentoring' and ETLParams = 'Faculty'
		if @FilterID > 0
		begin
			insert into #FilterRelationship select distinct a.personID, @FilterID From @MentoringPeople a join [Profile.Data].[Person.Mentoring.JobOpportunities] b on a.PersonID = b.PersonID and b.Faculty =1
		end

		set @FilterID = 0
		select @FilterID = PersonFilterID from [Profile.Data].[Person.Filter] where ETLProcedure = '[Profile.Data].[Person.Filter.UpdateFilters]/Mentoring' and ETLParams = 'Fellows'
		if @FilterID > 0
		begin
			insert into #FilterRelationship select distinct a.personID, @FilterID From @MentoringPeople a join [Profile.Data].[Person.Mentoring.JobOpportunities] b on a.PersonID = b.PersonID and b.Fellows =1
		end

		set @FilterID = 0
		select @FilterID = PersonFilterID from [Profile.Data].[Person.Filter] where ETLProcedure = '[Profile.Data].[Person.Filter.UpdateFilters]/Mentoring' and ETLParams = 'Staff'
		if @FilterID > 0
		begin
			insert into #FilterRelationship select distinct a.personID, @FilterID From @MentoringPeople a join [Profile.Data].[Person.Mentoring.JobOpportunities] b on a.PersonID = b.PersonID and b.Staff =1
		end
	end

	if exists (select 1 from [Profile.Data].[Person.Filter] where ETLProcedure = '[Profile.Data].[Person.Filter.UpdateFilters]/MentoringOverview')
	begin
		declare @MentoringOverviewPeople table(NodeID bigint, PersonID int) 
		insert into @MentoringOverviewPeople (NodeID) select distinct subject from [RDF.].Triple where predicate = [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#mentoringOverview') and ViewSecurityGroup in (-10, -1)
		update a set a.PersonID = b.PersonID From @MentoringOverviewPeople a join [Profile.Cache].Person b on a.NodeID = b.NodeID
		;with a as (select PersonID, [Key] COLLATE SQL_Latin1_General_CP1_CI_AS as [Key], Value from [Profile.Data].[Person.Mentoring.Overview] Cross apply  openjson(Json))
		insert into #FilterRelationship 
		select c.PersonID, b.PersonFilterID from a a 
			join [Profile.Data].[Person.Filter] b on b.ETLProcedure = '[Profile.Data].[Person.Filter.UpdateFilters]/MentoringOverview' and a.[Value] = 'true' and a.[Key] = b.ETLParams
			join @MentoringOverviewPeople c on a.PersonID = c.PersonID
	end


	insert into #FilterRelationship
	select distinct PersonID, PersonFilterID from [RDF.].Triple a 
	join [Profile.Data].[Person.Filter] b
	on b.ETLProcedure = '[Profile.Data].[Person.Filter.UpdateFilters]/Sections' and a.Predicate = [RDF.].fnURI2NodeID(b.ETLParams) and ViewSecurityGroup in (-10, -1)
	join [Profile.Cache].Person c on a.Subject = c.NodeID

	begin try
		begin transaction trans_updateFilters
			delete from [Profile.Data].[Person.FilterRelationship] where PersonFilterid in (select PersonFilterID from [Profile.Data].[Person.Filter] where ETLProcedure like '\[Profile.Data].\[Person.Filter.UpdateFilters]%' ESCAPE '\')
			insert into [Profile.Data].[Person.FilterRelationship](PersonID, PersonFilterid) select PersonID, PersonFilterID from #FilterRelationship
		commit transaction trans_updateFilters
	end try
	begin catch
		rollback transaction trans_updateFilters
	end catch
END

GO
