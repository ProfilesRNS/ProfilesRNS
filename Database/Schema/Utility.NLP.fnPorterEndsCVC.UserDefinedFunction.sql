SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION  [Utility.NLP].[fnPorterEndsCVC]
	(
		@Word nvarchar(4000)
	)
RETURNS bit
AS
BEGIN
--*o  - the stem ends cvc, where the second c is not W, X or Y (e.g. -WIL, -HOP).

--declaring local variables
DECLARE @pattern NVARCHAR(3), @ret bit


SELECT @ret = 0

--'check to see if atleast 3 characters are present
If LEN(@Word) >= 3
    BEGIN
	-- find out the CVC pattern
	-- we need to check only the last three characters
	SELECT @pattern = RIGHT( [Utility.NLP].fnPorterCVCpattern(@Word),3)
	-- check to see if the letters in str match the sequence cvc
	IF @pattern = N'cvc' AND CHARINDEX(RIGHT(@Word,1), N'wxy') = 0
		SELECT @ret = 1
    END
RETURN @Ret
END
GO
