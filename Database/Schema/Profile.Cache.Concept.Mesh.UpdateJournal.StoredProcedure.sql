SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Cache].[Concept.Mesh.UpdateJournal]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1

 
	;WITH a AS (
		SELECT m.DescriptorName, g.MedlineTA, max(g.JournalTitle) JournalTitle, sum(Weight) Weight
		FROM [Profile.Data].[Publication.PubMed.General] g
			INNER JOIN (
				SELECT m.DescriptorName, m.PMID, max(case when MajorTopicYN = 'Y' then 1 else 0.25 end) Weight
				FROM [Profile.Data].[Publication.PubMed.Mesh] m
					INNER JOIN [Profile.Data].[Publication.Entity.InformationResource] e
						on m.PMID = e.PMID AND e.IsActive = 1
				GROUP BY m.DescriptorName, m.PMID
			) m ON g.PMID = m.PMID
		GROUP BY m.DescriptorName, g.MedlineTA
	), b AS (
		SELECT DescriptorName, COUNT(*) NumJournals
		FROM a
		GROUP BY DescriptorName
	), c AS (
		SELECT a.DescriptorName MeshHeader, 
			ROW_NUMBER() OVER (PARTITION BY a.DescriptorName ORDER BY Weight DESC, a.MedlineTA) SortOrder,
			a.MedlineTA Journal,
			a.JournalTitle,
			a.Weight,
			b.NumJournals
		FROM a INNER JOIN b ON a.DescriptorName = b.DescriptorName
	)
	SELECT *
		INTO #ConceptMeshJournal
		FROM c
		WHERE SortOrder <= 10

	CREATE UNIQUE CLUSTERED INDEX idx_ms ON #ConceptMeshJournal (MeshHeader, SortOrder)

	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.Journal]
			INSERT INTO [Profile.Cache].[Concept.Mesh.Journal] (MeshHeader, SortOrder, Journal, JournalTitle, Weight, NumJournals)
				SELECT MeshHeader, SortOrder, Journal, JournalTitle, Weight, NumJournals
				FROM #ConceptMeshJournal
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
