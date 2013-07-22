SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[Support.GetHTML]
	@NodeID BIGINT,
	@EditMode BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @str VARCHAR(MAX)

	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
			AND m.Class = 'http://xmlns.com/foaf/0.1/Person' AND m.InternalType = 'Person'

	IF @PersonID IS NOT NULL
	BEGIN

		if @editMode = 0
			set @str = 'Local representatives can answer questions about the Profiles website or help with editing a profile or issues with profile data. For assistance with this profile:'
		else
			set @str = 'Local representatives can help you modify your basic information above, including title and contact information, or answer general questions about Profiles. For assistance with this profile:'

		select @str = @str + (
				select ' '+s.html
					from [Profile.Module].[Support.HTML] s, (
						select m.SupportID, min(SortOrder) x 
							from [Profile.Cache].[Person.Affiliation] a, [Profile.Module].[Support.Map] m
							where a.instititutionname = m.institution and (a.departmentname = m.department or m.department = '')
								and a.PersonID = @PersonID
							group by m.SupportID
					) t
					where s.SupportID = t.SupportID
					order by t.x
					for xml path(''), type
			).value('(./text())[1]','nvarchar(max)')

	END

	SELECT @str HTML WHERE @str IS NOT NULL

END
GO
