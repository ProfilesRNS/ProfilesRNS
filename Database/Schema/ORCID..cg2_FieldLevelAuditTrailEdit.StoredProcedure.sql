SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [ORCID.].[cg2_FieldLevelAuditTrailEdit]

    @FieldLevelAuditTrailID  BIGINT =NULL OUTPUT 
    , @RecordLevelAuditTrailID  BIGINT 
    , @MetaFieldID  INT 
    , @ValueBefore  VARCHAR(50) =NULL
    , @ValueAfter  VARCHAR(50) =NULL

AS


    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
    DECLARE @strReturn  Varchar(200) 
    SET @intReturnVal = 0
 
  
        UPDATE [ORCID.].[FieldLevelAuditTrail]
        SET
            [RecordLevelAuditTrailID] = @RecordLevelAuditTrailID
            , [MetaFieldID] = @MetaFieldID
            , [ValueBefore] = @ValueBefore
            , [ValueAfter] = @ValueAfter
        FROM
            [ORCID.].[FieldLevelAuditTrail]
        WHERE
        [ORCID.].[FieldLevelAuditTrail].[FieldLevelAuditTrailID] = @FieldLevelAuditTrailID

        
        SET @intReturnVal = @@error
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while editing the FieldLevelAuditTrail record.', 11, 11); 
            RETURN @intReturnVal 
        END



GO
