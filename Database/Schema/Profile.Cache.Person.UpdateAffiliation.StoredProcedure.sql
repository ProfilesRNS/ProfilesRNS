SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Person.UpdateAffiliation]
as
begin
 
DECLARE @date DATETIME,@auditid UNIQUEIDENTIFIER, @rows int
SELECT @date=GETDATE() 
EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName ='Person.UpdateAffiliation',@ProcessStartDate =@date,@insert_new_record=1
 
 
truncate table [Profile.Cache].[Person.Affiliation]
insert into [Profile.Cache].[Person.Affiliation]
SELECT personid, sortorder,isprimary,title,institutionname,institutionabbreviation,departmentname,divisionname,facultyrank
												FROM [Profile.Data].[Person.Affiliation] pa  
												JOIN [Profile.Data].[Organization.Department] d on  d.departmentid=pa.departmentid 
			    						  JOIN [Profile.Data].[Organization.Institution] ins ON ins.institutionid=pa.institutionid 
									 LEFT JOIN [Profile.Data].[Organization.Division] di on di.divisionid=pa.divisionid
									 LEFT JOIN [Profile.Data].[Person.FacultyRank] fr on fr.facultyrankid = pa.facultyrankid
 
 
SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName ='Person.UpdateAffiliation',@ProcessEndDate =@date,@ProcessedRows = @rows,@insert_new_record=0
 
 
end
GO
