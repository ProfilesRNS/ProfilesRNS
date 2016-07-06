SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[CustomEditEducationalTraining.StoreItem]
@ExistingEducationalTrainingID BIGINT=NULL, @ExistingEducationalTrainingURI VARCHAR (400)=NULL, @educationalTrainingForID BIGINT=NULL, @educationalTrainingForURI BIGINT=NULL, 
@institution VARCHAR (MAX), @location VARCHAR (MAX),  @degree VARCHAR (MAX)=NULL,
@endDate VARCHAR (MAX)=NULL, @fieldOfStudy VARCHAR (MAX), @SessionID UNIQUEIDENTIFIER=NULL, @Error BIT=NULL OUTPUT, @NodeID BIGINT=NULL OUTPUT
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
	IF ((@ExistingEducationalTrainingID IS NULL) AND (@educationalTrainingForID IS NULL))
	BEGIN
		SELECT @Error = 1
		RETURN
	END

	-- Convert properties to NodeIDs
	DECLARE @institutionNodeID BIGINT
	DECLARE @locationNodeID BIGINT
	DECLARE @degreeNodeID BIGINT
	DECLARE @endDateNodeID BIGINT
	DECLARE @fieldOfStudyNodeID BIGINT
	
	SELECT @institutionNodeID = NULL, @locationNodeID = NULL, @degreeNodeID = NULL, @endDateNodeID = NULL, @fieldOfStudyNodeID = NULL
	
	IF IsNull(@institution,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @institution, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @institutionNodeID OUTPUT
	IF IsNull(@location,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @location, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @locationNodeID OUTPUT
	IF IsNull(@degree,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @degree, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @degreeNodeID OUTPUT
	IF IsNull(@endDate,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @endDate, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @endDateNodeID OUTPUT
	IF IsNull(@fieldOfStudy,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @fieldOfStudy, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @fieldOfStudyNodeID OUTPUT


	DECLARE @label nvarchar(max)
	select @label = isnull(@institution, '') + ', ' + isnull(@fieldOfStudy, '')

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
									@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#trainingAtOrganization',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#trainingLocation',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://vivoweb.org/ontology/core#degreeEarned',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#endDate',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://vivoweb.org/ontology/core#majorField',
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
										@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#trainingAtOrganization',
										@ObjectID = @institutionNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
		IF @locationNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#trainingLocation',
										@ObjectID = @locationNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
		IF @degreeNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://vivoweb.org/ontology/core#degreeEarned',
										@ObjectID = @degreeNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
		IF @endDateNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#endDate',
										@ObjectID = @endDateNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
		IF @fieldOfStudyNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://vivoweb.org/ontology/core#majorField',
										@ObjectID = @fieldOfStudyNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
	END

END
GO
