SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [RDF.].[fnValueHash] (
	@Language	nvarchar(255),
	@DataType	nvarchar(255),
	@Value		nvarchar(max)
) 
RETURNS binary(20)
AS
BEGIN
	DECLARE @result binary(20)
	SELECT @result = CONVERT(binary(20),
						HASHBYTES('sha1',
							CONVERT(nvarchar(4000),
									N'"'+replace(isnull(@Value,N''),N'"',N'\"')+N'"'
									+IsNull(N'@'+replace(@Language,N'@',N''),N'')
									+IsNull(N'^^'+replace(@DataType,N'^',N''),N'')
							)
						)
					)
	RETURN @result
END
GO
