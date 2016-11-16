SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Funding.LoadDisambiguationResults] (@xml XML)
AS
BEGIN
	Truncate table [Profile.Data].[Funding.DisambiguationResults]

	Insert into [Profile.Data].[Funding.DisambiguationResults]
	(PersonID, FundingID, GrantAwardedBy, StartDate, EndDate, PrincipalInvestigatorName,
		AgreementLabel, Abstract, Source, FundingID2, RoleLabel)
	select nref.value('@PersonID','varchar(max)') PersonID,
	sref.value('FundingID[1]','varchar(max)') FundingID,
	sref.value('GrantAwardedBy[1]','varchar(max)') GrantAwardedBy,
	sref.value('StartDate[1]','varchar(max)') StartDate,
	sref.value('EndDate[1]','varchar(max)') EndDate,
	sref.value('PrincipalInvestigatorName[1]','varchar(max)') PrincipalInvestigatorName,
	sref.value('AgreementLabel[1]','varchar(max)') AgreementLabel,
	sref.value('Abstract[1]','varchar(max)') Abstract,
	sref.value('Source[1]','varchar(max)') Source,
	sref.value('FundingID2[1]','varchar(max)') FundingID2,
	sref.value('RoleLabel[1]','varchar(max)') RoleLabel
	from @xml.nodes('//PersonList[1]/Person') as R(nref)
	cross apply R.nref.nodes('Funding') as S(sref)
END

GO
