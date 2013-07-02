SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [Profile.Data].[vwPerson.Affiliation] as
	select PersonAffiliationID,
		a.PersonID,
		a.SortOrder,
		a.IsActive,
		a.IsPrimary,
		a.InstitutionID,
		a.DepartmentID,
		a.DivisionID,
		coalesce(a.Title,'') Title,
		coalesce(a.EmailAddress,'') EmailAddress,
		coalesce(i.InstitutionName,'') InstitutionName,
		coalesce(i.InstitutionAbbreviation,'') InstitutionAbbreviation, 
		coalesce(d.DepartmentName,'') DepartmentName, 
		coalesce(v.DivisionName,'') DivisionName 
	from [Profile.Data].[Person.Affiliation] a 
		left outer join [Profile.Data].[Organization.Institution] i on a.institutionid = i.institutionid 
		left outer join [Profile.Data].[Organization.Department] d on a.departmentid = d.departmentid 
		left outer join [Profile.Data].[Organization.Division] v on a.divisionid = v.divisionid
	where a.IsActive = 1
GO
