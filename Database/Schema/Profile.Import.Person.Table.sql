SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[Person](
	[internalusername] [nvarchar](1000) NULL,
	[firstname] [nvarchar](1000) NULL,
	[middlename] [nvarchar](1000) NULL,
	[lastname] [nvarchar](1000) NULL,
	[displayname] [nvarchar](1000) NULL,
	[suffix] [nvarchar](1000) NULL,
	[addressline1] [nvarchar](1000) NULL,
	[addressline2] [nvarchar](1000) NULL,
	[addressline3] [nvarchar](1000) NULL,
	[addressline4] [nvarchar](1000) NULL,
	[addressstring] [nvarchar](1000) NULL,
	[City] [nvarchar](1000) NULL,
	[State] [nvarchar](1000) NULL,
	[Zip] [nvarchar](1000) NULL,
	[building] [nvarchar](1000) NULL,
	[room] [nvarchar](1000) NULL,
	[floor] [nvarchar](100) NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[phone] [nvarchar](1000) NULL,
	[fax] [nvarchar](1000) NULL,
	[emailaddr] [nvarchar](1000) NULL,
	[isactive] [bit] NULL,
	[isvisible] [bit] NULL
) ON [PRIMARY]
GO
