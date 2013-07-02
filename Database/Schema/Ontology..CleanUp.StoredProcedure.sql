SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.].[CleanUp]
	@Action varchar(100) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- This stored procedure contains code to help developers manage
	-- content in several ontology tables.
	
	-------------------------------------------------------------
	-- View the contents of the tables
	-------------------------------------------------------------

	if @Action = 'ShowTables'
	begin
		select * from [Ontology.].ClassGroup
		select * from [Ontology.].ClassGroupClass
		select * from [Ontology.].ClassProperty
		select * from [Ontology.].DataMap
		select * from [Ontology.].Namespace
		select * from [Ontology.].PropertyGroup
		select * from [Ontology.].PropertyGroupProperty
		select * from [Ontology.Import].[Triple]
		select * from [Ontology.Import].OWL
		select * from [Ontology.Presentation].General
	end
	
	-------------------------------------------------------------
	-- Insert missing records, use default values
	-------------------------------------------------------------

	if @Action = 'AddMissingRecords'
	begin

		insert into [Ontology.].ClassProperty (ClassPropertyID, Class, NetworkProperty, Property, IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, MinCardinality, MaxCardinality, CustomEditModule)
			select ClassPropertyID, Class, NetworkProperty, Property, IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, MinCardinality, MaxCardinality, CustomEditModule
				from [Ontology.].vwMissingClassProperty

		insert into [Ontology.].PropertyGroupProperty (PropertyGroupURI, PropertyURI, SortOrder)
			select PropertyGroupURI, PropertyURI, SortOrder
				from [Ontology.].vwMissingPropertyGroupProperty

	end

	-------------------------------------------------------------
	-- Update IDs using the default sort order
	-------------------------------------------------------------

	if @Action = 'UpdateIDs'
	begin
		
		update x
			set x.ClassPropertyID = y.k
			from [Ontology.].ClassProperty x, (
				select *, row_number() over (order by (case when NetworkProperty is null then 0 else 1 end), Class, NetworkProperty, IsDetail, IncludeNetwork, Property) k
					from [Ontology.].ClassProperty
			) y
			where x.Class = y.Class and x.Property = y.Property
				and ((x.NetworkProperty is null and y.NetworkProperty is null) or (x.NetworkProperty = y.NetworkProperty))

		update x
			set x.DataMapID = y.k
			from [Ontology.].DataMap x, (
				select *, row_number() over (order by	(case when Property is null then 0 when NetworkProperty is null then 1 else 2 end), 
														(case when Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User' then 0 else 1 end), 
														Class,
														(case when NetworkProperty = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' then 0 when NetworkProperty = 'http://www.w3.org/2000/01/rdf-schema#label' then 1 else 2 end),
														NetworkProperty, 
														(case when Property = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' then 0 when Property = 'http://www.w3.org/2000/01/rdf-schema#label' then 1 else 2 end),
														MapTable,
														Property
														) k
					from [Ontology.].DataMap
			) y
			where x.Class = y.Class and x.sInternalType = y.sInternalType
				and ((x.Property is null and y.Property is null) or (x.Property = y.Property))
				and ((x.NetworkProperty is null and y.NetworkProperty is null) or (x.NetworkProperty = y.NetworkProperty))

		update x
			set x.PresentationID = y.k
			from [Ontology.Presentation].General x, (
				select *, row_number() over (order by	(case when Type = 'E' then 1 else 0 end), 
														Subject,
														(case Type when 'P' then 1 when 'N' then 2 else 3 end),
														Predicate, Object
														) k
					from [Ontology.Presentation].General
			) y
			where x.Type = y.Type
				and ((x.Subject is null and y.Subject is null) or (x.Subject = y.Subject))
				and ((x.Predicate is null and y.Predicate is null) or (x.Predicate = y.Predicate))
				and ((x.Object is null and y.Object is null) or (x.Object = y.Object))	

	end

	-------------------------------------------------------------
	-- Update derived and calculated fields
	-------------------------------------------------------------

	if @Action = 'UpdateFields'
	begin
		exec [Ontology.].UpdateDerivedFields
		exec [Ontology.].UpdateCounts
	end
    
END
GO
