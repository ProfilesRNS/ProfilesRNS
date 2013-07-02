SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Organization.GetDivisions]

AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT x.DivisionID, x.DivisionName, n.NodeID, n.Value URI
		FROM (
				SELECT *
				FROM [Profile.Data].[Organization.Division] WITH (NOLOCK)
				WHERE LTRIM(RTRIM(DivisionName))<>''
			) x 
			LEFT OUTER JOIN [RDF.Stage].InternalNodeMap m WITH (NOLOCK)
				ON m.class = 'http://xmlns.com/foaf/0.1/Organization'
					AND m.InternalType = 'Division'
					AND m.InternalID = CAST(x.DivisionID AS VARCHAR(50))
			LEFT OUTER JOIN [RDF.].Node n WITH (NOLOCK)
				ON m.NodeID = n.NodeID
					AND n.ViewSecurityGroup = -1
		ORDER BY DivisionName

END
GO
