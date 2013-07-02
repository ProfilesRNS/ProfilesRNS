SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Framework.].[vwDatabaseObjects] AS
	SELECT o.type, o.type_desc, '['+s.name+'].['+o.name+']' full_name, s.name schema_name, o.name, 
			o.object_id, o.principal_id, o.schema_id, o.parent_object_id, 
			o.create_date, o.modify_date, o.is_ms_shipped, o.is_published, o.is_schema_published
		FROM sys.objects o, sys.schemas s
		WHERE o.schema_id = s.schema_id
	UNION ALL
	SELECT '@', 'SCHEMA', '['+name+']', name, name,
			NULL, principal_id, schema_id, null, 
			null, null, null, null, null
		FROM sys.schemas
GO
