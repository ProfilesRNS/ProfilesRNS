SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[GenericRDF.AddEditPluginData]
	@Name varchar(55),
	@NodeID bigint,
	@Data varchar(max),
	@SearchableData varchar(max)
AS
BEGIN
	DECLARE @Error bit, @PluginInstanceID BIGINT
	IF ISNULL(@Data, '') <> ''
	BEGIN
		IF EXISTS (SELECT 1 FROM [Profile.Module].[GenericRDF.Data] WHERE Name = @Name and NodeID = @NodeID)
		BEGIN
			UPDATE [Profile.Module].[GenericRDF.Data] SET Data = @Data, SearchableData = @SearchableData WHERE Name = @Name and NodeID = @NodeID
		END
		ELSE
		BEGIN		
			INSERT INTO [Profile.Module].[GenericRDF.Data] (Name, NodeID, Data, SearchableData) VALUES(@Name, @NodeID, @Data, @SearchableData)
		END
		EXEC [Profile.Module].[GenericRDF.AddPluginToProfile] @SubjectID=@NodeID, @PluginName=@Name, @Error=@Error OUTPUT, @NodeID=@PluginInstanceID OUTPUT
	END
	ELSE
	BEGIN
		EXEC [Profile.Module].[GenericRDF.RemovePluginFromProfile] @SubjectID=@NodeID, @PluginName=@Name
		DELETE FROM [Profile.Module].[GenericRDF.Data] WHERE Name = @Name and NodeID = @NodeID
	END
END
GO
