-- reference data
insert [ORNG].Visibility select * from profiles_102.ORNG.Visibility;

-- apps and supporting app data
insert [ORNG].Apps select * from profiles_102.ORNG.Apps;
insert [ORNG].AppViews select * from profiles_102.ORNG.AppViews;

-- person data
insert [ORNG].AppRegistry 
	select r.appId, 'http://stage-profiles.ucsf.edu/profiles103/profile/' +
		cast(pn.nodeId as varchar), r.createdDT, r.visibility from profiles_102.ORNG.AppRegistry r
		join profiles_102.UCSF.vwPersonExport po on r.personId = 'http://stage-profiles.ucsf.edu/profiles102/profile/' +
		cast(po.nodeId as varchar) join UCSF.vwPersonExport pn on pn.personid = po.personid;

insert [ORNG].AppData 
	select 'http://stage-profiles.ucsf.edu/profiles103/profile/' +
		cast(pn.nodeId as varchar), d.appId, d.keyname, d.value, d.createdDT, d.updatedDT 
		from profiles_102.ORNG.AppData d
		join profiles_102.UCSF.vwPersonExport po on d.userId = 'http://stage-profiles.ucsf.edu/profiles102/profile/' +
		cast(po.nodeId as varchar) join UCSF.vwPersonExport pn on pn.personid = po.personid;		
