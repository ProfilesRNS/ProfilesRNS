SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION  [Utility.NLP].[fnPorterEndsDoubleConsonant]
	(
		@Word nvarchar(4000)
	)
RETURNS bit
AS
BEGIN

--checking whether word ends with a double consonant (e.g. -TT, -SS).

--declaring local variables
DECLARE @holds_ends NVARCHAR(2), @ret bit, @hold_third_last NCHAR(1)

SET @ret = 0
--first check whether the size of the word is >= 2
If Len(@Word) >= 2
    BEGIN
	-- extract 2 characters from right of str
	SELECT @holds_ends = Right(@Word, 2)
	-- checking if both the characters are same and not double vowel
    	IF SUBSTRING(@holds_ends,1,1) = SUBSTRING(@holds_ends,2,1) AND
	   CHARINDEX(@holds_ends, N'aaeeiioouu') = 0
	    BEGIN
            	--if the second last character is y, and there are atleast three letters in str
            	If @holds_ends = N'yy' AND Len(@Word) > 2 
		    BEGIN
			-- extracting the third last character
			SELECT @hold_third_last = LEFT(Right(@Word, 3),1)
                	IF CHARINDEX(@hold_third_last, N'aaeeiioouu') > 0
			    SET @ret = 1
		    END            
            	ELSE
		    SET @ret = 1
	    END            
    END            
            
RETURN @Ret
END
GO
