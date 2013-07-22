SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Module].[NetworkRadial.GetCoauthors]
	@NodeID BIGINT,
	@SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE @PersonID1 INT
 
	SELECT @PersonID1 = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
		
	SELECT TOP 120
						personid,
						distance,
						numberofpaths,
						weight,
						w2,
						lastname,
						firstname,
						p,
						k,
						cast(-1 as bigint) nodeid,
						cast('' as varchar(400)) uri
			 INTO #network 
			 FROM ( 
							SELECT personid, 
										 distance, 
										 numberofpaths, 
										 weight, 
										 w2, 
										 p.lastname, 
										 p.firstname, 
										 p.numpublications p, 
										 ROW_NUMBER() OVER (PARTITION BY distance ORDER BY w2 DESC) k 
							  FROM [Profile.Cache].Person p
							  JOIN ( SELECT *, ROW_NUMBER() OVER (PARTITION BY personid2 ORDER BY distance, w2 DESC) k 
										FROM (
											SELECT personid2, 1 distance, n numberofpaths, w weight, w w2 
												FROM [Profile.Cache].[SNA.Coauthor]  
												WHERE personid1 = @personid1
											UNION ALL 
												SELECT b.personid2, 2 distance, b.n numberofpaths, b.w weight,a.w*b.w w2 
												FROM [Profile.Cache].[SNA.Coauthor] a JOIN [Profile.Cache].[SNA.Coauthor] b ON a.personid2 = b.personid1 
												WHERE a.personid1 = @personid1  
											UNION ALL 
												SELECT @personid1 personid2, 0 distance, 1 numberofpaths, 1 weight, 1 w2 
										) t 
									) t ON p.personid = t.personid2 
							  WHERE k = 1  AND p.IsActive = 1
						) t 
			WHERE k <= 80 
	ORDER BY distance, k
	
	UPDATE n
		SET n.NodeID = m.NodeID, n.URI = p.Value + cast(m.NodeID as varchar(50))
		FROM #network n, [RDF.Stage].InternalNodeMap m, [Framework.].Parameter p
		WHERE p.ParameterID = 'baseURI' AND m.InternalHash = [RDF.].fnValueHash(null,null,'http://xmlns.com/foaf/0.1/Person^^Person^^'+cast(n.PersonID as varchar(50)))
 
	DELETE FROM #network WHERE IsNull(URI,'') = ''	
	
 
	SELECT c.personid1 id1, c.personid2	id2, c.n, CAST(c.w AS VARCHAR) w, 
			(CASE WHEN YEAR(firstpubdate)<1980 THEN 1980 ELSE YEAR(firstpubdate) END) y1, 
			(CASE WHEN YEAR(lastpubdate)<1980 THEN 1980 ELSE YEAR(lastpubdate) END) y2,
			(case when c.personid1 = @personid1 or c.personid2 = @personid1 then 1 else 0 end) k,
			a.nodeid n1, b.nodeid n2, a.uri u1, b.uri u2
		into #network2
		from #network a
			JOIN #network b on a.personid < b.personid  
			JOIN [Profile.Cache].[SNA.Coauthor] c ON a.personid = c.personid1 and b.personid = c.personid2  
 
	;with a as (
		select id1, id2, w, k from #network2
		union all
		select id2, id1, w, k from #network2
	), b as (
		select a.*, row_number() over (partition by a.id1 order by a.w desc, a.id2) s
		from a, 
			(select id1 from a group by id1 having max(k) = 0) b,
			(select id1 from a group by id1 having max(k) > 0) c
		where a.id1 = b.id1 and a.id2 = c.id1
	)
	update n
		set n.k = 2
		from #network2 n, b
		where (n.id1 = b.id1 and n.id2 = b.id2 and b.s = 1) or (n.id1 = b.id2 and n.id2 = b.id1 and b.s = 1)
 
	update n
		set n.k = 3
		from #network2 n, (
			select *, row_number() over (order by k desc, w desc) r 
			from #network2 
		) r
		where n.id1=r.id1 and n.id2=r.id2 and n.k=0 and r.r<=360
 
	SELECT (
		SELECT personid "@id", nodeid "@nodeid", uri "@uri", distance "@d", p "@pubs", firstname "@fn", lastname "@ln", cast(w2 as varchar(50)) "@w2"
		FROM #network
		FOR XML PATH('NetworkPerson'),ROOT('NetworkPeople'),TYPE
	), (
		SELECT id1 "@id1", id2 "@id2", n "@n", cast(w as varchar(50)) "@w", y1 "@y1", y2 "@y2",
			n1 "@nodeid1", n2 "@nodeid2", u1 "@uri1", u2 "@uri2"
		FROM #network2
		WHERE k > 0
		FOR XML PATH('NetworkCoAuthor'),ROOT('NetworkCoAuthors'),TYPE
	)
	FOR XML PATH('LocalNetwork')
 
 
 
END
GO
