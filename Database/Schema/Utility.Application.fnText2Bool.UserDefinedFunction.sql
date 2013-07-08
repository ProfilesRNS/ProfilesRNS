SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [Utility.Application].[fnText2Bool] (@bool VARCHAR(5))
RETURNS varchar(5) 
begin
	return CASE WHEN @bool = 'true' THEN 1 ELSE 0 END
	
end
GO
