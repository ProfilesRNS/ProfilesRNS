SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [UCSF.].[LoadExternalCoauthors] (@ExternalDBName varchar(max), @ExternalAffiliation varchar(100))
AS BEGIN
	 
	SET NOCOUNT ON;
 
	-- First set URL with local authors.  This probably should not be here but that's fine -- 
	DECLARE @basePath varchar(255)
	SELECT @basePath = Value + '/' FROM [Framework.].Parameter where ParameterID = 'basePath' 
	select @basePath

	UPDATE a SET a.URL = @basePath + na.UrlName from [Profile.Data].[Publication.PubMed.Author] a join [Profile.Data].[Publication.PubMed.Author2Person] ap
	on a.PmPubsAuthorID = ap.PmPubsAuthorID join [Profile.Data].Person p on ap.PersonID = p.PersonID 
	join [UCSF.].NameAdditions na on na.InternalUserName = p.InternalUsername where a.URL is null;

	-- now load them from an external source
	DECLARE @sql NVARCHAR(MAX) 
	
	-- set URL with other authors. 
	SELECT @sql = 'UPDATE a set a.URL = fa.URL, a.Affiliation = ''' + @ExternalAffiliation + ''' FROM [Profile.Data].[Publication.PubMed.Author] a join [' +
	@ExternalDBName + '].[Profile.Data].[Publication.PubMed.Author] fa on  a.PMID = fa.PMID and a.LastName = fa.LastName and a.ForeName = fa.ForeName ' +
	'WHERE  fa.URL is not null AND a.URL is null'
	
	EXEC sp_executesql @sql
END	