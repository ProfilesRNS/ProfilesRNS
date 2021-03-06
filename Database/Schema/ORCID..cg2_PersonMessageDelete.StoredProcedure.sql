SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_PersonMessageDelete]
 
    @PersonMessageID  INT 

 
AS
 
    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
 
 
        DELETE FROM [ORCID.].[PersonMessage] WHERE         [ORCID.].[PersonMessage].[PersonMessageID] = @PersonMessageID

 
        SET @intReturnVal = @@error
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while deleting the PersonMessage record.', 11, 11); 
            RETURN @intReturnVal 
        END
    RETURN @intReturnVal



GO
