SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.].[vwClass] AS
	select Class, Label, ClassNode, LabelNode
		from (
			select s.Value Class, l.Value Label, s.NodeID ClassNode, l.NodeID LabelNode,
				row_number() over (partition by s.Value order by s.NodeID, l.NodeID) k
			from [RDF.].Triple t
				inner join [RDF.].Node s
					on t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
						and t.object = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#Class')
						and t.subject = s.NodeID
				left outer join [RDF.].Triple v
					on v.subject = t.subject
						and v.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')
				left outer join [RDF.].Node l
					on v.object = l.NodeID
		) t
		where k = 1
GO
