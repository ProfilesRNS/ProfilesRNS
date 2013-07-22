SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.Stage].[LoadAliases]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	TRUNCATE TABLE [RDF.].Alias

	INSERT INTO [RDF.].Alias (AliasType, AliasID, NodeID, Preferred)
		SELECT 'Network', 'CoAuthors', [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf'), 1
	INSERT INTO [RDF.].Alias (AliasType, AliasID, NodeID, Preferred)
		SELECT 'Network', 'SimilarTo', [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#similarTo'), 1
	INSERT INTO [RDF.].Alias (AliasType, AliasID, NodeID, Preferred)
		SELECT 'Network', 'ResearchAreas', [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#hasResearchArea'), 1

	/*
	
	-- Example: PersonID as the preferred alias for a person
	INSERT INTO [RDF.].Alias (AliasType, AliasID, NodeID, Preferred)
		SELECT InternalType, InternalID, NodeID, 1
			FROM [RDF.Stage].InternalNodeMap
			WHERE InternalType='Person' and Class = 'http://xmlns.com/foaf/0.1/Person'

	-- Example: InternalUsername as an alternative alias for a person
	INSERT INTO [RDF.].Alias (AliasType, AliasID, NodeID, Preferred)
		SELECT 'Username', p.InternalUsername, m.NodeID, 0
			FROM [RDF.Stage].InternalNodeMap m, [Profile.Data].[Person] p
			WHERE m.InternalType='Person' and m.Class = 'http://xmlns.com/foaf/0.1/Person'
				and m.InternalID = CAST(p.PersonID as varchar(50))

	*/
	
END
GO
