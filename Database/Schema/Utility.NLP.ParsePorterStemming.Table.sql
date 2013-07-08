SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Utility.NLP].[ParsePorterStemming](
	[Step] [int] NOT NULL,
	[Ordering] [int] NOT NULL,
	[phrase1] [nvarchar](15) NOT NULL,
	[phrase2] [nvarchar](15) NULL
) ON [PRIMARY]
GO
