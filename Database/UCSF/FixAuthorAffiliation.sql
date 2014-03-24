
-------------------------
BEGIN  tran

 ALTER TABLE [Profile.Data].[Publication.PubMed.Author] add    Affiliation2 varchar(4000) NULL
 GO
 UPDATE [Profile.Data].[Publication.PubMed.Author] set Affiliation2 = Affiliation
 
 ALTER TABLE [Profile.Data].[Publication.PubMed.Author] drop column   Affiliation 
 GO
 EXEC sp_rename '[Profile.Data].[Publication.PubMed.Author].Affiliation2', 'Affiliation','COLUMN'

 COMMIT
----------------------------
 
