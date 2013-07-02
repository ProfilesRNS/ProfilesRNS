SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Person.DoesPersonExist](	@PersonID INT,@exists BIT OUTPUT)
AS
BEGIN
	SET NOCOUNT ON;

  SELECT @exists=0
  SELECT TOP 1 @exists=0, @exists = CASE WHEN PersonID	  IS NULL THEN 0 ELSE 1 END  
		FROM [Profile.Data].vw_person 
	 WHERE PersonID	  = @PersonID
		 AND IsActive=1
 
END
GO
