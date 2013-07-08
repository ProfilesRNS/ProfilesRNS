SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[GetPresentationXML]
@subject BIGINT=NULL, @predicate BIGINT=NULL, @object BIGINT=NULL, @subjectType BIGINT=NULL, @objectType BIGINT=NULL, @SessionID UNIQUEIDENTIFIER=NULL, @EditMode BIT=0, @returnXML BIT=1, @PresentationXML XML=NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @typeID bigint
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')

	select @subject = null where @subject = 0
	select @predicate = null where @predicate = 0
	select @object = null where @object = 0

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
	select @PresentationType = (case when IsNull(@object,@objectType) is not null AND @predicate is not null AND IsNull(@subject,@subjectType) is not null then 'C'
									when @predicate is not null AND IsNull(@subject,@subjectType) is not null then 'N'
									when IsNull(@subject,@subjectType) is not null then 'P'
									else NULL end)

	-------------------------------------------------------------------------------
	-- Determine whether the user can edit this profile
	-------------------------------------------------------------------------------

	DECLARE @CanEdit BIT
	SELECT @CanEdit = 0
	DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT, @HasSpecialEditAccess BIT
	EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT, @HasSpecialEditAccess OUTPUT
	CREATE TABLE #SecurityGroupNodes (SecurityGroupNode BIGINT PRIMARY KEY)
	IF (@PresentationType = 'P') AND (@SessionID IS NOT NULL)
	BEGIN
		-- Get SecurityGroup nodes
		INSERT INTO #SecurityGroupNodes (SecurityGroupNode) EXEC [RDF.Security].GetSessionSecurityGroupNodes @SessionID, @Subject
		SELECT @CanEdit = 1
			FROM [RDF.].Node
			WHERE NodeID = @subject
				AND ( (EditSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )
		-- Get names/descriptions of different SecurityGroups
		IF @CanEdit = 1 AND @EditMode = 1
		BEGIN
			;WITH a AS (
				SELECT 1 x, m.NodeID SecurityGroupID, 'Only Me' Label, 'Only me and special authorized users who manage this website.' Description
					FROM [User.Session].[Session] s, [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
					WHERE s.SessionID = @SessionID AND s.UserID IS NOT NULL
						AND m.InternalID = s.UserID AND m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User' AND m.InternalType = 'User'
						AND n.NodeID = @Subject AND n.EditSecurityGroup = m.NodeID 
			), b AS (
				SELECT 2 x, n.EditSecurityGroup SecurityGroupID, 'Owner' Label, 'Only ' + IsNull(Max(o.Value),'') + ' and special authorized users who manage this website.' Description
					FROM [RDF.].Node n, [RDF.].Triple t, [RDF.].Node o
					WHERE n.NodeID = @Subject AND n.EditSecurityGroup > 0
						AND n.EditSecurityGroup NOT IN (SELECT SecurityGroupID FROM a)
						AND t.Subject = n.NodeID 
						AND t.Predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label') 
						AND t.Object = o.NodeID
						AND ( (n.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (n.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (n.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )
						AND ( (t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )
						AND ( (o.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (o.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (o.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )
					GROUP BY n.EditSecurityGroup
			), c AS (
				SELECT 3 x, SecurityGroupID, Label, Description
					FROM [RDF.Security].[Group]
					WHERE SecurityGroupID between @SecurityGroupID and -1
				UNION ALL SELECT * FROM a
				UNION ALL SELECT * FROM b
			)
			SELECT @SecurityGroupListXML = (
				SELECT	SecurityGroupID "@ID",
						Label "@Label",
						Description "@Description"
					FROM c
					ORDER BY x, SecurityGroupID
					FOR XML PATH('SecurityGroup'), TYPE
			)
		END
	END

	-------------------------------------------------------------------------------
	-- Get the PresentationID based on type
	-------------------------------------------------------------------------------

	declare @PresentationID int
	select @PresentationID = (
			select top 1 PresentationID
				from [Ontology.Presentation].[XML]
				where type = (case when @EditMode = 1 then 'E' else IsNull(@PresentationType,'P') end)
					AND	(_SubjectNode IS NULL
							OR _SubjectNode = @subjectType
							OR _SubjectNode IN (select object from [RDF.].Triple where @subject is not null and subject=@subject and predicate=@typeID)
						)
					AND	(_PredicateNode IS NULL
							OR _PredicateNode = @predicate
						)
					AND	(_ObjectNode IS NULL
							OR _ObjectNode = @objectType
							OR _ObjectNode IN (select object from [RDF.].Triple where @object is not null and subject=@object and predicate=@typeID)
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
	if @EditMode = 0
	begin
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
									select object 
										from [RDF.].Triple 
										where subject=@subject and predicate=@typeID and @predicate is null and @object is null
									union all
									select @NetworkNode
										where @subject is not null and @predicate is not null and @object is null
									union all
									select @ConnectionNode
										where @subject is not null and @predicate is not null and @object is not null
								)
								and 1 = (case	when c._NetworkPropertyNode is null and @predicate is null then 1
												when c._NetworkPropertyNode is null and @predicate is not null and @object is null and c._ClassNode = @NetworkNode then 1
												when c._NetworkPropertyNode is null and @predicate is not null and @object is not null and c._ClassNode = @ConnectionNode then 1
												when c._NetworkPropertyNode = @predicate and @object is not null then 1
												else 0 end)
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
	end
	else
	begin
		-- Edit properties
		select @PropertyListXML = (
			select PropertyGroupURI "@URI", _PropertyGroupLabel "@Label", SortOrder "@SortOrder", x.query('.')
			from (
				select PropertyGroupURI, _PropertyGroupLabel, SortOrder,
				(
					select	a.URI "@URI", 
							a.TagName "@TagName", 
							a.Label "@Label", 
							p.SortOrder "@SortOrder",
							IsNull(s.ViewSecurityGroup,a.ViewSecurityGroup) "@ViewSecurityGroup",
							(case when a.CustomEdit = 1 then 'true' else 'false' end) "@CustomEdit",
							(case when a.EditPermissions = 1 then 'true' else 'false' end) "@EditPermissions",
							(case when a.EditExisting = 1 then 'true' else 'false' end) "@EditExisting",
							(case when a.EditAddNew = 1 then 'true' else 'false' end) "@EditAddNew",
							(case when a.EditAddExisting = 1 then 'true' else 'false' end) "@EditAddExisting",
							(case when a.EditDelete = 1 then 'true' else 'false' end) "@EditDelete",
							a.MinCardinality "@MinCardinality",
							a.MaxCardinality "@MaxCardinality",
							a.ObjectType "@ObjectType",
							(case when a.HasDataFeed = 1 then 'true' else 'false' end) "@HasDataFeed",
							cast(a.CustomEditModule as xml)
					from [ontology.].PropertyGroupProperty p inner join (
						select NodeID,
							max(URI) URI, 
							max(TagName) TagName, 
							max(Label) Label,
							max(ViewSecurityGroup) ViewSecurityGroup,
							max(CustomEdit) CustomEdit,
							max(EditPermissions) EditPermissions,
							max(EditExisting) EditExisting,
							max(EditAddNew) EditAddNew,
							max(EditAddExisting) EditAddExisting,
							max(EditDelete) EditDelete,
							min(MinCardinality) MinCardinality,
							max(MaxCardinality) MaxCardinality,
							max(cast(ObjectType as tinyint)) ObjectType,
							max(HasDataFeed) HasDataFeed,
							max(CustomEditModule) CustomEditModule
						from (
								select
									c._PropertyNode NodeID,
									c.Property URI,
									c._TagName TagName,
									c._PropertyLabel Label,
									c.ViewSecurityGroup,
									cast(c.CustomEdit as tinyint) CustomEdit,
									(case when ( (EditPermissionsSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditPermissionsSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditPermissionsSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) ) then 1 else 0 end) EditPermissions,
									(case when ( (EditExistingSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditExistingSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditExistingSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) ) then 1 else 0 end) EditExisting,
									(case when ( (EditAddNewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditAddNewSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditAddNewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) ) then 1 else 0 end) EditAddNew,
									(case when ( (EditAddExistingSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditAddExistingSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditAddExistingSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) ) then 1 else 0 end) EditAddExisting,
									(case when ( (EditDeleteSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditDeleteSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditDeleteSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) ) then 1 else 0 end) EditDelete,
									c.MinCardinality,
									c.MaxCardinality,
									c._ObjectType ObjectType,
									(case when d._PropertyNode is null then 0 else 1 end) HasDataFeed,
									IsNull(cast(c.CustomEditModule as nvarchar(max)),cast(p.CustomEditModule as nvarchar(max))) CustomEditModule
								from [Ontology.].ClassProperty c
									left outer join (
										select distinct _ClassNode, _PropertyNode
										from [Ontology.].DataMap
										where NetworkProperty is null and _ClassNode is not null and _PropertyNode is not null and IsAutoFeed = 1
									) d
										on c._ClassNode = d._ClassNode and c._PropertyNode = d._PropertyNode
									left outer join [Ontology.].PropertyGroupProperty p
										on c.Property = p.PropertyURI
								where c._ClassNode in (
									select object 
										from [RDF.].Triple 
										where subject=@subject and predicate=@typeID and @predicate is null and @object is null
								)
								and c.Property is not null
								and c.NetworkProperty is null
								and ( (EditSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )
							) t
						group by NodeID
					) a
					on p._PropertyNode = a.NodeID and p._PropertyGroupNode = g._PropertyGroupNode
					left outer join [RDF.Security].NodeProperty s
					on s.NodeID = @subject and s.Property = p._PropertyNode 
					order by p.SortOrder
					for xml path('Property'), type
				) x
				from [ontology.].PropertyGroup g
			) t
			where x is not null
			order by SortOrder
			for xml path('PropertyGroup'), type
		)
	end	

	-------------------------------------------------------------------------------
	-- Combine the PresentationXML with property information
	-------------------------------------------------------------------------------

	select @PresentationXML = (
		select
			PresentationXML.value('Presentation[1]/@PresentationClass[1]','varchar(max)') "@PresentationClass",
			PresentationXML.value('Presentation[1]/PageOptions[1]/@Columns[1]','varchar(max)') "PageOptions/@Columns",
			(case when @CanEdit = 1 then 'true' else NULL end) "PageOptions/@CanEdit",
			(case when @CanEdit = 1 then 'true' else NULL end) "CanEdit",
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
	
	if @returnXML = 1
		select @PresentationXML PresentationXML

END
GO
