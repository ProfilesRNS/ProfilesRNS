SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[CustomViewPersonSameDepartment.GetList]
	@NodeID BIGINT,
	@SessionID UNIQUEIDENTIFIER = NULL
AS
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	declare @labelID bigint
	select @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')

	declare @baseURI nvarchar(400)
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'

	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID

	declare @i nvarchar(500)
	declare @d nvarchar(500)
	declare @v nvarchar(500)

	select @i = institutionname, @d = departmentname, @v = divisionfullname
		from [Profile.Cache].[Person]
		where personid = @personid

	declare @InstitutionURI varchar(400)
	declare @DepartmentURI varchar(400)

	select	@InstitutionURI = @baseURI + cast(j.NodeID as varchar(50)),
			@DepartmentURI = @baseURI + cast(e.NodeID as varchar(50))
		from [Profile.Data].[Organization.Institution] i,
			[Profile.Data].[Organization.Department] d,
			[RDF.Stage].[InternalNodeMap] j,
			[RDF.Stage].[InternalNodeMap] e
		where i.InstitutionName = @i and d.DepartmentName = @d
			and j.InternalType = 'Institution' and j.Class = 'http://xmlns.com/foaf/0.1/Organization' and j.InternalID = cast(i.InstitutionID as varchar(50))
			and e.InternalType = 'Department' and e.Class = 'http://xmlns.com/foaf/0.1/Organization' and e.InternalID = cast(d.DepartmentID as varchar(50))

	declare @x xml

	;with a as (
		select a.personid, 
			max(case when a.divisionname = @v then 1 else 0 end) v,
			max(case when s.numpublications > 0 then 1 else 0 end) p
			--row_number() over (order by newid()) k
		from [Profile.Cache].[Person.Affiliation] a, [Profile.Cache].[Person] s
		where a.personid <> @personid
			and a.instititutionname = @i and a.departmentname = @d
			and a.personid = s.personid
		group by a.personid
	), b as (
		select top(5) *
		from a
		order by v desc, p desc, newid()
	), c as (
		select m.NodeID, n.Value URI, l.Value Label
		from b
			inner join [RDF.Stage].[InternalNodeMap] m
				on m.InternalType = 'Person' and m.Class = 'http://xmlns.com/foaf/0.1/Person' and m.InternalID = cast(b.personid as varchar(50))
			inner join [RDF.].[Node] n
				on n.NodeID = m.NodeID and n.ViewSecurityGroup = -1
			inner join [RDF.].[Triple] t
				on t.subject = n.NodeID and t.predicate = @labelID and t.ViewSecurityGroup = -1
			inner join [RDF.].[Node] l
				on l.NodeID = t.object and l.ViewSecurityGroup = -1
	)
	select @x = (
			select	(select count(*) from a) "NumberOfConnections",
					@InstitutionURI "InstitutionURI",
					@DepartmentURI "DepartmentURI",
					(select	NodeID "Connection/@NodeID",
							URI "Connection/@URI",
							Label "Connection"
						from c
						order by Label
						for xml path(''), type
					)
			for xml path('Network'), type
		)

	select @x XML

END
GO
