SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.Import].[ConvertTriple2OWL]
	@OWL varchar(50),
	@Graph bigint = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- This stored procedure is currently only intended for use with @OWL = 'PRNS_1.0' (and @Graph = 3)

	select t.subject, n.prefix+':'+right(t.predicate,len(t.predicate)-len(n.uri)) predicate, t.object
		into #t
		from [Ontology.Import].Triple t, [Ontology.].Namespace n
		where t.OWL = @OWL and t.Predicate like n.URI+'%'
		order by t.subject, predicate, t.object

	declare @z as varchar(max)

	select @z =
		(select 
				'<rdf:Description rdf:about="'+subject+'">'
				+(
					select '<'+v.predicate+' rdf:resource="'+v.object+'"/>' 
					from #t v 
					where v.subject = t.subject 
					order by v.predicate, v.object
					for xml path(''), type
				).value('(./text())[1]','nvarchar(max)')
				+'</rdf:Description>'
			from (select distinct subject from #t) t
			order by t.subject
			for xml path(''), type
		).value('(./text())[1]','nvarchar(max)')

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + @z + '</rdf:RDF>'

	-- select cast(@x as xml) RDF
	BEGIN TRY
		begin transaction

			delete 
				from [Ontology.Import].[OWL] 
				where Name = @OWL

			insert into [Ontology.Import].[OWL] (Name, Data, Graph)
				select @OWL, cast(@x as xml), @Graph

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


	-- select * from [Ontology.Import].[OWL]

END
GO
