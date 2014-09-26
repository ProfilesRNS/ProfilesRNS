-- add start and end time
--EXEC [Ontology.].[AddProperty]	@OWL = 'UCSF_1.0',
--								@PropertyURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#startDate',
--								@PropertyName = 'start date',
--								@ObjectType = 1,
--								@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupTime',
--								@ClassURI = 'http://vivoweb.org/ontology/core#EducationalTraining',
--								@IsDetail = 0,
--								@IncludeDescription = 0
EXEC [Ontology.].[AddProperty]	@OWL = 'UCSF_1.0',
								@PropertyURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#endDate',
								@PropertyName = 'end date',
								@ObjectType = 1,
								@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupTime',
								@ClassURI = 'http://vivoweb.org/ontology/core#EducationalTraining',
								@IsDetail = 0,
								@IncludeDescription = 0
								
select COUNT(*) FROM [Ontology.].ClassGroup;	--6
select COUNT(*) FROM [Ontology.].ClassGroupClass; --9							
select COUNT(*) FROM [Ontology.].ClassProperty;		--871					
select COUNT(*) FROM [Ontology.].PropertyGroup;		--17
select COUNT(*) FROM [Ontology.].PropertyGroupProperty;	--411	

UPDATE [Ontology.].[ClassProperty] SET SearchWeight = 0.1, CustomDisplay = 1, CustomEdit = 1, 
	EditSecurityGroup = -20, EditPermissionsSecurityGroup = -20, EditAddNewSecurityGroup = -20, EditDeleteSecurityGroup = -20,
	CustomEditModule = '<Module ID="CustomEditEducationalTraining" />'
	WHERE Class = 'http://xmlns.com/foaf/0.1/Person' and Property = 'http://vivoweb.org/ontology/core#educationalTraining';
	
-- To make the properties we care about visible
UPDATE [Ontology.].[ClassProperty] SET IsDetail = 0
	WHERE Class = 'http://vivoweb.org/ontology/core#EducationalTraining' and Property = 'http://vivoweb.org/ontology/core#degreeEarned';

UPDATE [Ontology.].[ClassProperty] SET IsDetail = 0
	WHERE Class = 'http://vivoweb.org/ontology/core#EducationalTraining' and Property = 'http://vivoweb.org/ontology/core#departmentOrSchool';

UPDATE [Ontology.].[ClassProperty] SET IsDetail = 0
	WHERE Class = 'http://vivoweb.org/ontology/core#EducationalTraining' and Property = 'http://vivoweb.org/ontology/core#trainingAtOrganization';

UPDATE [Ontology.].[PropertyGroupProperty] SET CustomDisplayModule = N'<Module ID="ApplyXSLT">
  <ParamList>
    <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
    <Param Name="XSLTPath">~/profile/XSLT/EducationalTraining.xslt</Param>
  </ParamList>
</Module>'
	WHERE PropertyURI = 'http://vivoweb.org/ontology/core#educationalTraining';

EXEC [Ontology.].UpdateDerivedFields;

