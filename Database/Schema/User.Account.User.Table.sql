SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [User.Account].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[IsActive] [bit] NULL,
	[CanBeProxy] [bit] NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[DisplayName] [nvarchar](255) NULL,
	[Institution] [nvarchar](500) NULL,
	[Department] [nvarchar](500) NULL,
	[Division] [nvarchar](500) NULL,
	[EmailAddr] [nvarchar](255) NULL,
	[UserName] [nvarchar](50) NULL,
	[Password] [varchar](128) NULL,
	[CreateDate] [datetime] NULL,
	[ApplicationName] [varchar](255) NULL,
	[Comment] [varchar](255) NULL,
	[IsApproved] [bit] NULL,
	[IsOnline] [bit] NULL,
	[InternalUserName] [nvarchar](50) NULL,
	[NodeID] [bigint] NULL,
 CONSTRAINT [PK__user] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
