SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Framework.].[GetBaseURI]
AS
BEGIN
	select [value] from [Framework.].[parameter] with(nolock) where parameterid = 'baseuri'

END
GO
