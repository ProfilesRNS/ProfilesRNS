SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[Person.Mentoring.Overview]
	@Subject bigint=NULL
	,@PropertyURI [varchar](100)
	,@Json nvarchar(max)
	,@status varchar(50) OUTPUT
AS
BEGIN
	declare @overview nvarchar(max)
	select @overview = [value] from openJson(@json) where [Key] = 'text'


	declare @personID int
	select @personID = personID from [Profile.Cache].Person where NodeID = @Subject

	BEGIN TRANSACTION
	delete from [Profile.Data].[Person.Mentoring.Overview] where personID = @PersonID
	insert into [Profile.Data].[Person.Mentoring.Overview] (PersonID, JSON, OverviewText) values (@PersonID, @json, @overview)
	COMMIT TRANSACTION


	declare @dataMapID int
	select @dataMapID = DataMapID from [Ontology.].DataMap where Class = 'http://xmlns.com/foaf/0.1/Person' and Property = 'http://profiles.catalyst.harvard.edu/ontology/prns#mentoringOverview'
	EXEC [RDF.Stage].ProcessDataMap   @DataMapID = @dataMapID, @InternalIdIn = @personID, @TurnOffIndexing=0, @SaveLog=0;	

	select @status = 'SUCCESS'
END
GO
