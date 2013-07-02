SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Profile.Data].[vwPublication.Entity.Concept.MinorTopicList] AS
	SELECT EntityID, SubjectAreaList
	FROM (
		SELECT e.EntityID, substring((
			SELECT '; '+t.DescriptorName
			FROM (
				SELECT m.DescriptorName
				FROM [Profile.Data].[Publication.PubMed.Mesh] m
				WHERE e.pmid = m.pmid
				GROUP BY m.DescriptorName
				HAVING MAX(MajorTopicYN)='N'
			) t
			ORDER BY t.DescriptorName
			FOR XML PATH(''), TYPE
			).value('(./text())[1]','nvarchar(max)'),3,99999) SubjectAreaList
		FROM [Profile.Data].[vwPublication.Entity.InformationResource] e
		WHERE e.IsActive = 1
	) t
	WHERE SubjectAreaList IS NOT NULL
GO
