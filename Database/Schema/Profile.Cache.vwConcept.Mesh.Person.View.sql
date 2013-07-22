SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    view [Profile.Cache].[vwConcept.Mesh.Person]
with schemabinding
as
SELECT meshheader,
			 personid,
			 MAX(ISNULL(numpubsall,0))numpubsall,
			 MAX(ISNULL(NumPubsThis,0))NumPubsThis,
			 SUM(ISNULL(TopicWeight,0))TopicWeight,
			 SUM(ISNULL(AuthorWeight,0))AuthorWeight,
			 SUM(ISNULL(YearWeight,0))YearWeight,
			 MAX(ISNULL(UniquenessWeight,0))UniquenessWeight,
			 MAX(ISNULL(MeshWeight,0))MeshWeight,
			 COUNT_BIG(*)countbig
from [Profile.Cache].[Concept.Mesh.PersonPublication]
group by meshheader,
			 personid
GO
