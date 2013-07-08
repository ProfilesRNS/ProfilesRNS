SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.MyPub.General](
	[MPID] [nvarchar](50) NOT NULL,
	[PersonID] [int] NULL,
	[PMID] [nvarchar](15) NULL,
	[HmsPubCategory] [nvarchar](60) NULL,
	[NlmPubCategory] [nvarchar](250) NULL,
	[PubTitle] [nvarchar](2000) NULL,
	[ArticleTitle] [nvarchar](2000) NULL,
	[ArticleType] [nvarchar](30) NULL,
	[ConfEditors] [nvarchar](2000) NULL,
	[ConfLoc] [nvarchar](2000) NULL,
	[EDITION] [nvarchar](30) NULL,
	[PlaceOfPub] [nvarchar](60) NULL,
	[VolNum] [nvarchar](30) NULL,
	[PartVolPub] [nvarchar](15) NULL,
	[IssuePub] [nvarchar](30) NULL,
	[PaginationPub] [nvarchar](30) NULL,
	[AdditionalInfo] [nvarchar](2000) NULL,
	[Publisher] [nvarchar](255) NULL,
	[SecondaryAuthors] [nvarchar](2000) NULL,
	[ConfNm] [nvarchar](2000) NULL,
	[ConfDTs] [nvarchar](60) NULL,
	[ReptNumber] [nvarchar](35) NULL,
	[ContractNum] [nvarchar](35) NULL,
	[DissUnivNm] [nvarchar](2000) NULL,
	[NewspaperCol] [nvarchar](15) NULL,
	[NewspaperSect] [nvarchar](15) NULL,
	[PublicationDT] [smalldatetime] NULL,
	[Abstract] [varchar](max) NULL,
	[Authors] [varchar](max) NULL,
	[URL] [varchar](1000) NULL,
	[CreatedDT] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedDT] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK__my_pubs_general__03BB8E22] PRIMARY KEY CLUSTERED 
(
	[MPID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Profile.Data].[Publication.MyPub.General]  WITH NOCHECK ADD  CONSTRAINT [FK_my_pubs_general_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Publication.MyPub.General] CHECK CONSTRAINT [FK_my_pubs_general_person]
GO
