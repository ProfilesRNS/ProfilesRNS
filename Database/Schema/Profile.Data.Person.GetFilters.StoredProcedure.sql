SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Person.GetFilters]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT x.PersonFilterID, x.PersonFilterCategory, x.PersonFilter, x.PersonFilterSort, n.NodeID, n.Value URI
		FROM (
				SELECT PersonFilterID, PersonFilterCategory, PersonFilter, PersonFilterSort
				FROM [Profile.Data].[Person.Filter]
			) x 
			LEFT OUTER JOIN [RDF.Stage].InternalNodeMap m WITH (NOLOCK)
				ON m.class = 'http://profiles.catalyst.harvard.edu/ontology/prns#PersonFilter'
					AND m.InternalType = 'PersonFilter'
					AND m.InternalID = CAST(x.PersonFilterID AS VARCHAR(50))
			LEFT OUTER JOIN [RDF.].Node n WITH (NOLOCK)
				ON m.NodeID = n.NodeID
					AND n.ViewSecurityGroup = -1
		ORDER BY PersonFilterSort

END
GO
