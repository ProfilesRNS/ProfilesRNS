SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.].[UpdateCounts]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @typeID BIGINT
	SELECT @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')

	-- Get ClassGroup counts
	SELECT g.ClassGroupURI, COUNT(DISTINCT t.Subject) NumberOfNodes
		INTO #ClassGroup
		FROM [Ontology.].[ClassGroup] g, [Ontology.].[ClassGroupClass] c, [RDF.].[Triple] t,
			[RDF.].[Node] s, [RDF.].[Node] p, [RDF.].[Node] o
		WHERE g.ClassGroupURI = c.ClassGroupURI and c._ClassNode = t.Object and t.Predicate = @typeID
			and t.ViewSecurityGroup = -1
			and t.subject = s.nodeid and s.ViewSecurityGroup = -1
			and t.predicate = p.nodeid and p.ViewSecurityGroup = -1
			and t.object = o.nodeid and o.ViewSecurityGroup = -1
		GROUP BY g.ClassGroupURI

	-- Get ClassGroupClass counts
	SELECT c.ClassGroupURI, c.ClassURI, COUNT(DISTINCT t.Subject) NumberOfNodes
		INTO #ClassGroupClass
		FROM [Ontology.].[ClassGroupClass] c, [RDF.].[Triple] t,
			[RDF.].[Node] s, [RDF.].[Node] p, [RDF.].[Node] o
		WHERE c._ClassNode = t.Object and t.Predicate = @typeID
			and t.ViewSecurityGroup = -1
			and t.subject = s.nodeid and s.ViewSecurityGroup = -1
			and t.predicate = p.nodeid and p.ViewSecurityGroup = -1
			and t.object = o.nodeid and o.ViewSecurityGroup = -1
		GROUP BY c.ClassGroupURI, c.ClassURI

	-- Get ClassProperty counts
	SELECT c.ClassPropertyID, COUNT(DISTINCT t.Subject) NumberOfNodes, COUNT(DISTINCT t2.TripleID) NumberOfTriples
		INTO #ClassProperty
		FROM [Ontology.].[ClassProperty] c, [RDF.].[Triple] t,
			[RDF.].[Node] s, [RDF.].[Node] p, [RDF.].[Node] o,
			[RDF.].[Triple] t2,
			[RDF.].[Node] p2, [RDF.].[Node] o2
		WHERE c._ClassNode = t.Object 
			and c._NetworkPropertyNode is null
			and t.Predicate = @typeID 
			and t.ViewSecurityGroup = -1
			and t.subject = s.nodeid and s.ViewSecurityGroup = -1
			and t.predicate = p.nodeid and p.ViewSecurityGroup = -1
			and t.object = o.nodeid and o.ViewSecurityGroup = -1
			and t2.subject = t.subject
			and t2.predicate = c._PropertyNode
			and t2.ViewSecurityGroup = -1
			and t2.predicate = p2.nodeid and p2.ViewSecurityGroup = -1
			and t2.object = o2.nodeid and o2.ViewSecurityGroup = -1
		GROUP BY c.ClassPropertyID
BEGIN TRY 
	begin transaction
		
		-- Update ClassGroup
		UPDATE o
			SET	o._NumberOfNodes = IsNull(g.NumberOfNodes,0)
			FROM [Ontology.].[ClassGroup] o
				left outer join #ClassGroup g on o.ClassGroupURI = g.ClassGroupURI

		-- Update ClassGroupClass
		UPDATE o
			SET	o._NumberOfNodes = IsNull(c.NumberOfNodes,0)
			FROM [Ontology.].[ClassGroupClass] o
				left outer join #ClassGroupClass c on o.ClassGroupURI = c.ClassGroupURI and o.ClassURI = c.ClassURI

		-- Update ClassProperty
		UPDATE o
			SET	o._NumberOfNodes = IsNull(c.NumberOfNodes,0), o._NumberOfTriples = IsNull(c.NumberOfTriples,0)
			FROM [Ontology.].[ClassProperty] o
				left outer join #ClassProperty c on o.ClassPropertyID = c.ClassPropertyID

	commit transaction
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		

END
GO
