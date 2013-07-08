SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.Application].[fnEncryptBase64RC4]( @strInput VARCHAR(max), @strPassword VARCHAR(100) ) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN [Utility.Application].fnBinaryToBase64(
				CONVERT(VARBINARY(max),
							[Utility.Application].[fnEncryptRC4](@strInput,@strPassword)
						)
			)
END
GO
