/***************************************************************************
*                                                                          *
*                  ### ProcessDataMap Example Script ###                   *
*                                                                          *
*  Use this script with the ProfilesRNS_1.0.1_ArchitectureGuide.pdf file.  *
*                                                                          *
***************************************************************************/


-- ***************************************************************************
-- ***************************************************************************
-- ***  Extend the Ontology                                                ***
-- ***************************************************************************
-- ***************************************************************************

------------------------------------------------------------------------------
-- Define a namespace
------------------------------------------------------------------------------

-- Create your own namespace in the [Ontology.].[Namespace] table.
-- Let's assume the URI is 'http://myuniversity/ontology#' and the Prefix is 'myont'. 
-- Note that you can use this namespace for all future ontology extensions you make.

INSERT INTO [Ontology.].[Namespace] (URI, Prefix) 
	VALUES ('http://myuniversity/ontology#', 'myont')

------------------------------------------------------------------------------
-- Define a new class in the custom namespace
------------------------------------------------------------------------------

-- Create a new class of type myont:Car.
-- Do this by adding records to [Ontology.Import].[Triple] to indicate that a car is a class with name "Car".
-- Note that the first letter in class names is typically upper case.

INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('myont_1.0', 4, 'http://myuniversity/ontology#Car', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', 'http://www.w3.org/2002/07/owl#Class')
INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object) 
	VALUES ('myont_1.0', 4, 'http://myuniversity/ontology#Car', 'http://www.w3.org/2000/01/rdf-schema#label', 'Car')

-- Load the new class into the [RDF.] tables.

EXEC [RDF.Stage].[LoadTriplesFromOntology] @Truncate = 1
EXEC [RDF.Stage].[ProcessTriples]
EXEC [Ontology.].[UpdateDerivedFields]

-- Assign the new class to a ClassGroup.
-- For this example, let's say the ClassGroup is prns:ClassGroupResearch.
-- (If you were really doing this, you might want to create a new ClassGroup, such as myont:ClassGroupTransportation.)

INSERT INTO [Ontology.].[ClassGroupClass] (ClassGroupURI, ClassURI, SortOrder) 
	VALUES ('http://profiles.catalyst.harvard.edu/ontology/prns#ClassGroupResearch', 'http://myuniversity/ontology#Car',2)

------------------------------------------------------------------------------
-- Define properties for the class
------------------------------------------------------------------------------

-- Every entity should have a label.
-- Let's use the car's license plate as the label.
-- The property rdfs:label is already defined in the ontology. 
-- So, we only need to add it to the [Ontology.].[ClassProperty] table.
-- In this example, we are using 9999 as an arbitrary ClassPropertyID.
-- Don't forget to update derived ontology fields after editing an ontology table.

INSERT INTO [Ontology.].[ClassProperty] (ClassPropertyID, 
		Class, NetworkProperty, Property, 
		IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, 
		CustomDisplay, CustomEdit, ViewSecurityGroup, 
		EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, 
		MinCardinality, MaxCardinality, 
		CustomDisplayModule, CustomEditModule)
	VALUES (9999,
			'http:// myuniversity/ontology#Car', NULL, 'http://www.w3.org/2000/01/rdf-schema#label',
			0, NULL, 0, 0, 1,
			0, 0, -1,
			-40, -40, -40, -40, -40, -40,
			0, NULL,
			NULL, NULL)
EXEC [Ontology.].[UpdateDerivedFields]


-- Now we will create three new properties.
-- The first will be the make and model, which we will name myont:makeAndModel.
-- The next links people to cars, which we will name myont:drivesCar.
-- The third is the inverse relation that links cars to people, which we will call myont:drivenBy. 
-- To create new properties, use the [Ontology.].[AddProperty] stored procedure.
-- This procedure combines many individual steps needed to create a property.
-- There are many options for this procedure which are not illustrated here.
-- Note that the first letter in property names is typically lower case.

EXEC [Ontology.].[AddProperty]	@OWL = 'myont_1.0',
								@PropertyURI = 'http://myuniversity/ontology#makeAndModel',
								@PropertyName = 'makeAndModel',
								@ObjectType = 1,
								@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupIdentifiers',
								@ClassURI = 'http:// myuniversity/ontology#Car',
								@IsDetail = 0,
								@IncludeDescription = 0
EXEC [Ontology.].[AddProperty]	@OWL = 'myont_1.0', 
								@PropertyURI = 'http://myuniversity/ontology#drivesCar',
								@PropertyName = 'drives car',
								@ObjectType = 0,
								@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview', 
								@ClassURI = 'http://xmlns.com/foaf/0.1/Person',
								@IsDetail = 1,
								@IncludeDescription = 1
EXEC [Ontology.].[AddProperty]	@OWL = 'myont_1.0',
								@PropertyURI = 'http://myuniversity/ontology#drivenBy',
								@PropertyName = 'driven by',
								@ObjectType = 0,
								@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview',
								@ClassURI = 'http:// myuniversity/ontology#Car',
								@IsDetail = 0,
								@IncludeDescription = 1


-- ***************************************************************************
-- ***************************************************************************
-- ***  Import data into an extended schema table                          ***
-- ***************************************************************************
-- ***************************************************************************

-- Create a table to store the data about cars in the [Profile.Data] schema.

