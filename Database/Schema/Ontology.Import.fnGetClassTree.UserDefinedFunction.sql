SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Ontology.Import].[fnGetClassTree]
(
	-- Add the parameters for the function here
	@class nvarchar(1000) = NULL,
	@depth int = 0
)
RETURNS xml
AS
BEGIN
	-- Declare the return variable here
	DECLARE @x xml

	-- select [Ontology.Import].fnGetClassTree(null,0)

	if @class is null
		select @x = (
				select Subject as "class/@name", @depth as "class/@depth", @class as "class/@parent",
					[Ontology.Import].fnGetClassTree(Subject,@depth+1) as "class"
				from (
					select Subject
						from [Ontology.Import].[Triple] a
						where Object = 'http://www.w3.org/2002/07/owl#Class'
							and not exists (
								select * 
								from [Ontology.Import].[Triple] b 
								where b.Predicate = 'http://www.w3.org/2000/01/rdf-schema#subClassOf'
									and b.Object not like 'http://profiles.catalyst.harvard.edu/ontology/nodeID#%'
									and b.Subject = a.Subject
							)
					union all
					select Object
						from [Ontology.Import].[Triple] a
						where a.Predicate = 'http://www.w3.org/2000/01/rdf-schema#subClassOf'
							and not exists (
								select * from [Ontology.Import].[Triple] b
								where b.Object = 'http://www.w3.org/2002/07/owl#Class'
									and a.Object = b.Subject
							)
							and a.Object not like 'http://profiles.catalyst.harvard.edu/ontology/nodeID#%'
				) t
				order by Subject
				for xml path(''), type
		)
	else
		select @x = (
				select Subject as "class/@name", @depth as "class/@depth", @class as "class/@parent",
					[Ontology.Import].fnGetClassTree(Subject,@depth+1) as "class"
				from [Ontology.Import].[Triple] a
				where Object = 'http://www.w3.org/2002/07/owl#Class'
					and exists (
						select * 
						from [Ontology.Import].[Triple] b 
						where b.Predicate = 'http://www.w3.org/2000/01/rdf-schema#subClassOf'
							and b.Object = @class
							and b.Subject = a.Subject
					)
				order by Subject
				for xml path(''), type
		)

	-- Return the result of the function
	RETURN @x

END
GO
