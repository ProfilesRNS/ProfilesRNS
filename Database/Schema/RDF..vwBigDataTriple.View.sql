SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.].[vwBigDataTriple] AS
SELECT    
'<' + s.VALUE + '> ' + 
'<' + p.value + '> ' + 
CASE WHEN o.objecttype = 1 THEN  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(o.VALUE,'\','\\'),'"','\"'),CHAR(10),'\n'),CHAR(13),'\r'),CHAR(9),'\t')    
	 else '<'  + o.value + '>' end
+ ' .' + CHAR(13) + CHAR(10) triple
FROM [RDF.].Triple t, [RDF.].Node s, [RDF.].Node p, [RDF.].Node o
WHERE t.subject=s.nodeid AND t.predicate=p.nodeid AND t.object=o.nodeid
AND s.ViewSecurityGroup  =-1 AND  p.ViewSecurityGroup =-1  and o.ViewSecurityGroup =-1 AND t.ViewSecurityGroup =-1
GO
