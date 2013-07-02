SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[Beta.SetDisplayPreferences]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select m.NodeID, p.Property, (case when p.n=3 then -1 else v.NodeID end) ViewSecurityGroup
		into #NodeProperty
		from [User.Account].[User] u, [Profile.Import].[Beta.DisplayPreference] d, 
			[RDF.Stage].InternalNodeMap m, [RDF.Stage].InternalNodeMap v, (
				select 0 n, [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#authorInAuthorship') Property
				union all
				select 1 n, [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#awardOrHonor') Property
				union all
				select 2 n, [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#overview') Property
				union all
				select 3 n, [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#mainImage') Property
			) p
		where u.PersonID = d.PersonID
			and m.Class = 'http://xmlns.com/foaf/0.1/Person'
			and m.InternalType = 'Person'
			and m.InternalID = cast(u.PersonID as nvarchar(50))
			and v.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
			and v.InternalType = 'User'
			and v.InternalID = cast(u.UserID as nvarchar(50))
			and ( (p.n=0 and d.ShowPublications='N') or (p.n=1 and d.ShowAwards='N') or (p.n=2 and d.ShowNarrative='N') or (p.n=3 and d.ShowPhoto='Y') )
	create unique clustered index idx_np on #NodeProperty (NodeID, Property)

	insert into [RDF.Security].NodeProperty (NodeID, Property, ViewSecurityGroup)
		select NodeID, Property, ViewSecurityGroup
			from #NodeProperty a
			where not exists (
				select *
				from [RDF.Security].NodeProperty s
				where a.NodeID = s.NodeID and a.Property = s.Property
			)

	update t
		set t.ViewSecurityGroup = n.ViewSecurityGroup
		from #NodeProperty n, [RDF.].Triple t
		where n.NodeID = t.Subject and n.Property = t.Predicate
END
GO
