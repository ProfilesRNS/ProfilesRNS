SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.Pubmed.AddPublication] 
	@UserID INT,
	@pmid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	if exists (select * from [Profile.Data].[Publication.PubMed.AllXML] where pmid = @pmid)
	begin
 
		declare @ParseDate datetime
		set @ParseDate = (select coalesce(ParseDT,'1/1/1900') from [Profile.Data].[Publication.PubMed.AllXML] where pmid = @pmid)
		if (@ParseDate < '1/1/2000')
		begin
			exec [Profile.Data].[Publication.Pubmed.ParsePubMedXML] 
			 @pmid
		end
 BEGIN TRY 
		BEGIN TRANSACTION
 
			if not exists (select * from [Profile.Data].[Publication.Person.Include] where PersonID = @UserID and pmid = @pmid)
			begin
 
				declare @pubid uniqueidentifier
				declare @mpid varchar(50)
 
				set @mpid = null
 
				set @pubid = (select top 1 pubid from [Profile.Data].[Publication.Person.Exclude] where PersonID = @UserID and pmid = @pmid)
				if @pubid is not null
					begin
						set @mpid = (select mpid from [Profile.Data].[Publication.Person.Exclude] where pubid = @pubid)
						delete from [Profile.Data].[Publication.Person.Exclude] where pubid = @pubid
					end
				else
					begin
						set @pubid = (select newid())
					end
 
				insert into [Profile.Data].[Publication.Person.Include](pubid,PersonID,pmid,mpid)
					values (@pubid,@UserID,@pmid,@mpid)
 
				insert into [Profile.Data].[Publication.Person.Add](pubid,PersonID,pmid,mpid)
					values (@pubid,@UserID,@pmid,@mpid)
					
				insert into [Profile.Data].[Publication.PubMed.Disambiguation] (PersonID, PMID)
					values (@UserID, @pmid)
 
				EXEC  [Profile.Data].[Publication.Pubmed.AddOneAuthorPosition] @PersonID = @UserID, @pmid = @pmid
 
				-- Popluate [Publication.Entity.Authorship] and [Publication.Entity.InformationResource] tables
				EXEC [Profile.Data].[Publication.Entity.UpdateEntityOnePerson]@UserID
				
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
 
END
GO
