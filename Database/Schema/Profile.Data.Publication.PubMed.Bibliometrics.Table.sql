SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.Pubmed.Bibliometrics] (
    [PMID]                     INT           NOT NULL,
    [PMCCitations]             INT           NOT NULL,
    [MedlineTA]                VARCHAR (255) NULL,
    [Fields]                   VARCHAR (MAX) NULL,
    [TranslationHumans]        INT           NULL,
    [TranslationAnimals]       INT           NULL,
    [TranslationCells]         INT           NULL,
    [TranslationPublicHealth]  INT           NULL,
    [TranslationClinicalTrial] INT           NULL,
    PRIMARY KEY CLUSTERED ([PMID] ASC)
);
GO
