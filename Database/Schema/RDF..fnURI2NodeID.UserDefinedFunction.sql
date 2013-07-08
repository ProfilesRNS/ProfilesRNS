SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [RDF.].[fnURI2NodeID] (
	@URI	nvarchar(4000)
) 
RETURNS bigint
AS
BEGIN
	DECLARE @result bigint
	IF @URI IS NULL
		SELECT @result = NULL
	ELSE
		SELECT @result = NodeID
			FROM [RDF.].Node
			WHERE ValueHash = [RDF.].fnValueHash(null,null,@URI)
	RETURN @result
END
GO
