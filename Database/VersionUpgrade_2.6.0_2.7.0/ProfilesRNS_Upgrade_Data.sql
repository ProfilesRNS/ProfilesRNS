/*

Run this script on:

	Profiles RNS Version 2.6.0

to update its data to:

	Profiles RNS Version 2.7.0

*** You are recommended to back up your database before running this script!

*** You should review each step of this script to ensure that it will not overwrite any customizations you have made to ProfilesRNS.

*** Make sure you run the ProfilesRNS_Upgrade_Schema.sql file before running this file.
 
*/

update [Ontology.Presentation].[XML] set  PresentationXML =  
        '<Presentation PresentationClass="profile">
          <PageOptions Columns="3" />
          <WindowName>{{{rdf:RDF[1]/rdf:Description[1]/rdfs:label[1]}}}</WindowName>
          <PageColumns>3</PageColumns>
          <PageTitle>{{{rdf:RDF[1]/rdf:Description[1]/rdfs:label[1]}}}</PageTitle>
          <PageBackLinkName />
          <PageBackLinkURL />
          <PageSubTitle />
          <PageDescription />
          <PanelTabType>Fixed</PanelTabType>
          <PanelList>
            <Panel Type="active">
              <Module ID="MiniSearch" />
              <Module ID="MainMenu" />
            </Panel>
            <Panel Type="main" TabSort="0" TabType="Default">
              <Module ID="CustomViewConceptMeshInfo">
                <ParamList />
              </Module>
            </Panel>
            <Panel Type="main" TabSort="0" TabType="Default">
              <Module ID="CustomViewConceptPublication">
                <ParamList>
                  <Param Name="TimelineCaption">This graph shows the total number of publications written about "@ConceptName" by people in this website by year, and whether "@ConceptName" was a major or minor topic of these publications. &lt;!--In all years combined, a total of [[[TODO:PUBLICATION COUNT]]] publications were written by people in Profiles.--&gt;</Param>
                  <Param Name="CitedCaption">Below are the publications written about "@ConceptName" that have been cited the most by articles in Pubmed Central.</Param>
                  <Param Name="NewestCaption">Below are the most recent publications written about "@ConceptName" by people in Profiles.</Param>
                  <Param Name="OldestCaption">Below are the earliest publications written about "@ConceptName" by people in Profiles.</Param>
                </ParamList>
              </Module>
            </Panel>
            <Panel Type="passive">
              <Module ID="PassiveList">
                <ParamList>
                  <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
                  <Param Name="InfoCaption">People</Param>
                  <Param Name="Description">People who have written about this concept.</Param>
                  <Param Name="MaxDisplay">5</Param>
                  <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:researchAreaOf/@rdf:resource]</Param>
                  <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
                  <Param Name="ItemText" />
                  <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
                  <Param Name="MoreURL">/search/default.aspx?searchtype=people&amp;searchfor={{{rdf:RDF/rdf:Description/rdfs:label}}}&amp;classuri=http://xmlns.com/foaf/0.1/Person&amp;erpage=15&amp;offset=0&amp;exactPhrase=true</Param>
                  <Param Name="MoreText">See all people</Param>
                </ParamList>
              </Module>
              <Module ID="CustomViewConceptSimilarMesh">
                <ParamList>
                  <Param Name="InfoCaption">Similar Concepts</Param>
                  <Param Name="Description">People who have written about this concept.</Param>
                </ParamList>
              </Module>
              <Module ID="CustomViewConceptTopJournal">
                <ParamList>
                  <Param Name="InfoCaption">Top Journals</Param>
                  <Param Name="Description">Top journals in which articles about this concept have been published.</Param>
                </ParamList>
              </Module>
            </Panel>
          </PanelList>
        </Presentation>'
		 where Type= 'P' and  Subject= 'http://www.w3.org/2004/02/skos/core#Concept' and  Predicate is null and  Object is null
		 
--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
--*****
--***** Finalize changes
--*****
--*****************************************************************************************
--*****************************************************************************************
--*****************************************************************************************
  
-- The next two rows update fields such as nodeID values, and table identifiers. This should not affect any existing customizations
EXEC [Ontology.].[UpdateDerivedFields]
EXEC [Ontology.].[UpdateCounts]
EXEC [Ontology.].CleanUp @action='UpdateIDs'

-- Update the RDF tables and cache
EXEC [Framework.].[RunJobGroup] @JobGroup = 3


GO