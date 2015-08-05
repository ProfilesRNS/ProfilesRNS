/*

Run this script on:

	Profiles RNS Version 2.5.1

to update its data to:

	Profiles RNS Version 2.6.0

*** You are recommended to back up your database before running this script!

*** This script will delete any customizations made to [Framework.].Job
*** If you added additional steps to [Framework.].Job you will need to manually merge these changes.

*** This script will make changes to OpenSocial application URLs, to hit versions compatible with the latest version of ShindigOrng, If you are hosting the OpenSocial xml locally, you will need to update this XML.

*** You should review each step of this script to ensure that it will not overwrite any customizations you have made to ProfilesRNS.

*** Make sure you run the ProfilesRNS_Upgrade_Schema.sql file before running this file.

*/

-- Insert new sites into [Direct.].Sites
insert into [Direct.].[Sites] ( SiteID,SiteName, IsActive, BootstrapURL, QueryURL, SortOrder) 
select max(SiteID) + 1, 'Charles R Drew University of Medicine and Science', 1, 'http://profiles.cdrewu.edu/profiles/Direct/Direct.xml', 'http://profiles.cdrewu.edu/profiles/DIRECT/Modules/DirectSearch/DirectService.aspx?Request=IncomingCount&SearchPhrase=', max(SortOrder) + 1 from [Direct.].[Sites]

-- Alphabetize the sort direct sites sort order 
;with newSortOrders as(
        select SiteID, ROW_NUMBER() over (order by SiteName) as NewSortOrder  from [Direct.].[Sites]
)
update s set SortOrder = newSortOrder from [Direct.].Sites s join newSortOrders n on s.SiteID = n.SiteID


-- Update ORNG App URLs.
update [ORNG.].[Apps] set  URL = 'http://profiles.ucsf.edu/apps_2.6/Links.xml', Enabled =  1 where AppID= 103 and  Name= 'Websites'
update [ORNG.].[Apps] set  URL = 'http://profiles.ucsf.edu/apps_2.6/RDFTest.xml' where AppID= 10 and  Name= 'RDF Test'
update [ORNG.].[Apps] set  URL = 'http://profiles.ucsf.edu/apps_2.6/SlideShare.xml', Enabled =  1 where AppID= 101 and  Name= 'Featured Presentations'
update [ORNG.].[Apps] set  URL = 'http://profiles.ucsf.edu/apps_2.6/Twitter.xml', Enabled =  1 where AppID= 112 and  Name= 'Twitter'
update [ORNG.].[Apps] set  URL = 'http://profiles.ucsf.edu/apps_2.6/YouTube.xml', Enabled =  1 where AppID= 114 and  Name= 'Featured Videos'

-- Update default ORCID settings.
update [Ontology.].[ClassProperty] set  IsDetail =  0, MaxCardinality =  1, CustomEditModule =  '<Module ID="CustomEditORCID"/>', EditSecurityGroup =  -50, EditPermissionsSecurityGroup =  -50, EditExistingSecurityGroup =  -50, EditAddNewSecurityGroup =  -50, EditAddExistingSecurityGroup =  -50, EditDeleteSecurityGroup =  -50, CustomDisplay =  1, CustomEdit =  1, ViewSecurityGroup =  -50 where Class= 'http://xmlns.com/foaf/0.1/Person' and  NetworkProperty is null and  Property= 'http://vivoweb.org/ontology/core#orcidId'

--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
--*****
--***** Finalize changes
--*****
--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
  
-- The next two rows update fields such as nodeID values, and table identifiers. This should not affect any existing customizations
EXEC [Ontology.].[UpdateDerivedFields]
EXEC [Ontology.].[UpdateCounts]
EXEC [Ontology.].CleanUp @action='UpdateIDs'

-- Update the RDF tables and cache
EXEC [Framework.].[RunJobGroup] @JobGroup = 3


GO