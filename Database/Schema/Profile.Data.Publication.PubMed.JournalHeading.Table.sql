SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.Pubmed.JournalHeading] (
    [MedlineTA]           VARCHAR (255) NOT NULL,
    [BroadJournalHeading] VARCHAR (100) NOT NULL,
    [Weight]              FLOAT (53)    NOT NULL,
    [DisplayName]         VARCHAR (100) NULL,
    [Abbreviation]        VARCHAR (50)  NULL,
    [Color]               VARCHAR (6)   NULL,
    [Angle]               FLOAT (53)    NULL,
    [Arc]                 FLOAT (53)    NULL,
    PRIMARY KEY CLUSTERED ([MedlineTA] ASC, [BroadJournalHeading] ASC)
);
GO
