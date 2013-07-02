SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION  [Utility.NLP].[fnPorterCountm]
	(
		@Word nvarchar(4000)
	)
RETURNS tinyint
AS
BEGIN

--A \consonant\ in a word is a letter other than A, E, I, O or U, and other
--than Y preceded by a consonant. (The fact that the term `consonant' is
--defined to some extent in terms of itself does not make it ambiguous.) So in
--TOY the consonants are T and Y, and in SYZYGY they are S, Z and G. If a
--letter is not a consonant it is a \vowel\.

--declaring local variables
DECLARE @pattern nvarchar(4000), @ret tinyint, @i int, @flag bit

--initializing
SELECT @ret = 0, @flag = 0,  @i = 1

If Len(@Word) > 0
    BEGIN
	--find out the CVC pattern
	SELECT @pattern =  [Utility.NLP].fnPorterCVCpattern(@Word)
	--counting the number of m's...
	WHILE @i <= LEN(@pattern)
	    BEGIN
        	IF SUBSTRING(@pattern,@i,1) = N'v' OR @flag = 1
		    BEGIN
			SELECT @flag = 1
		        IF SUBSTRING(@pattern,@i,1) = N'c'
			    SELECT @ret = @ret + 1, @flag = 0
		    END
		SELECT @i = @i + 1
	    END
    END

    RETURN @Ret
END
GO
