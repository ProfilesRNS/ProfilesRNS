SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[SetNodePropertySecurity]
	@NodeID bigint,
	@PropertyID bigint = NULL,
	@PropertyURI varchar(400) = NULL,
	@ViewSecurityGroup bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	SELECT @NodeID = NULL WHERE @NodeID = 0
	SELECT @PropertyID = NULL WHERE @PropertyID = 0

	IF (@PropertyID IS NULL) AND (@PropertyURI IS NOT NULL)
		SELECT @PropertyID = [RDF.].fnURI2NodeID(@PropertyURI)

	-- If node+property, then save setting so that it does
	-- not get overwritten through data loads
	IF (@NodeID IS NOT NULL) AND (@PropertyID IS NOT NULL) AND (@ViewSecurityGroup IS NOT NULL)
	BEGIN
		-- Save setting
		UPDATE [RDF.Security].NodeProperty
			SET ViewSecurityGroup = @ViewSecurityGroup
			WHERE NodeID = @NodeID AND Property = @PropertyID
		INSERT INTO [RDF.Security].NodeProperty (NodeID, Property, ViewSecurityGroup)
			SELECT @NodeID, @PropertyID, @ViewSecurityGroup
			WHERE NOT EXISTS (
				SELECT *
				FROM [RDF.Security].NodeProperty
				WHERE NodeID = @NodeID AND Property = @PropertyID
			)
		-- Update existing triples
		UPDATE [RDF.].Triple
			SET ViewSecurityGroup = @ViewSecurityGroup
			WHERE Subject = @NodeID AND Predicate = @PropertyID
		-- Change ViewSecurityGroup of object nodes to be at least as permissive as the triples
		UPDATE n
			SET n.ViewSecurityGroup = t.v
			FROM [RDF.].[Node] n
				INNER JOIN (
					SELECT NodeID, MAX(v) v
					FROM (
						SELECT n.NodeID, n.ViewSecurityGroup,
							(CASE	WHEN t.ViewSecurityGroup < 0 AND n.ViewSecurityGroup > 0 THEN -1
									WHEN t.ViewSecurityGroup < 0 AND n.ViewSecurityGroup < t.ViewSecurityGroup THEN t.ViewSecurityGroup
									WHEN t.ViewSecurityGroup > 0 AND n.ViewSecurityGroup > 0 AND t.ViewSecurityGroup <> n.ViewSecurityGroup THEN -20
									WHEN t.ViewSecurityGroup > 0 AND n.ViewSecurityGroup < -20 THEN -20
									ELSE n.ViewSecurityGroup END) v
						FROM [RDF.].[Triple] t
							INNER JOIN [RDF.].[Node] n ON t.Object = n.NodeID
						WHERE t.Subject = @NodeID AND t.Predicate = @PropertyID
					) t
					WHERE ViewSecurityGroup <> v
					GROUP BY NodeID
				) t
				ON n.NodeID = t.NodeID
	END
 
END
GO
