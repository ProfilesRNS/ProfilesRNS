SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [Profile.Data].[Person.GetAffiliations] (@PersonID INT)
AS
BEGIN
	SET NOCOUNT ON;	
		SELECT title,
					 InstitutionFullName,
					 DepartmentFullname,
					 DivisionFullname 
			FROM [Profile.Data].[Person.Affiliation] p
LEFT	JOIN [Profile.Data].[Organization.InstitutionFullName] i on i.institutionfullnameid=p.institutionfullnameid
LEFT	JOIN [Profile.Data].[Organization.DepartmentFullName] d on d.departmentfullnameid = p.departmentfullnameid
LEFT	JOIN [Profile.Data].[Organization.DivisionFullName] di on di.divisionfullnameid = p.divisionfullnameid
		 WHERE PersonID = @PersonID 
			 AND sortorder > 1 
  ORDER BY sortorder 
END
GO
