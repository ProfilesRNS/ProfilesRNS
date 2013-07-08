SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[SNA.Coauthor.UpdateBetweenness]  
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @date DATETIME,@auditid UNIQUEIDENTIFIER, @rows int
	 
	CREATE TABLE #neighbors (i INT NOT NULL, j INT NOT NULL)
	INSERT INTO #neighbors (i,j)
		SELECT DISTINCT PersonID1, PersonID2
			FROM [Profile.Cache].[SNA.Coauthor] 
			WHERE PersonID1 <> PersonID2

	ALTER TABLE #neighbors ADD PRIMARY KEY (i,j)

	CREATE TABLE #c(v INT PRIMARY KEY, c FLOAT)
	CREATE TABLE #p(w INT, v INT)
	CREATE CLUSTERED INDEX idx_w ON #p(w)
	CREATE TABLE #e(t INT PRIMARY KEY, e FLOAT)
	CREATE TABLE #d(j int primary key, distance INT, numpaths FLOAT)
	CREATE UNIQUE NONCLUSTERED INDEX idx_d ON #d(distance,j)

	DECLARE @s INT, @d INT, @AuthCount INT, @MaxS INT

	INSERT INTO #c SELECT DISTINCT i, 0 FROM #neighbors
	INSERT INTO #e SELECT DISTINCT i, 0 FROM #neighbors
	INSERT INTO #d SELECT DISTINCT i, 0, 0 FROM #neighbors
 
	SELECT @AuthCount = COUNT(DISTINCT i ) FROM [Profile.Cache].[SNA.Coauthor]

	SELECT @MaxS = (SELECT MAX(PersonID1) FROM [Profile.Cache].[SNA.Coauthor.Distance])

	SET @s = 1
	WHILE @s <= @MaxS
	BEGIN
		IF EXISTS (SELECT top 1 * FROM [Profile.Cache].[SNA.Coauthor] WHERE PersonID1 = @s)
		BEGIN

			DROP INDEX #d.idx_d
			UPDATE	d 
				SET	d.distance = s.distance, 
							d.numpaths = s.numpaths
				FROM	#d d
					JOIN  [Profile.Cache].[SNA.Coauthor.Distance] s ON s.PersonID1 = @s AND s.PersonID2 = d.j

			CREATE UNIQUE NONCLUSTERED INDEX idx_d ON #d(distance,j)

			TRUNCATE TABLE #p
			DROP INDEX #p.idx_w

			INSERT INTO #p(w,v)
				SELECT w.j, v.j
					FROM #d v
					JOIN #neighbors n ON v.j = n.i
					JOIN #d w on n.j = w.j
								 AND w.distance = v.distance + 1
				WHERE v.distance <= 99   
				 
			CREATE CLUSTERED INDEX idx_w ON #p(w)

			UPDATE #e 
				 SET e = 0

			SELECT @d = (SELECT MAX(distance) FROM #d WHERE distance < 99)
			WHILE @d > -1
			BEGIN
				UPDATE e 
					SET e.e = e.e + t.e
					FROM #e e, (
						SELECT	ev.t, SUM((bv.numpaths/bw.numpaths)*(1+ew.e)) e
							FROM	#p p
								JOIN  #e ev ON p.v = ev.t 
								JOIN  #e ew ON p.w = ew.t 
								JOIN  #d d ON d.distance = @d AND d.j = p.w
								JOIN  #d bv ON p.v = bv.j
								JOIN  #d bw ON  p.w = bw.j 										 
							GROUP BY ev.t
						) t
					WHERE e.t = t.t

				 SELECT @d = @d - 1
			END

			UPDATE c 
				SET c.c = c.c + e.e 
				FROM #c c
					JOIN #e e ON c.v = e.t
				WHERE c.v <> @s

		END

		SET @s = @s + 1
	END
	 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[SNA.Coauthor.Betweenness]
			INSERT INTO [Profile.Cache].[SNA.Coauthor.Betweenness] (personid,b)
				SELECT v, c FROM #c							 
		COMMIT 
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK

		 
		 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

	 
END
GO
