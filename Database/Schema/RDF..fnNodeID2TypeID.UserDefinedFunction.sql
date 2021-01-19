SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [RDF.].[fnNodeID2TypeID] (
	@NodeID	bigint
) 
RETURNS nvarchar(200)
AS
BEGIN
	DECLARE @result nvarchar(200)

	declare @typeID bigint
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')

	select @result = coalesce(@result + ',', '') + cast(Object as nvarchar(10))  from [RDF.].Triple where subject=@NodeID and predicate=@typeID order by Object
	RETURN @result
END
GO
