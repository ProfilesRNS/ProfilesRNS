select * from [Ontology.].[ClassProperty] where CustomDisplayModule is not null;

  
update [Ontology.].[ClassProperty] set ViewSecurityGroup = 0, EditSecurityGroup = 0 WHERE 
Property = 'http://orng.info/ontology/orng#hasucsfprofile';

DECLARE @propertyNode  BIGINT;
SELECT @propertyNode = _PropertyNode FROM [Ontology.].[ClassProperty] WHERE 
Property = 'http://orng.info/ontology/orng#hasucsfprofile';

SELECT @propertyNode
select * from [RDF.].Triple t left outer join [RDF.].Node n on t.object = n.nodeid where t.Predicate = @propertyNode
UPDATE [RDF.].Triple SET ViewSecurityGroup = 0 where Predicate = @propertyNode;

select * from [RDF.].Triple where Predicate = 14891924 and Subject = 370012;


-- turn back on
update [Ontology.].[ClassProperty] set ViewSecurityGroup = -1, EditSecurityGroup = -20 WHERE 
Property = 'http://orng.info/ontology/orng#hasucsfprofile';

DECLARE @propertyNode  BIGINT;
SELECT @propertyNode = _PropertyNode FROM [Ontology.].[ClassProperty] WHERE 
Property = 'http://orng.info/ontology/orng#hasucsfprofile';

SELECT @propertyNode
select * from [RDF.].Triple where Predicate = @propertyNode
UPDATE [RDF.].Triple SET ViewSecurityGroup = -1 where Predicate = @propertyNode;

select * from [RDF.].Triple where Predicate = 14891924 and Subject = 368113;

exec [RDF.].GetDataRDF 368113;

select * from [ORNG.].AppRegistry where AppID = 116;

select 'exec [ORNG.].RemoveAppFromPerson @SubjectID = ' + cast(nodeid as varchar) + ', @AppID = 116;'
from [ORNG.].AppRegistry where AppID = 116;

DECLARE @propertyNode  BIGINT;
SELECT @propertyNode = _PropertyNode FROM [Ontology.].[ClassProperty] WHERE 
Property = 'http://orng.info/ontology/orng#hasucsfprofile';

SELECT @propertyNode
delete from [RDF.].Triple where Predicate = @propertyNode ;
--select * from [RDF.].Node where NodeID in (select [Object] from [RDF.].Triple where Predicate = @propertyNode)
delete from [ORNG.].AppRegistry where AppID = 116;

select 'exec [ORNG.].AddAppToPerson @SubjectID = ' + cast(nodeid as varchar) + ', @AppID = 116;'
from [ORNG.].AppRegistry where AppID = 116; --2190
