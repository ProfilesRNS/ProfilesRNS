SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Data].[Funding.DeleteFunding]
	@FundingRoleID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO [Profile.Data].[Funding.Delete] ([FundingRoleID], [PersonID], [FundingAgreementID], [Source], [FundingID], [FundingID2])
			SELECT @FundingRoleID, PersonID, r.FundingAgreementID, Source, FundingID, FundingID2
				FROM [Profile.Data].[Funding.Role] r 
					INNER JOIN [Profile.Data].[Funding.Agreement] a
						ON r.FundingAgreementID = a.FundingAgreementID
				WHERE r.FundingRoleID = @FundingRoleID
		DELETE 
			FROM [Profile.Data].[Funding.Add]
			WHERE FundingRoleID = @FundingRoleID
		DELETE 
			FROM [Profile.Data].[Funding.Role]
			WHERE FundingRoleID = @FundingRoleID
		DELETE a
			FROM [Profile.Data].[Funding.Delete] d 
				INNER JOIN [Profile.Data].[Funding.Agreement] a
					ON d.FundingAgreementID = a.FundingAgreementID
			WHERE d.FundingRoleID = @FundingRoleID
				AND NOT EXISTS (
					SELECT * 
					FROM [Profile.Data].[Funding.Role] r
					WHERE r.FundingAgreementID = a.FundingAgreementID
				)
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		--Check success
		/*IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=1
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)*/
	END CATCH
END

GO
