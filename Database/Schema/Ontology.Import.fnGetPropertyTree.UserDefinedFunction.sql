SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Ontology.Import].[fnGetPropertyTree]
(
	-- Add the parameters for the function here
	@property nvarchar(1000) = NULL,
	@depth int = 0
)
RETURNS xml
AS
BEGIN
	-- Declare the return variable here
	DECLARE @x xml

	-- select [Ontology.Import].[fnGetPropertyTree](null,0)

	if @property is null
		select @x = (
				select Subject as "property/@name", @depth as "property/@depth", Object as "property/@type",
					[Ontology.Import].[fnGetPropertyTree](Subject,@depth+1) as "property"
				from (
					select Subject, Object
						from [Ontology.Import].[Triple] a
						where Object in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
							and not exists (
								select * 
								from [Ontology.Import].[Triple] b 
								where b.Predicate = 'http://www.w3.org/2000/01/rdf-schema#subPropertyOf'
									and b.Subject = a.Subject
							)
					union all
					select Object, 'http://www.w3.org/2002/07/owl#DatatypeProperty'
						from [Ontology.Import].[Triple] a
						where a.Predicate = 'http://www.w3.org/2000/01/rdf-schema#subPropertyOf'
							and not exists (
								select * from [Ontology.Import].[Triple] b
								where b.Object in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
									and a.Object = b.Subject
							)
				) t
				order by Subject
				for xml path(''), type
		)
	else
		select @x = (
				select Subject as "property/@name", @depth as "property/@depth", Object as "property/@type",
					[Ontology.Import].[fnGetPropertyTree](Subject,@depth+1) as "property"
				from [Ontology.Import].[Triple] a
				where Object in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
					and exists (
						select * 
						from [Ontology.Import].[Triple] b 
						where b.Predicate = 'http://www.w3.org/2000/01/rdf-schema#subPropertyOf'
							and b.Object = @property
							and b.Subject = a.Subject
					)
				order by Subject
				for xml path(''), type
		)

	-- Return the result of the function
	RETURN @x

END
GO
