SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.NLP].[fnPorterStep4]
	(
		@InWord nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN
--STEP 4
--
--    (m>1) AL    ->                  revival        ->  reviv
--    (m>1) ANCE  ->                  allowance      ->  allow
--    (m>1) ENCE  ->                  inference      ->  infer
--    (m>1) ER    ->                  airliner       ->  airlin
--    (m>1) IC    ->                  gyroscopic     ->  gyroscop
--    (m>1) ABLE  ->                  adjustable     ->  adjust
--    (m>1) IBLE  ->                  defensible     ->  defens
--    (m>1) ANT   ->                  irritant       ->  irrit
--    (m>1) EMENT ->                  replacement    ->  replac
--    (m>1) MENT  ->                  adjustment     ->  adjust
--    (m>1) ENT   ->                  dependent      ->  depend
--    (m>1 and (*S or *T)) ION ->     adoption       ->  adopt
--    (m>1) OU    ->                  homologou      ->  homolog
--    (m>1) ISM   ->                  communism      ->  commun
--    (m>1) ATE   ->                  activate       ->  activ
--    (m>1) ITI   ->                  angulariti     ->  angular
--    (m>1) OUS   ->                  homologous     ->  homolog
--    (m>1) IVE   ->                  effective      ->  effect
--    (m>1) IZE   ->                  bowdlerize     ->  bowdler
--
--The suffixes are now removed. All that remains is a little tidying up.

    DECLARE @Ret nvarchar(4000), @Temp nvarchar(4000)
    DECLARE @Phrase1 NVARCHAR(15)
    DECLARE @CursorName CURSOR

--checking word
    SELECT @Ret = @InWord
    SET @CursorName = CURSOR FOR 
	SELECT phrase1 FROM [Utility.NLP].ParsePorterStemming WHERE Step = 4 AND RIGHT(@Ret ,LEN(Phrase1)) = Phrase1
		ORDER BY Ordering
    OPEN @CursorName

    -- Do Step 4
    FETCH NEXT FROM @CursorName INTO @Phrase1
    WHILE @@FETCH_STATUS = 0 
	BEGIN
	    --IF RIGHT(@Ret ,LEN(@Phrase1)) = @Phrase1
		BEGIN
		    SELECT @temp = LEFT(@Ret, LEN(@Ret) - LEN(@Phrase1))
            	    IF [Utility.NLP].fnPorterCountm(@temp) > 1
			BEGIN
			    IF RIGHT(@Ret ,LEN(N'ion')) = N'ion'
				BEGIN
				    IF RIGHT(@temp ,1) = N's' OR RIGHT(@temp ,1) = N't'
					SELECT @Ret = LEFT(@Ret, LEN(@Ret) - LEN(@Phrase1))
				END
			    ELSE
				SELECT @Ret = LEFT(@Ret, LEN(@Ret) - LEN(@Phrase1))
			END
            	    BREAK
		END
	    FETCH NEXT FROM @CursorName INTO @Phrase1
        END

    -- Free Resources
    CLOSE @CursorName
    DEALLOCATE @CursorName

    --retuning the word
    RETURN @Ret
 
END
GO
