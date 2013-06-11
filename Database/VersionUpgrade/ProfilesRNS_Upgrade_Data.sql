/*

Run this script on:

	Profiles RNS Version 1.0.3

to update its data to:

	Profiles RNS Version 1.0.4

*** You are recommended to back up your database before running this script!

*** Make sure you run the ProfilesRNS_Upgrade_Schema.sql file before running this file.

*/

update [ontology.].classproperty
       set editsecuritygroup=-20, EditPermissionsSecurityGroup=-20
       where Class='http://xmlns.com/foaf/0.1/Person' and NetworkProperty is null and Property='http://vivoweb.org/ontology/core#mailingAddress'

update [ontology.].classproperty
       set editsecuritygroup=-20, EditPermissionsSecurityGroup=-20
       where Class='http://xmlns.com/foaf/0.1/Person' and NetworkProperty is null and Property='http://profiles.catalyst.harvard.edu/ontology/prns#emailEncrypted'
