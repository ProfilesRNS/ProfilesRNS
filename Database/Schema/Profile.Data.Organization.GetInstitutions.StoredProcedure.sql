SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Organization.GetInstitutions]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT x.InstitutionID, x.InstitutionName, x.InstitutionAbbreviation, n.NodeID, n.Value URI
		FROM (
				SELECT CAST(MAX(InstitutionID) AS VARCHAR(50)) InstitutionID,
						LTRIM(RTRIM(InstitutionName)) InstitutionName, 
						MIN(institutionabbreviation) InstitutionAbbreviation
				FROM [Profile.Data].[Organization.Institution] WITH (NOLOCK)
				GROUP BY LTRIM(RTRIM(InstitutionName))
			) x 
			LEFT OUTER JOIN [RDF.Stage].InternalNodeMap m WITH (NOLOCK)
				ON m.class = 'http://xmlns.com/foaf/0.1/Organization'
					AND m.InternalType = 'Institution'
					AND m.InternalID = CAST(x.InstitutionID AS VARCHAR(50))
			LEFT OUTER JOIN [RDF.].Node n WITH (NOLOCK)
				ON m.NodeID = n.NodeID
					AND n.ViewSecurityGroup = -1
		ORDER BY InstitutionName

END
GO
