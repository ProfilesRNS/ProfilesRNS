SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [User.Session].[Session](
	[SessionID] [uniqueidentifier] NOT NULL,
	[SessionSequence] [int] IDENTITY(0,1) NOT NULL,
	[CreateDate] [datetime] NULL,
	[LastUsedDate] [datetime] NULL,
	[LoginDate] [datetime] NULL,
	[LogoutDate] [datetime] NULL,
	[RequestIP] [varchar](16) NULL,
	[UserID] [int] NULL,
	[PersonID] [int] NULL,
	[EntityID] [int] NULL,
	[UserRoleSetID] [uniqueidentifier] NULL,
	[NodeID] [bigint] NULL,
	[UserNode] [bigint] NULL,
	[ImpersonateUserNode] [bigint] NULL,
	[UserAgent] [varchar](500) NULL,
	[IsBot] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[SessionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [SessionSequence] ON [User.Session].[Session] 
(
	[SessionSequence] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
ALTER TABLE [User.Session].[Session]  WITH CHECK ADD  CONSTRAINT [FK_Session_Person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [User.Session].[Session] CHECK CONSTRAINT [FK_Session_Person]
GO
ALTER TABLE [User.Session].[Session]  WITH CHECK ADD  CONSTRAINT [FK_Session_User] FOREIGN KEY([UserID])
REFERENCES [User.Account].[User] ([UserID])
GO
ALTER TABLE [User.Session].[Session] CHECK CONSTRAINT [FK_Session_User]
GO
