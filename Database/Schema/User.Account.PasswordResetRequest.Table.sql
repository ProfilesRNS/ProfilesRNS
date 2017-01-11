SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [User.Account].[PasswordResetRequest](
	[PasswordResetRequestID] [int] IDENTITY(1,1) NOT NULL,
	[ResetToken] [nvarchar](255) NOT NULL,
	[EmailAddr] [nvarchar](255) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[RequestExpireDate] [datetime] NOT NULL,
	[ResendRequestsRemaining] int NOT NULL,
	[ResetDate] [datetime] NULL

 CONSTRAINT [PK__passwordresetrequest] PRIMARY KEY CLUSTERED 
(
	[PasswordResetRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


CREATE NONCLUSTERED INDEX [IDX_passwordresetrequest_userid] ON [User.Account].[PasswordResetRequest]
(
	[EmailAddr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IDX_passwordresetrequest_resettoken] ON [User.Account].[PasswordResetRequest]
(
	[ResetToken] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO