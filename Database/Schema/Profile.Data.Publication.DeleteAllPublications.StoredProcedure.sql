SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.DeleteAllPublications]
	@PersonID INT,
	@deletePMID BIT = 0,
	@deleteMPID BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @pubids table (pubid uniqueidentifier primary key)

	insert into @pubids(pubid)
		select pubid 
			from [Profile.Data].[Publication.Person.Include] 
			where PersonID = @PersonID AND (
					( (@deletePMID = 1) AND (@deleteMPID = 0) AND (pmid is not null) )
				or	( (@deletePMID = 0) AND (@deleteMPID = 1) AND (pmid is null) AND (mpid is not null) )
				or	( (@deletePMID = 1) AND (@deleteMPID = 1) )
			)
BEGIN TRY 
	BEGIN TRANSACTION

			insert into [Profile.Data].[Publication.Person.Exclude]
			         (pubid,PersonID,pmid,mpid)
				select pubid,@PersonID,pmid,mpid 
					from [Profile.Data].[Publication.Person.Include] 
					where pubid in (select pubid from @pubids)

			delete a
				from [Profile.Cache].[Publication.PubMed.AuthorPosition] a, (
					select distinct pmid
					from [Profile.Data].[Publication.Person.Include] 
					where pubid in (select pubid from @pubids)
						and pmid is not null
				) t
				where a.personid = @PersonID and a.pmid = t.pmid

			delete from [Profile.Data].[Publication.Person.Include] 
					where pubid in (select pubid from @pubids)

			delete from [Profile.Data].[Publication.Person.Add]
					where pubid in (select pubid from @pubids)

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
