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
          <Param Name="InfoCaption">Concepts</Param>
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
          <Param Name="InfoCaption">Similar People</Param>
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
      <Module ID="PassiveList">
        <ParamList>
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
  <ExpandRDFList>
    <ExpandRDF Class="http://xmlns.com/foaf/0.1/Person" Property="http://vivoweb.org/ontology/core#authorInAuthorship" Limit="1" />
  </ExpandRDFList>
</Presentation>'',1) WHERE [PresentationID]=5')