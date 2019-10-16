SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Person.GetPhotos](@NodeID bigINT, @SessionID UNIQUEIDENTIFIER=NULL)
AS
BEGIN

	DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT, @HasSecurityGroupNodes BIT
	EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
	CREATE TABLE #SecurityGroupNodes (SecurityGroupNode BIGINT PRIMARY KEY)
	INSERT INTO #SecurityGroupNodes (SecurityGroupNode) EXEC [RDF.Security].GetSessionSecurityGroupNodes @SessionID, @NodeID

	DECLARE @PredicateID BIGINT
	SELECT @PredicateID = _PropertyNode FROM [Ontology.].ClassProperty WHERE Property = 'http://profiles.catalyst.harvard.edu/ontology/prns#mainImage'
	
	DECLARE @ViewSecurityGroup BIGINT
	SELECT @ViewSecurityGroup = isnull(ViewSecurityGroup, -100) from [RDF.].Triple where Subject = @NodeID AND Predicate = @PredicateID

	IF (@ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (@ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (@ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes))
	BEGIN
		DECLARE @InternalID INT, @InternalType NVARCHAR(300)

		SELECT @InternalID = CAST(m.InternalID AS INT),
			@InternalType = InternalType
 			FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
			WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID

		IF @InternalType = 'Person'
		BEGIN
			SELECT  photo,
					p.PhotoID		
				FROM [Profile.Data].[Person.Photo] p WITH(NOLOCK)
				WHERE PersonID=@InternalID  
			END

		ELSE IF @InternalType = 'Group' 
		BEGIN
			SELECT  photo,
					p.PhotoID		
				FROM [Profile.Data].[Group.Photo] p WITH(NOLOCK)
				WHERE GroupID=@InternalID  
			END
		END
END
GO
