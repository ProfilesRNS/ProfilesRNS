SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_RecordLevelAuditTrailGet]
 
    @RecordLevelAuditTrailID  BIGINT 

AS
 
    SELECT TOP 100 PERCENT
        [ORCID.].[RecordLevelAuditTrail].[RecordLevelAuditTrailID]
        , [ORCID.].[RecordLevelAuditTrail].[MetaTableID]
        , [ORCID.].[RecordLevelAuditTrail].[RowIdentifier]
        , [ORCID.].[RecordLevelAuditTrail].[RecordLevelAuditTypeID]
        , [ORCID.].[RecordLevelAuditTrail].[CreatedDate]
        , [ORCID.].[RecordLevelAuditTrail].[CreatedBy]
    FROM
        [ORCID.].[RecordLevelAuditTrail]
    WHERE
        [ORCID.].[RecordLevelAuditTrail].[RecordLevelAuditTrailID] = @RecordLevelAuditTrailID




GO
