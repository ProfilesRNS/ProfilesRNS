SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Person.UpdatePhysicalNeighbor]
AS
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	SELECT personid, neighborid, distance, displayname, myneighbors
		INTO #neighbors
		FROM (
			SELECT personid, neighborid, d distance, displayname, lf myneighbors, row_number() over (partition by personid order by d, newid()) k
			FROM (
				select p.personid, q.personid neighborid, q.displayname, q.lastname + ', ' + q.firstname lf,
					(CASE
						WHEN p.room <> '' and p.room = q.room THEN 1
						WHEN p.floor <> '' and p.floor = q.floor THEN 2
						WHEN p.building <> '' and p.building = q.building THEN 3
						WHEN p.institutionname <> '' and p.departmentname <> '' and p.divisionfullname <> '' and p.institutionname = q.institutionname and p.departmentname = q.departmentname and p.divisionfullname = q.divisionfullname THEN 4
						WHEN p.institutionname <> '' and p.departmentname <> '' and p.institutionname = q.institutionname and p.departmentname = q.departmentname THEN 5
						WHEN p.institutionname <> '' and p.institutionname = q.institutionname THEN 6
						ELSE 7
					END) d
				from [Profile.Cache].Person p, [Profile.Cache].Person q
				where p.personid <> q.personid and p.latitude = q.latitude and p.longitude = q.longitude 
					and p.latitude is not null and p.longitude is not null
					and q.latitude is not null and q.longitude is not null
				--where p.personid <> q.personid and p.addressline3 <> '' and p.addressline4 <> '' and p.addressline3 = q.addressline3 and p.addressline4 = q.addressline4
			) t
		) t
		WHERE k <= 5
 
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Person.PhysicalNeighbor]
			INSERT INTO [Profile.Cache].[Person.PhysicalNeighbor]
				SELECT * FROM #neighbors
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@error = 1,@insert_new_record=0
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
