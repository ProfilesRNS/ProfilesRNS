SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE  [Profile.Data].[Publication.Pubmed.AddDisambiguationLog] (@batchID UNIQUEIDENTIFIER, 
												@personID INT,
												@actionValue INT,
												@action VARCHAR(200),
												@actionText varchar(max) = null )
AS
BEGIN
	IF @action='StartService'
		BEGIN
			INSERT INTO [Profile.Data].[Publication.PubMed.DisambiguationAudit]  (BatchID,BatchCount,PersonID,ServiceCallStart)
			VALUES (@batchID,@actionValue,@personID,GETDATE())
		END
	IF @action='EndService'
		BEGIN
			UPDATE [Profile.Data].[Publication.PubMed.DisambiguationAudit] 
			   SET ServiceCallEnd = GETDATE(),
				   ServiceCallPubsFound  =@actionValue
			 WHERE batchID=@batchID
			   AND personid=@personID
		END
	IF @action='LocalCounts'
		BEGIN
			UPDATE [Profile.Data].[Publication.PubMed.DisambiguationAudit] 
			   SET ServiceCallNewPubs = @actionValue,
				   ServiceCallExistingPubs  =ServiceCallPubsFound-@actionValue
			 WHERE batchID=@batchID
			   AND personid=@personID
		END
	IF @action='AuthorComplete'
		BEGIN
			UPDATE [Profile.Data].[Publication.PubMed.DisambiguationAudit] 
			   SET ServiceCallPubsAdded = @actionValue,
				   ProcessEnd  =GETDATE(),
				   Success= 1
			 WHERE batchID=@batchID
			   AND personid=@personID
		END
	IF @action='Error'
		BEGIN
			UPDATE [Profile.Data].[Publication.PubMed.DisambiguationAudit] 
			   SET ErrorText = @actionText,
				   ProcessEnd  =GETDATE(),
				   Success=0
			 WHERE batchID=@batchID
			   AND personid=@personID
		END
END
GO
