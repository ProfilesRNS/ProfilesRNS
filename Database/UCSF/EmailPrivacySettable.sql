/****** Script for SelectTopNRows command from SSMS  ******/
SELECT * FROM [profiles_102].[Ontology.].[ClassProperty] where Property like '%email%';
SELECT * FROM [profiles_103].[Ontology.].[ClassProperty] where Property like '%email%';
SELECT * FROM [harvard_103].[Ontology.].[ClassProperty] where Property like '%email%';

update [profiles_103].[Ontology.].[ClassProperty] set ViewSecurityGroup = -10
where ClassPropertyID in (812, 814); --predicate = 272, 168

update [profiles_103].[Ontology.].[ClassProperty] set EditSecurityGroup = -20, EditPermissionsSecurityGroup = -20
where ClassPropertyID = 804; --predicate = 355

SELECT * FROM [profiles_102].[Ontology.].[ClassProperty] where Property like '%address%';
SELECT * FROM [profiles_103].[Ontology.].[ClassProperty] where Property like '%address%';
SELECT * FROM [harvard_103].[Ontology.].[ClassProperty] where Property like '%address%';

update [profiles_103].[Ontology.].[ClassProperty] set EditSecurityGroup = -20, EditPermissionsSecurityGroup = -20
where ClassPropertyID = 840; -- Mailing Address predicate = 355
--STOP

SELECT * FROM [profiles_103].[Ontology.].[ClassProperty] where Property like '%phone%';

update [profiles_103].[Ontology.].[ClassProperty] set EditSecurityGroup = -40, EditPermissionsSecurityGroup = -40
where ClassPropertyID in (779, 780); -- Phone, predicate = 355

