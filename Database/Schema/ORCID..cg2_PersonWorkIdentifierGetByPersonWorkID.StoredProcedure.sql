SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_PersonWorkIdentifierGetByPersonWorkID]
 
    @PersonWorkID  INT 

AS
 
    SELECT TOP 100 PERCENT
        [ORCID.].[PersonWorkIdentifier].[PersonWorkIdentifierID]
        , [ORCID.].[PersonWorkIdentifier].[PersonWorkID]
        , [ORCID.].[PersonWorkIdentifier].[WorkExternalTypeID]
        , [ORCID.].[PersonWorkIdentifier].[Identifier]
    FROM
        [ORCID.].[PersonWorkIdentifier]
    WHERE
        [ORCID.].[PersonWorkIdentifier].[PersonWorkID] = @PersonWorkID




GO
