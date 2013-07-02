SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.Application].[fnBinaryToBase64] (@Binary VARBINARY(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN CAST(N'' AS XML).value('xs:base64Binary(xs:hexBinary(sql:variable("@Binary")))', 'VARCHAR(MAX)')
END
GO
