SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_PersonTokenGetByPersonIDAndPermissionID]
 
    @PersonID  INT 
    , @PermissionID  INT 

AS
 
    SELECT TOP 100 PERCENT
        [ORCID.].[PersonToken].[PersonTokenID]
        , [ORCID.].[PersonToken].[PersonID]
        , [ORCID.].[PersonToken].[PermissionID]
        , [ORCID.].[PersonToken].[AccessToken]
        , [ORCID.].[PersonToken].[TokenExpiration]
        , [ORCID.].[PersonToken].[RefreshToken]
    FROM
        [ORCID.].[PersonToken]
    WHERE
        [ORCID.].[PersonToken].[PersonID] = @PersonID
        AND [ORCID.].[PersonToken].[PermissionID] = @PermissionID




GO
