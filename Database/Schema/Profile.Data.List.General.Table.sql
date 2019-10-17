SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [Profile.Data].[List.General] (
    [ListID]     INT      IDENTITY (1, 1) NOT NULL,
    [UserID]     INT      NULL,
    [CreateDate] DATETIME NULL,
    [Size]       INT      NULL,
    PRIMARY KEY CLUSTERED ([ListID] ASC)
)

GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_User_List]
    ON [Profile.Data].[List.General]([UserID] ASC, [ListID] ASC)

GO
