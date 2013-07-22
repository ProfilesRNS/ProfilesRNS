SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.].[UpdateDerivedFields]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Triple
	UPDATE o
		SET	_SubjectNode = [RDF.].fnURI2NodeID(subject),
			_PredicateNode = [RDF.].fnURI2NodeID(predicate),
			_ObjectNode = [RDF.].fnURI2NodeID(object),
			_TripleID = NULL
		FROM [Ontology.Import].[Triple] o
	UPDATE o
		SET o._TripleID = r.TripleID
		FROM [Ontology.Import].[Triple] o, [RDF.].Triple r
		WHERE o._SubjectNode = r.Subject AND o._PredicateNode = r.Predicate AND o._ObjectNode = r.Object

	-- DataMap
	UPDATE o
		SET	_ClassNode = [RDF.].fnURI2NodeID(Class),
			_NetworkPropertyNode = [RDF.].fnURI2NodeID(NetworkProperty),
			_PropertyNode = [RDF.].fnURI2NodeID(property)
		FROM [Ontology.].DataMap o

	-- ClassProperty
	UPDATE o
		SET	_ClassNode = [RDF.].fnURI2NodeID(Class),
			_NetworkPropertyNode = [RDF.].fnURI2NodeID(NetworkProperty),
			_PropertyNode = [RDF.].fnURI2NodeID(property),
			_TagName = (select top 1 n.Prefix+':'+substring(o.property,len(n.URI)+1,len(o.property)) t
						from [Ontology.].Namespace n
						where o.property like n.uri+'%'
						)
		FROM [Ontology.].ClassProperty o
	UPDATE e
		SET e._PropertyLabel = o.value
		FROM [ontology.].ClassProperty e
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON e._PropertyNode = t.subject AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label') 
			LEFT OUTER JOIN [RDF.].[Node] o
				ON t.object = o.nodeid
	UPDATE e
		SET e._ObjectType = (CASE WHEN o.value = 'http://www.w3.org/2002/07/owl#ObjectProperty' THEN 0 ELSE 1 END)
		FROM [ontology.].ClassProperty e
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON e._PropertyNode = t.subject AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type') 
			LEFT OUTER JOIN [RDF.].[Node] o
				ON t.object = o.nodeid and o.value in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')

	-- ClassGroup
	UPDATE o
		SET	_ClassGroupNode = [RDF.].fnURI2NodeID(ClassGroupURI)
		FROM [Ontology.].ClassGroup o
	UPDATE e
		SET e._ClassGroupLabel = o.value
		FROM [ontology.].ClassGroup e
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON e._ClassGroupNode = t.subject AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label') 
			LEFT OUTER JOIN [RDF.].[Node] o
				ON t.object = o.nodeid

	-- ClassGroupClass
	UPDATE o
		SET	_ClassGroupNode = [RDF.].fnURI2NodeID(ClassGroupURI),
			_ClassNode = [RDF.].fnURI2NodeID(ClassURI)
		FROM [Ontology.].ClassGroupClass o
	UPDATE e
		SET e._ClassLabel = o.value
		FROM [ontology.].ClassGroupClass e
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON e._ClassNode = t.subject AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label') 
			LEFT OUTER JOIN [RDF.].[Node] o
				ON t.object = o.nodeid
				
	-- ClassTreeDepth
	declare @ClassDepths table (
		NodeID bigint,
		SubClassOf bigint,
		Depth int,
		ClassURI varchar(400),
		ClassName varchar(400)
	)
	;with x as (
		select t.subject NodeID, 
			max(case when w.subject is null then null else v.object end) SubClassOf
		from [RDF.].Triple t
			left outer join [RDF.].Triple v
				on v.subject = t.subject 
				and v.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#subClassOf')
			left outer join [RDF.].Triple w
				on w.subject = v.object
				and w.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type') 
				and w.object = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#Class')
		where t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type') 
			and t.object = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#Class') 
		group by t.subject
	)
	insert into @ClassDepths (NodeID, SubClassOf, Depth, ClassURI)
		select x.NodeID, x.SubClassOf, (case when x.SubClassOf is null then 0 else null end) Depth, n.Value
		from x, [RDF.].Node n
		where x.NodeID = n.NodeID
	;with a as (
		select NodeID, SubClassOf, Depth
			from @ClassDepths
		union all
		select b.NodeID, IsNull(a.NodeID,b.SubClassOf), a.Depth+1
			from a, @ClassDepths b
			where b.SubClassOf = a.NodeID
				and a.Depth is not null
				and b.Depth is null
	), b as (
		select NodeID, SubClassOf, Max(Depth) Depth
		from a
		group by NodeID, SubClassOf
	)
	update c
		set c.Depth = b.Depth
		from @ClassDepths c, b
		where c.NodeID = b.NodeID
	;with a as (
		select c.NodeID, max(n.Value) ClassName
			from @ClassDepths c
				inner join [RDF.].Triple t
					on t.subject = c.NodeID
						and t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')
				inner join [RDF.].Node n
					on t.object = n.NodeID
			group by c.NodeID
	)
	update c
		set c.ClassName = a.ClassName
		from @ClassDepths c, a
		where c.NodeID = a.NodeID
	truncate table [Ontology.].ClassTreeDepth
	insert into [Ontology.].ClassTreeDepth (Class, _TreeDepth, _ClassNode, _ClassName)
		select ClassURI, Depth, NodeID, ClassName
			from @ClassDepths

	-- PropertyGroup
	UPDATE o
		SET	_PropertyGroupNode = [RDF.].fnURI2NodeID(PropertyGroupURI)
		FROM [Ontology.].PropertyGroup o
	UPDATE e
		SET e._PropertyGroupLabel = o.value
		FROM [ontology.].PropertyGroup e
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON e._PropertyGroupNode = t.subject AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label') 
			LEFT OUTER JOIN [RDF.].[Node] o
				ON t.object = o.nodeid

	-- PropertyGroupProperty
	UPDATE o
		SET	_PropertyGroupNode = [RDF.].fnURI2NodeID(PropertyGroupURI),
			_PropertyNode = [RDF.].fnURI2NodeID(PropertyURI),
			_TagName = (select top 1 n.Prefix+':'+substring(o.PropertyURI,len(n.URI)+1,len(o.PropertyURI)) t
						from [Ontology.].Namespace n
						where o.PropertyURI like n.uri+'%'
						)
		FROM [Ontology.].PropertyGroupProperty o
	UPDATE e
		SET e._PropertyLabel = o.value
		FROM [ontology.].PropertyGroupProperty e
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON e._PropertyNode = t.subject AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label') 
			LEFT OUTER JOIN [RDF.].[Node] o
				ON t.object = o.nodeid


	-- Presentation
	UPDATE o
		SET	_SubjectNode = [RDF.].fnURI2NodeID(subject),
			_PredicateNode = [RDF.].fnURI2NodeID(predicate),
			_ObjectNode = [RDF.].fnURI2NodeID(object)
		FROM [Ontology.Presentation].[XML] o


	-- select * from [Ontology.Import].[Triple]
	-- select * from [Ontology.].ClassProperty
	-- select * from [Ontology.].ClassGroup
	-- select * from [Ontology.].ClassGroupClass
	-- select * from [Ontology.].ClassTreeDepth
	-- select * from [Ontology.].PropertyGroup
	-- select * from [Ontology.].PropertyGroupProperty
	-- select * from [Ontology.Presentation].[XML]

END
GO
