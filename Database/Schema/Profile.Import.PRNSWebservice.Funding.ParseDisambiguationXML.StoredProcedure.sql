SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[PRNSWebservice.Funding.ParseDisambiguationXML]
	@Job varchar(55) = '',
	@BatchID varchar(100) = '',
	@RowID int = -1,
	@LogID int = -1,
	@URL varchar (500) = '',
	@Data varchar(max)
AS
BEGIN
	SET NOCOUNT ON;	

	BEGIN TRY 
		declare @rowsCount int
		declare @xml xml
		set @xml = cast(@Data as xml)

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
		
		select @rowsCount = @@ROWCOUNT
		if @logID > 0
			update [Profile.Import].[PRNSWebservice.Log] set ResultCount = @rowsCount where LogID = @logID
	END TRY
	BEGIN CATCH
		declare @errorMessage varchar(max)
		select @errorMessage = Error_Message()

		if @LogID < 0
		begin
			select @LogID = isnull(LogID, -1) from [Profile.Import].[PRNSWebservice.Log] where BatchID = @BatchID and RowID = @RowID
		end
		select @logid
		if @LogID > 0
			update [Profile.Import].[PRNSWebservice.Log] set Success = 0, HttpResponse = @Data, ErrorText = @errorMessage where LogID = @LogID
		else
			insert into [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID, URL, HttpResponse, Success, ErrorText) Values (@Job, @BatchID, @RowID, @URL, @Data, 0, @errorMessage)
	END CATCH	
END
GO
