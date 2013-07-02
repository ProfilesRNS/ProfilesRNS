SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Organization.Institution](
	[InstitutionID] [int] IDENTITY(1,1) NOT NULL,
	[InstitutionName] [nvarchar](500) NULL,
	[InstitutionAbbreviation] [nvarchar](50) NULL,
 CONSTRAINT [PK__institution] PRIMARY KEY CLUSTERED 
(
	[InstitutionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
