SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [ORCID.].[cg2_REFDecisionEdit]

    @DecisionID  INT =NULL OUTPUT 
    , @DecisionDescription  VARCHAR(150) 
    , @DecisionDescriptionLong  VARCHAR(500) 

AS


    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
    DECLARE @strReturn  Varchar(200) 
    SET @intReturnVal = 0
    DECLARE @intRecordLevelAuditTrailID INT 
    DECLARE @intFieldLevelAuditTrailID INT 
    DECLARE @intTableID INT 
    SET @intTableID = 3730
 
  
        UPDATE [ORCID.].[REF_Decision]
        SET
            [DecisionDescription] = @DecisionDescription
            , [DecisionDescriptionLong] = @DecisionDescriptionLong
        FROM
            [ORCID.].[REF_Decision]
        WHERE
        [ORCID.].[REF_Decision].[DecisionID] = @DecisionID

        
        SET @intReturnVal = @@error
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while editing the REF_Decision record.', 11, 11); 
            RETURN @intReturnVal 
        END



GO
