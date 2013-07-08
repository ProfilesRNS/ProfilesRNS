SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [Profile.Data].[Person.UpdateUnGeocodedAddress]	 (@latitude VARCHAR(20),
												  @longitude VARCHAR(20),
												  @geoscore VARCHAR(10),
												  @addressstring VARCHAR(2000))
AS
BEGIN
	SET NOCOUNT ON;	

UPDATE [Profile.Data].Person
   SET latitude=@latitude,
	   longitude=@longitude,
	   geoscore=@geoscore
 WHERE addressstring=@addressstring
 

END
GO
