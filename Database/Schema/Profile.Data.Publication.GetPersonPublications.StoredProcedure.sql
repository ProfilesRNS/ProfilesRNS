SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.GetPersonPublications] 
	-- Add the parameters for the stored procedure here
	@UserID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
SELECT *
  FROM [Profile.Data].[fnPublication.Person.GetPublications](@UserID)
 
 
	--ORDER BY publication_dt, publications
 
 
 
END
GO
