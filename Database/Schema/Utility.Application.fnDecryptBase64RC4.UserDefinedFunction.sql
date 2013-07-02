SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.Application].[fnDecryptBase64RC4]( @strInput VARCHAR(max), @strPassword VARCHAR(100) ) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN [Utility.Application].[fnEncryptRC4](
				[Utility.Application].fnBase64ToBinary(@strInput),
				@strPassword
			)
END
GO
