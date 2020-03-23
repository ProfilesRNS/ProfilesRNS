SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Import].[PRNSWebservice.Log] (
    [LogID]            INT           IDENTITY (1, 1) NOT NULL,
    [Job]              VARCHAR (100) NOT NULL,
    [BatchID]          VARCHAR (100) NOT NULL,
    [RowID]            INT           NOT NULL,
    [HttpMethod]       VARCHAR (10)  NULL,
    [URL]              VARCHAR (500) NULL,
    [PostData]         VARCHAR (MAX) NULL,
    [ServiceCallStart] DATETIME      NULL,
    [ServiceCallEnd]   DATETIME      NULL,
    [ProcessEnd]       DATETIME      NULL,
    [Success]          BIT           NULL,
    [HttpResponseCode] INT           NULL,
    [HttpResponse]     VARCHAR (MAX) NULL,
    [ResultCount]      INT           NULL,
    [ErrorText]        VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([LogID] ASC)
);
GO

CREATE NONCLUSTERED INDEX [idx_PRNSWebserviceLogBatchRow]
    ON [Profile.Import].[PRNSWebservice.Log]([BatchID] ASC, [RowID] ASC)
    INCLUDE([LogID]);
GO
