SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [Utility.NLP].[fnNamePart1]
(
	@s nvarchar(500)
)
RETURNS nvarchar(500)
AS
BEGIN

	set @s = (
		select
			replace(replace((case when charindex(' ',x) = 0 then x else left(x,charindex(' ',x)-1) end),'^$',' '),'^#','-')
		from (
			select
				substring(
					replace(replace(replace(
					replace(replace(replace(replace(replace(replace(replace(replace(
					replace(replace(replace(replace(replace(replace(replace(replace(
					replace(replace(replace(replace(
					' '+ltrim(rtrim(replace(
					@s
					,'.',' ')))
					,' de la ',' de^$la^$'),' de-la ',' de^#la^$'),' de la-',' de^$la^#'),' de-la-',' de^#la^#')
					,' da ',' da^$'),' de ',' de^$'),' del ',' del^$'),' do ',' do^$'),' dos ',' dos^$'),' du ',' du^$'),' el ',' el^$'),' le ',' le^$')
					,' da-',' da^#'),' de-',' de^#'),' del-',' del^#'),' do-',' do^#'),' dos-',' dos^#'),' du-',' du^#'),' el-',' el^#'),' le-',' le^#')
					,' -',' ^#'),'-',' '),'  ',' ')
				,2,999) x
		) t
	)

	RETURN @s

END
GO
