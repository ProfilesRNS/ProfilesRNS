SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Framework.].[CreateInstallData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @x xml

	select @x = (
		select
			(
				select
					--------------------------------------------------------
					-- [Framework.]
					--------------------------------------------------------
					(
						select	'[Framework.].[Parameter]' 'Table/@Name',
								(
									select	ParameterID 'ParameterID', 
											Value 'Value'
									from [Framework.].[Parameter]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Framework.].[RestPath]' 'Table/@Name',
								(
									select	ApplicationName 'ApplicationName',
											Resolver 'Resolver'
									from [Framework.].[RestPath]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Framework.].[Job]' 'Table/@Name',
								(
									select	JobGroup 'JobGroup',
											Step 'Step',
											IsActive 'IsActive',
											Script 'Script'
									from [Framework.].[Job]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Framework.].[JobGroup]' 'Table/@Name',
								(
									SELECT  JobGroup 'JobGroup',
											Name 'Name',
											Type 'Type',
											Description 'Description'	
									from [Framework.].JobGroup
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [Ontology.]
					--------------------------------------------------------
					(
						select	'[Ontology.].[ClassGroup]' 'Table/@Name',
								(
									select	ClassGroupURI 'ClassGroupURI',
											SortOrder 'SortOrder',
											IsVisible 'IsVisible'
									from [Ontology.].[ClassGroup]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[ClassGroupClass]' 'Table/@Name',
								(
									select	ClassGroupURI 'ClassGroupURI',
											ClassURI 'ClassURI',
											SortOrder 'SortOrder'
									from [Ontology.].[ClassGroupClass]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[ClassProperty]' 'Table/@Name',
								(
									select	Class 'Class',
											NetworkProperty 'NetworkProperty',
											Property 'Property',
											IsDetail 'IsDetail',
											Limit 'Limit',
											IncludeDescription 'IncludeDescription',
											IncludeNetwork 'IncludeNetwork',
											SearchWeight 'SearchWeight',
											CustomDisplay 'CustomDisplay',
											CustomEdit 'CustomEdit',
											ViewSecurityGroup 'ViewSecurityGroup',
											EditSecurityGroup 'EditSecurityGroup',
											EditPermissionsSecurityGroup 'EditPermissionsSecurityGroup',
											EditExistingSecurityGroup 'EditExistingSecurityGroup',
											EditAddNewSecurityGroup 'EditAddNewSecurityGroup',
											EditAddExistingSecurityGroup 'EditAddExistingSecurityGroup',
											EditDeleteSecurityGroup 'EditDeleteSecurityGroup',
											MinCardinality 'MinCardinality',
											MaxCardinality 'MaxCardinality',
											CustomDisplayModule 'CustomDisplayModule',
											CustomEditModule 'CustomEditModule'
									from [Ontology.].ClassProperty
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[ClassPropertyCustom]' 'Table/@Name',
								(
									select	
											ClassPropertyCustomTypeID 'ClassPropertyCustomTypeID',
											Class 'Class',
											NetworkProperty 'NetworkProperty',
											Property 'Property',
											IncludeProperty 'IncludeProperty',
											Limit 'Limit',
											IncludeNetwork 'IncludeNetwork',
											IncludeDescription 'IncludeDescription',
											IsDetail 'IsDetail'
									from [Ontology.].ClassPropertyCustom
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[DataMap]' 'Table/@Name',
						
								(
									select  DataMapGroup 'DataMapGroup',
											IsAutoFeed 'IsAutoFeed',
											Graph 'Graph',
											Class 'Class',
											NetworkProperty 'NetworkProperty',
											Property 'Property',
											MapTable 'MapTable',
											sInternalType 'sInternalType',
											sInternalID 'sInternalID',
											cClass 'cClass',
											cInternalType 'cInternalType',
											cInternalID 'cInternalID',
											oClass 'oClass',
											oInternalType 'oInternalType',
											oInternalID 'oInternalID',
											oValue 'oValue',
											oDataType 'oDataType',
											oLanguage 'oLanguage',
											oStartDate 'oStartDate',
											oStartDatePrecision 'oStartDatePrecision',
											oEndDate 'oEndDate',
											oEndDatePrecision 'oEndDatePrecision',
											oObjectType 'oObjectType',
											Weight 'Weight',
											OrderBy 'OrderBy',
											ViewSecurityGroup 'ViewSecurityGroup',
											EditSecurityGroup 'EditSecurityGroup'
									from [Ontology.].[DataMap]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[Namespace]' 'Table/@Name',
								(
									select	URI 'URI',
											Prefix 'Prefix'
									from [Ontology.].[Namespace]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[PropertyGroup]' 'Table/@Name',
								(
									select	PropertyGroupURI 'PropertyGroupURI',
											SortOrder 'SortOrder',
											_PropertyGroupLabel '_PropertyGroupLabel'
									from [Ontology.].[PropertyGroup]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[PropertyGroupProperty]' 'Table/@Name',
								(
									select	PropertyGroupURI 'PropertyGroupURI',
											PropertyURI 'PropertyURI',
											SortOrder 'SortOrder',
											CustomDisplayModule 'CustomDisplayModule',
											CustomEditModule 'CustomEditModule',
											_TagName '_TagName',
											_PropertyLabel '_PropertyLabel'
									from [Ontology.].[PropertyGroupProperty]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [Ontology.Presentation]
					--------------------------------------------------------
					(
						select	'[Ontology.Presentation].[XML]' 'Table/@Name',
								(
									select	type 'type',
											subject 'subject',
											predicate 'predicate',
											object 'object',
											presentationXML 'presentationXML'
									from [Ontology.Presentation].[XML]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [RDF.Security]
					--------------------------------------------------------
					(
						select	'[RDF.Security].[Group]' 'Table/@Name',
								(
									select	SecurityGroupID 'SecurityGroupID',
											Label 'Label',
											HasSpecialViewAccess 'HasSpecialViewAccess',
											HasSpecialEditAccess 'HasSpecialEditAccess',
											Description 'Description'
									from [RDF.Security].[Group]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [Utility.NLP]
					--------------------------------------------------------
					(
						select	'[Utility.NLP].[ParsePorterStemming]' 'Table/@Name',
								(
									select	step 'Step',
											Ordering 'Ordering',
											phrase1 'phrase1',
											phrase2 'phrase2'
									from [Utility.NLP].ParsePorterStemming
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Utility.NLP].[StopWord]' 'Table/@Name',
								(
									select	word 'word',
											stem 'stem',
											scope 'scope'
									from [Utility.NLP].[StopWord]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Utility.NLP].[Thesaurus.Source]' 'Table/@Name',
								(
									select	Source 'Source',
											SourceName 'SourceName'
									from [Utility.NLP].[Thesaurus.Source]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [User.Session]
					--------------------------------------------------------
					(
						select	'[User.Session].Bot' 'Table/@Name',
							(
								SELECT UserAgent 'UserAgent' 
								  FROM [User.Session].Bot
				  					for xml path('Row'), type
			   				) 'Table'  
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [Direct.]
					--------------------------------------------------------
					(
						select	'[Direct.].[Sites]' 'Table/@Name',
							(
								SELECT SiteID 'SiteID',
										BootstrapURL 'BootstrapURL',
										SiteName 'SiteName',
										QueryURL 'QueryURL',
										SortOrder 'SortOrder',
										IsActive 'IsActive'  
								  FROM [Direct.].[Sites] 
			 					for xml path('Row'), type
					 		) 'Table'   
						for xml path(''), TYPE
					),
					--------------------------------------------------------
					-- [Profile.Data]
					--------------------------------------------------------
					(
						select	'[Profile.Data].[Publication.Type]' 'Table/@Name',
							(
								SELECT	pubidtype_id 'pubidtype_id',
										name 'name',
										sort_order 'sort_order'
								  FROM [Profile.Data].[Publication.Type]
				  					for xml path('Row'), type
			   				) 'Table'  
						for xml path(''), type
					),
					(
						select	'[Profile.Data].[Publication.MyPub.Category]' 'Table/@Name',
							(
								SELECT	HmsPubCategory 'HmsPubCategory',
										CategoryName 'CategoryName'
								  FROM [Profile.Data].[Publication.MyPub.Category]
				  					for xml path('Row'), type
							) 'Table'  
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [ORCID.]
					--------------------------------------------------------
					(
						select '[ORCID.].[REF_Permission]' 'Table/@Name',
						(
							SELECT	PermissionScope 'PermissionScope', 
									PermissionDescription 'PermissionDescription', 
									MethodAndRequest 'MethodAndRequest',
									SuccessMessage 'SuccessMessage',
									FailedMessage 'FailedMessage'
								from [ORCID.].[REF_Permission]
									for xml path('Row'), type
						) 'Table'  
						for xml path(''), type
					),
					(
						select '[ORCID.].[REF_PersonStatusType]' 'Table/@Name',
						(
							SELECT	StatusDescription 'StatusDescription'
								from [ORCID.].[REF_PersonStatusType]
									for xml path('Row'), type
						) 'Table'  
						for xml path(''), type
					),
					(
						select '[ORCID.].[REF_WorkExternalType]' 'Table/@Name',
						(
							SELECT	WorkExternalType 'WorkExternalType',
									WorkExternalDescription 'WorkExternalDescription'
								from [ORCID.].[REF_WorkExternalType]
									for xml path('Row'), type
						) 'Table'  
						for xml path(''), type
					),
					(
						select '[ORCID.].[REF_RecordStatus]' 'Table/@Name',
						(
							SELECT	RecordStatusID 'RecordStatusID',
									StatusDescription, 'StatusDescription'
								from [ORCID.].[REF_RecordStatus]
									for xml path('Row'), type
						) 'Table'  
						for xml path(''), type
					),
					(
						select '[ORCID.].[REF_Decision]' 'Table/@Name',
						(
							SELECT	DecisionDescription 'DecisionDescription',
									DecisionDescriptionLong 'DecisionDescriptionLong'
								from [ORCID.].[REF_Decision]
									for xml path('Row'), type
						) 'Table'  
						for xml path(''), type
					),
					(
						select '[ORCID.].[RecordLevelAuditType]' 'Table/@Name',
						(
							SELECT	AuditType 'AuditType'
								from [ORCID.].[RecordLevelAuditType]
									for xml path('Row'), type
						) 'Table'  
						for xml path(''), type
					),
					(
						select '[ORCID.].[DefaultORCIDDecisionIDMapping]' 'Table/@Name',
						(
							SELECT	SecurityGroupID 'SecurityGroupID',
									DefaultORCIDDecisionID 'DefaultORCIDDecisionID'
								from [ORCID.].[DefaultORCIDDecisionIDMapping]
									for xml path('Row'), type
						) 'Table'  
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [Profile.Module].[GenericRDF.Plugins]
					--------------------------------------------------------					
					(
						select '[ORNG.].[Apps]' 'Table/@Name',
						(
							SELECT	Name 'Name',
									EnabledForPerson 'EnabledForPerson',
									EnabledForGroup 'EnabledForGroup',
									Label 'Label',
									PropertyGroupURI 'PropertyGroupURI',
									[CustomDisplayModule] 'CustomDisplayModule',
									[CustomEditModule] 'CustomEditModule'
								from [Profile.Module].[GenericRDF.Plugins]
									for xml path('Row'), type
						) 'Table'  
						for xml path(''), type
					)					
				for xml path(''), type
			) 'Import'
		for xml path(''), type
	)

	/*	INSERT INTO [Profile.Module].[GenericRDF.Plugins]
		(
			[Name],
			[EnabledForPerson],
			[EnabledForGroup],
			[Label],
			[PropertyGroupURI],
			[CustomDisplayModule],
			[CustomEditModule]
		)
   SELECT	R.x.value('Name[1]','varchar(max)'),
			R.x.value('EnabledForPerson[1]','int'),
			R.x.value('EnabledForGroup[1]','int'),
			R.x.value('Label[1]','varchar(max)'),
			R.x.value('PropertyGroupURI[1]','varchar(max)'),
			R.x.value('CustomDisplayModule[1]','varchar(max)'),
			R.x.value('CustomEditModule[1]','varchar(max)')
	 FROM    (SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Profile.Module].[GenericRDF.Plugins]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )*/

	insert into [Framework.].[InstallData] (Data)
		select @x


   --Use to generate select lists for new tables
   --SELECT    c.name +  ' ''' + name + ''','
   --FROM sys.columns c  
   --WHERE object_id IN (SELECT object_id FROM sys.tables WHERE name = 'Publication.MyPub.Category')  

END
GO
