SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Framework.].[vwDatabaseCode] AS
	SELECT o.type, o.type_desc, o.full_name, 
		o.object_id, o.create_date, o.modify_date,
		c.number, c.colid, c.text,
		o.schema_name, o.name,
		o.principal_id, o.schema_id, o.parent_object_id,
		o.is_ms_shipped, o.is_published, o.is_schema_published
	FROM [Framework.].vwDatabaseObjects o, syscomments c
	WHERE c.id = o.object_id
GO
