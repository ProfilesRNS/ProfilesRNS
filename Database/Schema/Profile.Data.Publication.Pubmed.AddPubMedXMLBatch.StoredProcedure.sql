SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Data].[Publication.Pubmed.AddPubMedXMLBatch]	
	@Data xml
AS
BEGIN		
	create table #tmpPubs (pmid int primary key, Filename varchar(50), x xml)
		insert into #tmpPubs (pmid, Filename, x)
		select t.x.value('@PMID', 'int') as PMID,
		t.x.value('@Filename', 'varchar(50)') as PMCCitations,
		t.x.query('PubmedArticle') as x
		from @data.nodes('/Publications/Publication') t(x)

		delete from [Profile.Data].[Publication.PubMed.AllXML] where pmid in (select pmid from #tmpPubs)
		insert into [Profile.Data].[Publication.PubMed.AllXML] (pmid, x, filename) select pmid, x, filename from #tmpPubs
END
GO
