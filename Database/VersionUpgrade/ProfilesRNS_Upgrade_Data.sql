/*

Run this script on:

	Profiles RNS Version 1.0.1

to update its data to:

	Profiles RNS Version 1.0.2

*** You are recommended to back up your database before running this script!

*** Make sure you run the ProfilesRNS_Upgrade_Schema.sql file before running this file.

*** Make sure the file path of InstallData.xml is correct in line 25.

*/


---------------------------------------------------
-- Update the InstallData file
---------------------------------------------------

TRUNCATE TABLE [Framework.].[InstallData]
EXEC [Framework.].[LoadXMLFile] @FilePath = 'c:\InstallData.xml', @TableDestination = '[Framework.].[InstallData]', @DestinationColumn = 'DATA'

---------------------------------------------------
-- Update the PresentationXML
---------------------------------------------------

TRUNCATE TABLE [Ontology.Presentation].[XML]

INSERT INTO [Ontology.Presentation].[XML] (
		PresentationID,
		type,
		subject,
		predicate,
		object,
		presentationXML,
		_SubjectNode,
		_PredicateNode,
		_ObjectNode
        )
	SELECT	R.x.value('PresentationID[1]', 'varchar(max)') ,
		R.x.value('type[1]', 'varchar(max)') ,
		R.x.value('subject[1]', 'varchar(max)'),
		R.x.value('predicate[1]', 'varchar(max)'),
		R.x.value('object[1]', 'varchar(max)'),
		(case when CAST(R.x.query('presentationXML[1]/*') AS NVARCHAR(MAX))<>'' then R.x.query('presentationXML[1]/*') else NULL end) , 
		R.x.value('_SubjectNode[1]', 'varchar(max)'),
		R.x.value('_PredicateNode[1]', 'varchar(max)'),
		R.x.value('_ObjectNode[1]', 'varchar(max)')
	FROM (
		SELECT TOP 1 Data.query('Import[1]/Table[@Name=''[Ontology.Presentation].[XML]'']') x
		FROM [Framework.].[InstallData]
		ORDER BY InstallDataID DESC
	) t
	CROSS APPLY x.nodes('//Row') AS R (x)

EXEC [Ontology.].[UpdateDerivedFields]

