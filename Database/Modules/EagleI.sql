INSERT [Ontology.].[ClassProperty] 
	([ClassPropertyID], [Class], [NetworkProperty], 
	[Property], [IsDetail], [Limit], 
	[IncludeDescription], [IncludeNetwork], [SearchWeight], 
	[CustomDisplay], [CustomEdit], [ViewSecurityGroup], 
	[EditSecurityGroup], [EditPermissionsSecurityGroup], [EditExistingSecurityGroup], 
	[EditAddNewSecurityGroup], [EditAddExistingSecurityGroup], [EditDeleteSecurityGroup], 
	[MinCardinality], [MaxCardinality], [CustomDisplayModule], 
	[CustomEditModule], [_ClassNode], [_NetworkPropertyNode], 
	[_PropertyNode], [_TagName], [_PropertyLabel], 
	[_ObjectType], [_NumberOfNodes], [_NumberOfTriples]) 
	VALUES (1000, N'http://xmlns.com/foaf/0.1/Person', NULL, 
	N'http://profiles.catalyst.harvard.edu/ontology/prns#hasEagleIData', 1, 
	NULL, 0, 0, 
	0.5, 1, 1, 
	-1, -20, -20, 
	-40, -40, -40, 
	-40, 0, NULL,
	N'<Module ID="CustomViewEagleI" />', N'<Module ID="CustomEditEagleI" />', 67, 
	NULL, 8559043, N'prns:hasEagleIData', N'research resources', 
	1, 240, 240)

INSERT [Ontology.].[PropertyGroupProperty] 
	([PropertyGroupURI], [PropertyURI], [SortOrder], 
	[CustomDisplayModule], [CustomEditModule], [_PropertyGroupNode], 
	[_PropertyNode], [_TagName], [_PropertyLabel], 
	[_NumberOfNodes]) 
	VALUES (N'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupResearch', N'http://profiles.catalyst.harvard.edu/ontology/prns#hasEagleIData', 9, 
	NULL, NULL, 485, 
	8559043, N'prns:hasEagleIData', N'research resources', 
	0)

EXEC [Ontology.].[UpdateDerivedFields]
Exec [Ontology.].[CleanUp] @action='UpdateIDs'