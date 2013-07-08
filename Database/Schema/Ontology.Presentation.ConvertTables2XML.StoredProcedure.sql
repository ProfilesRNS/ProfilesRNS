SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.Presentation].[ConvertTables2XML]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	TRUNCATE TABLE [Ontology.Presentation].[XML]
	INSERT INTO [Ontology.Presentation].[XML]
		SELECT PresentationID, Type, Subject, Predicate, Object,
			(SELECT	(CASE Type WHEN 'P' THEN 'profile' WHEN 'N' THEN 'network' WHEN 'C' THEN 'connection' WHEN 'E' THEN 'profile' END) "@PresentationClass",
					PageColumns "PageOptions/@Columns",
					WindowName,
					PageColumns,
					PageTitle,
					PageBackLinkName,
					PageBackLinkURL,
					PageSubTitle,
					PageDescription,
					PanelTabType,
					(SELECT	Type "Panel/@Type",
							(CASE WHEN TabSort = -1 THEN NULL ELSE TabSort END) "Panel/@TabSort",
							TabType "Panel/@TabType",
							Alias "Panel/@Alias",
							Name "Panel/@Name",
							Icon "Panel/@Icon",
							DisplayRule "Panel/@DisplayRule",
							ModuleXML "Panel"
						FROM [Ontology.Presentation].[Panel] p
						WHERE p.PresentationID = g.PresentationID
						FOR XML PATH(''), TYPE
					) PanelList,
					ExpandRDFList ExpandRDFList
				FOR XML PATH('Presentation'), TYPE
			) PresentationXML,
			[RDF.].fnURI2NodeID(subject) _SubjectNode,
			[RDF.].fnURI2NodeID(predicate) _PredicateNode,
			[RDF.].fnURI2NodeID(object) _ObjectNode
		FROM [Ontology.Presentation].[General] g

	-- SELECT * FROM [Ontology.Presentation].[XML]

END
GO
