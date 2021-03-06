/*
Run this script on:

        Profiles 3.0.0   -  This database will be modified

to synchronize it with:

        Profiles 3.1.0

You are recommended to back up your database before running this script

This script updates permissions for the App_Profiles10 database user. 
If you use a different user to connect your Profiles application to your 
Profiles Database, you should modify the user name in this script.

*/

GRANT EXEC ON [Profile.Data].[Publication.Pubmed.AddPubmedBookArticle] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[Publication.Pubmed.ParsePubmedBookArticle] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[Publication.Pubmed.UpdateAuthor2Person] TO App_Profiles10
GRANT EXEC ON [Profile.Import].[PRNSWebservice.Funding.GetPersonInfoForDisambiguation] TO App_Profiles10
GRANT EXEC ON [Profile.Import].[PRNSWebservice.Funding.ParseDisambiguationXML] TO App_Profiles10
GRANT EXEC ON [Profile.Import].[PRNSWebservice.PubMed.GetAllPMIDs] TO App_Profiles10
GRANT EXEC ON [Profile.Import].[PRNSWebservice.PubMed.GetPersonInfoForDisambiguation] TO App_Profiles10
GRANT EXEC ON [Profile.Import].[PRNSWebservice.PubMed.ImportDisambiguationResults] TO App_Profiles10
GRANT EXEC ON [Profile.Import].[PRNSWebservice.Pubmed.AddPubMedXML] TO App_Profiles10
GRANT EXEC ON [RDF.].[GetPresentationXMLByType] TO App_Profiles10
GRANT EXEC ON [RDF.Security].[CanEditNode] TO App_Profiles10

GRANT EXECUTE ON [RDF.].[fnNodeID2TypeID] TO App_Profiles10
