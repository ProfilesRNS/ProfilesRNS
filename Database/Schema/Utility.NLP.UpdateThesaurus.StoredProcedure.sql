SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Utility.NLP].[UpdateThesaurus]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- MeSH
	delete from [Utility.NLP].[Thesaurus] where Source = 1
	insert into [Utility.NLP].[Thesaurus] (Source, ConceptID, TermName)
		select 1, dense_rank() over (order by ConceptUI) ConceptID, TermName
		from (
			select ConceptUI, replace(TermName,',','') TermName
				from [Profile.Data].[Concept.Mesh.Term]
			union
			select ConceptUI, replace(DescriptorName,',','') DescriptorName
				from [Profile.Data].[Concept.Mesh.Term]
				where PreferredConceptYN = 'N' and ConceptPreferredTermYN = 'Y'
		) t

END
GO
