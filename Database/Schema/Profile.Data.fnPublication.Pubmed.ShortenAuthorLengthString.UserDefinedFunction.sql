SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Profile.Data].[fnPublication.Pubmed.ShortenAuthorLengthString](@strInput VARCHAR(max)) 
RETURNS VARCHAR(MAX)
AS
BEGIN
		select @strInput = substring(@strInput,3,len(@strInput))
		return case	when len(@strInput) < 3990 then @strInput
					when charindex(',',reverse(left(@strInput,3990)))>0 then
						left(@strInput,3990-charindex(',',reverse(left(@strInput,3990))))+', et al'
					else left(@strInput,3990)
					end
END
GO

