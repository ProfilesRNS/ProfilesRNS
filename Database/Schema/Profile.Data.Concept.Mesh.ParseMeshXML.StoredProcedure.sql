SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Concept.Mesh.ParseMeshXML]
AS
BEGIN
	SET NOCOUNT ON;

	-- Clear any existing data
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.XML]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.Descriptor]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.Qualifier]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.Term]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.SemanticType]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.SemanticGroupType]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.SemanticGroup]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.Tree]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.TreeTop]

	-- Extract items from SemGroups.xml
	INSERT INTO [Profile.Data].[Concept.Mesh.SemanticGroupType] (SemanticGroupUI,SemanticGroupName,SemanticTypeUI,SemanticTypeName)
		SELECT 
			S.x.value('SemanticGroupUI[1]','varchar(10)'),
			S.x.value('SemanticGroupName[1]','varchar(50)'),
			S.x.value('SemanticTypeUI[1]','varchar(10)'),
			S.x.value('SemanticTypeName[1]','varchar(50)')
		FROM [Profile.Data].[Concept.Mesh.File] CROSS APPLY Data.nodes('//SemanticType') AS S(x)
		WHERE Name = 'SemGroups.xml'

	-- Extract items from MeSH2011.xml
	INSERT INTO [Profile.Data].[Concept.Mesh.XML] (DescriptorUI, MeSH)
		SELECT D.x.value('DescriptorUI[1]','varchar(10)'), D.x.query('.')
			FROM [Profile.Data].[Concept.Mesh.File] CROSS APPLY Data.nodes('//DescriptorRecord') AS D(x)
			WHERE Name = 'MeSH.xml'


	---------------------------------------
	-- Parse MeSH XML and populate tables
	---------------------------------------


	INSERT INTO [Profile.Data].[Concept.Mesh.Descriptor] (DescriptorUI, DescriptorName)
		SELECT DescriptorUI, MeSH.value('DescriptorRecord[1]/DescriptorName[1]/String[1]','varchar(255)')
			FROM [Profile.Data].[Concept.Mesh.XML]

	INSERT INTO [Profile.Data].[Concept.Mesh.Qualifier] (DescriptorUI, QualifierUI, DescriptorName, QualifierName, Abbreviation)
		SELECT	m.DescriptorUI,
				Q.x.value('QualifierReferredTo[1]/QualifierUI[1]','varchar(10)'),
				m.MeSH.value('DescriptorRecord[1]/DescriptorName[1]/String[1]','varchar(255)'),
				Q.x.value('QualifierReferredTo[1]/QualifierName[1]/String[1]','varchar(255)'),
				Q.x.value('Abbreviation[1]','varchar(2)')
			FROM [Profile.Data].[Concept.Mesh.XML] m CROSS APPLY MeSH.nodes('//AllowableQualifier') AS Q(x)

	SELECT	m.DescriptorUI,
			C.x.value('ConceptUI[1]','varchar(10)') ConceptUI,
			m.MeSH.value('DescriptorRecord[1]/DescriptorName[1]/String[1]','varchar(255)') DescriptorName,
			C.x.value('@PreferredConceptYN[1]','varchar(1)') PreferredConceptYN,
			C.x.value('ConceptRelationList[1]/ConceptRelation[1]/@RelationName[1]','varchar(3)') RelationName,
			C.x.value('ConceptName[1]/String[1]','varchar(255)') ConceptName,
			C.x.query('.') ConceptXML
		INTO #c
		FROM [Profile.Data].[Concept.Mesh.XML] m 
			CROSS APPLY MeSH.nodes('//Concept') AS C(x)

	INSERT INTO [Profile.Data].[Concept.Mesh.Term] (DescriptorUI, ConceptUI, TermUI, TermName, DescriptorName, PreferredConceptYN, RelationName, ConceptName, ConceptPreferredTermYN, IsPermutedTermYN, LexicalTag)
		SELECT	DescriptorUI,
				ConceptUI,
				T.x.value('TermUI[1]','varchar(10)'),
				T.x.value('String[1]','varchar(255)'),
				DescriptorName,
				PreferredConceptYN,
				RelationName,
				ConceptName,
				T.x.value('@ConceptPreferredTermYN[1]','varchar(1)'),
				T.x.value('@IsPermutedTermYN[1]','varchar(1)'),
				T.x.value('@LexicalTag[1]','varchar(3)')
			FROM #c C CROSS APPLY ConceptXML.nodes('//Term') AS T(x)

	INSERT INTO [Profile.Data].[Concept.Mesh.SemanticType] (DescriptorUI, SemanticTypeUI, SemanticTypeName)
		SELECT DISTINCT 
				m.DescriptorUI,
				S.x.value('SemanticTypeUI[1]','varchar(10)') SemanticTypeUI,
				S.x.value('SemanticTypeName[1]','varchar(50)') SemanticTypeName
			FROM [Profile.Data].[Concept.Mesh.XML] m 
				CROSS APPLY MeSH.nodes('//SemanticType') AS S(x)

	INSERT INTO [Profile.Data].[Concept.Mesh.SemanticGroup] (DescriptorUI, SemanticGroupUI, SemanticGroupName)
		SELECT DISTINCT t.DescriptorUI, g.SemanticGroupUI, g.SemanticGroupName
			FROM [Profile.Data].[Concept.Mesh.SemanticGroupType] g, [Profile.Data].[Concept.Mesh.SemanticType] t
			WHERE g.SemanticTypeUI = t.SemanticTypeUI

	INSERT INTO [Profile.Data].[Concept.Mesh.Tree] (DescriptorUI, TreeNumber)
		SELECT	m.DescriptorUI,
				T.x.value('.','varchar(255)')
			FROM [Profile.Data].[Concept.Mesh.XML] m 
				CROSS APPLY MeSH.nodes('//TreeNumber') AS T(x)

	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] (TreeNumber, DescriptorName)
		SELECT	T.x.value('.','varchar(255)'),
				m.MeSH.value('DescriptorRecord[1]/DescriptorName[1]/String[1]','varchar(255)')
			FROM [Profile.Data].[Concept.Mesh.XML] m 
				CROSS APPLY MeSH.nodes('//TreeNumber') AS T(x)
	UPDATE [Profile.Data].[Concept.Mesh.TreeTop]
		SET TreeNumber = left(TreeNumber,1)+'.'+TreeNumber
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('A','Anatomy')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('B','Organisms')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('C','Diseases')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('D','Chemicals and Drugs')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('E','Analytical, Diagnostic and Therapeutic Techniques and Equipment')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('F','Psychiatry and Psychology')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('G','Biological Sciences')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('H','Natural Sciences')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('I','Anthropology, Education, Sociology and Social Phenomena')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('J','Technology, Industry, Agriculture')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('K','Humanities')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('L','Information Science')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('M','Named Groups')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('N','Health Care')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('V','Publication Characteristics')
	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] VALUES ('Z','Geographicals')

END
GO
