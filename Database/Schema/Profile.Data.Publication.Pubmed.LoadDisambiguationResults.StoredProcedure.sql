SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.Pubmed.LoadDisambiguationResults]
AS
BEGIN
BEGIN TRY  
BEGIN TRAN
 
-- Remove orphaned pubs
DELETE FROM [Profile.Data].[Publication.Person.Include]
	  WHERE NOT EXISTS (SELECT *
						  FROM [Profile.Data].[Publication.PubMed.Disambiguation] p
						 WHERE p.personid = [Profile.Data].[Publication.Person.Include].personid
						   AND p.pmid = [Profile.Data].[Publication.Person.Include].pmid)
		AND mpid IS NULL

-- Add Added Pubs
insert into [Profile.Data].[Publication.Person.Include](pubid,PersonID,pmid,mpid)
select a.PubID, a.PersonID, a.PMID, a.MPID from [Profile.Data].[Publication.Person.Add] a
	left join [Profile.Data].[Publication.Person.Include] i
	on a.PersonID = i.PersonID
	and isnull(a.PMID, -1) = isnull(i.PMID, -1)
	and isnull(a.mpid, '') = isnull(i.mpid, '')
	where i.personid is null
	and (a.pmid is null or a.PMID in (select pmid from [Profile.Data].[Publication.PubMed.General]))
	and (a.mpid is null or a.MPID in (select mpid from [Profile.Data].[Publication.MyPub.General]))
		
--Move in new pubs
INSERT INTO [Profile.Data].[Publication.Person.Include]
SELECT	 NEWID(),
		 personid,
		 pmid,
		 NULL
  FROM [Profile.Data].[Publication.PubMed.Disambiguation] d
 WHERE NOT EXISTS (SELECT *
					 FROM  [Profile.Data].[Publication.Person.Include] p
					WHERE p.personid = d.personid
					  AND p.pmid = d.pmid)
  AND EXISTS (SELECT 1 FROM [Profile.Data].[Publication.PubMed.General] g where g.pmid = d.pmid)					  
 
COMMIT
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
 
-- Popluate [Publication.Entity.Authorship] and [Publication.Entity.InformationResource] tables
	EXEC [Profile.Data].[Publication.Entity.UpdateEntity]
END
GO
