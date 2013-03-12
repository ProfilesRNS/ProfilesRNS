/*

Run this script on:

	Profiles RNS Version 1.0.2

to update its data to:

	Profiles RNS Version 1.0.3

*** You are recommended to back up your database before running this script!

*** Make sure you run the ProfilesRNS_Upgrade_Schema.sql file before running this file.

*** Make sure the file path of InstallData.xml is correct in line 25.

*/


---------------------------------------------------
-- Update the InstallData file
---------------------------------------------------

TRUNCATE TABLE [Framework.].[InstallData]
EXEC [Framework.].[LoadXMLFile] @FilePath = 'C:\InstallData.xml', @TableDestination = '[Framework.].[InstallData]', @DestinationColumn = 'DATA'
DELETE FROM [Ontology.Import].OWL where Name = 'PRNS_1.0'
EXEC [Framework.].[LoadXMLFile] @FilePath = 'C:\PRNS_1.0.owl', @TableDestination = '[Ontology.Import].owl', @DestinationColumn = 'DATA', @NameValue = 'PRNS_1.0'


 DECLARE @x XML
 SELECT @x = ( SELECT TOP 1
                        Data
               FROM     [Framework.].[InstallData]
               ORDER BY InstallDataID DESC
             ) 


---------------------------------------------------------------
-- [Framework.]
---------------------------------------------------------------
       
-- [Framework.].[RestPath] 
truncate table [Framework.].RestPath
INSERT INTO [Framework.].RestPath
        ( ApplicationName, Resolver )   
SELECT  R.x.value('ApplicationName[1]', 'varchar(max)') ,
        R.x.value('Resolver[1]', 'varchar(max)') 
FROM    ( SELECT
                    @x.query
                    ('Import[1]/Table[@Name=''[Framework.].[RestPath]'']')
                    x
        ) t
CROSS APPLY x.nodes('//Row') AS R ( x )

   
--[Framework.].[Job]
truncate table [Framework.].Job
INSERT INTO [Framework.].Job
        ( JobID,
		  JobGroup,
          Step,
          IsActive,
          Script
        ) 
SELECT	R.x.value('JobID[1]','varchar(max)'),
		R.x.value('JobGroup[1]','varchar(max)'),
		R.x.value('Step[1]','varchar(max)'),
		R.x.value('IsActive[1]','varchar(max)'),
		R.x.value('Script[1]','varchar(max)')
FROM    ( SELECT
                  @x.query
                  ('Import[1]/Table[@Name=''[Framework.].[Job]'']')
                  x
      ) t
CROSS APPLY x.nodes('//Row') AS R ( x )

---------------------------------------------------------------
-- [Ontology.]
---------------------------------------------------------------
 
 --[Ontology.].[ClassGroup]
 TRUNCATE TABLE [Ontology.].[ClassGroup]
 INSERT INTO [Ontology.].ClassGroup
         ( ClassGroupURI,
           SortOrder,
           IsVisible
         )
  SELECT  R.x.value('ClassGroupURI[1]', 'varchar(max)') ,
          R.x.value('SortOrder[1]', 'varchar(max)'),
          R.x.value('IsVisible[1]', 'varchar(max)')
  FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.].[ClassGroup]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x ) 
  
   
--[Ontology.].[ClassProperty]
truncate table [Ontology.].ClassProperty
INSERT INTO [Ontology.].ClassProperty
        ( ClassPropertyID,
          Class,
          NetworkProperty,
          Property,
          IsDetail,
          Limit,
          IncludeDescription,
          IncludeNetwork,
          SearchWeight,
          CustomDisplay,
          CustomEdit,
          ViewSecurityGroup,
          EditSecurityGroup,
          EditPermissionsSecurityGroup,
          EditExistingSecurityGroup,
          EditAddNewSecurityGroup,
          EditAddExistingSecurityGroup,
          EditDeleteSecurityGroup,
          MinCardinality,
          MaxCardinality,
          CustomDisplayModule,
          CustomEditModule
        )
