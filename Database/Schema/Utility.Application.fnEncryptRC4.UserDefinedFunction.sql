SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.Application].[fnEncryptRC4]( @strInput VARCHAR(max), @strPassword VARCHAR(100) ) 
RETURNS VARCHAR(MAX)
AS
BEGIN
    --Returns a string encrypted with key k 
    --     ( RC4 encryption )
    --Original code: Eric Hodges http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=29691&lngWId=1
    --Originally translated to TSQL by Joseph Gama
    DECLARE @i int, @j int, @n int, @t int, @s VARCHAR(256), @k VARCHAR(256),
     @tmp1 CHAR(1), @tmp2 CHAR(1), @result VARCHAR(max)
    SET @i=0 SET @s='' SET @k='' SET @result=''
    SET @strPassword = 'PRNS'+@strPassword
    WHILE @i<=255--127--255
    	BEGIN
    	SET @s=@s+CHAR(@i)
    	SET @k=@k+CHAR(ASCII(SUBSTRING(@strPassword, 1+@i % LEN(@strPassword),1)))
    	SET @i=@i+1
    	END
    SET @i=0 SET @j=0
    WHILE @i<=255--127--255
    	BEGIN
    	SET @j=(@j+ ASCII(SUBSTRING(@s,@i+1,1))+ASCII(SUBSTRING(@k,@i+1,1)))% 128--256
    	SET @tmp1=SUBSTRING(@s,@i+1,1)
    	SET @tmp2=SUBSTRING(@s,@j+1,1)
    	SET @s=STUFF(@s,@i+1,1,@tmp2)
    	SET @s=STUFF(@s,@j+1,1,@tmp1)
    	SET @i=@i+1
    	END
    SET @i=0 SET @j=0
    SET @n=1
    WHILE @n<=LEN(@strInput)
    	BEGIN
    	SET @i=(@i+1) % 256--128--256
    	SET @j=(@j+ASCII(SUBSTRING(@s,@i+1,1))) % 256--128--256
    	SET @tmp1=SUBSTRING(@s,@i+1,1)
    	SET @tmp2=SUBSTRING(@s,@j+1,1)
    	SET @s=STUFF(@s,@i+1,1,@tmp2)
    	SET @s=STUFF(@s,@j+1,1,@tmp1)
    	SET @t=((ASCII(SUBSTRING(@s,@i+1,1))+ASCII(SUBSTRING(@s,@j+1,1))) % 256)--128)	--256)
    	IF ASCII(SUBSTRING(@s,@t+1,1))=ASCII(SUBSTRING(@strInput,@n,1))
    		SET @result=@result+SUBSTRING(@strInput,@n,1)
    	ELSE	
    		SET @result=@result+CHAR(ASCII(SUBSTRING(@s,@t+1,1)) ^ ASCII(SUBSTRING(@strInput,@n,1)))
    	SET @n=@n+1
    	END
    RETURN @result
END
GO
