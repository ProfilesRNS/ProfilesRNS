-- 1.0.3

EXEC(N'UPDATE [Ontology.Presentation].[XML] SET [PresentationXML]=CONVERT(xml,N''<Presentation PresentationClass="profile">
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
                  <Param Name="TimelineCaption">This graph shows the total number of publications written about "@ConceptName" by people in UCSF Profiles by year, and whether "@ConceptName" was a major or minor topic of these publication. &lt;!--In all years combined, a total of [[[TODO:PUBLICATION COUNT]]] publications were written by people in Profiles.--&gt;</Param>
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
                  <Param Name="MoreURL">/search/default.aspx?searchtype=people&amp;searchfor={{{rdf:RDF/rdf:Description/rdfs:label}}}&amp;classuri=http://xmlns.com/foaf/0.1/Person&amp;erpage=15&amp;offset=0 </Param>
                  <Param Name="MoreText">See all people</Param>
                </ParamList>
              </Module>
              <Module ID="CustomViewConceptSimilarMesh">
                <ParamList>
                  <Param Name="InfoCaption">Related Concepts</Param>
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
        </Presentation>'',1) WHERE [PresentationID]=4')
	  
-- remove physical neighbors and change Concepts to Related Concepts, Similar People to Related Authors
-- 5
EXEC(N'UPDATE [Ontology.Presentation].[XML] SET [PresentationXML]=CONVERT(xml,N''<Presentation PresentationClass="profile">
  <PageOptions Columns="3" />
  <WindowName>{{{rdf:RDF[1]/rdf:Description[1]/foaf:firstName[1]}}} {{{rdf:RDF[1]/rdf:Description[1]/foaf:lastName[1]}}}</WindowName>
  <PageColumns>3</PageColumns>
  <PageTitle>{{{rdf:RDF[1]/rdf:Description[1]/prns:fullName[1]}}}</PageTitle>
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
    <Panel Type="main" TabType="Fixed">
      <Module ID="CustomViewPersonGeneralInfo" />
      <Module ID="ApplyXSLT">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="XSLTPath">~/profile/XSLT/OtherPositions.xslt</Param>
        </ParamList>
      </Module>
      <Module ID="PropertyList">
        <ParamList />
      </Module>
      <Module ID="HRFooter" />
    </Panel>
    <Panel Type="passive">
      <Module ID="PassiveHeader">
        <ParamList>
          <Param Name="DisplayRule">rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections</Param>
          <Param Name="DisplayRule">rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections</Param>
          <Param Name="DisplayRule">rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Related Concepts</Param>
          <Param Name="Description">Derived automatically from this person''''s publications.</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:hasResearchArea/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) concept(s)</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="InfoCaption">Co-Authors</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="Description">People in Profiles who have published with this person.</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:coAuthorOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="InfoCaption">Related Authors</Param>
          <Param Name="Description">People who share similar concepts with this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:similarTo/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="CustomViewPersonSameDepartment" />
      <Module ID="Gadgets">
        <ParamList>
          <Param Name="HTML">
            <div id="gadgets-tools" class="gadgets-gadget-parent" />
          </Param>
        </ParamList>
      </Module>
      <!--Module ID="PassiveList">
        <ParamList>
          <Param Name="InfoCaption">Physical Neighbors</Param>
          <Param Name="Description">People whose addresses are nearby this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:physicalNeighborOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
        </ParamList>
      </Module-->
    </Panel>
  </PanelList>
  <ExpandRDFList>
    <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
  </ExpandRDFList>
</Presentation>'',1) WHERE [PresentationID]=5')

-- remove physical neighbors  
-- 6
EXEC(N'UPDATE [Ontology.Presentation].[XML] SET [PresentationXML]=CONVERT(xml,N''<Presentation PresentationClass="network">
  <PageOptions Columns="3" />
  <WindowName>{{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}</WindowName>
  <PageColumns>3</PageColumns>
  <PageTitle>{{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}</PageTitle>
  <PageBackLinkName>Back to Profile</PageBackLinkName>
  <PageBackLinkURL>{{{//rdf:RDF/rdf:Description/rdf:subject/@rdf:resource}}}</PageBackLinkURL>
  <PageSubTitle>Co-Authors ({{{//rdf:RDF/rdf:Description/prns:numberOfConnections}}})</PageSubTitle>
  <PageDescription>Co-Authors are people in Profiles who have published together.</PageDescription>
  <PanelTabType>Default</PanelTabType>
  <PanelList>
    <Panel Type="active">
      <Module ID="MiniSearch" />
      <Module ID="MainMenu" />
    </Panel>
    <Panel Type="main" TabSort="0" TabType="Default" Alias="list" Name="List">
      <Module ID="NetworkList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="BulletType">disc</Param>
          <Param Name="Columns">2</Param>
          <Param Name="NetworkListNode">rdf:RDF/rdf:Description[@rdf:about= ../rdf:Description[1]/prns:hasConnection/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdf:object/@rdf:resource}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/rdf:object/@rdf:resource}}}</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="1" Alias="map" Name="Map" DisplayRule="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/prns:latitude">
      <Module ID="NetworkMap">
        <ParamList>
          <Param Name="MapType">CoAuthor</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="2" Alias="radial" Name="Radial">
      <Module ID="NetworkRadial" />
    </Panel>
    <Panel Type="main" TabSort="3" Alias="cluster" Name="Cluster">
      <Module ID="NetworkCluster" />
    </Panel>
    <Panel Type="main" TabSort="4" Alias="timeline" Name="Timeline">
      <Module ID="NetworkTimeline">
        <ParamList>
          <Param Name="TimelineType">CoAuthor</Param>
          <Param Name="InfoCaption">The timeline below shows the dates (blue tick marks) of publications @SubjectName co-authored with other people in Profiles. The average publication date for each co-author is shown as a red circle, illustrating changes in the people that @SubjectName has worked with over time.</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="5" Alias="details" Name="Details">
      <Module ID="ApplyXSLT">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="XSLTPath">~/profile/XSLT/CoAuthorDetail.xslt</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="passive">
      <Module ID="PassiveHeader">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Related Concepts</Param>
          <Param Name="Description">Derived automatically from this person''''s publications.</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:hasResearchArea/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) concept(s)</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Co-Authors</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="Description">People in Profiles who have published with this person.</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:coAuthorOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Related Authors</Param>
          <Param Name="Description">People who share similar concepts with this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:similarTo/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="CustomViewPersonSameDepartment" />
      <!--Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Physical Neighbors</Param>
          <Param Name="Description">People whose addresses are nearby this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:physicalNeighborOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
        </ParamList>
      </Module-->
    </Panel>
  </PanelList>
</Presentation>'',1) WHERE [PresentationID]=6')
	  
