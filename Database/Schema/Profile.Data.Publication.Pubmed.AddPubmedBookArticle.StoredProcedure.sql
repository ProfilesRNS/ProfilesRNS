SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.Pubmed.AddPubmedBookArticle]
	@pmid int,
	@personID int
AS
BEGIN
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	

	declare @mpid varchar(50)
	if exists (select 1 from [Profile.Data].[Publication.MyPub.General] where pmid=@pmid)
	begin
		select @mpid = mpid from [Profile.Data].[Publication.MyPub.General] where pmid=@pmid
	end
	else
	begin
		SET @mpid = cast(NewID() as nvarchar(50))
		exec [Profile.Data].[Publication.Pubmed.ParsePubmedBookArticle] @pmid=@pmid, @mpid=@mpid
	end

	DECLARE @pubid nvarchar(50)
	SET @pubid = cast(NewID() as nvarchar(50))


	BEGIN TRY
	BEGIN TRANSACTION
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
