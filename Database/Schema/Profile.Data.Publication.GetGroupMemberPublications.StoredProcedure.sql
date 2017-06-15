SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Publication.GetGroupMemberPublications]
	@GroupID INT=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  ;with pubs as (
	  select distinct pmid, mpid from [Profile.Data].[Publication.Person.Include] a
		  join [Profile.Data].Person p on a.PersonID = p.PersonID
		  join [Profile.Data].[Group.Member] g on p.UserID = g.UserID
		  and g.GroupID = @GroupID
		  where (pmid is null or pmid not in (select pmid from [Profile.Data].[Publication.Group.Include] where GroupID = @GroupID and PMID is not null))
		  and (mpid is null or mpid not in (select copiedMPID from [Profile.Data].[Publication.Group.MyPub.General] where GroupID = @GroupID and copiedMPID is not null))
  )
  select top 100 '' as rownum, reference, case when e.PMID is not null then 'true' else 'false' end as FromPubMed, 0 as PubID, e.pmid, e.mpid, e.url, e.EntityDate as pubdate, '' as category from [Profile.Data].[vwPublication.Entity.InformationResource] e
	  join pubs a on (a.PMID = e.PMID and e.MPID is null) OR (a.MPID = e.MPID and e.PMID is null)
	  order by EntityDate desc
END

GO
