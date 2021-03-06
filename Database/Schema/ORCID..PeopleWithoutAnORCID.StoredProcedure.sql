SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[PeopleWithoutAnORCID]
 
AS
 
    SELECT TOP 100 PERCENT
        [Profile.Data].[Person].[PersonID]
        , [Profile.Data].[Person].[UserID]
        , [Profile.Data].[Person].[EmailAddr]
        , [Profile.Data].[Person].[FacultyRankID]
        , [Profile.Data].[Person].[InternalUsername]
		, [Profile.Data].[Person.FacultyRank].FacultyRank
		, [Profile.Data].[Person].LastName + ', ' + [Profile.Data].[Person].FirstName AS DisplayName
		, [Profile.Data].[Organization.Institution].InstitutionName
		, [Profile.Data].[Organization.Department].DepartmentName
		, [Profile.Data].[Organization.Division].DivisionName
		, OP.ORCID
    FROM
        [Profile.Data].[Person]
		LEFT JOIN [Profile.Data].[Person.FacultyRank] ON [Profile.Data].[Person].FacultyRankID = [Profile.Data].[Person.FacultyRank].FacultyRankID
		LEFT JOIN [ORCID.].Person OP ON [Profile.Data].[Person].InternalUsername = OP.InternalUsername
		INNER JOIN  [Profile.Data].[Person.Affiliation] 
			ON 
				[Profile.Data].[Person].PersonID = [Profile.Data].[Person.Affiliation].PersonID
				AND [Profile.Data].[Person.Affiliation].IsPrimary = 1
		LEFT JOIN   [Profile.Data].[Organization.Institution] ON [Profile.Data].[Person.Affiliation].InstitutionID = [Profile.Data].[Organization.Institution].InstitutionID
		LEFT JOIN   [Profile.Data].[Organization.Department] ON [Profile.Data].[Person.Affiliation].DepartmentID = [Profile.Data].[Organization.Department].DepartmentID
		LEFT JOIN   [Profile.Data].[Organization.Division] ON [Profile.Data].[Person.Affiliation].DivisionID = [Profile.Data].[Organization.Division].DivisionID
	WHERE 
		NOT ([Profile.Data].[Person].EmailAddr IS NULL)
		AND [Profile.Data].[Person].IsActive = 1
		AND [Profile.Data].[Person].Visible = 1
		AND OP.ORCID IS NULL
	ORDER BY
		[Profile.Data].[Organization.Institution].InstitutionName
		, [Profile.Data].[Organization.Department].DepartmentName
		, [Profile.Data].[Organization.Division].DivisionName
		, [Profile.Data].[Person].LastName 
		, [Profile.Data].[Person].FirstName


GO
