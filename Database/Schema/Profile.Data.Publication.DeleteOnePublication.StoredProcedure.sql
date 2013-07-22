SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.DeleteOnePublication]
	@PersonID INT,
	@PubID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY 	 
	BEGIN TRANSACTION

		if exists (select * from [Profile.Data].[Publication.Person.Include]  where pubid = @PubID and PersonID = @PersonID)
		begin

			declare @pmid int
			declare @mpid varchar(50)

			set @pmid = (select pmid from [Profile.Data].[Publication.Person.Include] where pubid = @PubID)
			set @mpid = (select mpid from [Profile.Data].[Publication.Person.Include] where pubid = @PubID)

			insert into [Profile.Data].[Publication.Person.Exclude](pubid,PersonID,pmid,mpid)
				values (@pubid,@PersonID,@pmid,@mpid)

			delete from [Profile.Data].[Publication.Person.Include] where pubid = @PubID
			delete from [Profile.Data].[Publication.Person.Add] where pubid = @PubID

			if @pmid is not null
				delete from [Profile.Cache].[Publication.PubMed.AuthorPosition] where personid = @PersonID and pmid = @pmid

			if @pmid is not null
				delete from [Profile.Data].[Publication.PubMed.Disambiguation] where personid = @PersonID and pmid = @pmid 
				
		end

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		

END
GO
