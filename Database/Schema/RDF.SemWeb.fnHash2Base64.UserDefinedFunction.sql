SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [RDF.SemWeb].[fnHash2Base64]
(
	@hash char(20)
)
RETURNS nchar(28)
WITH SCHEMABINDING
AS
BEGIN

	declare @SemWebHash as nchar(28)

	-- base64 encode hashed string
	declare @alphabet64 varchar(100)
	declare @s64 varchar(1000)
	declare @pad1 bit
	declare @pad2 bit
	declare @pos int
	declare @d3 int
	declare @b1 int
	declare @b2 int
	declare @b3 int
	declare @b4 int
	set @alphabet64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='
	set @s64 = ''
	set @pad1 = 0
	set @pad2 = 0
	set @pos = 1
	while @pos <= 20 --len(@hash)
	begin
		set @d3 = ascii(substring(@hash,@pos,1))*256*256
		if @pos+1 <= 20 --len(@hash)
		  set @d3 = @d3 + ascii(substring(@hash,@pos+1,1))*256
		else
		  set @pad1 = 1
		if @pos+2 <= 20 --len(@hash)
		  set @d3 = @d3 + ascii(substring(@hash,@pos+2,1))
		else
		  set @pad2 = 1
		set @b1 = floor(@d3/(64*64*64))
		set @b2 = floor(@d3/(64*64)) - @b1*64
		set @b3 = floor(@d3/64) - @b1*64*64 - @b2*64
		set @b4 = @d3 - @b1*64*64*64 - @b2*64*64 - @b3*64
		set @s64 = @s64 + substring(@alphabet64,@b1+1,1)
		set @s64 = @s64 + substring(@alphabet64,@b2+1,1)
		if @pad1=1
		  set @s64 = @s64 + '='
		else
		  set @s64 = @s64 + substring(@alphabet64,@b3+1,1)
		if @pad2=1
		  set @s64 = @s64 + '='
		else
		  set @s64 = @s64 + substring(@alphabet64,@b4+1,1)
		set @pos = @pos + 3
	end

	select @SemWebHash = cast(@s64 as nchar(28))

	-- return result
	RETURN @SemWebHash

	-- select [RDF.SemWeb].[fnHash2Base64] ( [RDF.].[fnValueHash](null,null,'Griffin') )

END
GO
