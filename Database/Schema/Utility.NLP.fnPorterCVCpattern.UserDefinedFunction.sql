SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION  [Utility.NLP].[fnPorterCVCpattern]
	(
		@Word nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN

--local variables
    DECLARE @Ret nvarchar(4000), @i int

--checking each character to see if it is a consonent or a vowel. also inputs the information in const_vowel
SELECT @i = 1, @Ret = N''
WHILE @i <= LEN(@Word)
    BEGIN
	IF CHARINDEX(SUBSTRING(@Word,@i,1), N'aeiou') > 0
	    BEGIN
		SELECT @Ret = @Ret + N'v'
	    END
	-- if y is not the first character, only then check the previous character
	ELSE IF SUBSTRING(@Word,@i,1) = N'y' AND @i > 1
	    BEGIN
            	--check to see if previous character is a consonent
		IF CHARINDEX(SUBSTRING(@Word,@i-1,1), N'aeiou') = 0
		     SELECT @Ret = @Ret + N'v'
		ELSE
		     SELECT @Ret = @Ret + N'c'
	    END
        Else
	    BEGIN
	     SELECT @Ret = @Ret + N'c'
	    END
	SELECT @i = @i + 1
    END
    RETURN @Ret
END
GO
