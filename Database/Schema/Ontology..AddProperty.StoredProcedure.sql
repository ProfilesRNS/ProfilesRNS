SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.].[AddProperty]
	@OWL nvarchar(100),
	@PropertyURI varchar(400),
	@PropertyName varchar(max),
	@ObjectType bit,
	@PropertyGroupURI varchar(400) = null,
	@SortOrder int = null,
	@ClassURI varchar(400) = null,
	@NetworkPropertyURI varchar(400) = null,
	@IsDetail bit = null,
	@Limit int = null,
	@IncludeDescription bit = null,
	@IncludeNetwork bit = null,
	@SearchWeight float = null,
	@CustomDisplay bit = null,
	@CustomEdit bit = null,
	@ViewSecurityGroup bigint = null,
	@EditSecurityGroup bigint = null,
	@EditPermissionsSecurityGroup bigint = null,
	@EditExistingSecurityGroup bigint = null,
	@EditAddNewSecurityGroup bigint = null,
	@EditAddExistingSecurityGroup bigint = null,
	@EditDeleteSecurityGroup bigint = null,
	@MinCardinality int = null,
	@MaxCardinality int = null,
	@CustomEditModule xml = null,
	@ReSortClassProperty bit = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	---------------------------------------------------
	-- [Ontology.Import].[Triple]
	---------------------------------------------------

	DECLARE @LoadRDF BIT
	SELECT @LoadRDF = 0

	-- Get Graph
	DECLARE @Graph BIGINT
	SELECT @Graph = (SELECT Graph FROM [Ontology.Import].[OWL] WHERE Name = @OWL)

	-- Insert Type record
	IF NOT EXISTS (SELECT *
					FROM [Ontology.Import].[Triple]
					WHERE OWL = @OWL and Subject = @PropertyURI and Predicate = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
	BEGIN
		INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object)
			SELECT @OWL, @Graph, @PropertyURI,
				'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
				(CASE WHEN @ObjectType = 1 THEN 'http://www.w3.org/2002/07/owl#DatatypeProperty'
						ELSE 'http://www.w3.org/2002/07/owl#ObjectProperty' END)
		SELECT @LoadRDF = 1
	END
	
	-- Insert Label record
	IF NOT EXISTS (SELECT *
					FROM [Ontology.Import].[Triple]
					WHERE OWL = @OWL and Subject = @PropertyURI and Predicate = 'http://www.w3.org/2000/01/rdf-schema#label')
	BEGIN
		INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object)
			SELECT @OWL, @Graph, @PropertyURI,
				'http://www.w3.org/2000/01/rdf-schema#label',
				@PropertyName
		SELECT @LoadRDF = 1
	END

	-- Load RDF
	IF @LoadRDF = 1
	BEGIN
		EXEC [RDF.Stage].[LoadTriplesFromOntology] @OWL = @OWL, @Truncate = 1
		EXEC [RDF.Stage].[ProcessTriples]
	END
	
	---------------------------------------------------
	-- [Ontology.].[PropertyGroupProperty]
	---------------------------------------------------

	IF NOT EXISTS (SELECT * FROM [Ontology.].PropertyGroupProperty WHERE PropertyURI = @PropertyURI)
	BEGIN
	
		-- Validate the PropertyGroupURI
		SELECT @PropertyGroupURI = IsNull((SELECT TOP 1 PropertyGroupURI 
											FROM [Ontology.].PropertyGroup
											WHERE PropertyGroupURI = @PropertyGroupURI
												AND @PropertyGroupURI IS NOT NULL
											),'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview')
		
		-- Validate the SortOrder
		DECLARE @MaxSortOrder INT
		SELECT @MaxSortOrder = IsNull((SELECT MAX(SortOrder)
										FROM [Ontology.].PropertyGroupProperty
										WHERE PropertyGroupURI = @PropertyGroupURI),0)
		SELECT @SortOrder = (CASE WHEN @SortOrder IS NULL THEN @MaxSortOrder+1
									WHEN @SortOrder > @MaxSortOrder THEN @MaxSortOrder+1
									ELSE @SortOrder END)

		-- Shift SortOrder of existing records
		UPDATE [Ontology.].PropertyGroupProperty
			SET SortOrder = SortOrder + 1
			WHERE PropertyGroupURI = @PropertyGroupURI AND SortOrder >= @SortOrder
		
		-- Insert new property
		INSERT INTO [Ontology.].PropertyGroupProperty (PropertyGroupURI, PropertyURI, SortOrder, _NumberOfNodes)
			SELECT @PropertyGroupURI, @PropertyURI, @SortOrder, 0

	END

	---------------------------------------------------
	-- [Ontology.].[ClassProperty]
	---------------------------------------------------

	IF (@ClassURI IS NOT NULL) AND NOT EXISTS (
		SELECT *
		FROM [Ontology.].[ClassProperty]
		WHERE Class = @ClassURI AND Property = @PropertyURI
			AND ( (NetworkProperty IS NULL AND @NetworkPropertyURI IS NULL) OR (NetworkProperty = @NetworkPropertyURI) )
	)
	BEGIN

		-- Get the ClassPropertyID	
		DECLARE @ClassPropertyID INT
		SELECT @ClassPropertyID = IsNull((SELECT MAX(ClassPropertyID)
											FROM [Ontology.].ClassProperty),0)+1
		-- Insert the new property
		INSERT INTO [Ontology.].[ClassProperty] (
				ClassPropertyID,
				Class, NetworkProperty, Property,
				IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight,
				CustomDisplay, CustomEdit, ViewSecurityGroup,
				EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup,
				MinCardinality, MaxCardinality, CustomEditModule,
				_NumberOfNodes, _NumberOfTriples		
			)
			SELECT	@ClassPropertyID,
					@ClassURI, @NetworkPropertyURI, @PropertyURI,
					IsNull(@IsDetail,1), @Limit, IsNull(@IncludeDescription,0), IsNull(@IncludeNetwork,0),
					IsNull(@SearchWeight,(CASE WHEN @ObjectType = 0 THEN 0 ELSE 0.5 END)),
					IsNull(@CustomDisplay,0), IsNull(@CustomEdit,0), IsNull(@ViewSecurityGroup,-1),
					IsNull(@EditSecurityGroup,-40),
					Coalesce(@EditPermissionsSecurityGroup,@EditSecurityGroup,-40),
					Coalesce(@EditExistingSecurityGroup,@EditSecurityGroup,-40),
					Coalesce(@EditAddNewSecurityGroup,@EditSecurityGroup,-40),
					Coalesce(@EditAddExistingSecurityGroup,@EditSecurityGroup,-40),
					Coalesce(@EditDeleteSecurityGroup,@EditSecurityGroup,-40),
					IsNull(@MinCardinality,0),
					@MaxCardinality,
					@CustomEditModule,
					0, 0

		-- Re-sort the table
		IF @ReSortClassProperty = 1
			update x
				set x.ClassPropertyID = y.k
				from [Ontology.].ClassProperty x, (
					select *, row_number() over (order by (case when NetworkProperty is null then 0 else 1 end), Class, NetworkProperty, IsDetail, IncludeNetwork, Property) k
						from [Ontology.].ClassProperty
				) y
				where x.Class = y.Class and x.Property = y.Property
					and ((x.NetworkProperty is null and y.NetworkProperty is null) or (x.NetworkProperty = y.NetworkProperty))

	END

	---------------------------------------------------
	-- Update Derived Fields
	---------------------------------------------------

	EXEC [Ontology.].UpdateDerivedFields
	
	
	/*
	
	-- Example
	exec [Ontology.].AddProperty
		@OWL = 'PRNS_1.0',
		@PropertyURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#emailEncrypted',
		@PropertyName = 'email encrypted',
		@ObjectType = 1,
		@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupAddress',
		@SortOrder = 20,
		@ClassURI = 'http://xmlns.com/foaf/0.1/Person',
		@NetworkPropertyURI = null,
		@IsDetail = 0,
		@SearchWeight = 0,
		@CustomDisplay = 1,
		@CustomEdit = 1

	*/
	
END
GO
