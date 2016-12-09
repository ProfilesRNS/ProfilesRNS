/*

Run this script on:

	Profiles RNS Version 2.9.0

to update its data to:

	Profiles RNS Version 2.10.0

*** You are recommended to back up your database before running this script!

*** You should review each step of this script to ensure that it will not overwrite any customizations you have made to ProfilesRNS.

*** Make sure you run the ProfilesRNS_Upgrade_Schema.sql file before running this file.
 
*** Modify line 31, replace $(ProfilesRNSRootPath)\Data with the location that contains the various XML files that came with Profiles RNS 2.9.0 (not an older version of that file). These file has to be on the database server, not your local machine.

*/

-- Delete Agreement nodes and associated triples
DELETE FROM [RDF.].Triple WHERE Subject in (SELECT NodeID from [RDF.Stage].InternalNodeMap WHERE InternalType = 'Agreement') or Object in (SELECT NodeID from [RDF.Stage].InternalNodeMap WHERE InternalType = 'Agreement')
DELETE FROM [RDF.].Node WHERE NodeID in (SELECT NodeID from [RDF.Stage].InternalNodeMap WHERE InternalType = 'Agreement')
DELETE FROM [RDF.Stage].InternalNodeMap WHERE InternalType = 'Agreement'

-- Delete rows in DataMap that create Agreement nodes
DELETE FROM [Ontology.].[DataMap] WHERE Class = 'http://vivoweb.org/ontology/core#Agreement' AND NetworkProperty IS NULL AND Property IS NULL
DELETE FROM [Ontology.].[DataMap] WHERE Class = 'http://vivoweb.org/ontology/core#Agreement' AND NetworkProperty IS NULL AND Property = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'

-- Update Datamap to add Agreement type to Grant nodes
UPDATE [Ontology.].[DataMap] SET MapTable = '[Profile.Data].[Funding.Agreement] x CROSS APPLY (select ''http://vivoweb.org/ontology/core#Grant'' TypeValue union all select ''http://vivoweb.org/ontology/core#Agreement'') t', oValue = 'TypeValue', OrderBy = 'TypeValue' WHERE Class = 'http://vivoweb.org/ontology/core#Grant' AND NetworkProperty IS NULL AND Property = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'

-- Delete Role nodes and associated triples
DELETE FROM [RDF.].Triple WHERE Subject in (SELECT NodeID from [RDF.Stage].InternalNodeMap WHERE InternalType = 'Role') or Object in (SELECT NodeID from [RDF.Stage].InternalNodeMap WHERE InternalType = 'Role')
DELETE FROM [RDF.].Node WHERE NodeID in (SELECT NodeID from [RDF.Stage].InternalNodeMap WHERE InternalType = 'Role')
DELETE FROM [RDF.Stage].InternalNodeMap WHERE InternalType = 'Role'

-- Delete rows in DataMap that create Role nodes
DELETE FROM [Ontology.].[DataMap] WHERE Class = 'http://vivoweb.org/ontology/core#Role' AND NetworkProperty IS NULL AND Property IS NULL
DELETE FROM [Ontology.].[DataMap] WHERE Class = 'http://vivoweb.org/ontology/core#Role' AND NetworkProperty IS NULL AND Property = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'

-- Update Datamap to add Role type to ResearcherRole nodes
UPDATE [Ontology.].[DataMap] SET MapTable = '[Profile.Data].[Funding.Role] x CROSS APPLY (select ''http://vivoweb.org/ontology/core#ResearcherRole'' TypeValue union all select ''http://vivoweb.org/ontology/core#Role'') t', oValue = 'TypeValue', OrderBy = 'TypeValue' WHERE Class = 'http://vivoweb.org/ontology/core#ResearcherRole' AND NetworkProperty IS NULL AND Property = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'

  -- Update all derived fields
EXEC [Ontology.].[UpdateDerivedFields]
EXEC [Ontology.].[UpdateCounts]
EXEC [Ontology.].CleanUp @action='UpdateIDs'

-- Update the RDF tables and cache
EXEC [Framework.].[RunJobGroup] @JobGroup = 3
 
GO