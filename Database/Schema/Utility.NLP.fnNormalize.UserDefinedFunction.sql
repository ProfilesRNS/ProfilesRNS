SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [Utility.NLP].[fnNormalize]
	(
		@InWord nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN
    DECLARE @Temp nvarchar(4000)
	DECLARE @Norm nvarchar(4000)
	DECLARE @i int
	DECLARE @c varchar(1)
	DECLARE @lastc varchar(1)

    SELECT @Temp = LOWER(ISNULL(RTRIM(LTRIM(@InWord)),N''))

	SET @Norm = ''
	SET @i = 1
	SET @lastc = ''

	WHILE @i <= LEN(@Temp)
	BEGIN
		SET @c = (select substring(@Temp,@i,1))
		IF not ((ascii(@c) between 48 and 57) or (ascii(@c) between 97 and 122))
			SET @c = ' '
		IF (@c <> '') or (@lastc <> ' ')
			SET @Norm = @Norm + @c
		SET @lastc = @c
		SET @i = @i + 1
	END

    RETURN RTRIM(LTRIM(@Norm))
 
END
GO
