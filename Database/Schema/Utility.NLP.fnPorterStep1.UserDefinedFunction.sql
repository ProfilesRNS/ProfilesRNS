SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION  [Utility.NLP].[fnPorterStep1]
	(
		@InWord nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN

    DECLARE @Ret nvarchar(4000)
    DECLARE @Phrase1 NVARCHAR(15), @Phrase2 NVARCHAR(15)
    DECLARE @CursorName CURSOR

    -- DO some initial cleanup
    SELECT @Ret = @InWord

/*STEP 1A

    SSES -> SS                         caresses  ->  caress
    IES  -> I                          ponies    ->  poni
                                       ties      ->  ti
    SS   -> SS                         caress    ->  caress
    S    ->                            cats      ->  cat
*/
    -- Create Cursor for Porter Step 1
    SET @CursorName = CURSOR FOR 
	SELECT phrase1, phrase2 FROM  [Utility.NLP].ParsePorterStemming WHERE Step = 1 AND RIGHT(@Ret ,LEN(Phrase1)) = Phrase1
		ORDER BY Ordering
    OPEN @CursorName

    -- Do Step 1
    FETCH NEXT FROM @CursorName INTO @Phrase1, @Phrase2
    WHILE @@FETCH_STATUS = 0 
	BEGIN
	    --IF RIGHT(@Ret ,LEN(@Phrase1)) = @Phrase1
		BEGIN
		    SELECT @Ret = LEFT(@Ret, LEN(@Ret) - LEN(@Phrase1)) + @Phrase2
		    BREAK
		END
	    FETCH NEXT FROM @CursorName INTO @Phrase1, @Phrase2
        END
    -- Free Resources
    CLOSE @CursorName
    DEALLOCATE @CursorName

--STEP 1B
--
--   If
--       (m>0) EED -> EE                     feed      ->  feed
--                                           agreed    ->  agree
--   Else
--       (*v*) ED  ->                        plastered ->  plaster
--                                           bled      ->  bled
--       (*v*) ING ->                        motoring  ->  motor
--                                           sing      ->  sing
--
--If the second or third of the rules in Step 1b is successful, the following
--is done:
--
--    AT -> ATE                       conflat(ed)  ->  conflate
--    BL -> BLE                       troubl(ed)   ->  trouble
--    IZ -> IZE                       siz(ed)      ->  size
--    (*d and not (*L or *S or *Z))
--       -> single letter
--                                    hopp(ing)    ->  hop
--                                    tann(ed)     ->  tan
--                                    fall(ing)    ->  fall
--                                    hiss(ing)    ->  hiss
--                                    fizz(ed)     ->  fizz
--    (m=1 and *o) -> E               fail(ing)    ->  fail
--                                    fil(ing)     ->  file
--
--The rule to map to a single letter causes the removal of one of the double
--letter pair. The -E is put back on -AT, -BL and -IZ, so that the suffixes
---ATE, -BLE and -IZE can be recognised later. This E may be removed in step
--4.

--declaring local variables
DECLARE @m tinyint, @Temp nvarchar(4000),@second_third_success bit

--initializing 
SELECT @second_third_success = 0

--(m>0) EED -> EE..else..(*v*) ED  ->(*v*) ING  ->
    IF RIGHT(@Ret ,LEN(N'eed')) = N'eed'
	BEGIN
	    --counting the number of m--s
	    SELECT @temp = LEFT(@Ret, LEN(@Ret) - LEN(N'eed'))
	    SELECT @m =  [Utility.NLP].fnPorterCountm(@temp)

    	    If @m > 0
                SELECT @Ret = LEFT(@Ret, LEN(@Ret) - LEN(N'eed')) + N'ee' 
	END
    ELSE IF RIGHT(@Ret ,LEN(N'ed')) = N'ed'
	BEGIN
	    --trim and check for vowel
	    SELECT @temp = LEFT(@Ret, LEN(@Ret) - LEN(N'ed'))
	    If  [Utility.NLP].fnPorterContainsVowel(@temp) = 1
		SELECT @ret = LEFT(@Ret, LEN(@Ret) - LEN(N'ed')), @second_third_success = 1
	END
    ELSE IF RIGHT(@Ret ,LEN(N'ing')) = N'ing'
	BEGIN
	    --trim and check for vowel
	    SELECT @temp = LEFT(@Ret, LEN(@Ret) - LEN(N'ing'))
	    If  [Utility.NLP].fnPorterContainsVowel(@temp) = 1
		SELECT @ret = LEFT(@Ret, LEN(@Ret) - LEN(N'ing')), @second_third_success = 1
	END

--If the second or third of the rules in Step 1b is SUCCESSFUL, the following
--is done:
--
--    AT -> ATE                       conflat(ed)  ->  conflate
--    BL -> BLE                       troubl(ed)   ->  trouble
--    IZ -> IZE                       siz(ed)      ->  size
--    (*d and not (*L or *S or *Z))
--       -> single letter
--                                    hopp(ing)    ->  hop
--                                    tann(ed)     ->  tan
--                                    fall(ing)    ->  fall
--                                    hiss(ing)    ->  hiss
--                                    fizz(ed)     ->  fizz
--    (m=1 and *o) -> E               fail(ing)    ->  fail
--                                    fil(ing)     ->  file


IF @second_third_success = 1              --If the second or third of the rules in Step 1b is SUCCESSFUL
    BEGIN        
    	IF RIGHT(@Ret ,LEN(N'at')) = N'at'	--AT -> ATE
	    SELECT @ret = LEFT(@Ret, LEN(@Ret) - LEN(N'at')) + N'ate'
    	ELSE IF RIGHT(@Ret ,LEN(N'bl')) = N'bl'	--BL -> BLE
	    SELECT @ret = LEFT(@Ret, LEN(@Ret) - LEN(N'bl')) + N'ble'
    	ELSE IF RIGHT(@Ret ,LEN(N'iz')) = N'iz'	--IZ -> IZE
	    SELECT @ret = LEFT(@Ret, LEN(@Ret) - LEN(N'iz')) + N'ize'
    	ELSE IF  [Utility.NLP].fnPorterEndsDoubleConsonant(@Ret) = 1  /*(*d and not (*L or *S or *Z))-> single letter*/
	    BEGIN
		IF CHARINDEX(RIGHT(@Ret,1), N'lsz') = 0
		    SELECT @ret = LEFT(@Ret, LEN(@Ret) - 1)
            END
	ELSE IF  [Utility.NLP].fnPorterCountm(@Ret) = 1        /*(m=1 and *o) -> E */
	    BEGIN
	       	IF  [Utility.NLP].fnPorterEndsDoubleCVC(@Ret) = 1
                   SELECT @ret = @Ret + N'e'
            END
    END
    
----------------------------------------------------------------------------------------------------------
--
--STEP 1C
--
--    (*v*) Y -> I                    happy        ->  happi
--                                    sky          ->  sky
IF RIGHT(@Ret ,LEN(N'y')) = N'y'
    BEGIN        
        --trim and check for vowel
        SELECT @temp = LEFT(@Ret, LEN(@Ret)-1)
        IF  [Utility.NLP].fnPorterContainsVowel(@temp) = 1
	    SELECT @ret = LEFT(@Ret, LEN(@Ret) - 1) + N'i'
    END

    RETURN @Ret
 
END
GO
