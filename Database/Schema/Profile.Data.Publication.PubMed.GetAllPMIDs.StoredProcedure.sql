SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored Procedure

CREATE procedure [Profile.Data].[Publication.PubMed.GetAllPMIDs] (@GetOnlyNewXML BIT=0 )
AS
BEGIN
	SET NOCOUNT ON;	


	BEGIN TRY
		IF @GetOnlyNewXML = 1 
		-- ONLY GET XML FOR NEW Publications
			BEGIN
				SELECT pmid
				  FROM [Profile.Data].[Publication.PubMed.Disambiguation]
				 WHERE pmid NOT IN(SELECT PMID FROM [Profile.Data].[Publication.PubMed.General])
				   AND pmid IS NOT NULL 
			END
		ELSE 
		-- FULL REFRESH
			BEGIN
				SELECT pmid
				  FROM [Profile.Data].[Publication.PubMed.Disambiguation]
				 WHERE pmid IS NOT NULL 
				 UNION   
				SELECT pmid
				  FROM [Profile.Data].[Publication.Person.Include]
				 WHERE pmid IS NOT NULL 
			END 

	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK

		-- Raise an error with the details of the exception
		SELECT @ErrMsg = 'FAILED WITH : ' + ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)

	END CATCH				
END
GO
