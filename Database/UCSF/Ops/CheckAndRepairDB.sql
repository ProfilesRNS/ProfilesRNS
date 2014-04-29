DBCC checkdb('profiles_prod') WITH NO_INFOMSGS --20 minutes

ALTER DATABASE profiles_prod
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO
DBCC checkdb('profiles_prod', REPAIR_REBUILD)

DBCC updateusage('profiles_prod')

select COUNT(*) from profiles_prod.[Profile.Data].Person; --29562, 6651
select COUNT(*) from profiles_prod.[RDF.].Node; --14788121, 31700297
select COUNT(*) from profiles_prod.[RDF.].Triple; --22445452, 37921132

ALTER DATABASE profiles_prod
SET MULTI_USER
WITH ROLLBACK IMMEDIATE;
GO


--delete from [profiles_200].[User.Session].[Session];
--truncate table [profiles_200].[User.Session].[Session];