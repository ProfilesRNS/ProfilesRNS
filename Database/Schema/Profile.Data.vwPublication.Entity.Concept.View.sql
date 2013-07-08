SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Profile.Data].[vwPublication.Entity.Concept] AS
	SELECT t.EntityID, d.DescriptorUI, t.DescriptorName, hasSubjectAreaWeight, subjectAreaForWeight
	FROM (
		SELECT e.EntityID, m.DescriptorName,
			max(case when MajorTopicYN='N' then 0.25 else 1.0 end) hasSubjectAreaWeight,
			max(case when MajorTopicYN='N' then 0.25*e.YearWeight else e.YearWeight end) subjectAreaForWeight
		FROM [Profile.Data].[vwPublication.Entity.InformationResource] e, [Profile.Data].[Publication.PubMed.Mesh] m
		WHERE e.pmid = m.pmid AND e.pmid IS NOT NULL AND e.IsActive = 1
		GROUP BY e.EntityID, m.DescriptorName
	) t, [Profile.Data].[Concept.Mesh.Descriptor] d
	WHERE t.DescriptorName = d.DescriptorName
GO
