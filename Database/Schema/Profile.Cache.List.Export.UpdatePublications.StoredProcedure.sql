SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Cache].[List.Export.UpdatePublications]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT *, ROW_NUMBER() OVER (PARTITION BY PersonID, EntityID ORDER BY PMID) k
		INTO #t
		FROM (
			SELECT p.PersonID, i.EntityID, FirstName, LastName, DisplayName, i.PMID, i.EntityDate, g.MedlineTA Source, i.EntityName Item, i.Reference, i.URL
				FROM [Profile.Cache].[Person] p 
					INNER JOIN [Profile.Data].[Publication.Entity.Authorship] a on p.PersonID = a.PersonID
					INNER JOIN [Profile.Data].[Publication.Entity.InformationResource] i on a.InformationResourceID = i.EntityID
					INNER JOIN [Profile.Data].[Publication.PubMed.General] g on i.PMID=g.PMID
				WHERE i.PMID IS NOT NULL
			UNION ALL
			SELECT p.PersonID, i.EntityID, FirstName, LastName, DisplayName, i.PMID, i.EntityDate, g.PubTitle Source, i.EntityName Item, i.Reference, i.URL
				FROM [Profile.Cache].[Person] p 
					INNER JOIN [Profile.Data].[Publication.Entity.Authorship] a on p.PersonID = a.PersonID
					INNER JOIN [Profile.Data].[Publication.Entity.InformationResource] i on a.InformationResourceID = i.EntityID
					INNER JOIN [Profile.Data].[Publication.MyPub.General] g on i.MPID=g.MPID
				WHERE i.PMID IS NULL AND i.MPID IS NOT NULL
		) t


	SELECT ISNULL(PersonID,-1) PersonID,
			ISNULL(ROW_NUMBER() OVER (PARTITION BY PersonID ORDER BY EntityDate, PMID, EntityID),-1) SortOrder,
			CAST(PersonID AS VARCHAR(50)) 
			+ ',"' + REPLACE(FirstName,'"','""') + '"'
			+ ',"' + REPLACE(LastName,'"','""') + '"'
			+ ',"' + REPLACE(DisplayName,'"','""') + '"'
			+ ',' + CAST(PMID AS VARCHAR(50))
			+ ',"' + CONVERT(VARCHAR(50), EntityDate, 101) + '"'
			+ ',"' + REPLACE(Source,'"','""') + '"'
			+ ',"' + REPLACE(Item,'"','""') + '"'
			+ ',"' + REPLACE(Reference,'"','""') + '"'
			+ ',"' + REPLACE(URL,'"','""') + '"'
			s
		INTO #p
		FROM #t
		WHERE k=1

	ALTER TABLE #p ADD PRIMARY KEY (PersonID, SortOrder)


	;WITH a AS (
		SELECT DISTINCT PersonID
		FROM #p
	)
	SELECT PersonID, SUBSTRING(Data,2,LEN(Data)) Data
		INTO #x
		FROM (
			SELECT PersonID, CAST((
					SELECT CHAR(10)+s
					FROM #p b
					WHERE b.PersonID=a.PersonID
					FOR XML PATH(''), TYPE
				) AS VARCHAR(MAX)) Data
			FROM a
		) t

	
	TRUNCATE TABLE [Profile.Cache].[List.Export.Publications]

	INSERT INTO [Profile.Cache].[List.Export.Publications]
		SELECT * FROM #x

END
GO
