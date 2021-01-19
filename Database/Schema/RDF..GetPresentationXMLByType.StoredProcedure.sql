SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[GetPresentationXMLByType]
@subjectType varchar(max)=NULL, @predicate BIGINT=NULL, @objectType varchar(max)=NULL, @PresentationXML XML=NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @typeID bigint
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')

	select @subjectType = null where @subjectType = '0'
	select @predicate = null where @predicate = 0
	select @objectType = null where @objectType = '0'

	create table #subjectTypes ( st bigint)
	create table #objectTypes (ot bigint)

	insert into #subjectTypes SELECT cast(value as bigint) from string_split(@subjectType, ',')
	if @objectType is not null
		insert into #objectTypes SELECT cast(value as bigint) from string_split(@objectType, ',')

	declare @SecurityGroupListXML xml
	select @SecurityGroupListXML = NULL

	declare @NetworkNode bigint
	declare @ConnectionNode bigint
	select	@NetworkNode = [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#Network'),
			@ConnectionNode = [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#Connection')


	-------------------------------------------------------------------------------
	-- Determine the PresentationType (P = profile, N = network, C = connection)
	-------------------------------------------------------------------------------

	declare @PresentationType char(1)
	select @PresentationType = (case when @objectType is not null AND @predicate is not null AND @subjectType is not null then 'C'
									when @predicate is not null AND @subjectType is not null then 'N'
									when @subjectType is not null then 'P'
									else NULL end)


	-------------------------------------------------------------------------------
	-- Get the PresentationID based on type
	-------------------------------------------------------------------------------

	declare @PresentationID int
	select @PresentationID = (
			select top 1 PresentationID
				from [Ontology.Presentation].[XML]
				where type = IsNull(@PresentationType,'P')
					AND	(_SubjectNode IS NULL
							OR _SubjectNode in (select * from #subjectTypes)
						)
					AND	(_PredicateNode IS NULL
							OR _PredicateNode = @predicate
						)
					AND	(_ObjectNode IS NULL
							OR _ObjectNode in (select * from #objectTypes)
						)
				order by	(case when _ObjectNode is null then 1 else 0 end),
							(case when _PredicateNode is null then 1 else 0 end),
							(case when _SubjectNode is null then 1 else 0 end),
							PresentationID
		)

	-------------------------------------------------------------------------------
	-- Get the PropertyListXML based on type
	-------------------------------------------------------------------------------

	declare @PropertyListXML xml

	-- View properties
	select @PropertyListXML = (
		select PropertyGroupURI "@URI", _PropertyGroupLabel "@Label", SortOrder "@SortOrder", x.query('.')
		from (
			select PropertyGroupURI, _PropertyGroupLabel, SortOrder,
			(
				select	a.URI "@URI", 
						a.TagName "@TagName", 
						a.Label "@Label", 
						p.SortOrder "@SortOrder",
						(case when a.CustomDisplay = 1 then 'true' else 'false' end) "@CustomDisplay",
						cast(a.CustomDisplayModule as xml)
				from [ontology.].PropertyGroupProperty p, (
					select NodeID,
						max(URI) URI, 
						max(TagName) TagName, 
						max(Label) Label,
						max(CustomDisplay) CustomDisplay,
						max(CustomDisplayModule) CustomDisplayModule
					from (
							select
								c._PropertyNode NodeID,
								c.Property URI,
								c._TagName TagName,
								c._PropertyLabel Label,
								cast(c.CustomDisplay as tinyint) CustomDisplay,
								IsNull(cast(c.CustomDisplayModule as nvarchar(max)),cast(p.CustomDisplayModule as nvarchar(max))) CustomDisplayModule
							from [Ontology.].ClassProperty c
								left outer join [Ontology.].PropertyGroupProperty p
								on c.Property = p.PropertyURI
							where c._ClassNode in (
								select * from #subjectTypes where @predicate is null and @objectType is null
								union all
								select @NetworkNode
									where @subjectType is not null and @predicate is not null and @objectType is null
								union all
								select @ConnectionNode
									where @subjectType is not null and @predicate is not null and @objectType is not null
							)
							and 1 = (case	when c._NetworkPropertyNode is null and @predicate is null then 1
											when c._NetworkPropertyNode is null and @predicate is not null and @objectType is null and c._ClassNode = @NetworkNode then 1
											when c._NetworkPropertyNode is null and @predicate is not null and @objectType is not null and c._ClassNode = @ConnectionNode then 1
											when c._NetworkPropertyNode = @predicate and @objectType is not null then 1
											else 0 end)
							and (c.CustomDisplay = 0 OR (c.CustomDisplay = 1 and c.CustomDisplayModule is not null))
						) t
					group by NodeID
				) a
				where p._PropertyNode = a.NodeID and p._PropertyGroupNode = g._PropertyGroupNode
				order by p.SortOrder
				for xml path('Property'), type
			) x
			from [ontology.].PropertyGroup g
		) t
		where x is not null
		order by SortOrder
		for xml path('PropertyGroup'), type
	)

	-------------------------------------------------------------------------------
	-- Combine the PresentationXML with property information
	-------------------------------------------------------------------------------

	select @PresentationXML = (
		select
			PresentationXML.value('Presentation[1]/@PresentationClass[1]','varchar(max)') "@PresentationClass",
			PresentationXML.value('Presentation[1]/PageOptions[1]/@Columns[1]','varchar(max)') "PageOptions/@Columns",
			PresentationXML.query('Presentation[1]/WindowName[1]'),
			PresentationXML.query('Presentation[1]/PageColumns[1]'),
			PresentationXML.query('Presentation[1]/PageTitle[1]'),
			PresentationXML.query('Presentation[1]/PageBackLinkName[1]'),
			PresentationXML.query('Presentation[1]/PageBackLinkURL[1]'),
			PresentationXML.query('Presentation[1]/PageSubTitle[1]'),
			PresentationXML.query('Presentation[1]/PageDescription[1]'),
			PresentationXML.query('Presentation[1]/PanelTabType[1]'),
			PresentationXML.query('Presentation[1]/PanelList[1]'),
			PresentationXML.query('Presentation[1]/ExpandRDFList[1]'),
			@PropertyListXML "PropertyList",
			@SecurityGroupListXML "SecurityGroupList"
		from [Ontology.Presentation].[XML]
		where presentationid = @PresentationID
		for xml path('Presentation'), type
	)
	
	select @PresentationXML PresentationXML

END
GO
