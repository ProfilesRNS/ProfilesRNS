SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [Profile.Data].[Publication.Pubmed.GetDisambiguationSettings](
	@PersonID int
	)
AS 
BEGIN
	select * from [Profile.Data].[Publication.Pubmed.DisambiguationSettings] where PersonID = @PersonID
END
GO
