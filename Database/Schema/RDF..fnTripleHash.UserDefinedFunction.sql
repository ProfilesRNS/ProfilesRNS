SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [RDF.].[fnTripleHash] (
	@Subject	bigint,
	@Predicate	bigint,
	@Object		bigint
) 
RETURNS binary(20)
AS
BEGIN
	DECLARE @result binary(20)
	SELECT @result = convert(binary(20),HashBytes('sha1',
						convert(nvarchar(max),
							+N'"'
							+N'<#'+convert(nvarchar(max),@Subject)+N'> '
							+N'<#'+convert(nvarchar(max),@Predicate)+N'> '
							+N'<#'+convert(nvarchar(max),@Object)+N'> .'
							+N'"'
							+N'^^http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement'
						)
					))
	RETURN @result
END
GO
