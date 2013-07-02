SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure  [Profile.Data].[Publication.Pubmed.AddPubMedXML] ( 					 @pmid INT,
																			   @pubmedxml XML)
AS
BEGIN
	SET NOCOUNT ON;	
	 
	-- Parse Load Publication XML
	BEGIN TRY 	 
	
	IF ISNULL(CAST(@pubmedxml AS NVARCHAR(MAX)),'')='' 
		BEGIN
			DELETE FROM [Profile.Data].[Publication.PubMed.Disambiguation] WHERE pmid = @pmid AND NOT EXISTS (SELECT 1 FROM [Profile.Data].[Publication.Person.Add]  pa WHERE pa.pmid = @pmid)
			RETURN
		END
 
		BEGIN TRAN
			-- Remove existing pmid record
			DELETE FROM [Profile.Data].[Publication.PubMed.AllXML] WHERE pmid = @pmid
		
			-- Add Pub Med XML	
			INSERT INTO [Profile.Data].[Publication.PubMed.AllXML](pmid,X) VALUES(@pmid,CAST(@pubmedxml AS XML))		
			
			-- Parse Pub Med XML
			EXEC [Profile.Data].[Publication.Pubmed.ParsePubMedXML] 	 @pmid		
		 
		COMMIT
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg = '[Profile.Data].[Publication.Pubmed.AddPubMedXML] FAILED WITH : ' + ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH				
END
GO
