SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [Utility.NLP].[fnQuoteNormalizeSplitStem]
	(
		@InWord nvarchar(4000)
	)
RETURNS 
	@words table (
	phrase int,
		plen int,
		wpos int,
		word varchar(255),
		phrasestr varchar(2000)
	)
 AS
 BEGIN

    DECLARE @Temp nvarchar(4000)
	DECLARE @str nvarchar(4000)
	DECLARE @i int
	DECLARE @c varchar(1)
	DECLARE @q int
	DECLARE @phrases table (
		phrase int identity(0,1),
		phrasestr varchar(4000),
		quoted int
	)
	DECLARE @w table (
		phrase int,
		wpos int identity(0,1),
		word varchar(255),
		quoted int,
		phrasestr varchar(2000)
	)

    SELECT @Temp = ISNULL(RTRIM(LTRIM(@InWord)),N'')

	SET @str = ''
	SET @i = 1
	SET @q = 0

	WHILE @i <= LEN(@Temp)
	BEGIN
		SET @c = (select substring(@Temp,@i,1))
		IF (@c = '"')
		BEGIN
			INSERT INTO @phrases (phrasestr, quoted) VALUES (@str, @q)
			SET @q = 1 - @q
			SET @str = ''
		END
		ELSE
		BEGIN
			SET @str = @str + @c
		END
		SET @i = @i + 1
	END
	INSERT INTO @phrases (phrasestr, quoted) VALUES (@str, @q)

	DELETE FROM @phrases WHERE phrasestr = ''

 
 
	insert into @w (phrase, word, quoted,phrasestr)
		select phrase, word, quoted,CASE WHEN quoted=1 THEN ltrim(rtrim(phrasestr))ELSE word2 END
		from @phrases cross apply [Utility.NLP].fnNormalizeSplitStem(phrasestr)
		where word not in ('and');
 
	;with w as (
		select phrase, (row_number() over (partition by phrase order by wpos)) - 1 wpos, word, phrasestr
		from (
			select word, wpos, (dense_rank() over (order by k)) - 1 phrase,phrasestr
			from (
				select phrase + (case when quoted = 1 then 0 else wpos/10000.0 end) k, * from @w
			) t
		) t
	)
	insert into @words (phrase, plen, wpos, word,phrasestr)
		select w.phrase, v.plen, w.wpos, w.word ,phrasestr
		from w, (select phrase, count(*) plen from w group by phrase) v
		where w.phrase = v.phrase

    RETURN
 
END
GO
