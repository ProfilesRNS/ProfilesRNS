ALTER VIEW [ORNG.].[vwAppPerson] as
	SELECT cast(m.NodeID as varchar) + '-' + CAST(a.appid as varchar) NodeIdAppId, 
	 a.Name + ' for ' + p.DisplayName Label, m.InternalID PersonId, a.appId,
	 a.name AppName, a.url AppUrl, r.visibility FROM [ORNG.].[Apps] a join [ORNG.].AppRegistry r on a.appId = r.appId join
	[RDF.Stage].InternalNodeMap m on r.nodeid = m.NodeID join [Profile.Data].Person p on p.PersonID = cast(m.InternalID as int);
	
select * from [orng.].[vwAppPerson];

ALTER VIEW [ORNG.].[vwAppPersonData] as
	SELECT cast(m.NodeID as varchar) + '-' + CAST(a.appid as varchar) + '-' + d.keyname PrimaryId, 
	 cast(m.NodeID as varchar) + '-' + CAST(a.appid as varchar)NodeIdAppId,
	 m.InternalID PersonId, a.appId,
	 a.name AppName, d.keyname, d.value FROM [ORNG.].[Apps] a 
	 join [ORNG.].AppData d on a.appId = d.appId 
	 join [RDF.Stage].InternalNodeMap m on d.nodeid = m.NodeID;

select top 100 * from [orng.].[vwAppPersonData];