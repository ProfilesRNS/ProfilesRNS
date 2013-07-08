SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[CustomEditAwardOrHonor.StoreItem]
@ExistingAwardReceiptID BIGINT=NULL, @ExistingAwardReceiptURI VARCHAR (400)=NULL, @awardOrHonorForID BIGINT=NULL, @awardOrHonorForURI BIGINT=NULL, @label VARCHAR (MAX), @awardConferredBy VARCHAR (MAX)=NULL, @startDate VARCHAR (MAX)=NULL, @endDate VARCHAR (MAX)=NULL, @SessionID UNIQUEIDENTIFIER=NULL, @Error BIT=NULL OUTPUT, @NodeID BIGINT=NULL OUTPUT
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
 	IF (@ExistingAwardReceiptID IS NULL) AND (@ExistingAwardReceiptURI IS NOT NULL)
		SELECT @ExistingAwardReceiptID = [RDF.].fnURI2NodeID(@ExistingAwardReceiptURI)
 	IF (@awardOrHonorForID IS NULL) AND (@awardOrHonorForURI IS NOT NULL)
		SELECT @awardOrHonorForID = [RDF.].fnURI2NodeID(@awardOrHonorForURI)

	-- Check that some operation will be performed
	IF ((@ExistingAwardReceiptID IS NULL) AND (@awardOrHonorForID IS NULL)) OR (IsNull(@label,'') = '')
	BEGIN
		SELECT @Error = 1
		RETURN
	END

	-- Convert properties to NodeIDs
	DECLARE @awardConferredByNodeID BIGINT
	DECLARE @startDateNodeID BIGINT
	DECLARE @endDateNodeID BIGINT
	
	SELECT @awardConferredByNodeID = NULL, @startDateNodeID = NULL, @endDateNodeID = NULL
	
	IF IsNull(@awardConferredBy,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @awardConferredBy, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @awardConferredByNodeID OUTPUT
	IF IsNull(@startDate,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @startDate, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @startDateNodeID OUTPUT
	IF IsNull(@endDate,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @endDate, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @endDateNodeID OUTPUT

	-------------------------------------------------
	-- Handle required nodes and properties
	-------------------------------------------------

	-- Get an AwardReceipt with just a label
	IF (@ExistingAwardReceiptID IS NOT NULL)
	BEGIN
		-- The AwardReceipt NodeID is the ExistingAwardReceipt
		SELECT @NodeID = @ExistingAwardReceiptID
		-- Delete any existing properties
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#awardConferredBy',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#startDate',
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
		-- Create a new AwardReceipt
		EXEC [RDF.].GetStoreNode	@EntityClassURI = 'http://vivoweb.org/ontology/core#AwardReceipt',
									@Label = @label,
									@ForceNewEntity = 1,
									@SessionID = @SessionID, 
									@Error = @Error OUTPUT, 
									@NodeID = @NodeID OUTPUT
		-- Link the AwardReceipt to the awardOrHonorFor
		EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://vivoweb.org/ontology/core#awardOrHonorFor',
									@ObjectID = @awardOrHonorForID,
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		-- Link the awardOrHonorFor to the AwardReceipt
		EXEC [RDF.].GetStoreTriple	@SubjectID = @awardOrHonorForID,
									@PredicateURI = 'http://vivoweb.org/ontology/core#awardOrHonor',
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
		IF @awardConferredByNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#awardConferredBy',
										@ObjectID = @awardConferredByNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
		IF @startDateNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#startDate',
										@ObjectID = @startDateNodeID,
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
