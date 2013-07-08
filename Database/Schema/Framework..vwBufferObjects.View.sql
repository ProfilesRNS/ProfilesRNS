SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Framework.].[vwBufferObjects] AS
	SELECT OBJECT_SCHEMA_NAME(t.object_id) SchemaName, OBJECT_NAME(t.object_id) ObjectName, i.name IndexName, 
			i.type_desc IndexType, t.BufferPageCount/128.0 BufferMB, t.BufferPageCount, t.object_id, t.index_id
		FROM (
				SELECT p.object_id, p.index_id, count(*) BufferPageCount
				FROM sys.dm_os_buffer_descriptors b
					INNER JOIN sys.allocation_units a
						ON b.allocation_unit_id = a.allocation_unit_id
					INNER JOIN sys.partitions p
						ON a.container_id = p.hobt_id
				WHERE b.database_id = db_id()
				GROUP BY p.object_id, p.index_id
			) t
			LEFT OUTER JOIN sys.indexes i
				ON i.object_id = t.object_id AND i.index_id = t.index_id
GO
