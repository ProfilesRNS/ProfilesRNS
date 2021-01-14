SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.Pubmed.ParsePubmedBookArticle]
	@pmid int,
	@mpid varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	

	if not exists (select 1 from [Profile.Data].[vwPublication.PubMed.AllXML.PubmedBookArticle] where pmid = @pmid)
	begin
		set @ErrMsg =  'Error in [Profile.Data].[Publication.Pubmed.ParsePubmedBookArticle] pmid ' + cast(@pmid as varchar(50)) + ' does not exist'
		RAISERROR(@ErrMsg, 16, 1)
	end

	create table #authors (
		ValidYN varchar(1),
		LastName varchar(100),
		FirstName varchar(100),
		ForeName varchar(100),
		Suffix varchar(20),
		Initials varchar(20),
		Affiliation varchar(max))
			
	insert into #authors
	select
		nref.value('@ValidYN','varchar(1)') ValidYN, 
		nref.value('LastName[1]','varchar(100)') LastName, 
		nref.value('FirstName[1]','varchar(100)') FirstName,
		nref.value('ForeName[1]','varchar(100)') ForeName,
		nref.value('Suffix[1]','varchar(20)') Suffix,
		nref.value('Initials[1]','varchar(20)') Initials,
		COALESCE(nref.value('AffiliationInfo[1]/Affiliation[1]','varchar(1000)'),
			nref.value('Affiliation[1]','varchar(max)')) Affiliation
	from [Profile.Data].[Publication.PubMed.AllXML] cross apply x.nodes('//AuthorList[@Type="authors"]/Author') as R(nref) 
	where pmid = @pmid

	declare @authors varchar(max)
	select @authors = isnull(cast((
		select ', '+lastname+' '+initials
		from #authors q
		--order by PmPubsAuthorID
		for xml path(''), type
	) as nvarchar(max)),'') 

	if len(@authors) > 2
	select @authors = SUBSTRING(@authors, 3, len(@authors) - 2)
	
	BEGIN TRY
	BEGIN TRANSACTION
		if exists (select 1 from [Profile.Data].[Publication.MyPub.General] where pmid=@pmid)
		begin
			update a set 
				HmsPubCategory = b.HmsPubCategory,
				a.PubTitle = b.PubTitle,
				a.ArticleTitle = b.ArticleTitle,
				a.PlaceOfPub = b.PlaceOfPub,
				a.Publisher = b.Publisher,
				a.PublicationDT = b.PublicationDT,
				a.Authors = isnull(@authors, ''),
				URL = 'https://www.ncbi.nlm.nih.gov/pubmed/' + cast(@pmid as varchar(50))
			from [Profile.Data].[Publication.MyPub.General] a
			join [Profile.Data].[vwPublication.PubMed.AllXML.PubmedBookArticle] b
			on a.PMID = @pmid and b.PMID = @pmid
		end 
		else 
		begin
			insert into [Profile.Data].[Publication.MyPub.General] (MPID, PMID, HmsPubCategory, PubTitle, ArticleTitle, PlaceOfPub, Publisher, PublicationDT, Authors, URL)
			select @mpid, PMID, HmsPubCategory, PubTitle, ArticleTitle, PlaceOfPub, Publisher, PublicationDT, isnull(@authors, ''), 'https://www.ncbi.nlm.nih.gov/pubmed/' + cast(@pmid as varchar(50)) from [Profile.Data].[vwPublication.PubMed.AllXML.PubmedBookArticle] where pmid = @pmid
		end

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=1
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
END
GO
