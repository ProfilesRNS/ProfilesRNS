SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [Utility.Application].[fnBool2Text] (@bool BIT)
RETURNS varchar(5) 
begin
	return CASE WHEN @bool = 1 THEN 'true' ELSE 'false' END
	
end
GO
