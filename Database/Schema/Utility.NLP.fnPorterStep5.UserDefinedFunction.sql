SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [Utility.NLP].[fnPorterStep5]
	(
		@InWord nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN
--STEP 5a
--
--    (m>1) E     ->                  probate        ->  probat
--                                    rate           ->  rate
--    (m=1 and not *o) E ->           cease          ->  ceas
--
--STEP 5b
--
--    (m>1 and *d and *L) -> single letter
--                                    controll       ->  control
--                                    roll           ->  roll

--declaring local variables
    DECLARE @Ret nvarchar(4000), @Temp nvarchar(4000), @m tinyint
    SET @Ret = @InWord

--Step5a
    IF RIGHT(@Ret , 1) = N'e'	            --word ends with e
	BEGIN
	    SELECT @temp = LEFT(@Ret, LEN(@Ret) - 1)
	    SELECT @m = [Utility.NLP].fnPorterCountm(@temp)
	    IF @m > 1						--m>1
		SELECT @Ret = LEFT(@Ret, LEN(@Ret) - 1)
	    ELSE IF @m = 1					--m=1
		BEGIN
		    IF [Utility.NLP].fnPorterEndsCVC(@temp) = 0		--not *o
			SELECT @Ret = LEFT(@Ret, LEN(@Ret) - 1)
		END
	END
----------------------------------------------------------------------------------------------------------
--
--Step5b
IF [Utility.NLP].fnPorterCountm(@Ret) > 1
    BEGIN
	IF [Utility.NLP].fnPorterEndsDoubleConsonant(@Ret) = 1 AND RIGHT(@Ret, 1) = N'l'
	    SELECT @Ret = LEFT(@Ret, LEN(@Ret) - 1)
    END
--retuning the word
RETURN @Ret
 
END
GO
