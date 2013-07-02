SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdatePersonPublication]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	DECLARE @proc VARCHAR(200)
	SELECT @proc = OBJECT_NAME(@@PROCID)
	DECLARE @date DATETIME,@auditid UNIQUEIDENTIFIER, @rows int
	SELECT @date=GETDATE() 
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	SELECT *, (case when majortopicyn='Y' then 1.0 else 0.25 end) TopicWeight 
		INTO #pm_pub_mesh 
		FROM [Profile.Data].[vwPublication.Pubmed.Mesh.Descriptor]
	CREATE UNIQUE CLUSTERED INDEX idx_pm on #pm_pub_mesh(pmid, meshheader)
 
	SELECT m.MeshHeader, a.PersonID, a.PMID, c.NumPublications NumPubsAll, 1 NumPubsThis,
			m.TopicWeight, a.AuthorWeight, a.YearWeight, c.Weight UniquenessWeight,
			m.TopicWeight * a.AuthorWeight * a.YearWeight * c.Weight MeshWeight,
			a.AuthorPosition, a.PubYear, c.NumFaculty NumPeopleAll, a.PubDate
		INTO #cache_pub_mesh
		FROM #pm_pub_mesh m, [Profile.Cache].[Publication.PubMed.AuthorPosition] a, [Profile.Cache].[Concept.Mesh.Count] c
		WHERE a.pmid = m.pmid and m.meshheader = c.meshheader
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.PersonPublication]
			INSERT INTO [Profile.Cache].[Concept.Mesh.PersonPublication] (MeshHeader, PersonID, PMID, NumPubsAll, NumPubsThis, TopicWeight, AuthorWeight, YearWeight, UniquenessWeight, MeshWeight, AuthorPosition, PubYear, NumPeopleAll, PubDate)
				SELECT MeshHeader, PersonID, PMID, NumPubsAll, NumPubsThis, TopicWeight, AuthorWeight, YearWeight, UniquenessWeight, MeshWeight, AuthorPosition, PubYear, NumPeopleAll, PubDate
				FROM #cache_pub_mesh
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
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName ='usp_cache_pub_mesh',@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
