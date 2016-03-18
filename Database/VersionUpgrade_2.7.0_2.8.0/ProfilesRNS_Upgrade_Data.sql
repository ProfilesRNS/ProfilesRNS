/*

Run this script on:

	Profiles RNS Version 2.7.0

to update its data to:

	Profiles RNS Version 2.8.0

*** You are recommended to back up your database before running this script!

*** You should review each step of this script to ensure that it will not overwrite any customizations you have made to ProfilesRNS.

*** Make sure you run the ProfilesRNS_Upgrade_Schema.sql file before running this file.

*/

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