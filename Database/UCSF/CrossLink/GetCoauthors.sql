
/****** Object:  StoredProcedure [Profile.Data].[Person.GetPhotos]    Script Date: 01/15/2014 14:10:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [UCSF.].[GetCoauthors] @NodeID bigINT, @externalOnly bit = 1 
AS
BEGIN

DECLARE @PersonID INT 
DECLARE @basePath varchar(255)
DECLARE @PersonURL varchar(1000)

    SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
	SELECT @basePath = Value + '/' FROM [Framework.].Parameter where ParameterID = 'basePath' 
	SELECT @PersonURL = @basePath + na.UrlName FROM [Profile.Data].Person p join [UCSF.].NameAdditions na on
		p.InternalUsername = na.InternalUserName where p.PersonID = @PersonID

	create table #coauthors (
		URL varchar(1000),
		DisplayName varchar(1000),
		Affiliation varchar(1000),
		PublicationCount int
	)
			
	IF (@externalOnly = 1)
	BEGIN
		INSERT #coauthors (URL, PublicationCount)
		SELECT a.url, COUNT(a.PMID) FROM [Profile.Data].[Publication.PubMed.Author] a WHERE a.URL is not null 
			and a.URL NOT LIKE (@basePath + '%') AND a.PMID in 
			(SELECT pmid FROM [Profile.Data].[Publication.Person.Include] WHERE PMID is not null and PersonID = @PersonID) 
			GROUP BY a.url
	 END
	 ELSE
	 BEGIN
		INSERT #coauthors (URL, PublicationCount)
		SELECT a.url, COUNT(a.PMID) FROM [Profile.Data].[Publication.PubMed.Author] a WHERE a.URL is not null 
			AND a.URL <> @PersonURL and a.PMID in 
			(SELECT pmid FROM [Profile.Data].[Publication.Person.Include] WHERE PMID is not null and PersonID = @PersonID) 
			GROUP BY a.url
	 END
	 
	 -- this is not great because we have no control over which forename is used.  Make it better later
	 UPDATE c set c.DisplayName = a.ForeName + ' ' + a.LastName, c.Affiliation = a.Affiliation FROM
		#coauthors c JOIN [Profile.Data].[Publication.PubMed.Author] a on c.URL = a.URL
	 
	 SELECT * from #coauthors
END

GO


