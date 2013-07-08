SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdatePerson]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	SELECT *, 1 WeightCategory, row_number() over (partition by personid order by weight desc, meshheader) k
		INTO #cache_user_mesh
		FROM (
			SELECT PersonID, MeshHeader, max(NumPubsAll) NumPubsAll, count(*) NumPubsThis, sum(MeshWeight) Weight, 
				min(PubYear) FirstPublicationYear, max(PubYear) LastPublicationYear, max(AuthorWeight) MaxAuthorWeight,
				min(PubDate) FirstPubDate, max(PubDate) LastPubDate
			FROM [Profile.Cache].[Concept.Mesh.PersonPublication]
			GROUP BY PersonID, MeshHeader
		) t
	CREATE UNIQUE CLUSTERED INDEX idx_pm ON #cache_user_mesh(personid, meshheader)
 
	UPDATE c
		SET c.WeightCategory = 
			(case	when k <= (case when n.n >= 50 then floor(n.n*0.1) else 5 end) then 2 
					when k >= (n.n - floor((n.n-5)/2)) then 0 
					else 1 end)
		FROM #cache_user_mesh c, (
			select personid, count(*) n
			from #cache_user_mesh
			group by personid
		) n
		WHERE c.personid = n.personid
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.Person]
			INSERT INTO [Profile.Cache].[Concept.Mesh.Person] (PersonID, MeshHeader, NumPubsAll, NumPubsThis, Weight, FirstPublicationYear, LastPublicationYear, MaxAuthorWeight, WeightCategory, FirstPubDate, LastPubDate)
				SELECT PersonID, MeshHeader, NumPubsAll, NumPubsThis, Weight, FirstPublicationYear, LastPublicationYear, MaxAuthorWeight, WeightCategory, FirstPubDate, LastPubDate
				FROM #cache_user_mesh
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
