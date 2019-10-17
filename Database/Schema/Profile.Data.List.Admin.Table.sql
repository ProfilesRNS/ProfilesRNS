SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [Profile.Data].[List.Admin] (
    [AdminID]             INT            IDENTITY (0, 1) NOT NULL,
    [UserID]              INT            NOT NULL,
    [AdminForInstitution] NVARCHAR (500) NULL,
    [AdminForDepartment]  NVARCHAR (500) NULL,
    [AdminForDivision]    NVARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([AdminID] ASC)
)

GO
