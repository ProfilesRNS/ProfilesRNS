SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[ConnectionDetails.Person.SimilarTo.GetData]
	@subject BIGINT,
	@object BIGINT,
	@SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @subject
 
	DECLARE @PersonID2 INT
 	SELECT @PersonID2 = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @object

	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	DECLARE @hasResearchAreaID BIGINT
	SELECT @hasResearchAreaID = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#hasResearchArea')

	;with a as (
		select a.PersonID PersonID1, b.PersonID PersonID2, a.MeshHeader, 
			a.NumPubsThis PublicationCount1, b.NumPubsThis PublicationCount2,
			a.Weight KeywordWeight1, b.Weight KeywordWeight2,
			a.Weight*b.Weight OverallWeight
		from [Profile.Cache].[Concept.Mesh.Person] a, [Profile.Cache].[Concept.Mesh.Person] b
		where a.personid = @PersonID and b.personid = @PersonID2
			and a.meshheader = b.meshheader
	), b as (
		select count(*) SharedKeywords, sum(OverallWeight) TotalOverallWeight 
		from a
	)
	select a.*, b.*, @baseURI + cast(m.NodeID as varchar(50)) ObjectURI,
		@baseURI + cast(@subject as varchar(50)) + '/' + cast(@hasResearchAreaID as varchar(50)) + '/' + cast(m.NodeID as varchar(50)) ConnectionURI1,
		@baseURI + cast(@object as varchar(50)) + '/' + cast(@hasResearchAreaID as varchar(50)) + '/' + cast(m.NodeID as varchar(50)) ConnectionURI2
	from a, b, [Profile.Data].[Concept.Mesh.Descriptor] d, [RDF.Stage].[InternalNodeMap] m
	where a.MeshHeader = d.DescriptorName and d.DescriptorUI = m.InternalID
		and m.Class = 'http://www.w3.org/2004/02/skos/core#Concept' and m.InternalType = 'MeshDescriptor'
	order by OverallWeight desc, MeshHeader

END
GO