EXEC(N'UPDATE [Ontology.Presentation].[XML] SET [PresentationXML]=CONVERT(xml,N''<Presentation PresentationClass="network">
  <PageOptions Columns="3" />
  <WindowName>{{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}</WindowName>
  <PageColumns>3</PageColumns>
  <PageTitle>{{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{rdf:RDF[1]/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}</PageTitle>
  <PageBackLinkName>Back to Profile</PageBackLinkName>
  <PageBackLinkURL>{{{//rdf:RDF/rdf:Description/rdf:subject/@rdf:resource}}}</PageBackLinkURL>
  <PageSubTitle>Related Authors ({{{//rdf:RDF/rdf:Description/prns:numberOfConnections}}})</PageSubTitle>
  <PageDescription>Related Authors share similar sets of concepts, but are not necessarily co-authors.</PageDescription>
  <PanelTabType>Default</PanelTabType>
  <PanelList>
    <Panel Type="active">
      <Module ID="MiniSearch" />
      <Module ID="MainMenu" />
    </Panel>
    <Panel Type="main" TabSort="0" TabType="Default" Alias="list" Name="List">
      <Module ID="NetworkList">
        <ParamList>
          <Param Name="InfoCaption">The people in this list are ordered by decreasing similarity.     (<font color="red">*</font> These people are also co-authors.)</Param>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="BulletType">disc</Param>
          <Param Name="Columns">2</Param>
          <Param Name="NetworkListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasConnection/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdf:object/@rdf:resource}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/rdf:object/@rdf:resource}}}</Param>
          <Param Name="SortBy">Weight</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="1" Alias="map" Name="Map" DisplayRule="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/prns:latitude">
      <Module ID="NetworkMap">
        <ParamList>
          <Param Name="MapType">SimilarTo</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="3" Alias="details" Name="Details">
      <Module ID="ApplyXSLT">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="XSLTPath">~/profile/XSLT/SimilarPeopleDetail.xslt</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="passive">
      <Module ID="PassiveHeader">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Related Concepts</Param>
          <Param Name="Description">Derived automatically from this person''''s publications.</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:hasResearchArea/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) concept(s)</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Co-Authors</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="Description">People in Profiles who have published with this person.</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:coAuthorOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Related Authors</Param>
          <Param Name="Description">People who share similar concepts with this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:similarTo/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="CustomViewPersonSameDepartment" />
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Physical Neighbors</Param>
          <Param Name="Description">People whose addresses are nearby this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:physicalNeighborOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
        </ParamList>
      </Module>
    </Panel>
  </PanelList>
</Presentation>'',1) WHERE [PresentationID]=7')
	  
EXEC(N'UPDATE [Ontology.Presentation].[XML] SET [PresentationXML]=CONVERT(xml,N''<Presentation PresentationClass="network">
  <PageOptions Columns="3" />
  <WindowName>{{{//rdf:RDF/rdf:Description[@rdf:about= ../rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{//rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}</WindowName>
  <PageColumns>3</PageColumns>
  <PageTitle>{{{//rdf:RDF/rdf:Description[@rdf:about= ../rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{//rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}</PageTitle>
  <PageBackLinkName>Back to Profile</PageBackLinkName>
  <PageBackLinkURL>{{{//rdf:RDF/rdf:Description/rdf:subject/@rdf:resource}}}</PageBackLinkURL>
  <PageSubTitle>Related Concepts  ({{{//rdf:RDF/rdf:Description/prns:numberOfConnections}}})</PageSubTitle>
  <PageDescription>Related oncepts are derived automatically from a person''''s publications.</PageDescription>
  <PanelTabType>Default</PanelTabType>
  <PanelList>
    <Panel Type="active">
      <Module ID="MiniSearch" />
      <Module ID="MainMenu" />
    </Panel>
    <Panel Type="main" TabSort="0" TabType="Default" Alias="cloud" Name="Cloud">
      <Module ID="NetworkList">
        <ParamList>
          <Param Name="Cloud">true</Param>
        </ParamList>
      </Module>
      <!--<Module ID="NetworkList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description[1]/@rdf:about</Param>
          <Param Name="InfoCaption">In this concept ''''cloud'''', the sizes of the concepts are based not only on the number of corresponding publications, but also how relevant the concepts are to the overall topics of the publications, how long ago the publications were written, whether the person was the first or senior author, and how many other people have written about the same topic. The largest concepts are those that are most unique to this person.</Param>
          <Param Name="BulletType" />
          <Param Name="Columns">2</Param>
          <Param Name="NetworkListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasConnection/@rdf:resource]</Param>
          <Param Name="CloudWeightNode">prns:connectionWeight</Param>
          <Param Name="ItemURLText">{{{rdf:Description[1]/rdf:object/@rdf:resource}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description[1]/rdf:object/@rdf:resource}}}</Param>
        </ParamList>
      </Module>-->
    </Panel>
    <Panel Type="main" TabSort="1" Alias="categories" Name="Categories">
      <Module ID="NetworkCategories">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="InfoCaption">Concepts listed here are grouped according to their ''''semantic'''' categories. Within each category, up to ten concepts are shown, in decreasing order of relevance.</Param>
          <Param Name="NetworkListNode">rdf:RDF/rdf:Description[@rdf:about= //rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]</Param>
          <Param Name="CategoryPath">//prns:meshSemanticGroupName</Param>
          <Param Name="ItemText">{{{//rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemURL">{{{//rdf:Description/@rdf:about}}}</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="2" Alias="timeline" Name="Timeline">
      <Module ID="NetworkTimeline">
        <ParamList>
          <Param Name="TimelineType">Concept</Param>
          <Param Name="InfoCaption">The timeline below shows the dates (blue tick marks) of publications associated with @SubjectName''''s top concepts. The average publication date for each concept is shown as a red circle, illustrating changes in the primary topics that @SubjectName has written about over time.</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="main" TabSort="3" Alias="details" Name="Details">
      <Module ID="ApplyXSLT">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/@rdf:about</Param>
          <Param Name="XSLTPath">~/profile/XSLT/ConceptDetail.xslt</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="passive">
      <Module ID="PassiveHeader" />
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Related Concepts</Param>
          <Param Name="Description">Derived automatically from this person''''s publications.</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:hasResearchArea/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://vivoweb.org/ontology/core#hasResearchArea"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) concept(s)</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Co-Authors</Param>
          <Param Name="MaxDisplay">5</Param>
          <Param Name="Description">People in Profiles who have published with this person.</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:coAuthorOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Related Authors</Param>
          <Param Name="Description">People who share similar concepts with this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:similarTo/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
          <Param Name="MoreURL">{{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/@rdf:about}}}</Param>
          <Param Name="MoreText">See all ({{{rdf:RDF/rdf:Description[rdf:predicate/@rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#similarTo"][@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:hasNetwork/@rdf:resource]/prns:numberOfConnections}}}) people</Param>
        </ParamList>
      </Module>
      <Module ID="CustomViewPersonSameDepartment" />
      <Module ID="PassiveList">
        <ParamList>
          <Param Name="DataURI">rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ExpandRDFList">
            <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
          </Param>
          <Param Name="InfoCaption">Physical Neighbors</Param>
          <Param Name="Description">People whose addresses are nearby this person.</Param>
          <Param Name="MaxDisplay">11</Param>
          <Param Name="ListNode">rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:physicalNeighborOf/@rdf:resource]</Param>
          <Param Name="ItemURLText">{{{rdf:Description/rdfs:label}}}</Param>
          <Param Name="ItemText" />
          <Param Name="ItemURL">{{{rdf:Description/@rdf:about}}}</Param>
        </ParamList>
      </Module>
    </Panel>
  </PanelList>
</Presentation>'',1) WHERE [PresentationID]=8')

EXEC(N'UPDATE [Ontology.Presentation].[XML] SET [PresentationXML]=CONVERT(xml,N''<Presentation PresentationClass="connection">
  <PageOptions Columns="3" />
  <WindowName>{{{rdf:RDF[1]/rdf:Description[1]/rdfs:label[1]}}}</WindowName>
  <PageColumns>3</PageColumns>
  <PageTitle>Connection</PageTitle>
  <PageBackLinkName>Back to Details</PageBackLinkName>
  <PageBackLinkURL>{{{//rdf:RDF/rdf:Description/prns:connectionInNetwork/@rdf:resource}}}/details</PageBackLinkURL>
  <PageSubTitle>Co-Authors</PageSubTitle>
  <PageDescription>This is a "connection" page, showing publications co-authored by 
	{{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}} 
	and 
	{{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource]/foaf:firstName}}} {{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource]/foaf:lastName}}}.
  </PageDescription>
  <PanelTabType>Fixed</PanelTabType>
  <PanelList>
    <Panel Type="active">
      <Module ID="MiniSearch" />
      <Module ID="MainMenu" />
    </Panel>
    <Panel Type="main" TabSort="0" TabType="Default">
      <Module ID="CoAuthorConnection">
        <ParamList>
          <Param Name="SubjectName">//rdf:RDF/rdf:Description/rdfs:label</Param>
          <Param Name="SubjectURI">//rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ObjectName">//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource]/rdfs:label</Param>
          <Param Name="ObjectURI">//rdf:RDF/rdf:Description/rdf:object/@rdf:resource</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="passive">
      <Module ID="HTMLBlock">
        <ParamList>
          <Param Name="HTML">
            <div class="passiveSectionHead">
						Connection Strength
					</div>
            <br />
            <div class="passiveSectionBody"> The connection strength for concepts is the <u>sum</u> of the scores for each matching publication.
			<br /><br />
			
				Publication scores are based on many factors, including how long ago they were written and whether the person is a first or senior author.
			</div>
          </Param>
        </ParamList>
      </Module>
    </Panel>
  </PanelList>
</Presentation>'',1) WHERE [PresentationID]=9')

EXEC(N'UPDATE [Ontology.Presentation].[XML] SET [PresentationXML]=CONVERT(xml,N''<Presentation PresentationClass="connection">
  <PageOptions Columns="3" />
  <WindowName>{{{//rdf:RDF/rdf:Description[@rdf:about= ../rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{//rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}}</WindowName>
  <PageColumns>3</PageColumns>
  <PageTitle>Connection</PageTitle>
  <PageBackLinkName>Back to Details</PageBackLinkName>
  <PageBackLinkURL>{{{//rdf:RDF/rdf:Description[1]/prns:connectionInNetwork/@rdf:resource}}}/details</PageBackLinkURL>
  <PageSubTitle>Similar Person</PageSubTitle>
  <PageDescription>
	This is a "connection" page, showing concepts shared by  
	{{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} {{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}} and 
	{{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource]/foaf:firstName}}} {{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource]/foaf:lastName}}}.
  </PageDescription>
  <PanelTabType>Fixed</PanelTabType>
  <PanelList>
    <Panel Type="active">
      <Module ID="MiniSearch" />
      <Module ID="MainMenu" />
    </Panel>
    <Panel Type="main" TabSort="0" TabType="Default">
      <Module ID="SimilarConnection">
        <ParamList>
          <Param Name="SubjectName">//rdf:RDF/rdf:Description/rdfs:label</Param>
          <Param Name="SubjectURI">//rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ObjectName">//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource]/rdfs:label</Param>
          <Param Name="ObjectURI">//rdf:RDF/rdf:Description/rdf:object/@rdf:resource</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="passive">
      <Module ID="HTMLBlock">
        <ParamList>
          <Param Name="HTML">
            <div class="passiveSectionHead">
              Connection Strength
            </div>
            <br />
            <div class="passiveSectonBody"> The connection strength for related authors is the <u>sum</u> of the scores for each shared concept.<p>A shared concept score is the <u>product</u> of the concept scores for each person.</p><p>Click any person''''s concept score value to show details.</p></div>
          </Param>
        </ParamList>
      </Module>
    </Panel>
  </PanelList>
</Presentation>'',1) WHERE [PresentationID]=10')

EXEC(N'UPDATE [Ontology.Presentation].[XML] SET [PresentationXML]=CONVERT(xml,N''<Presentation PresentationClass="connection">
  <PageOptions Columns="3" />
  <WindowName>{{{rdf:RDF[1]/rdf:Description[1]/rdfs:label[1]}}}</WindowName>
  <PageColumns>3</PageColumns>
  <PageTitle>Connection</PageTitle>
  <PageBackLinkName>Back to Details
  </PageBackLinkName>
  <PageBackLinkURL>{{{//rdf:RDF/rdf:Description/prns:connectionInNetwork/@rdf:resource}}}/details</PageBackLinkURL>
  <PageSubTitle>
	{{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} 
	{{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}} 
	to 
	{{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource]/rdfs:label}}}
  </PageSubTitle>
  <PageDescription>
	This is a "connection" page, showing publications 
	{{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName}}} 
	{{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName}}} 
	has written about 
	{{{//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource]/rdfs:label}}}.
  </PageDescription>
  <PanelTabType>Fixed</PanelTabType>
  <PanelList>
    <Panel Type="active">
      <Module ID="MiniSearch" />
      <Module ID="MainMenu" />
    </Panel>
    <Panel Type="main" TabSort="0" TabType="Default">
      <Module ID="ConceptConnection">
        <ParamList>
          <Param Name="SubjectName">//rdf:RDF/rdf:Description/rdfs:label</Param>
          <Param Name="SubjectURI">//rdf:RDF/rdf:Description/rdf:subject/@rdf:resource</Param>
          <Param Name="ObjectName">//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource]/rdfs:label</Param>
          <Param Name="ObjectURI">//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource]/@rdf:about</Param>
        </ParamList>
      </Module>
    </Panel>
    <Panel Type="passive">
      <Module ID="HTMLBlock">
        <ParamList>
          <Param Name="HTML">
            <div class="passiveSectionHead">
              Connection Strength
            </div>
            <br />
            <div class="passiveSectionBody"> The connection strength for concepts is the <u>sum</u> of the scores for each matching publication.
			<br /><br />
				Publication scores are based on many factors, including how long ago they were written and whether the person is a first or senior author.
			</div>
          </Param>
        </ParamList>
      </Module>
    </Panel>
  </PanelList>
</Presentation>'',1) WHERE [PresentationID]=11')


-- ABOVE CONFIRMED for 1.0.3
