/*
Run this script on:

        Profiles 2.12.0   -  This database will be modified

to synchronize it with:

        Profiles 3.0.0

You are recommended to back up your database before running this script

This script updates permissions for the App_Profiles10 database user. 
If you use a different user to connect your Profiles application to your 
Profiles Database, you should modify the user name in this script.

*/

GRANT EXEC ON [Edit.Module].[CustomEditWebsite.AddEditWebsite] TO App_Profiles10
GRANT EXEC ON [Edit.Module].[CustomEditWebsite.GetData] TO App_Profiles10
GRANT EXEC ON [Framework.].[GetBasePath] TO App_Profiles10
GRANT EXEC ON [Framework.].[GetBaseURI] TO App_Profiles10
GRANT EXEC ON [Profile.Cache].[List.Export.UpdatePublications] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[Funding.GetDisambiguationSettings] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[Funding.UpdateDisambiguationSettings] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[List.AddRemove.Filter] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[List.AddRemove.Person] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[List.AddRemove.SelectedPeople] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[List.ExportCoAuthorConnections]  TO App_Profiles10
GRANT EXEC ON [Profile.Data].[List.ExportPersonList]  TO App_Profiles10
GRANT EXEC ON [Profile.Data].[List.ExportPersonPublicationsList] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[List.GetList] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[List.GetPeople] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[List.GetSummary] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[List.UpdateAllLists] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[Publication.Group.MyPub.GetPublication] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[Publication.Group.MyPub.UpdatePublication] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[Publication.Pubmed.GetDisambiguationSettings] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[Publication.Pubmed.UpdateDisambiguationSettings] TO App_Profiles10
GRANT EXEC ON [Profile.Module].[GenericRDF.AddPluginToProfile] TO App_Profiles10
GRANT EXEC ON [Profile.Module].[GenericRDF.AddUpdateOntology] TO App_Profiles10
GRANT EXEC ON [Profile.Module].[GenericRDF.GetPluginData] TO App_Profiles10
GRANT EXEC ON [Profile.Module].[GenericRDF.RemovePluginFromProfile] TO App_Profiles10
GRANT EXEC ON [Profile.Module].[NetworkMap.GetList] TO App_Profiles10
GRANT EXEC ON [Profile.Module].[NetworkRadial.List.GetCoAuthors] TO App_Profiles10
GRANT EXEC ON [Profile.Data].[List.AddRemove.Search] TO App_Profiles10
GRANT EXEC ON [Profile.Module].[GenericRDF.AddEditPluginData] TO App_Profiles10