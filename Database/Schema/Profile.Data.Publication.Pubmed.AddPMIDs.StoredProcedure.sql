SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Publication.Pubmed.AddPMIDs] (@personid INT,
																		@PMIDxml XML)
AS
BEGIN
	SET NOCOUNT ON;	
	

	BEGIN TRY
		BEGIN TRAN		 
			  delete from [Profile.Data].[Publication.PubMed.Disambiguation] where personid = @personid				 
			  -- Add publications_include records
			  INSERT INTO [Profile.Data].[Publication.PubMed.Disambiguation] (personid,pmid)
			  SELECT @personid,
					 D.element.value('.','INT') pmid		 
				FROM @PMIDxml.nodes('//PMID') AS D(element)
			   WHERE NOT EXISTS(SELECT TOP 1 * FROM [Profile.Data].[Publication.PubMed.Disambiguation]	 dp WHERE personid = @personid and dp.pmid = D.element.value('.','INT'))	

		
		COMMIT
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK

		-- Raise an error with the details of the exception
		SELECT @ErrMsg = 'usp_CheckPMIDList FAILED WITH : ' + ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH				
END
GO
