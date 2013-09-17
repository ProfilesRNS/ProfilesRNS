/****** Script for SelectTopNRows command from SSMS  ******/
create view UCSF.vwGrant as SELECT p.EmployeeId, pe.nodeid
      ,[ApplicationId]
      ,[Activity]
      ,[AdministeringIC]
      ,[ApplicationType]
      ,[ARRAFunded]
      ,[BudgetStart]
      ,[BudgetEnd]
      ,[FOANumber]
      ,[FullProjectNum]
      ,[FundingICS]
      ,[FY]
      ,[OrgCity]
      ,[OrgCountry]
      ,[OrgDistrict]
      ,[OrgDUNS]
      ,[OrgDept]
      ,[OrgFIPS]
      ,[OrgState]
      ,[OrgZip]
      ,[ICName]
      ,[OrgName]
      ,[ProjectTitle]
      ,[ProjectStart]
      ,[ProjectEnd]
      ,[TotalCost]
      ,[CoreProjectNumber]
      ,[IsVerified]
  FROM  ucsf.agPrincipalInvestigator p join ucsf.agGrantPrincipal gp on p.PrincipalInvestigatorPK =
  gp.PrincipalInvestigatorPK join ucsf.[agGrant] g on gp.GrantPK = g.GrantPK 
  join ucsf.vwPersonExport pe on pe.internalusername = p.EmployeeId where p.EmployeeId is not null;