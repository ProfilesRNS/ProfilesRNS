SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[GeocodingWebservice.Log] (
    [LogID]     INT            IDENTITY (1, 1) NOT NULL,
    [LogTime]   DATETIME       NULL,
    [ErrorText] NVARCHAR (MAX) NULL
);
GO
