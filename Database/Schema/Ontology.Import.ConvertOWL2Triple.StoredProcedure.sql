SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.Import].[ConvertOWL2Triple]
	@OWL varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY 
    begin transaction

		delete 
			from [Ontology.Import].Triple
			where OWL = @OWL

		insert into [Ontology.Import].Triple (OWL, Graph, Subject, Predicate, Object)
			select OWL, Graph, Subject, Predicate, Object 
			from [Ontology.Import].vwOwlTriple
			where OWL = @OWL

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

	-- select * from [Ontology.Import].Triple
	-- select * from [Ontology.Import].vwOwlTriple
	-- exec [Ontology.Import].[ConvertOWL2Triple] @OWL = 'VIVO_1.4'

END
GO
