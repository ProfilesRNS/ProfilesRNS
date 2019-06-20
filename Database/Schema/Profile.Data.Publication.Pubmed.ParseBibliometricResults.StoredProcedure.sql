SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Publication.Pubmed.ParseBibliometricResults]
	@Data xml
AS
BEGIN
	create table #tmp(
		pmid int primary key,
		PMCCitations int,
		MedlineTA varchar(255),
		TranslationAnimals int,
		TranslationCells int,
		TranslationHumans int,
		TranslationPublicHealth int,
		TranslationClinicalTrial int
	)

	CREATE TABLE #tmpJournalHeading(
		[MedlineTA] [varchar](255) NOT NULL,
		[BroadJournalHeading] [varchar](100) NOT NULL,
		[Weight] [float] NULL,
		[DisplayName] [varchar](100) NULL,
		[Abbreviation] [varchar](50) NULL,
		[Color] [varchar](6) NULL,
		[Angle] [float] NULL,
		[Arc] [float] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[MedlineTA] ASC,
		[BroadJournalHeading] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	)


	insert into #tmp
	select t.x.value('PMID[1]', 'int') as PMID,
	t.x.value('PMCCitations[1]', 'int') as PMCCitations,
	t.x.value('MedlineTA[1]', 'varchar(255)') as MedlineTA,
	t.x.value('TranslationAnimals[1]', 'int') as TranslationAnimals,
	t.x.value('TranslationCells[1]', 'int') as TranslationCells,
	t.x.value('TranslationHumans[1]', 'int') as TranslationHumans,
	t.x.value('TranslationPublicHealth[1]', 'int') as TranslationPublicHealth,
	t.x.value('TranslationClinicalTrial[1]', 'int') as TranslationClinicalTrial
	from @data.nodes('/Bibliometrics/ArticleSummary') t(x)

	insert into #tmpJournalHeading (MedlineTA, BroadJournalHeading, DisplayName, Abbreviation, Color, Angle, Arc)
		select 
		t.x.value('MedlineTA[1]', 'varchar(255)') as MedlineTA,
		t.x.value('BroadJournalHeading[1]', 'varchar(100)') as BroadJournalHeading,
	--	t.x.value('Weight[1]', 'float') as Weight,
		t.x.value('DisplayName[1]', 'varchar(100)') as DisplayName,
		t.x.value('Abbreviation[1]', 'varchar(50)') as Abbreviation,
		t.x.value('Color[1]', 'varchar(6)') as Color,
		t.x.value('Angle[1]', 'float') as Angle,
		t.x.value('Arc[1]', 'float') as Arc
		from @data.nodes('/Bibliometrics/JournalHeading') t(x)

	;with counts as (
		select MedlineTA, count(*) c from #tmpJournalHeading
		Group by MedlineTA
	)
	update a set a.weight = 1.0 / c from #tmpJournalHeading a join counts b on a.MedlineTA = b.MedlineTA

	delete from [Profile.Data].[Publication.Pubmed.JournalHeading] where MedlineTA in (select MedlineTA from #tmpJournalHeading)
	insert into [Profile.Data].[Publication.Pubmed.JournalHeading] select * from #tmpJournalHeading

	delete from [Profile.Data].[Publication.Pubmed.Bibliometrics] where PMID in (select pmid from #tmp)

	;
	with abbs as (
		SELECT t2.MedlineTA, weight, STUFF((SELECT ',' + '["' + CAST([Abbreviation] AS varchar) + '",#' + CAST([Color] as varchar) + ']' FROM [Profile.Data].[Publication.Pubmed.JournalHeading] t1  where t1.MedlineTA =t2.MedlineTA FOR XML PATH('')), 1 ,1, '') AS ValueList
		FROM #tmpJournalHeading t2
		GROUP BY t2.MedlineTA, t2.Weight
	)
	insert into [Profile.Data].[Publication.Pubmed.Bibliometrics] 
		(PMID, PMCCitations, MedlineTA, Fields, TranslationHumans, TranslationAnimals, TranslationCells, TranslationPublicHealth, TranslationClinicalTrial)
	select PMID, PMCCitations, a.MedlineTA, '{' + ValueList +  '}', TranslationHumans, TranslationAnimals, TranslationCells, TranslationPublicHealth, TranslationClinicalTrial
		from #tmp a join abbs b on a.MedlineTA = b.MedlineTA

END
GO
