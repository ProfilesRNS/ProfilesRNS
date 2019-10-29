SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [Profile.Data].[Funding.UpdateDisambiguationSettings](
	@PersonID int,
	@Enabled bit = 1
	)
AS 
BEGIN
	if exists (select 1 from [Profile.Data].[Funding.DisambiguationSettings] where PersonID = @PersonID)
	BEGIN
		update [Profile.Data].[Funding.DisambiguationSettings] set Enabled = @Enabled where PersonID = @PersonID
	END
	ELSE 
	BEGIN
		insert into [Profile.Data].[Funding.DisambiguationSettings] (PersonID, Enabled) values (@PersonID, @Enabled)
	END
END
GO
