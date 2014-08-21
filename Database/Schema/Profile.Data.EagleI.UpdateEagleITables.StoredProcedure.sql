SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[EagleI.UpdateEagleITables]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select right(ProfilesURI,charindex('/',reverse(ProfilesURI))-1) NodeID, *
		into #e
		from (
			select
				r.x.value('profiles-uri[1]','varchar(1000)') ProfilesURI,
				r.x.value('eagle-i-uri[1]','varchar(1000)') EagleiURI,
				cast(r.x.query('html-fragment[1]/*') as nvarchar(max)) HTML
			from [Profile.Data].[EagleI.ImportXML] e cross apply e.x.nodes('//eagle-i-mappings/eagle-i-mapping') as r(x)
		) t


	select e.*, m.InternalID as PersonID
		into #EagleI
		from #e e
			inner join [RDF.Stage].[InternalNodeMap] m
			on e.NodeID = m.NodeID and m.Class = 'http://xmlns.com/foaf/0.1/Person' and m.InternalType = 'Person'
		where e.NodeID is not null and IsNumeric(e.NodeID) = 1

	truncate table [Profile.Data].[EagleI.HTML]

	insert into [Profile.Data].[EagleI.HTML] (NodeID, PersonID, EagleIURI, HTML)
		select NodeID, PersonID, EagleIURI, HTML from #EagleI

END
