SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Funding.AddUpdateFunding]
	@FundingRoleID VARCHAR(50),
	@PersonID INT,
	@FundingID VARCHAR(50) = NULL,
	@FundingID2 VARCHAR(50) = NULL,
	@RoleLabel VARCHAR(100) = NULL,
	@RoleDescription VARCHAR(max) = NULL,
	@AgreementLabel VARCHAR(2000) = NULL,
	@GrantAwardedBy VARCHAR(1000) = NULL,
	@StartDate DATE = NULL,
	@EndDate DATE = NULL,
	@PrincipalInvestigatorName VARCHAR(100) = NULL,
	@Abstract VARCHAR(MAX) = NULL,
	@Source VARCHAR(20),
	@UserVerified BIT = 1 --Grants populated by disambiguation should use 0 for this. 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @FundingAgreementID VARCHAR(50)

	-- Cleanup input
	SELECT
		@FundingID = NULLIF(LTRIM(RTRIM(@FundingID)),''),
		@FundingID2 = NULLIF(LTRIM(RTRIM(@FundingID2)),''),
		@RoleLabel = NULLIF(LTRIM(RTRIM(@RoleLabel)),''),
		@RoleDescription = NULLIF(LTRIM(RTRIM(@RoleDescription)),''),
		@AgreementLabel = NULLIF(LTRIM(RTRIM(@AgreementLabel)),''),
		@GrantAwardedBy = NULLIF(LTRIM(RTRIM(@GrantAwardedBy)),''),
		@StartDate = NULLIF(@StartDate,'1/1/1900'),
		@EndDate = NULLIF(@EndDate,'1/1/1900'),
		@PrincipalInvestigatorName = NULLIF(LTRIM(RTRIM(@PrincipalInvestigatorName)),''),
		@Abstract = NULLIF(LTRIM(RTRIM(@Abstract)),''),
		@Source = ISNULL(NULLIF(LTRIM(RTRIM(@Source)),''),'Custom')

	SELECT @GrantAwardedBy = 'NIH'
		WHERE @GrantAwardedBy IS NULL AND @Source = 'NIH'

	--BEGIN TRY
	--BEGIN TRANSACTION
	
	IF EXISTS (SELECT * FROM [Profile.Data].[Funding.Role] WHERE FundingRoleID = @FundingRoleID)
	BEGIN
		-- Update existing funding

		SELECT @FundingAgreementID = FundingAgreementID 
			FROM [Profile.Data].[Funding.Role] 
			WHERE FundingRoleID = @FundingRoleID

		UPDATE [Profile.Data].[Funding.Role]
			SET	RoleLabel = @RoleLabel, 
				RoleDescription = @RoleDescription
			WHERE FundingRoleID = @FundingRoleID

		UPDATE [Profile.Data].[Funding.Agreement]
			SET	AgreementLabel = @AgreementLabel,
				FundingID = @FundingID,
				GrantAwardedBy = @GrantAwardedBy,
				StartDate = @StartDate,
				EndDate = @EndDate,
				PrincipalInvestigatorName = @PrincipalInvestigatorName,
				Abstract = @Abstract
			WHERE Source = 'Custom'
				AND FundingAgreementID = @FundingAgreementID
	END 
	ELSE
	BEGIN
		-- Add new funding

		-- Check if the agreement already exists (except for custom funding)
		SELECT @FundingAgreementID = FundingAgreementID
			FROM [Profile.Data].[Funding.Agreement]
			WHERE Source = @Source AND FundingID = @FundingID
				AND Source <> 'Custom'

		-- Create the agreement if it is new
		IF @FundingAgreementID IS NULL
		BEGIN
			SELECT @FundingAgreementID = NEWID() 

			INSERT INTO [Profile.Data].[Funding.Agreement] (FundingAgreementID, [Source], FundingID, FundingID2, AgreementLabel, GrantAwardedBy, StartDate, EndDate, PrincipalInvestigatorName, Abstract) 
				SELECT @FundingAgreementID, @Source, @FundingID, @FundingID2, @AgreementLabel, @GrantAwardedBy, @StartDate, @EndDate, @PrincipalInvestigatorName, @Abstract
		END

		-- Create the role if it does not already exist
		INSERT INTO [Profile.Data].[Funding.Role] (FundingRoleID, PersonID, FundingAgreementID, RoleLabel, RoleDescription)
			SELECT @FundingRoleID, @PersonID, @FundingAgreementID, @RoleLabel, @RoleDescription
			WHERE NOT EXISTS (SELECT * FROM [Profile.Data].[Funding.Role] WHERE PersonID = @PersonID AND FundingAgreementID = @FundingAgreementID)
	END

	-- Insert into the Funding.Add table if the user is manually editing funding
	IF (@UserVerified = 1)
		IF NOT EXISTS (SELECT * FROM [Profile.Data].[Funding.Add] WHERE FundingRoleID = @FundingRoleID)
			INSERT INTO [Profile.Data].[Funding.Add] (FundingRoleID, PersonID, FundingAgreementID)
				SELECT @FundingRoleID, @PersonID, @FundingAgreementID
				FROM [Profile.Data].[Funding.Role]
				WHERE FundingRoleID = @FundingRoleID

	--COMMIT TRANSACTION
	--END TRY
	--BEGIN CATCH
		--Check success
		/*IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=1
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)*/
	--END CATCH
END


GO
