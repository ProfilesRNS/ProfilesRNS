SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.DoesPublicationExist](	@pmid INT, @exists BIT OUTPUT)
AS
BEGIN
	SET NOCOUNT ON;

  SELECT @exists=0
  SELECT TOP 1 @exists=0, @exists = CASE WHEN PMID IS NULL THEN 0 ELSE 1 END  
		FROM [Profile.Data].[Publication.PubMed.AllXML] 
	 WHERE pmid = @PMID	 

END
GO
