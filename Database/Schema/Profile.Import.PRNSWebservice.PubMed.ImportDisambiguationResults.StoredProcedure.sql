SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[PRNSWebservice.PubMed.ImportDisambiguationResults] 
	@Job varchar(55) = '',
	@BatchID varchar(100) = '',
	@RowID int = -1,
	@LogID int = -1,
	@URL varchar (500) = '',
	@Data varchar(max)
AS
BEGIN
	SET NOCOUNT ON;	
	
	declare @x xml
	select @x = cast(@Data as xml)


	BEGIN TRY
		BEGIN TRAN		 
			  declare @rowsCount int
			  --delete from [Profile.Data].[Publication.PubMed.Disambiguation] where personid = @RowID				 
			  -- Add publications_include records
			  INSERT INTO [Profile.Data].[Publication.PubMed.Disambiguation] (personid,pmid)
			  SELECT @RowID,
					 D.element.value('.','INT') pmid		 
				FROM @x.nodes('//PMID') AS D(element)
			   WHERE NOT EXISTS(SELECT TOP 1 * FROM [Profile.Data].[Publication.PubMed.Disambiguation]	 dp WHERE personid = @RowID and dp.pmid = D.element.value('.','INT'))	
			   select @rowsCount = @@ROWCOUNT
			   if @logID > 0
			       update [Profile.Import].[PRNSWebservice.Log] set ResultCount = @rowsCount where LogID = @logID

		
		COMMIT
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK

		-- Raise an error with the details of the exception
		SELECT @ErrMsg = '[Profile.Import].[PRNSWebservice.PubMed.ImportDisambiguationResults]' + ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH				
END
GO
