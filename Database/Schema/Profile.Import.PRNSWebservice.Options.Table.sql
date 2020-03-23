SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Import].[PRNSWebservice.Options] (
    [job]       VARCHAR (100) NOT NULL,
    [url]       VARCHAR (500) NULL,
    [apiKey]    VARCHAR (100) NULL,
    [logLevel]  INT           NULL,
    [batchSize] INT           NULL,
    PRIMARY KEY CLUSTERED ([job] ASC)
);
GO
