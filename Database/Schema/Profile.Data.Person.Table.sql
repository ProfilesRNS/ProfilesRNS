SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Person](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[DisplayName] [nvarchar](255) NULL,
	[Suffix] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
	[EmailAddr] [nvarchar](255) NULL,
	[Phone] [nvarchar](35) NULL,
	[Fax] [nvarchar](25) NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[AddressLine3] [nvarchar](255) NULL,
	[AddressLine4] [nvarchar](255) NULL,
	[City] [nvarchar](55) NULL,
	[State] [nvarchar](50) NULL,
	[Zip] [nvarchar](50) NULL,
	[Building] [nvarchar](255) NULL,
	[Floor] [int] NULL,
	[Room] [nvarchar](255) NULL,
	[AddressString] [nvarchar](1000) NULL,
	[Latitude] [decimal](18, 14) NULL,
	[Longitude] [decimal](18, 14) NULL,
	[GeoScore] [tinyint] NULL,
	[FacultyRankID] [int] NULL,
	[InternalUsername] [nvarchar](50) NULL,
	[Visible] [bit] NULL,
 CONSTRAINT [PK__person] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
