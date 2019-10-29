SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [Profile.Data].[Funding.GetDisambiguationSettings](
	@PersonID int
	)
AS 
BEGIN
	select * from [Profile.Data].[Funding.DisambiguationSettings] where PersonID = @PersonID
END
GO
