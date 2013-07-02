SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[SNA.Coauthor.UpdateReach]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	select PersonID1 PersonID, Distance, count(*) NumPeople
		into #sna_reach_tmp
		from [Profile.Cache].[SNA.Coauthor.Distance]
		group by PersonID1, Distance
	create unique clustered index idx_pd on #sna_reach_tmp(PersonID, Distance)
 
	select 99 n into #n
	insert into #n(n)
		select n
		from [Utility.Math].N
		where n > 0 and n <= (select max(Distance) from #sna_reach_tmp where Distance < 99)
	create unique clustered index idx_n on #n(n)
 
	select p.PersonID, n.n Distance, 0 NumPeople
		into #sna_reach
		from #n n, (select distinct PersonID from #sna_reach_tmp) p
	create unique clustered index idx_pd on #sna_reach(PersonID, Distance)
 
	update s
		set s.NumPeople = t.NumPeople
		from #sna_reach s, #sna_reach_tmp t
		where s.PersonID = t.PersonID and s.Distance = t.Distance
 
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[SNA.Coauthor.Reach]
				INSERT INTO [Profile.Cache].[SNA.Coauthor.Reach] (PersonID,Distance,NumPeople)
					SELECT PersonID,Distance,NumPeople FROM #sna_reach
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
