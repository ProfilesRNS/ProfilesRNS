SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Person.GetUnGeocodedAddresses]	 
AS
BEGIN
	SET NOCOUNT ON;	

SELECT DISTINCT addressstring
  FROM [Profile.Data].Person
 WHERE (ISNULL(latitude ,0)=0
 		OR geoscore = 0)
and addressstring<>''


END
GO
