SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION  [Utility.NLP].[fnPorterContainsVowel]
	(
		@Word nvarchar(4000)
	)
RETURNS bit
AS
BEGIN

--checking word to see if vowels are present
DECLARE @pattern nvarchar(4000), @ret bit

SET @ret = 0

IF LEN(@Word) > 0
    BEGIN
    	--find out the CVC pattern
    	SELECT @pattern =  [Utility.NLP].fnPorterCVCpattern(@Word)
	--check to see if the return pattern contains a vowel
    	IF CHARINDEX( N'v',@pattern) > 0
	  SELECT @ret = 1
    END
RETURN @Ret
END
GO
