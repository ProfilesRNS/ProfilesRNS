SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Framework.].[vwBufferDatabases] AS
	SELECT (CASE WHEN database_id = 32767 THEN 'ResourceDb' ELSE DB_NAME(database_id) END) DatabaseName, 
			BufferPageCount/128.0 BufferMB, BufferPageCount, database_id
		FROM (
			SELECT database_id, count(*) BufferPageCount
			FROM sys.dm_os_buffer_descriptors
			GROUP BY database_id
		) t
	--DBCC FREEPROCCACHE
	--DBCC DROPCLEANBUFFERS
GO
