select * from [Ontology.].[ClassProperty] where CustomDisplayModule is not null;

  
update [Ontology.].[ClassProperty] set ViewSecurityGroup = 0, EditSecurityGroup = 0 WHERE 
Property = 'http://orng.info/ontology/orng#hasucsfprofile';

DECLARE @propertyNode  BIGINT;
SELECT @propertyNode = _PropertyNode FROM [Ontology.].[ClassProperty] WHERE 
Property = 'http://orng.info/ontology/orng#hasucsfprofile';

SELECT @propertyNode
select * from [RDF.].Triple where Predicate = @propertyNode
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

-- to unregister everyone.
-- run and execute the result  
select 'exec [ORNG.].[RegisterAppPerson] @Subject = ' + CAST(nodeid as varchar) + ', @appId = 116, @visibility = ''Nobody'';' FROM
[ORNG.].appregistry where appid = 116;

delete from  [ORNG.].appregistry where appid = 116;

SELECT PersonFilterID FROM [ORNG.].[Apps] WHERE appId = 116;
DELETE FROM [Profile.Data].[Person.FilterRelationship] WHERE personFilterId = (SELECT PersonFilterID FROM [ORNG.].[Apps] WHERE appId = 116);

select *  from [ORNG.].appregistry where appid = 116;
SELECT * FROM [Profile.Data].[Person.FilterRelationship] WHERE personFilterId = (SELECT PersonFilterID FROM [ORNG.].[Apps] WHERE appId = 116);
