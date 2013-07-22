SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Framework.].[LoadXMLFile](@FilePath varchar(max), @TableDestination VARCHAR(MAX), @DestinationColumn VARCHAR(MAX), @NameValue VARCHAR(MAX)=NULL )
AS
BEGIN
	 
	SET NOCOUNT ON;

	/*

	This stored procedure imports the contents of an xml file into the 
	specified table and column from a supplied filepath. 

	Input parameters:
		@FilePath				Path where xml data file exists, relative to the sql server.		  
		@TableDestination		Table where data is to be stored
		@DestinationColumn		Column where data is to be stored
		@NameValue				Name of the file (optional)

	Test Call:
		[Framework.].[uspLoadXMLFile] 'c:\InstallData.xml', '[Framework.].[InstallData]', 'Data', 'VIVO_1.4'
		
	*/

	DECLARE @sql NVARCHAR(MAX)
	 
	SELECT @SQL = 'INSERT INTO ' + @TableDestination + '(' + @DestinationColumn + CASE WHEN @NameValue IS NOT NULL THEN ',Name' ELSE '' END +  ') 
									 SELECT  xXML' + CASE WHEN @NameValue IS NOT NULL THEN ',''' + @NameValue + '''' ELSE '' END + ' FROM   ( SELECT CONVERT(xml, BulkColumn, 2) FROM OPENROWSET(BULK ''' + @FilePath + ''', SINGLE_BLOB) AS T ) AS x ( xXML )'  
	 
	EXEC SP_EXECUTESQL @SQL 

END
GO
