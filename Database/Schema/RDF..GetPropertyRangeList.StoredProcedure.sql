SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[GetPropertyRangeList]
	@PropertyID BIGINT = NULL,
	@PropertyURI VARCHAR(400) = NULL,
	@returnTable BIT = 0,
	@returnXML BIT = 1,
	@PropertyRangeListXML XML = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@PropertyURI IS NULL) AND (@PropertyID IS NOT NULL)
		SELECT @PropertyURI = Value
			FROM [RDF.].Node
			WHERE NodeID = @PropertyID

	declare @LabelID bigint
	declare @SubClassOfID bigint
	select	@LabelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label'),
			@SubClassOfID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#subClassOf')

	create table #range (
		ClassID bigint primary key,
		ClassURI varchar(400),
		Label varchar(400),
		Depth int,
		SortOrder float,
	)
	
	insert into #range (ClassID, Label, Depth, SortOrder)
		select p.ValueNode, n.Value, 0, row_number() over (order by n.Value)
			from [ontology.].vwPropertyTall p, [RDF.].Triple t, [RDF.].Node n
			where p.property = @PropertyURI
				and p.predicate = 'http://www.w3.org/2000/01/rdf-schema#range'
				and t.subject = p.ValueNode
				and t.predicate = @LabelID
				and t.object = n.NodeID

	declare @done bit
	select @done = 0
	while @done = 0
	begin
		insert into #range (ClassID, Label, Depth, SortOrder)
			select t.subject, left(n.Value,400), r.depth+1,
					r.SortOrder + power(cast(0.001 as float),r.depth+1)*(row_number() over (partition by r.classid order by n.value))
				from #range r, [RDF.].Triple t, [RDF.].Triple v, [RDF.].Node n
				where t.object = r.ClassID
					and t.predicate = @SubClassOfID
					and t.subject = v.subject
					and v.predicate = @LabelID
					and v.object = n.NodeID
					and t.subject not in (select ClassID from #range)
		if @@ROWCOUNT = 0
			select @done = 1
	end
	
	update r
		set r.ClassURI = n.Value
		from #range r, [RDF.].Node n
		where r.ClassID = n.NodeID

	if @returnTable = 1
		select * 
		from #range
		order by sortorder

	select @PropertyRangeListXML = (
			select (
					select	ClassID "@ClassID",
							ClassURI "@ClassURI",
							Depth "@Depth",
							Label "@Label"
						from #range
						order by SortOrder
						for xml path('PropertyRange'), type
				) "PropertyRangeList"
			for xml path(''), type
		)

	if @PropertyRangeListXML is null or (cast(@PropertyRangeListXML as nvarchar(max)) = '')
		select @PropertyRangeListXML = cast('<PropertyRangeList />' as xml)
	
	if @returnXML = 1
		select @PropertyRangeListXML PropertyRangeList

END
GO
