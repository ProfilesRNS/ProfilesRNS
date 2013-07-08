SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Person.GetFacultyRanks]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT x.FacultyRankID, x.FacultyRank,  n.NodeID, n.Value URI
		FROM (
				SELECT CAST(MAX(FacultyRankID) AS VARCHAR(50)) FacultyRankID,
						LTRIM(RTRIM(FacultyRank)) FacultyRank					
				FROM [Profile.Data].[Person.FacultyRank] WITH (NOLOCK) where facultyrank <> ''				
				group by FacultyRank ,FacultyRankSort
			) x 
			LEFT OUTER JOIN [RDF.Stage].InternalNodeMap m WITH (NOLOCK)
				ON m.class = 'http://profiles.catalyst.harvard.edu/ontology/prns#FacultyRank'
					AND m.InternalType = 'FacultyRank'
					AND m.InternalID = CAST(x.FacultyRankID AS VARCHAR(50))
			LEFT OUTER JOIN [RDF.].Node n WITH (NOLOCK)
				ON m.NodeID = n.NodeID
					AND n.ViewSecurityGroup = -1
		
 
 



END
GO
