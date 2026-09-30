SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[SetVisibility]
	@Subject bigint=NULL
	, @PropertyURI [varchar](100)=NULL
	, @ViewSecurityGroup bigint
	, @SessionID  UNIQUEIDENTIFIER = NULL
AS
BEGIN
/*
[RDF.].[SetNodePropertySecurity]
	@NodeID bigint,
	@PropertyID bigint = NULL,
	@PropertyURI varchar(400) = NULL,
	@ViewSecurityGroup bigint
*/

	declare @LogIDTable table (LogID int)
	insert into [Edit.Module].[AddUpdateDataLog](UpdateDate, Subject, PropertyURI, SessionID, ViewSecurityGroup) 
		output inserted.AddUpdateDataLogID into @LogIDTable
		values (GETDATE(), @Subject, @PropertyURI, @SessionID, @ViewSecurityGroup)

	declare  @LogID int
	select @LogID = LogID from @logIDTable

	-- Confirm that the session has access to edit this node
	DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT, @HasSpecialEditAccess BIT
	declare @canEdit int = 0
	if @SessionID is not null
	BEGIN
		EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT, @HasSpecialEditAccess OUTPUT
		CREATE TABLE #SecurityGroupNodes (SecurityGroupNode BIGINT PRIMARY KEY)
		INSERT INTO #SecurityGroupNodes (SecurityGroupNode) EXEC [RDF.Security].GetSessionSecurityGroupNodes @SessionID, @subject
		SELECT @CanEdit = 0
		SELECT @CanEdit = 1
			FROM [RDF.].Node
			WHERE NodeID = @subject
				AND ( (EditSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )

		declare @typeID bigint, @EditPermissionsSecurityGroup bigint = -100
		select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
		select @EditPermissionsSecurityGroup = max(EditPermissionsSecurityGroup) from [Ontology.].ClassProperty a 
			join [RDF.].Triple b
				on b.subject=@Subject and predicate=@typeID and a._ClassNode = b.object and a.Property = @PropertyURI	

		--TODO Add editing for Admins
		select @CanEdit = case when @canEdit = 1 and @EditPermissionsSecurityGroup = -20 then 1 else 0 end
	END

	IF @canEdit <> 1
	BEGIN
		update [Edit.Module].AddUpdateDataLog set Status = 'FORBIDDEN' where AddUpdateDataLogID = @LogID
		select 'FORBIDDEN' as status 
		return
	END	

	-- If this is a person page, the view security group should be the the node id of the user not the person.
	
	IF @ViewSecurityGroup > 0 and exists (select 1 from [Profile.Cache].Person where NodeID = @Subject)
	BEGIN
		declare @userID int
		select @userID = UserID from [Profile.Cache].Person where NodeID = @Subject
		select @ViewSecurityGroup = NodeID from [RDF.Stage].InternalNodeMap where InternalID = cast(@userID as varchar(50)) and Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User' 
	END

	Exec [RDF.].[SetNodePropertySecurity] @NodeID=@subject, @PropertyURI=@PropertyURI, @ViewSecurityGroup=@ViewSecurityGroup

	declare @predicateNodeID bigint
	select @predicateNodeID = [RDF.].[fnURI2NodeID](@PropertyURI)
	update [Edit.Module].AddUpdateDataLog set Status = 'SUCCESS' where AddUpdateDataLogID = @LogID
	select 'SUCCESS' as status
END
GO
