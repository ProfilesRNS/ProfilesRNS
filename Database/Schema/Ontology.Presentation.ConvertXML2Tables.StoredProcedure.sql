SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.Presentation].[ConvertXML2Tables]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	truncate table [Ontology.Presentation].[General]
	insert into [Ontology.Presentation].[General]
		select	PresentationID, 
				Type,
				Subject,
				Predicate,
				Object,
				PresentationXML.value('Presentation[1]/PageOptions[1]/@Columns[1]','varchar(max)') PageColumns,
				PresentationXML.value('Presentation[1]/WindowName[1]','varchar(max)') WindowName,
				PresentationXML.value('Presentation[1]/PageTitle[1]','varchar(max)') PageTitle,
				PresentationXML.value('Presentation[1]/PageBackLinkName[1]','varchar(max)') PageBackLinkName,
				PresentationXML.value('Presentation[1]/PageBackLinkURL[1]','varchar(max)') PageBackLinkURL,
				PresentationXML.value('Presentation[1]/PageSubTitle[1]','varchar(max)') PageSubTitle,
				PresentationXML.value('Presentation[1]/PageDescription[1]','varchar(max)') PageDescription,
				PresentationXML.value('Presentation[1]/PanelTabType[1]','varchar(max)') PanelTabType,
				(CASE WHEN CAST(PresentationXML.query('Presentation[1]/ExpandRDFList[1]/*') AS NVARCHAR(MAX)) <> ''
					THEN PresentationXML.query('Presentation[1]/ExpandRDFList[1]/*')
					ELSE NULL END) ExpandRDFList
			from [Ontology.Presentation].[XML]

	truncate table [Ontology.Presentation].[Panel]
	insert into [Ontology.Presentation].[Panel]
		select	o.PresentationID,
				p.x.value('@Type','varchar(max)') Type, 
				IsNull(p.x.value('@TabSort','varchar(max)'),-1) TabSort, 
				p.x.value('@TabType','varchar(max)') TabType,
				p.x.value('@Alias','varchar(max)') Alias,
				p.x.value('@Name','varchar(max)') Name,
				p.x.value('@Icon','varchar(max)') Icon,
				p.x.value('@DisplayRule','varchar(max)') DisplayRule,
				(CASE WHEN CAST(p.x.query('./*') AS NVARCHAR(MAX)) <> ''
					THEN p.x.query('./*')
					ELSE NULL END) ModuleXML
			from [Ontology.Presentation].[XML] o CROSS APPLY o.PresentationXML.nodes('Presentation[1]/PanelList[1]/Panel') as p(x)
			where p.x.value('@Type','varchar(max)') <> ''

	-- SELECT * FROM [Ontology.Presentation].[General]
	-- SELECT * FROM [Ontology.Presentation].[Panel]

END
GO