CREATE TABLE [Profile.Data].[Car] (
	CarID INT IDENTITY(0,1) PRIMARY KEY,
	PersonID INT,
	MakeAndModel VARCHAR(100),
	LicensePlate VARCHAR(20)
)

-- Insert some data into the [Profile.Data].[Car] table.

INSERT INTO [Profile.Data].[Car] (PersonID, LicensePlate, MakeAndModel)
	VALUES (1, 'ABC-123', 'Dodge Dakota')
INSERT INTO [Profile.Data].[Car] (PersonID, LicensePlate, MakeAndModel)
	VALUES (2, 'IJK-456', 'Honda Accord')
INSERT INTO [Profile.Data].[Car] (PersonID, LicensePlate, MakeAndModel)
	VALUES (3, 'XYZ-789', 'Cooper Mini')


-- ***************************************************************************
-- ***************************************************************************
-- ***  Create mappings from the new table to the ontology                 ***
-- ***************************************************************************
-- ***************************************************************************

-- Create a new node for each car.
-- Note that the property is null. No triple will be created.
-- Pick a large random DataMapID for now. We will change this later.

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1001, 1, 1, 1,
		'http://myuniversity/ontology#Car', NULL, NULL,
		'[Profile.Data].[Car]',
		'Car', 'CarID',
		NULL, NULL, NULL, NULL, NULL, NULL,
		0, 1, NULL, -1, -40)

-- Create triples that define the type, label, and makeAndModel of each car.
-- Here, a property value is specified.
-- The oObjectType is 0 for ObjectType properties (entities).
-- The oObjectType is 1 for DataType properties (literals).
-- All three of these properties use oValue/oDataType/oLanguage for the object.

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1002, 1, 1, 1,
		'http://myuniversity/ontology#Car', NULL, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
		'[Profile.Data].[Car]',
		'Car', 'CarID',
		NULL, NULL, NULL, '''http://myuniversity/ontology#Car''', NULL, NULL,
		0, 1, NULL, -1, -40)

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1003, 1, 1, 1,
		'http://myuniversity/ontology#Car', NULL, 'http://www.w3.org/2000/01/rdf-schema#label',
		'[Profile.Data].[Car]',
		'Car', 'CarID',
		NULL, NULL, NULL, 'LicensePlate', NULL, NULL,
		1, 1, NULL, -1, -40)

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1004, 1, 1, 1,
		'http://myuniversity/ontology#Car', NULL, 'http://myuniversity/ontology#makeAndModel',
		'[Profile.Data].[Car]',
		'Car', 'CarID',
		NULL, NULL, NULL, 'MakeAndModel', NULL, NULL,
		1, 1, NULL, -1, -40)

-- Create triples that link people and cars.
-- Both of these properties use oClass/oInternalType/oInternalID for the object.

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1005, 1, 1, 1,
		'http://myuniversity/ontology#Car', NULL, 'http://myuniversity/ontology#drivenBy',
		'[Profile.Data].[Car]',
		'Car', 'CarID',
		'http://xmlns.com/foaf/0.1/Person', 'Person', 'PersonID', NULL, NULL, NULL,
		0, 1, NULL, -1, -40)

INSERT INTO [Ontology.].[DataMap] (DataMapID, DataMapGroup, IsAutoFeed, Graph, 
		Class, NetworkProperty, Property, 
		MapTable, 
		sInternalType, sInternalID, 
		oClass, oInternalType, oInternalID, oValue, oDataType, oLanguage, 
		oObjectType, Weight, OrderBy, ViewSecurityGroup, EditSecurityGroup)
	VALUES (1006, 1, 1, 1,
		'http://xmlns.com/foaf/0.1/Person', NULL, 'http://myuniversity/ontology#drivesCar',
		'[Profile.Data].[Car]',
		'Person', 'PersonID',
		'http://myuniversity/ontology#Car', 'Car', 'CarID', NULL, NULL, NULL,
		0, 1, NULL, -1, -40)

-- Update derived fields in the [Ontology.].[DataMap]

EXEC [Ontology.].UpdateDerivedFields


-- ***************************************************************************
-- ***************************************************************************
-- ***  Run ProcessDataMap to generate the RDF                             ***
-- ***************************************************************************
-- ***************************************************************************

-- Optionally, run this one time now manually to test the mappings.
-- It will be run automatically by the nightly jobs to synch the [Profile.Data].[Car] table with the RDF.

EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1001, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1002, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1003, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1004, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1005, @ShowCounts = 1
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = 1006, @ShowCounts = 1

-- Get the RDF for PersonID = 1 to confirm that the car has been added.

DECLARE @PersonNodeID BIGINT
SELECT @PersonNodeID = NodeID
	FROM [RDF.Stage].[InternalNodeMap]
	WHERE Class = 'http://xmlns.com/foaf/0.1/Person' AND InternalType = 'Person' AND InternalID = '1'
EXEC [RDF.].[GetDataRDF] @subject = @PersonNodeID, @showDetails = 1, @expand = 1

-- CLEANUP...
-- The records in [Ontology.].[DataMap] must be sorted so that nodes 
-- are created before the triples that use them. The [Ontology.].[CleanUp]
-- stored procedure can automatically reassign DataMapIDs so that the
-- records are sorted correctly.

EXEC [Ontology.].[CleanUp] @Action = 'UpdateIDs'

