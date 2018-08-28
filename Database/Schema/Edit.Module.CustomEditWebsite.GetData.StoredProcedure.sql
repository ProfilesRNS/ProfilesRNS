SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[CustomEditWebsite.GetData]
	@NodeID bigint=NULL
	, @Predicate [varchar](100)=NULL
AS
BEGIN

	DECLARE @InternalID INT, @InternalType NVARCHAR(300)

	SELECT @InternalID = CAST(m.InternalID AS INT),
		@InternalType = InternalType
 		FROM [RDF.Stage].[InternalNodeMap] m
		WHERE m.Status = 3 AND m.NodeID = @NodeID

	IF @InternalType = 'Person' AND @Predicate = 'http://vivoweb.org/ontology/core#webpage'
	BEGIN
		SELECT *, null as PublicationDate FROM [Profile.Data].[Person.Websites] WHERE PersonID = @InternalID ORDER BY SortOrder
	END
	ELSE IF @InternalType = 'Person' AND @Predicate = 'http://profiles.catalyst.harvard.edu/ontology/prns#mediaLinks'
	BEGIN
		SELECT * FROM [Profile.Data].[Person.MediaLinks] WHERE PersonID = @InternalID ORDER BY SortOrder
	END
	ELSE IF @InternalType = 'Group' AND @Predicate = 'http://vivoweb.org/ontology/core#webpage'
	BEGIN
		SELECT *, null as PublicationDate FROM [Profile.Data].[Group.Websites] WHERE GroupID = @InternalID ORDER BY SortOrder
	END
	ELSE IF @InternalType = 'Group' AND @Predicate = 'http://profiles.catalyst.harvard.edu/ontology/prns#mediaLinks'
	BEGIN
		SELECT * FROM [Profile.Data].[Group.MediaLinks] WHERE GroupID = @InternalID ORDER BY SortOrder
	END
END
GO
