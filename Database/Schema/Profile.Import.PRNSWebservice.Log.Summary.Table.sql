SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Import].[PRNSWebservice.Log.Summary](
	[LogID] INT IDENTITY (1, 1) NOT NULL,
	[Job]              VARCHAR (100) NOT NULL,
    [BatchID]          VARCHAR (100) NOT NULL,
	[RecordsCount] INT NULL,
	[RowsCount] INT NULL,
	[JobStart] DATETIME NULL,
	[JobEnd] DATETIME NULL,
	[ErrorCount] int
	)

CREATE NONCLUSTERED INDEX [idx_PRNSWebserviceLogSummaryBatch]
    ON [Profile.Import].[PRNSWebservice.Log.Summary]([BatchID] ASC)
    INCLUDE([LogID]);
GO
