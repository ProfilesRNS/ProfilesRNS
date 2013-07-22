SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [RDF.Stage].[LoadTriplesFromOntology]
	@OWL NVARCHAR(100) = NULL,
	@Truncate BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	if @Truncate = 1
		truncate table [RDF.Stage].Triple
 
	insert into [RDF.Stage].Triple (
			sURI,sViewSecurityGroup,sEditSecurityGroup,
			pProperty,pViewSecurityGroup,pEditSecurityGroup,
			oValue,oObjectType,oViewSecurityGroup,oEditSecurityGroup,
			tViewSecurityGroup,Weight,SortOrder,Graph)
		select	Subject, -1, -50,
				Predicate, -1, -50,
				Object, (case when Object like 'http%' then 0 else 1 end), -1, -50,
				-1, 1, row_number() over (partition by Subject, Predicate order by Object),
				Graph
		from [Ontology.Import].Triple
		where OWL = IsNull(@OWL,OWL)
 
END
GO