SELECT  R.x.value('ClassPropertyID[1]','varchar(max)'),
		R.x.value('Class[1]','varchar(max)'),
		R.x.value('NetworkProperty[1]','varchar(max)'),
		R.x.value('Property[1]','varchar(max)'),
		R.x.value('IsDetail[1]','varchar(max)'),
		R.x.value('Limit[1]','varchar(max)'),
		R.x.value('IncludeDescription[1]','varchar(max)'),
		R.x.value('IncludeNetwork[1]','varchar(max)'),
		R.x.value('SearchWeight[1]','varchar(max)'),
		R.x.value('CustomDisplay[1]','varchar(max)'),
		R.x.value('CustomEdit[1]','varchar(max)'),
		R.x.value('ViewSecurityGroup[1]','varchar(max)'),
		R.x.value('EditSecurityGroup[1]','varchar(max)'),
		R.x.value('EditPermissionsSecurityGroup[1]','varchar(max)'),
		R.x.value('EditExistingSecurityGroup[1]','varchar(max)'),
		R.x.value('EditAddNewSecurityGroup[1]','varchar(max)'),
		R.x.value('EditAddExistingSecurityGroup[1]','varchar(max)'),
		R.x.value('EditDeleteSecurityGroup[1]','varchar(max)'),
		R.x.value('MinCardinality[1]','varchar(max)'),
		R.x.value('MaxCardinality[1]','varchar(max)'),
		(case when CAST(R.x.query('CustomDisplayModule[1]/*') AS NVARCHAR(MAX))<>'' then R.x.query('CustomDisplayModule[1]/*') else NULL end),
		(case when CAST(R.x.query('CustomEditModule[1]/*') AS NVARCHAR(MAX))<>'' then R.x.query('CustomEditModule[1]/*') else NULL end)
  FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.].[ClassProperty]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )

  
  --[Ontology.].[DataMap]
  TRUNCATE TABLE [Ontology.].DataMap
  INSERT INTO [Ontology.].DataMap
          ( DataMapID,
			DataMapGroup ,
            IsAutoFeed ,
            Graph ,
            Class ,
            NetworkProperty ,
            Property ,
            MapTable ,
            sInternalType ,
            sInternalID ,
            cClass ,
            cInternalType ,
            cInternalID ,
            oClass ,
            oInternalType ,
            oInternalID ,
            oValue ,
            oDataType ,
            oLanguage ,
            oStartDate ,
            oStartDatePrecision ,
            oEndDate ,
            oEndDatePrecision ,
            oObjectType ,
            Weight ,
            OrderBy ,
            ViewSecurityGroup ,
            EditSecurityGroup ,
            [_ClassNode] ,
            [_NetworkPropertyNode] ,
            [_PropertyNode]
          )
  SELECT    R.x.value('DataMapID[1]','varchar(max)'),
			R.x.value('DataMapGroup[1]','varchar(max)'),
			R.x.value('IsAutoFeed[1]','varchar(max)'),
			R.x.value('Graph[1]','varchar(max)'),
			R.x.value('Class[1]','varchar(max)'),
			R.x.value('NetworkProperty[1]','varchar(max)'),
			R.x.value('Property[1]','varchar(max)'),
			R.x.value('MapTable[1]','varchar(max)'),
			R.x.value('sInternalType[1]','varchar(max)'),
			R.x.value('sInternalID[1]','varchar(max)'),
			R.x.value('cClass[1]','varchar(max)'),
			R.x.value('cInternalType[1]','varchar(max)'),
			R.x.value('cInternalID[1]','varchar(max)'),
			R.x.value('oClass[1]','varchar(max)'),
			R.x.value('oInternalType[1]','varchar(max)'),
			R.x.value('oInternalID[1]','varchar(max)'),
			R.x.value('oValue[1]','varchar(max)'),
			R.x.value('oDataType[1]','varchar(max)'),
			R.x.value('oLanguage[1]','varchar(max)'),
			R.x.value('oStartDate[1]','varchar(max)'),
			R.x.value('oStartDatePrecision[1]','varchar(max)'),
			R.x.value('oEndDate[1]','varchar(max)'),
			R.x.value('oEndDatePrecision[1]','varchar(max)'),
			R.x.value('oObjectType[1]','varchar(max)'),
			R.x.value('Weight[1]','varchar(max)'),
			R.x.value('OrderBy[1]','varchar(max)'),
			R.x.value('ViewSecurityGroup[1]','varchar(max)'),
			R.x.value('EditSecurityGroup[1]','varchar(max)'),
			R.x.value('_ClassNode[1]','varchar(max)'),
			R.x.value('_NetworkPropertyNode[1]','varchar(max)'),
			R.x.value('_PropertyNode[1]','varchar(max)')
  FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.].[DataMap]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )
  
  
  
	--[Ontology.].[PropertyGroupProperty]
	truncate table [Ontology.].PropertyGroupProperty
	INSERT INTO [Ontology.].PropertyGroupProperty
	        ( PropertyGroupURI ,
	          PropertyURI ,
	          SortOrder ,
	          CustomDisplayModule ,
	          CustomEditModule ,
	          [_PropertyGroupNode] ,
	          [_PropertyNode] ,
	          [_TagName] ,
	          [_PropertyLabel] ,
	          [_NumberOfNodes]
	        ) 
	SELECT	R.x.value('PropertyGroupURI[1]','varchar(max)'),
			R.x.value('PropertyURI[1]','varchar(max)'),
			R.x.value('SortOrder[1]','varchar(max)'),
			(case when CAST(R.x.query('CustomDisplayModule[1]/*') AS NVARCHAR(MAX))<>'' then R.x.query('CustomDisplayModule[1]/*') else NULL end),
			(case when CAST(R.x.query('CustomEditModule[1]/*') AS NVARCHAR(MAX))<>'' then R.x.query('CustomEditModule[1]/*') else NULL end),
			R.x.value('_PropertyGroupNode[1]','varchar(max)'),
			R.x.value('_PropertyNode[1]','varchar(max)'),
			R.x.value('_TagName[1]','varchar(max)'),
			R.x.value('_PropertyLabel[1]','varchar(max)'),
			R.x.value('_NumberOfNodes[1]','varchar(max)')
	 FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.].[PropertyGroupProperty]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )
  

