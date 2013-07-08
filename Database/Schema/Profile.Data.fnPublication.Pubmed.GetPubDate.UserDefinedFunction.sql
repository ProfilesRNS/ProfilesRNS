SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [Profile.Data].[fnPublication.Pubmed.GetPubDate]
(
	@MedlineDate varchar(255),
	@JournalYear varchar(50),
	@JournalMonth varchar(50),	
	@JournalDay varchar(50),	
	@ArticleYear varchar(10),
	@ArticleMonth varchar(10),	
	@ArticleDay varchar(10)
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PubDate datetime


	declare @MedlineMonth varchar(10)
	declare @MedlineYear varchar(10)

	set @MedlineYear = left(@MedlineDate,4)

	set @JournalMonth = (select case left(@JournalMonth,3)
								when 'Jan' then '1'
								when 'Feb' then '2'
								when 'Mar' then '3'
								when 'Apr' then '4'
								when 'May' then '5'
								when 'Jun' then '6'
								when 'Jul' then '7'
								when 'Aug' then '8'
								when 'Sep' then '9'
								when 'Oct' then '10'
								when 'Nov' then '11'
								when 'Dec' then '12'
								when 'Win' then '1'
								when 'Spr' then '4'
								when 'Sum' then '7'
								when 'Fal' then '10'
								when '1' then '1'
								when '2' then '2'
								when '3' then '3'
								when '4' then '4'
								when '5' then '5'
								when '6' then '6'
								when '7' then '7'
								when '8' then '8'
								when '9' then '9'
								when '01' then '1'
								when '02' then '2'
								when '03' then '3'
								when '04' then '4'
								when '05' then '5'
								when '06' then '6'
								when '07' then '7'
								when '08' then '8'
								when '09' then '9'
								when '10' then '10'
								when '11' then '11'
								when '12' then '12'
								else null end)
	set @MedlineMonth = (select case substring(replace(@MedlineDate,' ',''),5,3)
								when 'Jan' then '1'
								when 'Feb' then '2'
								when 'Mar' then '3'
								when 'Apr' then '4'
								when 'May' then '5'
								when 'Jun' then '6'
								when 'Jul' then '7'
								when 'Aug' then '8'
								when 'Sep' then '9'
								when 'Oct' then '10'
								when 'Nov' then '11'
								when 'Dec' then '12'
								when 'Win' then '1'
								when 'Spr' then '4'
								when 'Sum' then '7'
								when 'Fal' then '10'
								else null end)
	set @ArticleMonth = (select case @ArticleMonth
								when 'Jan' then '1'
								when 'Feb' then '2'
								when 'Mar' then '3'
								when 'Apr' then '4'
								when 'May' then '5'
								when 'Jun' then '6'
								when 'Jul' then '7'
								when 'Aug' then '8'
								when 'Sep' then '9'
								when 'Oct' then '10'
								when 'Nov' then '11'
								when 'Dec' then '12'
								when 'Win' then '1'
								when 'Spr' then '4'
								when 'Sum' then '7'
								when 'Fal' then '10'
								when '1' then '1'
								when '2' then '2'
								when '3' then '3'
								when '4' then '4'
								when '5' then '5'
								when '6' then '6'
								when '7' then '7'
								when '8' then '8'
								when '9' then '9'
								when '01' then '1'
								when '02' then '2'
								when '03' then '3'
								when '04' then '4'
								when '05' then '5'
								when '06' then '6'
								when '07' then '7'
								when '08' then '8'
								when '09' then '9'
								when '10' then '10'
								when '11' then '11'
								when '12' then '12'
								else null end)
	declare @jd datetime
	declare @ad datetime


	set @jd = (select case when @JournalYear is not null and (@MedlineYear is null or @JournalMonth is not null) then
							cast(coalesce(@JournalMonth,'1') + '/' + coalesce(@JournalDay,'1') + '/' + @JournalYear as datetime)
						when @MedlineYear is not null then
							cast(coalesce(@MedlineMonth,'1') + '/1/' + @MedlineYear as datetime)
						else
							null
						end)

	set @ad = (select case when @ArticleYear is not null then
							cast(coalesce(@ArticleMonth,'1') + '/' + coalesce(@ArticleDay,'1') + '/' + @ArticleYear as datetime)
						else
							null
						end)

	declare @jdx int
	declare @adx int

	set @jdx = (select case when @jd is null then 0
							when @JournalDay is not null then 3
							when @JournalMonth is not null then 2
							else 1
							end)
	set @adx = (select case when @ad is null then 0
							when @ArticleDay is not null then 3
							when @ArticleMonth is not null then 2
							else 1
							end)

	set @PubDate = (select case when @jdx + @adx = 0 then cast('1/1/1900' as datetime)
								when @jdx > @adx then @jd
								when @adx > @jdx then @ad
								when @ad < @jd then @ad
								else @jd
								end)

	-- Return the result of the function
	RETURN @PubDate

END
GO
