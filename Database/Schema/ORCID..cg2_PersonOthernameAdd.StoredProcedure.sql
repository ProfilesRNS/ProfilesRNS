SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [ORCID.].[cg2_PersonOthernameAdd]

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
 
  
        INSERT INTO [ORCID.].[PersonOthername]
        (
            [PersonID]
            , [OtherName]
            , [PersonMessageID]
        )
        (
            SELECT
            @PersonID
            , @OtherName
            , @PersonMessageID
        )
   
        SET @intReturnVal = @@error
        SET @PersonOthernameID = @@IDENTITY
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while adding the PersonOthername record.', 11, 11); 
            RETURN @intReturnVal 
        END



GO
