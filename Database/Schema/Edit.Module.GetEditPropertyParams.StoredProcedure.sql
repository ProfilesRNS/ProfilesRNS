SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Edit.Module].[GetEditPropertyParams]
	@Subject bigint=NULL
	, @PropertyURI [varchar](100)=NULL
	, @SessionID  UNIQUEIDENTIFIER = NULL
AS
BEGIN
	declare @viewSecurityGroup bigint, @propertyNode bigint, @propertyName nvarchar(400), @editModule varchar(100), @maxCardinality int
	select @propertyURI = isnull(a.Property, 'ERROR'), @propertyName = isnull(a._PropertyLabel, 'Unknown Property'), @editModule = isnull(EditModule, 'Edit.Error'), @maxCardinality = isnull(MaxCardinality, 0), @viewSecurityGroup =isnull(a.ViewSecurityGroup, Subject), @propertyNode = a._PropertyNode
		from [Ontology.].ClassProperty a 
		join [RDF.].Triple b
			on b.subject=@Subject and predicate=[RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type') and a._ClassNode = b.object and a.Property = @PropertyURI	
		join [Edit.Module].EditClassProperty c on a._PropertyNode = c._PropertyNode and a._ClassNode = c._ClassNode
	select @viewSecurityGroup = isnull(ViewSecurityGroup, @viewSecurityGroup) from  [RDF.Security].[NodeProperty] where nodeID = @subject and Property = @PropertyNode
	select (select @propertyURI propertyURI, @propertyName propertyName, @editModule propertyModule, @maxCardinality maxCardinality, @viewSecurityGroup viewSecurityGroup for json path , WITHOUT_ARRAY_WRAPPER) as editPropertyParams
END
GO
