SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[GetData]
	@Subject bigint=NULL
	, @PropertyURI [varchar](100)=NULL
	, @SessionID  UNIQUEIDENTIFIER = NULL
AS
BEGIN
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
	END

	IF @canEdit <> 1
	BEGIN
		select '{}' as JSON, 'FORBIDDEN' as status
		return
	END

	-- Confirm that the users can update this property, or the user is an administrator with higher permissions.
	declare @typeID bigint
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
	declare @SubjectType table(t bigint)
	insert into @SubjectType
	select Object from [RDF.].Triple where subject=@Subject and predicate=@typeID order by Object
	
	set @PropertyURI = REPLACE(@PropertyURI, '!', '#')
	declare @predicateNodeID bigint
	select @predicateNodeID = [RDF.].[fnURI2NodeID](@PropertyURI)

	declare @editSecurityGroup bigint = -100
	select @editSecurityGroup = max(EditSecurityGroup) from [Ontology.].ClassProperty a join @SubjectType b on _ClassNode = t and _PropertyNode = @predicateNodeID
	if NOT(@editSecurityGroup = -20 OR (@SecurityGroupID <= -40 AND  @SecurityGroupID <= @editSecurityGroup)) 
	begin
		select '{}' as JSON, 'FORBIDDEN' as status
		return
	end

	declare @proc varchar(400)
	select @proc = GetDataStoredProcedure from [Edit.Module].EditClassProperty a join @SubjectType b on a._ClassNode = b.t and a._PropertyNode = @predicateNodeID


	declare @status varchar(50)
	declare @json nvarchar(max)
	exec @proc	@Subject=@Subject, @PropertyURI=@PropertyURI, @SessionID=@SessionID, @Json=@Json OUTPUT

	select @json as JSON, 'SUCCESS' as status
END
GO
