SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.].[ParseSearchString]
	@SearchString VARCHAR(500) = NULL,
	@NumberOfPhrases INT = 0 OUTPUT,
	@CombinedSearchString VARCHAR(8000) = '' OUTPUT,
	@SearchPhraseXML XML = NULL OUTPUT,
	@SearchPhraseFormsXML XML = NULL OUTPUT,
	@ProcessTime INT = 0 OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

	-- Start timer
	declare @d datetime
	select @d = GetDate()


	-- Remove bad characters
	declare @SearchStringNormalized varchar(max)
	select @SearchStringNormalized = ''
	declare @StringPos int
	select @StringPos = 1
	declare @InQuotes tinyint
	select @InQuotes = 0
	declare @Char char(1)
	while @StringPos <= len(@SearchString)
	begin
		select @Char = substring(@SearchString,@StringPos,1)
		select @InQuotes = 1 - @InQuotes where @Char = '"'
		if @Char like '[0-9A-Za-z]'
			select @SearchStringNormalized = @SearchStringNormalized + @Char
		else if @Char = '"'
			select @SearchStringNormalized = @SearchStringNormalized + ' '
		else if right(@SearchStringNormalized,1) not in (' ','_')
			select @SearchStringNormalized = @SearchStringNormalized + (case when @InQuotes = 1 then '_' else ' ' end)
		select @StringPos = @StringPos + 1
	end
	select @SearchStringNormalized = replace(@SearchStringNormalized,'  ',' ')
	select @SearchStringNormalized = ' ' + ltrim(rtrim(replace(replace(' '+@SearchStringNormalized+' ',' _',' '),'_ ',' '))) + ' |'


	-- Find phrase positions
	declare @PhraseBreakPositions table (z int, n int, m int, i int)
	;with a as (
		select n.n, row_number() over (order by n.n) - 1 i
			from [Utility.Math].N n
			where n.n between 1 and len(@SearchStringNormalized) and substring(@SearchStringNormalized,n.n,1) = ' '
	), b as (
		select count(*)-1 j from a
	)
	insert into @PhraseBreakPositions
		select n.n z, a.n, a.i m, row_number() over (partition by n.n order by a.n) i
			from a, b, [Utility.Math].N n
			where n.n < Power(2,b.j-1)
				and 1 = (case when a.i=0 then 1 when a.i=b.j then 1 when Power(2,a.i-1) & n.n > 0 then 1 else 0 end)
	select @SearchStringNormalized = replace(@SearchStringNormalized,'_',' ')


	-- Extract phrases
	declare @TempPhraseList table (i int, w varchar(max), x int) 
	;with d as (
		select c.*, substring(@SearchStringNormalized,c.n+1,d.n-c.n-1) w, d.m-c.m l
			from @PhraseBreakPositions c, @PhraseBreakPositions d
			where c.z=d.z and c.i=d.i-1
	), e as (
		select d.*, IsNull(t.x,0) x
		from d outer apply (select top 1 1 x from [Utility.NLP].Thesaurus t where d.w = t.TermName) t
	), f as (
		select top 1 z
		from e
		group by z 
		order by sum(l*l*x) desc, z desc
	)
	insert into @TempPhraseList
		select row_number() over (order by e.i) i, e.w, e.x
			from e, f
			where e.z = f.z
				and e.w not in (select word from [Utility.NLP].StopWord where scope = 0)
				and e.w <> ''
	declare @PhraseList table (PhraseID int, Phrase varchar(max), ThesaurusMatch bit, Forms varchar(max))
	insert into @PhraseList (PhraseID, Phrase, ThesaurusMatch, Forms)
		select i, w, x, (case when x = 0 then '"'+[Utility.NLP].fnPorterAlgorithm(p.w)+'*"'
						else substring(cast( (
									select distinct ' OR "'+v.TermName+'"'
										from [Utility.NLP].Thesaurus t, [Utility.NLP].Thesaurus v
										where p.w=t.TermName and t.Source=v.Source and t.ConceptID=v.ConceptID
										for xml path(''), type
								) as varchar(max)),5,999999)
						end)
		from @TempPhraseList p
	select @NumberOfPhrases = (select max(PhraseID) from @PhraseList)
	select @SearchStringNormalized = substring(@SearchStringNormalized,2,len(@SearchStringNormalized)-3)


	-- Create a combined string for fulltext search
	select @CombinedSearchString = 
			(case when @NumberOfPhrases = 0 then ''
				when @NumberOfPhrases = 1 then
					'"'+@SearchStringNormalized+'" OR ' + (select Forms from @PhraseList)
				else
					'"'+@SearchStringNormalized+'"'
					+ ' OR '
					+ '(' + replace(@SearchStringNormalized,' ',' NEAR ') + ')'
					+ ' OR '
					+ '(' + substring(cast((select ' AND ('+Forms+')' from @PhraseList order by PhraseID for xml path(''), type) as varchar(max)),6,999999) + ')'
				end)
				
	
	-- Create an XML message listing the parsed phrases
	select @SearchPhraseXML =		(select
										(select PhraseID "SearchPhrase/@ID", 
											(case when ThesaurusMatch='1' then 'true' else 'false' end) "SearchPhrase/@ThesaurusMatch",
											Phrase "SearchPhrase"
										from @PhraseList
										order by PhraseID
										for xml path(''), type) "SearchPhraseList"
									for xml path(''), type)
	select @SearchPhraseFormsXML =	(select
										(select PhraseID "SearchPhrase/@ID", 
											(case when ThesaurusMatch='1' then 'true' else 'false' end) "SearchPhrase/@ThesaurusMatch",
											Forms "SearchPhrase/@Forms",
											Phrase "SearchPhrase"
										from @PhraseList
										order by PhraseID
										for xml path(''), type) "SearchPhraseList"
									for xml path(''), type)

					
	-- End timer
	select @ProcessTime = datediff(ms,@d,GetDate())

END
GO