---------------------------------------------------------------
-- [Ontology.Presentation]
---------------------------------------------------------------


 --[Ontology.Presentation].[XML]
 TRUNCATE TABLE [Ontology.Presentation].[XML]
 INSERT INTO [Ontology.Presentation].[XML]
         ( PresentationID,
			type ,
           subject ,
           predicate ,
           object ,
           presentationXML ,
           _SubjectNode ,
           _PredicateNode ,
           _ObjectNode
         )       
  SELECT  R.x.value('PresentationID[1]', 'varchar(max)') ,
		  R.x.value('type[1]', 'varchar(max)') ,
          R.x.value('subject[1]', 'varchar(max)'),
          R.x.value('predicate[1]', 'varchar(max)'),
          R.x.value('object[1]', 'varchar(max)'),
          (case when CAST(R.x.query('presentationXML[1]/*') AS NVARCHAR(MAX))<>'' then R.x.query('presentationXML[1]/*') else NULL end) , 
          R.x.value('_SubjectNode[1]', 'varchar(max)'),
          R.x.value('_PredicateNode[1]', 'varchar(max)'),
          R.x.value('_ObjectNode[1]', 'varchar(max)')
  FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.Presentation].[XML]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )


EXEC [Framework.].[RunJobGroup] @JobGroup = 1
EXEC [Framework.].[RunJobGroup] @JobGroup = 7
EXEC [Framework.].[RunJobGroup] @JobGroup = 8
EXEC [Framework.].[RunJobGroup] @JobGroup = 9
EXEC [Framework.].[RunJobGroup] @JobGroup = 3