SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Person.Filter](
	[PersonFilterID] [int] IDENTITY(1,1) NOT NULL,
	[PersonFilter] [varchar](200) NULL,
	[PersonFilterCategory] [varchar](200) NULL,
	[PersonFilterSort] [int] NULL,
	[ETLProcedure] [varchar](100) NULL,
	[ETLParams] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	[SearchDropdown] [varchar](max) NULL,
 CONSTRAINT [PK__PersonFilter__1CF15040] PRIMARY KEY CLUSTERED 
(
	[PersonFilterID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF


ALTER TABLE [Profile.Data].[Person.Filter] ADD  DEFAULT ((1)) FOR [IsActive]
GO
