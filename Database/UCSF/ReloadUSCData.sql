TRUNCATE TABLE [Profile.Data].[Person.Photo];
TRUNCATE TABLE [Profile.Data].[Publication.Person.Add];
TRUNCATE TABLE [Profile.Data].[Publication.Person.Include];
TRUNCATE TABLE [Profile.Data].[Publication.Person.Exclude];
TRUNCATE TABLE [User.Session].[Session];
TRUNCATE TABLE [Profile.Data].[Publication.PubMed.Mesh];
TRUNCATE TABLE [Profile.Data].[Publication.PubMed.PubType];
TRUNCATE TABLE [Profile.Data].[Publication.PubMed.Keyword];
TRUNCATE TABLE [Profile.Data].[Publication.PubMed.Investigator];
TRUNCATE TABLE [Profile.Data].[Publication.PubMed.Author2Person];
DELETE FROM [Profile.Data].[Person.FilterRelationship];
TRUNCATE TABLE [Profile.Data].[Publication.PubMed.Author2Person];
-- serious stuff
UPDATE [Profile.Data].[Person] SET UserID = NULL;
DELETE FROM [User.Account].[User];
TRUNCATE TABLE [Profile.Data].[Person.Affiliation];
DELETE FROM [Profile.Data].[Person];

select * from [Framework.].[Parameter];
--update Framework..Parameter 
exec [Framework.].ChangeBaseURI @oldBaseURI = 'http://profilesstage.sc-ctsi.org/profile/', @newBaseURI = 'http://profiles.sc-ctsi.org/profile/'


exec [Profile.Import].[Beta.LoadData] @SourceDBName = 'profiles_usc_prod';

select * from [Profile.Data].[Person];
update [Profile.Data].[Person] set InternalUsername = HASHBYTES('SHA1', internalusername);
select * from [Profile.Data].[Person];

select * from [User.Account].[User];
update [User.Account].[User] set InternalUsername = HASHBYTES('SHA1', internalusername);
update [User.Account].[User] set Username = InternalUserName;
select * from [User.Account].[User];

-- next run ProfilesRNS_ BetaUpgrade_Part3.sql, which is just:
EXEC [Framework.].[RunJobGroup] @JobGroup = 2 

--check that all pretty URL's are in rest path, following should return no results
   SELECT UrlName, '[Profile.Framework].ResolveURL'
   FROM [Profile.Import].[Person] p join [UCSF.].[NameAdditions] na on
   p.internalusername = na.internalusername WHERE  p.isactive = 1 and UrlName not in (SELECT ApplicationName from [Framework.].[RestPath]  )
