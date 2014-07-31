update [Ontology.].ClassProperty
	set IsDetail = 0,
		CustomDisplay = 1,
		CustomEdit = 1,
		EditSecurityGroup = -20,
		EditPermissionsSecurityGroup = -20,
		EditExistingSecurityGroup = -20,
		EditAddNewSecurityGroup = -20,
		MaxCardinality = 1,
		CustomEditModule = '<Module ID="CustomEditORCID" />'
	where class = 'http://xmlns.com/foaf/0.1/Person'
		and property = 'http://vivoweb.org/ontology/core#orcidId'