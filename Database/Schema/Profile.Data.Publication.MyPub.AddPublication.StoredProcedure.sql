SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.MyPub.AddPublication]
	@PersonID INT,
	@HMS_PUB_CATEGORY nvarchar(60) = '',
	@PUB_TITLE nvarchar(2000) = '',
	@ARTICLE_TITLE nvarchar(2000) = '',
	@CONF_EDITORS nvarchar(2000) = '',
	@CONF_LOC nvarchar(2000) = '',
	@EDITION nvarchar(30) = '',
	@PLACE_OF_PUB nvarchar(60) = '',
	@VOL_NUM nvarchar(30) = '',
	@PART_VOL_PUB nvarchar(15) = '',
	@ISSUE_PUB nvarchar(30) = '',
	@PAGINATION_PUB nvarchar(30) = '',
	@ADDITIONAL_INFO nvarchar(2000) = '',
	@PUBLISHER nvarchar(255) = '',
	@CONF_NM nvarchar(2000) = '',
	@CONF_DTS nvarchar(60) = '',
	@REPT_NUMBER nvarchar(35) = '',
	@CONTRACT_NUM nvarchar(35) = '',
	@DISS_UNIV_NM nvarchar(2000) = '',
	@NEWSPAPER_COL nvarchar(15) = '',
	@NEWSPAPER_SECT nvarchar(15) = '',
	@PUBLICATION_DT smalldatetime = '',
	@ABSTRACT varchar(max) = '',
	@AUTHORS varchar(max) = '',
	@URL varchar(1000) = '',
	@created_by varchar(50) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	 
	DECLARE @mpid nvarchar(50)
	SET @mpid = cast(NewID() as nvarchar(50))

	DECLARE @pubid nvarchar(50)
	SET @pubid = cast(NewID() as nvarchar(50))
	BEGIN TRY
	BEGIN TRANSACTION

		INSERT INTO [Profile.Data].[Publication.MyPub.General]
		        (
			mpid,
			PersonID,
			HmsPubCategory,
			PubTitle,
			ArticleTitle,
			ConfEditors,
			ConfLoc,
			EDITION,
			PlaceOfPub,
			VolNum,
			PartVolPub,
			IssuePub,
			PaginationPub,
			AdditionalInfo,
			Publisher,
			ConfNm,
			ConfDts,
			ReptNumber,
			ContractNum,
			DissUnivNM,
			NewspaperCol,
			NewspaperSect,
			PublicationDT,
			ABSTRACT,
			AUTHORS,
			URL,
			CreatedBy,
			CreatedDT,
			UpdatedBy,
			UpdatedDT
		) VALUES (
			@mpid,
			@PersonID,
			@HMS_PUB_CATEGORY,
			@PUB_TITLE,
			@ARTICLE_TITLE,
			@CONF_EDITORS,
			@CONF_LOC,
			@EDITION,
			@PLACE_OF_PUB,
			@VOL_NUM,
			@PART_VOL_PUB,
			@ISSUE_PUB,
			@PAGINATION_PUB,
			@ADDITIONAL_INFO,
			@PUBLISHER,
			@CONF_NM,
			@CONF_DTS,
			@REPT_NUMBER,
			@CONTRACT_NUM,
			@DISS_UNIV_NM,
	@NEWSPAPER_COL,
			@NEWSPAPER_SECT,
			@PUBLICATION_DT,
			@ABSTRACT,
			@AUTHORS,
			@URL,
			@created_by,
			GetDate(),
			@created_by,
			GetDate()
		)

		INSERT INTO [Profile.Data].[Publication.Person.Include]
		        ( PubID, PersonID,   MPID )
	 
			VALUES (@pubid, @PersonID, @mpid)

		INSERT INTO [Profile.Data].[Publication.Person.Add]
		        ( PubID, PersonID,   MPID )
			VALUES (@pubid, @PersonID, @mpid)

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=1
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

END
GO
