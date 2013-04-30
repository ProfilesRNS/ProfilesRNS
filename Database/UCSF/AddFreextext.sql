select * from sys.fulltext_catalogs;

-- create new row for freetextKeyword property
insert [Ontology.].[ClassProperty] 
SELECT 865
      ,[Class]
      ,[NetworkProperty]
      ,'http://vivoweb.org/ontology/core#freetextKeyword'
      ,[IsDetail]
      ,[Limit]
      ,[IncludeDescription]
      ,[IncludeNetwork]
      ,[SearchWeight]
      ,[CustomDisplay]
      ,[CustomEdit]
      ,[ViewSecurityGroup]
      ,[EditSecurityGroup]
      ,[EditPermissionsSecurityGroup]
      ,[EditExistingSecurityGroup]
      ,[EditAddNewSecurityGroup]
      ,[EditAddExistingSecurityGroup]
      ,[EditDeleteSecurityGroup]
      ,[MinCardinality]
      ,[MinCardinality]
      ,[CustomDisplayModule]
      ,[CustomEditModule]
      ,[_ClassNode]
      ,[_NetworkPropertyNode]
      ,[_PropertyNode]
      ,[_TagName]
      ,[_PropertyLabel]
      ,[_ObjectType]
      ,[_NumberOfNodes]
      ,[_NumberOfTriples]
  FROM [Ontology.].[ClassProperty] where ClassPropertyID = 844;

-- run this thing to update derived fields
exec [Ontology.].[UpdateDerivedFields];

-- check work
select * from [Ontology.].[ClassProperty] where ClassPropertyID in (844, 865);