/****** Object:  StoredProcedure [Edit.Module].[CustomEditEducationalTraining.StoreItem]    Script Date: 08/28/2014 13:23:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Edit.Module].[CustomEditEducationalTraining.StoreItem]
@ExistingEducationalTrainingID BIGINT=NULL, @ExistingEducationalTrainingURI VARCHAR (400)=NULL, @educationalTrainingForID BIGINT=NULL, @educationalTrainingForURI BIGINT=NULL, 
@label VARCHAR (MAX), @degree VARCHAR (MAX)=NULL, @institution VARCHAR (MAX)=NULL, @school VARCHAR (MAX)=NULL,
@endDate VARCHAR (MAX)=NULL, @SessionID UNIQUEIDENTIFIER=NULL, @Error BIT=NULL OUTPUT, @NodeID BIGINT=NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*
	
	This stored procedure either creates or updates an
	AwardReceipt. In both cases a label is required.
	Nodes can be specified either by ID or URI.
	
	*/
	
	SELECT @Error = 0

	-------------------------------------------------
	-- Validate and prepare variables
	-------------------------------------------------
	
	-- Convert URIs to NodeIDs
 	IF (@ExistingEducationalTrainingID IS NULL) AND (@ExistingEducationalTrainingURI IS NOT NULL)
		SELECT @ExistingEducationalTrainingID = [RDF.].fnURI2NodeID(@ExistingEducationalTrainingURI)
 	IF (@educationalTrainingForID IS NULL) AND (@educationalTrainingForURI IS NOT NULL)
		SELECT @educationalTrainingForID = [RDF.].fnURI2NodeID(@educationalTrainingForURI)

	-- Check that some operation will be performed
	IF ((@ExistingEducationalTrainingID IS NULL) AND (@educationalTrainingForID IS NULL)) OR (IsNull(@label,'') = '')
	BEGIN
		SELECT @Error = 1
		RETURN
	END

	-- Convert properties to NodeIDs
	DECLARE @institutionNodeID BIGINT
	DECLARE @degreeNodeID BIGINT
	DECLARE @schoolNodeID BIGINT
	DECLARE @endDateNodeID BIGINT
	
	SELECT @institutionNodeID = NULL, @degreeNodeID = NULL, @schoolNodeID = NULL, @endDateNodeID = NULL
	
	IF IsNull(@institution,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @institution, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @institutionNodeID OUTPUT
	IF IsNull(@degree,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @degree, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @degreeNodeID OUTPUT
	IF IsNull(@school,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @school, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @schoolNodeID OUTPUT
	IF IsNull(@endDate,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @endDate, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @endDateNodeID OUTPUT

	-------------------------------------------------
	-- Handle required nodes and properties
	-------------------------------------------------

	-- Get an EducationalTraining with just a label
	IF (@ExistingEducationalTrainingID IS NOT NULL)
	BEGIN
		-- The EducationalTraining NodeID is the ExistingEducationalTraining
		SELECT @NodeID = @ExistingEducationalTrainingID
		-- Delete any existing properties
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://vivoweb.org/ontology/core#trainingAtOrganization',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://vivoweb.org/ontology/core#degreeEarned',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://vivoweb.org/ontology/core#departmentOrSchool',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#endDate',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://www.w3.org/2000/01/rdf-schema#label',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		-- Add the label
		DECLARE @labelNodeID BIGINT
		EXEC [RDF.].GetStoreNode	@Value = @label, 
									@Language = NULL,
									@DataType = NULL,
									@SessionID = @SessionID, 
									@Error = @Error OUTPUT, 
									@NodeID = @labelNodeID OUTPUT
		EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://www.w3.org/2000/01/rdf-schema#label',
									@ObjectID = @labelNodeID,
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
	END
	ELSE
	BEGIN
		-- Create a new EducationalTraining
		EXEC [RDF.].GetStoreNode	@EntityClassURI = 'http://vivoweb.org/ontology/core#EducationalTraining',
									@Label = @label,
									@ForceNewEntity = 1,
									@SessionID = @SessionID, 
									@Error = @Error OUTPUT, 
									@NodeID = @NodeID OUTPUT
		-- Link the EducationalTraining to the educationalTrainingOf
		EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://vivoweb.org/ontology/core#educationalTrainingOf',
									@ObjectID = @educationalTrainingForID,
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		-- Link the educationalTrainingFor to the EducationalTraining
		EXEC [RDF.].GetStoreTriple	@SubjectID = @educationalTrainingForID,
									@PredicateURI = 'http://vivoweb.org/ontology/core#educationalTraining',
									@ObjectID = @NodeID,
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
	END

	-------------------------------------------------
	-- Handle optional properties
	-------------------------------------------------

	-- Add optional properties to the AwardReceipt
	IF (@NodeID IS NOT NULL) AND (@Error = 0)
	BEGIN
		IF @institutionNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://vivoweb.org/ontology/core#trainingAtOrganization',
										@ObjectID = @institutionNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
		IF @degreeNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://vivoweb.org/ontology/core#degreeEarned',
										@ObjectID = @degreeNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
		IF @schoolNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://vivoweb.org/ontology/core#departmentOrSchool',
										@ObjectID = @schoolNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
		IF @endDateNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#endDate',
										@ObjectID = @endDateNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
	END

END



GO


