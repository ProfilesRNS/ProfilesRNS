SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Concept.Mesh.GetSimilarMesh]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DescriptorName NVARCHAR(255)
 	SELECT @DescriptorName = d.DescriptorName
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n,
			[Profile.Data].[Concept.Mesh.Descriptor] d
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
			AND m.InternalID = d.DescriptorUI

 	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	;with a as (
		select SimilarConcept DescriptorName, Weight, SortOrder
		from [Profile.Cache].[Concept.Mesh.SimilarConcept]
		where meshheader = @DescriptorName
	), b as (
		select top 10 DescriptorName, Weight, (select count(*) from a) TotalRecords, SortOrder
		from a
	)
	 SELECT b.*, @baseURI + cast(m.NodeID as varchar(50)) ObjectURI
		 FROM [RDF.Stage].[InternalNodeMap] m, [Profile.Data].[Concept.Mesh.Descriptor] d, b
		 WHERE m.Class = 'http://www.w3.org/2004/02/skos/core#Concept' AND m.InternalType = 'MeshDescriptor'
			AND m.InternalID = d.DescriptorUI AND d.DescriptorName = b.DescriptorName

END
GO
