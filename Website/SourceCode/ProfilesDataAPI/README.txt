Profiles Data API



Installation:

Run the Profile.Module.ProfilesDataAPI.GetPersonData.sql query against your profiles database.

Publish the code in Visual Studio 2017. Copy your published code to a folder on your web server.

Create a new application in IIS for the API and set the connection string in the web.config file (these steps should be the same as described in "Installing the APIs" in the ProfilesRNS Install guide. 



Usage:

The profiles data API is a restful API for extracting data from profiles. Unlike prior APIs the Profiles Data API allows extraction of data for multiple profiles at a time. Profiles to be extracted can be selected by keyword, affiliation or personID. 

The following Restful URIs are valid:

getPeople/Institution/{inst}
getPeople/Institution/{inst}/Department/{dept}
getPeople/Institution/{inst}/Department/{dept}/Division/{div}
getPeople/Institution/{inst}/Count/{count:int}/Offset/{offset:int}
getPeople/Institution/{inst}/Department/{dept}/Count/{count:int}/Offset/{offset:int}
getPeople/Institution/{inst}/Department/{dept}/Division/{div}/Count/{count:int}/Offset/{offset:int}
getPeople/Keyword/{keyword}
getPeople/Keyword/{keyword}/Count/{count:int}/Offset/{offset:int}
getPeople/Keyword/{keyword}/Institution/{inst}
getPeople/Keyword/{keyword}/Institution/{inst}/Department/{dept}
getPeople/Keyword/{keyword}/Institution/{inst}/Department/{dept}/Division/{div}
getPeople/Keyword/{keyword}/Institution/{inst}/Count/{count:int}/Offset/{offset:int}
getPeople/Keyword/{keyword}/Institution/{inst}/Department/{dept}/Count/{count:int}/Offset/{offset:int}
getPeople/Keyword/{keyword}/Institution/{inst}/Department/{dept}/Division/{div}/Count/{count:int}/Offset/{offset:int}
getPeople/PersonIDs/{personIDs}

inst: Can be either the institution abbreviation or the institution name 
dept: Department Name
div: Division Name
Count: The number of profiles to return, default is 100 for affiliation requests, and 15 for keyword requests. For performance reasons keyword requests have a maximum count of 100 people.
Offset: Offset for the results, combine with count to page through results.
PersonIDs: Comma seperated list of person IDs

The results are returned in an XML format similar to the Profiles BETA xml. A PersonList node contains a list of Person nodes. These nodes contain Name, Address, Affiliation, Overview, and Publication data.