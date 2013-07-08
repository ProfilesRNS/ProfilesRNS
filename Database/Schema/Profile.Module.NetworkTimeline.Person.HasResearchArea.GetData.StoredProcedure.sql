SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[NetworkTimeline.Person.HasResearchArea.GetData]
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

	;with a as (
		select t.*, g.pubdate
		from (
			select top 20 *, 
				--numpubsthis/sqrt(numpubsall+100)/sqrt((LastPublicationYear+1 - FirstPublicationYear)*1.00000) w
				--numpubsthis/sqrt(numpubsall+100)/((LastPublicationYear+1 - FirstPublicationYear)*1.00000) w
				--WeightNTA/((LastPublicationYear+2 - FirstPublicationYear)*1.00000) w
				weight w
			from [Profile.Cache].[Concept.Mesh.Person]
			where personid = @PersonID
			order by w desc, meshheader
		) t, [Profile.Cache].[Concept.Mesh.PersonPublication] m, [Profile.Data].[Publication.PubMed.General] g
		where t.meshheader = m.meshheader and t.personid = m.personid and m.pmid = g.pmid and year(g.pubdate) > 1900
	), b as (
		select min(firstpublicationyear)-1 a, max(lastpublicationyear)+1 b,
			cast(cast('1/1/'+cast(min(firstpublicationyear)-1 as varchar(10)) as datetime) as float) f,
			cast(cast('1/1/'+cast(max(lastpublicationyear)+1 as varchar(10)) as datetime) as float) g
		from a
	), c as (
		select a.*, (cast(pubdate as float)-f)/(g-f) x, a, b, f, g
		from a, b
	), d as (
		select meshheader, min(x) MinX, max(x) MaxX, avg(x) AvgX
				--, (select avg(cast(g.pubdate as float))
				--from resnav_people_hmsopen.dbo.pm_pubs_general g, (
				--	select distinct pmid
				--	from resnav_people_hmsopen.dbo.cache_pub_mesh m
				--	where m.meshheader = c.meshheader
				--) t
				--where g.pmid = t.pmid) AvgAllX
		from c
		group by meshheader
	)
	select c.*, d.MinX, d.MaxX, d.AvgX,	c.meshheader label, (select count(distinct meshheader) from a) n, p.DescriptorUI
		into #t
		from c, d, [Profile.Data].[Concept.Mesh.Descriptor] p
		where c.meshheader = d.meshheader and d.meshheader = p.DescriptorName

	select t.*, @baseURI + cast(m.NodeID as varchar(50)) ObjectURI
		from #t t, [RDF.Stage].[InternalNodeMap] m
		where t.DescriptorUI = m.InternalID
			and m.Class = 'http://www.w3.org/2004/02/skos/core#Concept' and m.InternalType = 'MeshDescriptor'
		order by AvgX, firstpublicationyear, lastpublicationyear, meshheader, pubdate

END
GO
