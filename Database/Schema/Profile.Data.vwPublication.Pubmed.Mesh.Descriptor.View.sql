SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [Profile.Data].[vwPublication.Pubmed.Mesh.Descriptor]
AS
select pmid, descriptorname as MeshHeader, max(MajorTopicYN) MajorTopicYN
from [Profile.Data].[Publication.PubMed.Mesh]
group by pmid, descriptorname
GO
