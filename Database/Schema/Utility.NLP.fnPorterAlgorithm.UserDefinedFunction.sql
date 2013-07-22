SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.NLP].[fnPorterAlgorithm]
	(
		@InWord nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN
    DECLARE @Ret nvarchar(4000), @Temp nvarchar(4000)

    -- DO some initial cleanup
    SELECT @Ret = LOWER(ISNULL(RTRIM(LTRIM(@InWord)),N''))

    -- only strings greater than 2 are stemmed
    IF LEN(@Ret) > 2
	BEGIN
	    SELECT @Ret = [Utility.NLP].fnPorterStep1(@Ret)
	    SELECT @Ret = [Utility.NLP].fnPorterStep2(@Ret)
	    SELECT @Ret = [Utility.NLP].fnPorterStep3(@Ret)
	    SELECT @Ret = [Utility.NLP].fnPorterStep4(@Ret)
	    SELECT @Ret = [Utility.NLP].fnPorterStep5(@Ret)
	END

--End of Porter's algorithm.........returning the word
    RETURN @Ret
 
END
GO
