SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [ORCID.].[cg2_PersonOthernameEdit]

    @PersonOthernameID  INT =NULL OUTPUT 
    , @PersonID  INT 
    , @OtherName  NVARCHAR(500) =NULL
    , @PersonMessageID  INT =NULL

AS


    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
    DECLARE @strReturn  Varchar(200) 
    SET @intReturnVal = 0
    DECLARE @intRecordLevelAuditTrailID INT 
    DECLARE @intFieldLevelAuditTrailID INT 
    DECLARE @intTableID INT 
    SET @intTableID = 3733
 
  
        UPDATE [ORCID.].[PersonOthername]
        SET
            [PersonID] = @PersonID
            , [OtherName] = @OtherName
            , [PersonMessageID] = @PersonMessageID
        FROM
            [ORCID.].[PersonOthername]
        WHERE
        [ORCID.].[PersonOthername].[PersonOthernameID] = @PersonOthernameID

        
        SET @intReturnVal = @@error
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while editing the PersonOthername record.', 11, 11); 
            RETURN @intReturnVal 
        END



GO
