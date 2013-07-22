SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[GetPropertyList]
	@RDF xml = NULL,
	@RDFStr nvarchar(max) = NULL,
	@PresentationXML xml,
	@RootPath nvarchar(max) = 'rdf:RDF[1]/rdf:Description[1]',
	@ShowAllProperties bit = 0,
	@CountsOnly bit = 0,
	@PropertyGroupURI varchar(400) = NULL,
	@PropertyURI varchar(400) = NULL,
	@returnTable bit = 0,
	@returnXML bit = 1,
	@returnXMLasStr bit = 0,
	@PropertyListXML xml = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-----------------------------------------------------
	-- Copy the @RDFStr value to the @RDF variable
	-----------------------------------------------------

	if (@RDF is null and @RDFStr is not null)
		select @RDF = cast(replace(@RDFStr,char(13),'&#13;') as xml)

	-----------------------------------------------------
	-- Define temp tables and variables
	-----------------------------------------------------
		
	create table #RDFData (
		ItemSortOrder int identity(0,1) primary key,
		TagName varchar(400),
		ObjectValue nvarchar(max),
		ObjectURI varchar(400),
		ObjectClass varchar(400),
		ObjectClassName varchar(max)
	)

	declare @sql nvarchar(max)



	-----------------------------------------------------
	-- Parse the RDF data
	-----------------------------------------------------

	select @sql = ''
	select @sql = @sql + ' '''+URI+''' as '+Prefix+','
		from [Ontology.].Namespace
	select @sql = left(@sql,len(@sql)-1)
		
	select @sql = '
		;WITH XMLNAMESPACES (
			'+@sql+'
		), RDFDescriptions as (
			select	z.value(''@rdf:about'',''varchar(max)'') About,
					z.value(''rdfs:label[1]'',''varchar(max)'') Label,
					(select top 1 t.ClassURI
						from (select x.value(''@rdf:resource[1]'',''varchar(max)'') ClassURI
								from z.nodes(''rdf:type'') as t(x)
							) t
							left outer join [Ontology.].ClassTreeDepth d
							on t.ClassURI = d.Class
						order by (case when d._TreeDepth is null then 1 else 0 end), d._TreeDepth desc
					) Class
			from (select @RDF as x) t cross apply x.nodes(''rdf:RDF[1]/rdf:Description'') as R(z)
		), RDFTagsTemp as (
			select	z.value(''namespace-uri(.)'',''varchar(max)'') NamespaceURI,
					z.value(''local-name(.)'',''varchar(max)'') LocalName,
					z.value(''@rdf:resource'',''varchar(max)'') Resource,
					z.value(''.'',''nvarchar(max)'') Value
			from (select @RDF.query('''+@RootPath+''') as x) t cross apply x.nodes(''rdf:Description/*'') as R(z)
		)
		select	o.Prefix+'':''+b.LocalName TagName, 
					Coalesce(a.Label,b.Resource,b.Value) ObjectValue, 
					b.Resource ObjectURI,
					a.Class ObjectClass,
					c.Label ObjectClassName
			from RDFTagsTemp b 
				inner join [Ontology.].[Namespace] o on o.URI = b.NamespaceURI
				left outer join RDFDescriptions a on b.Resource = a.About
				left outer join RDFDescriptions c on a.Class = c.About
		'
		
	insert into #RDFData (TagName, ObjectValue, ObjectURI, ObjectClass, ObjectClassName)
			EXEC sp_executesql @sql, N'@RDF xml', @RDF = @RDF

	--create nonclustered index idx_TagName on #RDFData(TagName)

	-----------------------------------------------------
	-- Parse the PresentationXML
	-----------------------------------------------------

	select p.*, s.Label ViewSecurityGroupLabel
		into #Properties
		from (
			select	R.p.value('../@URI','varchar(400)') PropertyGroupURI,
					R.p.value('../@Label','varchar(max)') PropertyGroupLabel,
					R.p.value('../@SortOrder','int') PropertyGroupSortOrder,
					R.p.value('@URI','varchar(400)') PropertyURI,
					R.p.value('@Label','varchar(max)') PropertyLabel,
					R.p.value('@SortOrder','int') PropertySortOrder,
					R.p.value('@TagName','varchar(400)') TagName,
					R.p.value('@CustomDisplay','varchar(max)') CustomDisplay,
					R.p.value('@CustomEdit','varchar(max)') CustomEdit,
					R.p.value('@ViewSecurityGroup','bigint') ViewSecurityGroup,
					R.p.value('@EditPermissions','varchar(max)') EditPermissions,
					R.p.value('@EditExisting','varchar(max)') EditExisting,
					R.p.value('@EditAddNew','varchar(max)') EditAddNew,
					R.p.value('@EditAddExisting','varchar(max)') EditAddExisting,
					R.p.value('@EditDelete','varchar(max)') EditDelete,
					R.p.value('@MinCardinality','varchar(max)') MinCardinality,
					R.p.value('@MaxCardinality','varchar(max)') MaxCardinality,
					R.p.value('@ObjectType','bit') ObjectType,
					R.p.value('@HasDataFeed','varchar(max)') HasDataFeed,
					(case when cast(R.p.query('./*') as nvarchar(max))='' then null else R.p.query('./*') end) CustomModule
				from (select @PresentationXML x) t cross apply t.x.nodes('Presentation/PropertyList/PropertyGroup/Property') as R(p)
		) p left outer join (
			select	R.p.value('@ID','bigint') ID,
					R.p.value('@Label','varchar(max)') Label
				from (select @PresentationXML x) t cross apply t.x.nodes('Presentation/SecurityGroupList/SecurityGroup') as R(p)
		) s on p.ViewSecurityGroup = s.ID
		where PropertyGroupURI = IsNull(@PropertyGroupURI,PropertyGroupURI)
			and PropertyURI = IsNull(@PropertyURI,PropertyURI)
			and (@ShowAllProperties = 1 or (TagName in (select TagName from #RDFData)))

	--create nonclustered index idx_TagName on #Properties(TagName)
	--create nonclustered index idx_PropertyGroupURI on #Properties(PropertyGroupURI)
	--create nonclustered index idx_PropertyURI on #Properties(PropertyURI)

	-----------------------------------------------------
	-- Create the Property List
	-----------------------------------------------------

	if @returnTable = 1 and @CountsOnly = 0
		select	p.PropertyGroupURI, p.PropertyGroupLabel, p.PropertyGroupSortOrder, IsNull(gn.Items,0) NumberOfPropertyGroupConnections,
				p.PropertyURI, p.PropertyLabel, p.PropertySortOrder, p.TagName, IsNull(pn.Items,0) NumberOfPropertyConnections,
				r.ItemSortOrder, r.ObjectValue, r.ObjectURI, r.ObjectClass, r.ObjectClassName,
				p.CustomDisplay, p.ViewSecurityGroup, p.ViewSecurityGroupLabel, p.CustomEdit,
				p.EditPermissions, p.EditExisting, p.EditAddNew, p.EditAddExisting, p.EditDelete,
				p.MinCardinality, p.MaxCardinality, p.OjbectType, p.HasDataFeed,
				p.CustomModule
			from #Properties p
				left outer join (
					select p.PropertyGroupURI, count(*) Items
						from #Properties p inner join #RDFData r
							on p.TagName = r.TagName
					group by p.PropertyGroupURI
				) gn on gn.PropertyGroupURI = p.PropertyGroupURI
				left outer join (
					select p.PropertyURI, count(*) Items
						from #Properties p inner join #RDFData r
							on p.TagName = r.TagName
					group by p.PropertyURI
				) pn on pn.PropertyURI = p.PropertyURI
				left outer join #RDFData r
					on p.TagName = r.TagName
			where (@ShowAllProperties = 1 or r.ItemSortOrder is not null)
			order by p.PropertyGroupSortOrder, p.PropertySortOrder, r.ItemSortOrder


	if @returnTable = 1 and @CountsOnly = 1
		select	p.PropertyGroupURI, p.PropertyGroupLabel, p.PropertyGroupSortOrder, IsNull(gn.Items,0) NumberOfPropertyGroupConnections,
				p.PropertyURI, p.PropertyLabel, p.PropertySortOrder, p.TagName, IsNull(pn.Items,0) NumberOfPropertyConnections,
				p.CustomDisplay, p.ViewSecurityGroup, p.ViewSecurityGroupLabel, p.CustomEdit,
				p.EditPermissions, p.EditExisting, p.EditAddNew, p.EditAddExisting, p.EditDelete,
				p.MinCardinality, p.MaxCardinality, p.ObjectType, p.HasDataFeed,
				p.CustomModule
			from #Properties p
				left outer join (
					select p.PropertyGroupURI, count(*) Items
						from #Properties p inner join #RDFData r
							on p.TagName = r.TagName
					group by p.PropertyGroupURI
				) gn on gn.PropertyGroupURI = p.PropertyGroupURI
				left outer join (
					select p.PropertyURI, count(*) Items
						from #Properties p inner join #RDFData r
							on p.TagName = r.TagName
					group by p.PropertyURI
				) pn on pn.PropertyURI = p.PropertyURI
			where (@ShowAllProperties = 1 or pn.PropertyURI is not null)
			order by p.PropertyGroupSortOrder, p.PropertySortOrder


	if (@returnTable = 0 or @returnXML = 1)
		select @PropertyListXML = (
			select (
				select	g.PropertyGroupURI "@URI",
						g.PropertyGroupLabel "@Label",
						g.PropertyGroupSortOrder "@SortOrder",
						(select	count(*)
							from #Properties p, #RDFData r
							where p.PropertyGroupURI = g.PropertyGroupURI and r.TagName = p.TagName
						) "@NumberOfConnections",
						(
							select	p.PropertyURI "@URI",
									p.PropertyLabel "@Label",
									p.PropertySortOrder "@SortOrder",
									p.TagName "@TagName",
									(select	count(*)
										from #RDFData r
										where r.TagName = p.TagName
									) "@NumberOfConnections",
									p.CustomDisplay "@CustomDisplay",
									p.ViewSecurityGroup "@ViewSecurityGroup",
									p.ViewSecurityGroupLabel "@ViewSecurityGroupLabel",
									p.CustomEdit "@CustomEdit",
									p.EditPermissions "@EditPermissions",
									p.EditExisting "@EditExisting",
									p.EditAddNew "@EditAddNew",
									p.EditAddExisting "@EditAddExisting",
									p.EditDelete "@EditDelete",
									p.MinCardinality "@MinCardinality",
									p.MaxCardinality "@MaxCardinality",
									p.ObjectType "@ObjectType",
									p.HasDataFeed "@HasDataFeed",
									p.CustomModule "CustomModule",
									(case when @CountsOnly = 1 then null else (
											select	row_number() over (order by r.ItemSortOrder) "Connection/@SortOrder",
													r.ObjectURI "Connection/@ResourceURI",
													r.ObjectClass "Connection/@ClassURI",
													r.ObjectClassName "Connection/@ClassName",
													r.ObjectValue "Connection"
												from #RDFData r
												where r.TagName = p.TagName
												order by r.ItemSortOrder
												for xml path(''), type
										) end) "Network"
								from #Properties p
								where p.PropertyGroupURI = g.PropertyGroupURI
								order by p.PropertySortOrder
								for xml path('Property'), type
						)
					from (select distinct PropertyGroupURI, PropertyGroupLabel, PropertyGroupSortOrder from #Properties) g
					order by g.PropertyGroupSortOrder
					for xml path('PropertyGroup'), type
			) "PropertyList"
			for xml path(''), type
		)
		
	if @PropertyListXML is null or (cast(@PropertyListXML as nvarchar(max)) = '')
		select @PropertyListXML = cast('<PropertyList />' as xml)
	
	if @returnXML = 1 and @returnXMLasStr = 0
		select @PropertyListXML PropertyList

	if @returnXML = 1 and @returnXMLasStr = 1
		select cast(@PropertyListXML as nvarchar(max)) PropertyList

END
GO
