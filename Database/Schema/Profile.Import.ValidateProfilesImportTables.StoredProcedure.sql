SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Import].[ValidateProfilesImportTables]	 
AS
BEGIN
	SET NOCOUNT ON;	

	BEGIN TRY

		DECLARE @errorstring VARCHAR(2000), @ErrMsg VARCHAR(2000),@errSeverity VARCHAR(20)

		CREATE TABLE #Msg (MsgStr NVARCHAR(2000))
		DECLARE @sql NVARCHAR(max)


		--*************************************************************************************************************
		--*************************************************************************************************************
		--*** Validate column lengths and use of null values.
		--*************************************************************************************************************
		--*************************************************************************************************************

		-- Create a list of all the loading table columns and their valid lengths and types
		DECLARE @columns TABLE (
			tableName VARCHAR(50),
			columnName VARCHAR(50),
			dataType VARCHAR(50),
			maxLength INT,
			columnType VARCHAR(50)
		)
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','internalusername','string',50,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','firstname','string',50,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','middlename','string',50,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','lastname','string',50,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','displayname','string',255,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','suffix','string',50,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','addressline1','string',55,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','addressline2','string',55,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','addressline3','string',55,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','addressline4','string',55,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','addressstring','string',1000,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','city','string',100,'Not Used')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','state','string',2,'Not Used')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','zip','string',10,'Not Used')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','building','string',255,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','room','string',255,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','floor','int',null,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','latitude','decimal',null,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','longitude','decimal',null,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','phone','string',35,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','fax','string',25,'Optional') 
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','emailaddr','string',255,'Optional') 
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','isactive','bit',null,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','isvisible','bit',null,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','internalusername','string',50,'Required') 
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','title','string',200,'Optional') 
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','emailaddr','string',200,'Dont Use')
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','primaryaffiliation','bit',null,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','affiliationorder','int',null,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','institutionname','string',500,'Optional') 
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','institutionabbreviation','string',50,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','departmentname','string',500,'Optional')  
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','departmentvisible','bit',null,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','divisionname','string',500,'Optional')  
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','facultyrank','string',100,'Optional') 
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','facultyrankorder','tinyint',null,'Optional')  
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonFilterFlag]  ','internalusername','string',50,'Required') 
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonFilterFlag]  ','personfilter','string',50,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','internalusername','string',50,'Required') 
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','firstname','string',100,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','lastname','string',100,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','displayname','string',255,'Required') 
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','institution','string',500,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','department','string',500,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','canbeproxy','bit',null,'Required')

		-- Check for values that are too long
		SELECT @sql = ''
		SELECT @sql = @sql + '
				INSERT INTO #Msg 
					SELECT ''ERROR: '+tableName+'.'+columnName+' has values longer than '+cast(maxLength as nvarchar(50))+' characters.''
					FROM '+tableName+'
					HAVING MAX(LEN(ISNULL('+columnName+',''''))) > '+cast(maxLength as nvarchar(50))+';'
			FROM @columns
			WHERE dataType = 'string'
		EXEC sp_executesql @sql 			 

		-- Check for values that should be numeric but are not
		SELECT @sql = ''
		SELECT @sql = @sql + '
				INSERT INTO #Msg 
					SELECT ''ERROR: '+tableName+'.'+columnName+' has values that are not numeric.''
					FROM '+tableName+' where '+tableName+'.'+columnName+' <>''''
					HAVING MIN(ISNUMERIC(ISNULL('+columnName+',0))) = 0;'
			FROM @columns
			WHERE columnName IN ('floor','assistantuserid')
		EXEC sp_executesql @sql 			 
  
		-- Check that Required columns do not have any NULLs
		SELECT @sql = ''
		SELECT @sql = @sql + '
				INSERT INTO #Msg 
					SELECT ''ERROR: '+tableName+'.'+columnName+' must contain only NULL values. It currently has at least one NOT NULL value.''
					FROM '+tableName+'
					HAVING MAX(CASE WHEN '+columnName+' IS NULL THEN 1 ELSE 0 END)=1;'
			FROM @columns
			WHERE columnType = 'Required'
		EXEC sp_executesql @sql 			 

		-- Check that Dont Use columns only have NULLs
		SELECT @sql = ''
		SELECT @sql = @sql + '
				INSERT INTO #Msg 
					SELECT ''ERROR: '+tableName+'.'+columnName+' must contain only NULL values. It currently has at least one NOT NULL value.''
					FROM '+tableName+' where '+tableName+'.'+columnName+' <>''''
					HAVING MIN(CASE WHEN '+columnName+' IS NULL THEN 1 ELSE 0 END)=0;'
			FROM @columns
			WHERE columnType = 'Dont Use'
		EXEC sp_executesql @sql 			 

		-- Check that columns do not mix NULLs and NOT NULLs
		SELECT @sql = ''
		SELECT @sql = @sql + '
				INSERT INTO #Msg 
					SELECT ''ERROR: '+tableName+'.'+columnName+' contains both null and not null values.''
					FROM '+tableName+'
					HAVING MAX(CASE WHEN '+columnName+' IS NULL THEN 1 ELSE 0 END) <> MIN(CASE WHEN '+columnName+' IS NULL THEN 1 ELSE 0 END);'
			FROM @columns
		EXEC sp_executesql @sql 			 


		--*************************************************************************************************************
		--*************************************************************************************************************
		--*** Validate data logic (duplicate values, cross-column consistency, invalid mapping, etc).
		--*************************************************************************************************************
		--*************************************************************************************************************

		-- Check for internalusername duplicates

		INSERT INTO #Msg
			SELECT 'ERROR: An internalusername is used more than once in [Profile.Import].[Person] .'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[Person]  GROUP BY internalusername HAVING COUNT(*)>1)

		INSERT INTO #Msg
			SELECT 'ERROR: An internalusername is used more than once in [Profile.Import].[User].'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[User] GROUP BY internalusername HAVING COUNT(*)>1)

		-- Check that primaryaffiliation and affiliationsort are being used correctly

		INSERT INTO #Msg
			SELECT 'ERROR: A person in [Profile.Import].[PersonAffiliation] does not have a record with primaryaffiliation=1.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] GROUP BY internalusername HAVING SUM(primaryaffiliation*1)=0)

		INSERT INTO #Msg
			SELECT 'ERROR: A person in [Profile.Import].[PersonAffiliation] has more than one record with primaryaffiliation=1.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] GROUP BY internalusername HAVING SUM(primaryaffiliation*1)>1)

		INSERT INTO #Msg
			SELECT 'ERROR: A person in [Profile.Import].[PersonAffiliation] has more than one affiliationorder values that are the same.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] GROUP BY internalusername HAVING COUNT(DISTINCT affiliationorder)<>COUNT(affiliationorder))

		-- Check that institutions are being defined correctly

	
		INSERT INTO #Msg
			SELECT 'ERROR: An institutionname in [Profile.Import].[PersonAffiliation] is NULL when either institutionfullname or institutionabbreviation is defined.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE COALESCE(institutionname,institutionabbreviation) IS NOT NULL AND institutionname IS NULL)

		INSERT INTO #Msg
			SELECT 'ERROR: An institutionabbreviation in [Profile.Import].[PersonAffiliation] is NULL when either institutionfullname or institutionname is defined.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE institutionname IS NOT NULL AND institutionabbreviation IS NULL)

		INSERT INTO #Msg
			SELECT 'ERROR: An institutionname in [Profile.Import].[PersonAffiliation] is being mapped to more than one institutionabbreviation.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE institutionname IS NOT NULL GROUP BY institutionname HAVING COUNT(DISTINCT institutionabbreviation)>1)

		INSERT INTO #Msg
			SELECT 'ERROR: An institutionabbreviation in [Profile.Import].[PersonAffiliation] is being mapped to more than one institutionname.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE institutionabbreviation IS NOT NULL GROUP BY institutionabbreviation HAVING COUNT(DISTINCT institutionname)>1)

		-- Check that departments are being defined correctly
				
		INSERT INTO #Msg
			SELECT 'ERROR: A departmentvisible in [Profile.Import].[PersonAffiliation] is NULL when a departmentname is defined.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE departmentname IS NOT NULL AND departmentvisible IS NULL)

		-- Check that divisions are being defined correctly

		-- Check that faculty ranks are being defined correctly
		INSERT INTO #Msg
			SELECT 'ERROR: A facultyrank in [Profile.Import].[PersonAffiliation] has a NULL facultyrankorder.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE facultyrank IS NOT NULL AND facultyrankorder IS NULL)

		INSERT INTO #Msg
			SELECT 'ERROR: A facultyrank in [Profile.Import].[PersonAffiliation] is being mapped to more than one facultyrankorder.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE facultyrank IS NOT NULL GROUP BY facultyrank HAVING COUNT(DISTINCT facultyrankorder)>1)

		INSERT INTO #Msg
			SELECT 'ERROR: A facultyrankorder in [Profile.Import].[PersonAffiliation] is being mapped to more than one facultyrank.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE facultyrankorder IS NOT NULL GROUP BY facultyrankorder HAVING COUNT(DISTINCT facultyrank)>1)



		--*************************************************************************************************************
		--*************************************************************************************************************
		--*** Identify items that are not errors, but might produce unexpected behavior.
		--*************************************************************************************************************
		--*************************************************************************************************************

		INSERT INTO #Msg
			SELECT 'WARNING: All records in [Profile.Import].[Person]  have isactive=0 (or IS NULL). As a result, no people will appear on the website.'
				WHERE NOT EXISTS (SELECT 1 FROM [Profile.Import].[Person]  WHERE isactive=1)

		INSERT INTO #Msg
			SELECT 'WARNING: All records in [Profile.Import].[Person]  have isvisible=0 (or IS NULL). As a result, all profile pages will show an ''Under Construction'' message.'
				WHERE NOT EXISTS (SELECT 1 FROM [Profile.Import].[Person]  WHERE isvisible=1)

		INSERT INTO #Msg
			SELECT 'WARNING: All records in [Profile.Import].[User] have canbeproxy=0 (or IS NULL). As a result, people will not be able to select any of these users to be their proxies.'
				WHERE NOT EXISTS (SELECT 1 FROM [Profile.Import].[User] WHERE canbeproxy=1)

		INSERT INTO #Msg
			SELECT 'WARNING: All [Profile.Import].[Person] .addresslineN values are NULL. As a result, no addresses will be displayed on the website.'
				FROM [Profile.Import].[Person] 
				HAVING MIN(CASE WHEN COALESCE(addressline1,addressline2,addressline3,addressline4) IS NULL THEN 1 ELSE 0 END) = 1

		INSERT INTO #Msg
			SELECT 'WARNING: All [Profile.Import].[Person] .addressstring values are NULL. As a result, geocoding will not work, and people will not be displayed on maps.'
				FROM [Profile.Import].[Person] 
				HAVING MIN(CASE WHEN addressstring IS NULL AND (latitude IS NULL or longitude IS NULL) THEN 1 ELSE 0 END) = 1

		INSERT INTO #Msg
			SELECT 'WARNING: All departments in [Profile.Import].[PersonAffiliation] have departmentvisible=0 (or IS NULL). As a result, no departments will be listed in the website search form.'
				FROM [Profile.Import].[PersonAffiliation]
				HAVING MAX(IsNull(departmentvisible*1,-1))=0

		INSERT INTO #Msg
			SELECT 'WARNING: A departmentname in [Profile.Import].[PersonAffiliation] has records with departmentvisible=0 (or IS NULL) and departmentvisible=1. The department will be visible on the website.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE departmentname IS NOT NULL GROUP BY departmentname HAVING MAX(departmentvisible*1)<>MIN(departmentvisible*1))


		--*************************************************************************************************************
		--*************************************************************************************************************
		--*** Display the list of errors and warnings that were found.
		--*************************************************************************************************************
		--*************************************************************************************************************

		INSERT INTO #Msg
			SELECT 'No problems were found.'
				WHERE NOT EXISTS (SELECT 1 FROM #Msg)

		SELECT * FROM #Msg 


	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK

		-- Raise an error with the details of the exception
		SELECT @ErrMsg = '[usp_ValidateProfilesLoaderTables] Failed with : ' + ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH	
				
END
GO
