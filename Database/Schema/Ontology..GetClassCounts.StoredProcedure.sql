SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.].[GetClassCounts]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @s as xml
	select @s = (
		select 
			(
				select	
					g.ClassGroupURI as "@rdf_.._resource", 
					g._ClassGroupLabel as "rdfs_.._label", 
					'http://www.w3.org/2001/XMLSchema#int' as "prns_.._numberOfConnections/@rdf_.._datatype",
					g._NumberOfNodes as "prns_.._numberOfConnections",
					(select	c.ClassURI as "@rdf_.._resource",
							c._ClassLabel as "rdfs_.._label",
							'http://www.w3.org/2001/XMLSchema#int' as "prns_.._numberOfConnections/@rdf_.._datatype",
							c._NumberOfNodes as "prns_.._numberOfConnections"
						from [Ontology.].[ClassGroupClass] c
						where c.ClassGroupURI = g.ClassGroupURI
						order by c.SortOrder
						for xml path('prns_.._matchesClass'), type
					)
				from [Ontology.].[ClassGroup] g
				order by g.SortOrder
				for xml path('prns_.._matchesClassGroup'), type
			)
		for xml path('rdf_.._Description'), type
	)

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + replace(cast(@s as nvarchar(max)),'_.._',':') + '</rdf:RDF>'
	select cast(@x as xml) RDF

END
GO
