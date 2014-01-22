/****** Script for SelectTopNRows command from SSMS  ******/
ALTER TABLE [Profile.Data].[Publication.PubMed.Author] ADD URL varchar(1000) NULL;

-- set local URL's
DECLARE @basePath varchar(255)
SELECT @basePath = Value + '/' FROM [Framework.].Parameter where ParameterID = 'basePath' 
select @basePath

-- set URL with local authors -- 
UPDATE a SET a.URL = @basePath + na.UrlName from [Profile.Data].[Publication.PubMed.Author] a join [Profile.Data].[Publication.PubMed.Author2Person] ap
on a.PmPubsAuthorID = ap.PmPubsAuthorID join [Profile.Data].Person p on ap.PersonID = p.PersonID 
join [UCSF.].NameAdditions na on na.InternalUserName = p.InternalUsername where a.URL is null;

select a.* from [Profile.Data].[Publication.PubMed.Author] a join [Profile.Data].[Publication.PubMed.Author2Person] ap
on a.PmPubsAuthorID = ap.PmPubsAuthorID join [Profile.Data].Person p on ap.PersonID = p.PersonID 
join [UCSF.].NameAdditions na on na.InternalUserName = p.InternalUsername where p.PersonID = 1122;

-- set URL with other authors. 
UPDATE a set a.URL = fa.URL, a.Affiliation = 'USC' FROM [Profile.Data].[Publication.PubMed.Author] a join 
[profiles_usc_210].[Profile.Data].[Publication.PubMed.Author] fa on  a.PMID = fa.PMID and a.LastName = fa.LastName and a.ForeName = fa.ForeName
WHERE  fa.URL is not null AND a.URL is null;

select top 10 * from [Profile.Data].[Publication.PubMed.Author] a join [profiles_200].[Profile.Data].[Publication.PubMed.Author] fa
on a.PMID = fa.PMID and a.LastName = fa.LastName and a.ForeName = fa.ForeName where fa.URL is not null;


select * from [Profile.Data].[Publication.PubMed.Author]  where URL is not null and URL not like '%stage-profiles%';

select * from [Profile.Data].[Publication.PubMed.Author] a join [Profile.Data].[Publication.PubMed.Author2Person] ap
on a.PmPubsAuthorID = ap.PmPubsAuthorID where ap.PersonID = 1122;
join [Profile.Data].Person p on ap.PersonID = p.PersonID 
join [UCSF.].NameAdditions na on na.InternalUserName = p.InternalUsername;

select * from [ucsf.].vwPerson where lastname = 'buchanan'; --person = 1122, node = 137866
select * from [Profile.Data].[Publication.PubMed.Author2Person] where PersonID = 1122

-- buchanan's coauthors
select a.url, COUNT(a.PMID) from [Profile.Data].[Publication.PubMed.Author] a where a.URL is not null and a.PMID in 
(select pmid from [Profile.Data].[Publication.Person.Include] where PMID is not null and PersonID = 5089836) group by a.url 
order by COUNT(a.pmid) desc;

select * from [Profile.Data].[Publication.PubMed.Author] a join [Profile.Data].[Publication.PubMed.Author2Person] ap
on a.PmPubsAuthorID = ap.PmPubsAuthorID join [Profile.Data].Person p on ap.PersonID = p.PersonID 
join [UCSF.].NameAdditions na on na.InternalUserName = p.InternalUsername;


--exec [Profile.Cache].[Publication.PubMed.UpdateAuthorPosition]
    SELECT CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = 368313

exec [UCSF.].[GetCoauthors] @NodeID = 137866,@externalOnly = 0 --usc
exec [UCSF.].[GetCoauthors] @NodeID = 368313,@externalOnly = 0 -- ucsf


