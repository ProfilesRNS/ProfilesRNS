SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[GenericRDF.GetPluginData]
	@Name varchar(55),
	@NodeID bigint
AS
BEGIN
	SELECT data FROM [Profile.Module].[GenericRDF.Data] WHERE name = @name AND NodeID = @NodeID
END
GO
