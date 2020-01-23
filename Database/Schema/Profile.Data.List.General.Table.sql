SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [Profile.Data].[List.General](
	[UserID] [int] PRIMARY KEY,
	[CreateDate] [datetime] NULL,
	[Size] [int] NULL,
)
GO
