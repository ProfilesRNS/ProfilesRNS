SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[NetworkTimeline.Person.CoAuthorOf.GetData]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
 	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	;with e as (
		select top 20 s.PersonID1, s.PersonID2, s.n PublicationCount, 
			year(s.FirstPubDate) FirstPublicationYear, year(s.LastPubDate) LastPublicationYear, 
			p.DisplayName DisplayName2, ltrim(rtrim(p.FirstName+' '+p.LastName)) FirstLast2, s.w OverallWeight
		from [Profile.Cache].[SNA.Coauthor] s, [Profile.Cache].[Person] p
		where personid1 = @PersonID and personid2 = p.personid
		order by w desc, personid2
	), f as (
		select e.*, g.pubdate
		from [Profile.Data].[Publication.Person.Include] a, 
			[Profile.Data].[Publication.Person.Include] b, 
			[Profile.Data].[Publication.PubMed.General] g,
			e
		where a.personid = e.personid1 and b.personid = e.personid2 and a.pmid = b.pmid and a.pmid = g.pmid
			and g.pubdate > '1/1/1900'
	), g as (
		select min(year(pubdate))-1 a, max(year(pubdate))+1 b,
			cast(cast('1/1/'+cast(min(year(pubdate))-1 as varchar(10)) as datetime) as float) f,
			cast(cast('1/1/'+cast(max(year(pubdate))+1 as varchar(10)) as datetime) as float) g
		from f
	), h as (
		select f.*, (cast(pubdate as float)-f)/(g-f) x, a, b, f, g
		from f, g
	), i as (
		select personid2, min(x) MinX, max(x) MaxX, avg(x) AvgX
		from h
		group by personid2
	)
	select h.*, MinX, MaxX, AvgX, h.FirstLast2 label, (select count(distinct personid2) from i) n,
		@baseURI + cast(m.NodeID as varchar(50)) ObjectURI
	from h, i, [RDF.Stage].[InternalNodeMap] m
	where h.personid2 = i.personid2 and cast(i.personid2 as varchar(50)) = m.InternalID
		and m.Class = 'http://xmlns.com/foaf/0.1/Person' and m.InternalType = 'Person'
	order by AvgX, firstpublicationyear, lastpublicationyear, personid2, pubdate

END
GO
