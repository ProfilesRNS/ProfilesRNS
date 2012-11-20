<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:geo="http://aims.fao.org/aos/geopolitical.owl#" xmlns:afn="http://jena.hpl.hp.com/ARQ/function#" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:obo="http://purl.obolibrary.org/obo/" xmlns:dcelem="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:event="http://purl.org/NET/c4dm/event.owl#" xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:vann="http://purl.org/vocab/vann/" xmlns:vitro07="http://vitro.mannlib.cornell.edu/ns/vitro/0.7#" xmlns:vitro="http://vitro.mannlib.cornell.edu/ns/vitro/public#" xmlns:vivo="http://vivoweb.org/ontology/core#" xmlns:pvs="http://vivoweb.org/ontology/provenance-support#" xmlns:scirr="http://vivoweb.org/ontology/scientific-research-resource#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:swvs="http://www.w3.org/2003/06/sw-vocab-status/ns#" xmlns:skco="http://www.w3.org/2004/02/skos/core#" xmlns:owl2="http://www.w3.org/2006/12/owl2-xml#" xmlns:skos="http://www.w3.org/2008/05/skos#" xmlns:foaf="http://xmlns.com/foaf/0.1/">
  <xsl:output method="html"/>
  <xsl:param name="root"/>
  <xsl:template match="/">
    <script type="~/framework/JavaScript/profiles.js"/>
    <script type="text/javascript">
      function meshView(x)
      {
      myGetElementById('meshMenu1').style.display='none';
      myGetElementById('meshMenu2').style.display='none';
      myGetElementById('meshMenu3').style.display='none';
      myGetElementById('meshMenu4').style.display='none';
      myGetElementById('meshMenu5').style.display='none';
      myGetElementById('mesh1').style.display='none';
      myGetElementById('mesh2').style.display='none';
      myGetElementById('mesh3').style.display='none';
      myGetElementById('mesh4').style.display='none';
      myGetElementById('mesh5').style.display='none';
      myGetElementById('meshMenu'+x).style.display='block';
      myGetElementById('mesh'+x).style.display='block';}

      function pubView(x)
      {
      myGetElementById('pubMenu1').style.display='none';
      myGetElementById('pubMenu2').style.display='none';
      myGetElementById('pubMenu3').style.display='none';
      myGetElementById('pubMenu4').style.display='none';
      myGetElementById('pub1').style.display='none';
      myGetElementById('pub2').style.display='none';
      myGetElementById('pub3').style.display='none';
      myGetElementById('pub4').style.display='none';
      myGetElementById('pubMenu'+x).style.display='block';
      myGetElementById('pub'+x).style.display='block';}
    </script>
    <div class="profileKwCondenseList">
      <div style="padding-top: 10px;" class="sectionHeader">Concept Type</div>
      <xsl:text>"</xsl:text>
      <xsl:value-of select="rdf:RDF/rdf:Description[1]/rdfs:label"/>
      <xsl:text>"</xsl:text>
      <xsl:text> is a descriptor in the National Library of Medicine's controlled vocabulary thesaurus, </xsl:text>
      <a target="_blank" href="http://www.nlm.nih.gov/mesh/">MeSH (Medical Subject Headings)</a>. <xsl:text> Descriptors are arranged in a hierarchical structure, which enables searching at various levels of specificity.</xsl:text>
      <div class="sectionHeader">MeSH Information</div>

      <div class="publicationKwMenuBox">
        <div class="publicationMenu" id="meshMenu1" style="display: block;">
          <span class="publicationSelected">Definition</span>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('2');">Details</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('3');">More General Concepts</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('4');">Related Concepts</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('5');">More Specific Concepts</a>
        </div>
        <div class="publicationMenu" id="meshMenu2" style="display: none;">
          <a href="javascript:meshView('1');">Definition</a>
          <xsl:text> | </xsl:text>
          <span class="publicationSelected">Details</span>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('3');">More General Concepts</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('4');">Related Concepts</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('5');">More Specific Concepts</a>
        </div>
        <div class="publicationMenu" id="meshMenu3" style="display: none;">
          <a href="javascript:meshView('1');">Definition</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('2');">Details</a>
          <xsl:text> | </xsl:text>
          <span class="publicationSelected">More General Concepts</span>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('4');">Related Concepts</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('5');">More Specific Concepts</a>
        </div>
        <div class="publicationMenu" id="meshMenu4" style="display: none;">
          <a href="javascript:meshView('1');">Definition</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('2');">Details</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('3');">More General Concepts</a>
          <xsl:text> | </xsl:text>
          <span class="publicationSelected">Related Concepts</span>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('5');">More Specific Concepts</a>
        </div>
        <div class="publicationMenu" id="meshMenu5" style="display: none;">
          <a href="javascript:meshView('1');">Definition</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('2');">Details</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('3');">More General Concepts</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:meshView('4');">Related Concepts</a>
          <xsl:text> | </xsl:text>
          <span class="publicationSelected">More Specific Concepts</span>
        </div>
      </div>
      <div id="mesh1"  style="display: none;">
        <xsl:text>Here Goes the definition</xsl:text>
      </div>
      <div id="mesh2" style="display: none;">
        <div class="basicInfo">
          <table>
            <tbody>
              <tr>
                <th style="width: 100px;">Descriptor ID</th>
                <td>
                  <xsl:value-of select="rdf:RDF/rdf:Description[1]/prns:meshDescriptorUI"/>
                </td>
              </tr>
              <tr>
                <th style="width: 100px;">MeSH Number(s)</th>
                <td>
                  <xsl:for-each select="rdf:RDF/rdf:Description[1]/prns:meshTreeNumber">
                    <xsl:value-of select="."/>
                    <br/>
                  </xsl:for-each>
                </td>
              </tr>
              <tr>
                <th style="width: 100px;">Concepts/Terms</th>
                <!--<td>
                  <xsl:for-each select="Profile/Details/Term">
                    <xsl:if test="generate-id(.) =generate-id(key('uniqueTerms', .)[1])">
                      <a href="javascript:toggleVisibility('concept_','block')">
                        <xsl:value-of select="."/>
                      </a>
                      <br/>
                      <ul class="profileKwConcept" id="concept_">
                        <li>Biofilms</li>
                        <li>Biofilm</li>
                      </ul>

                    </xsl:if>
                  </xsl:for-each>
                </td>-->
                <td>Data Missing</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div id="mesh3" style="display: none;">
        <div class="profileKwMeshInfoDesc">Below are MeSH descriptors whose meaning is more general than "<xsl:value-of select="rdf:RDF/rdf:Description[1]/rdfs:label"/>".</div>
        <div>--- Dummy Text---</div>
        Biological Sciences [G]
        <ul>
          <li>
            <a href="http://connects.catalyst.harvard.edu/profiles/profile/concept/Microbiological+Phenomena">Microbiological Phenomena</a> [G06]
          </li>
          <ul>
            <li>
              <b>
                <a href="http://connects.catalyst.harvard.edu/profiles/profile/concept/Biofilms">Biofilms</a>
              </b> [G06.120]
            </li>
          </ul>
        </ul>
      </div>
      <div id="mesh4" style="display: none;">
        <div class="profileKwMeshInfoDesc">Below are MeSH descriptors whose meaning is related to "<xsl:value-of select="rdf:RDF/rdf:Description[1]/rdfs:label"/>".</div>
        <div>--- Dummy Text---</div>
        <a href="http://connects.catalyst.harvard.edu/profiles/profile/concept/Microbiological+Phenomena">Microbiological Phenomena</a>
        <ul>
          <li>
            <a href="http://connects.catalyst.harvard.edu/profiles/profile/concept/Bacterial+Physiological+Phenomena">Bacterial Physiological Phenomena</a>
          </li>
          <li>
            <b>
              <a href="http://connects.catalyst.harvard.edu/profiles/profile/concept/Biofilms">Biofilms</a>
            </b>
          </li>
          <li>
            <a href="http://connects.catalyst.harvard.edu/profiles/profile/concept/Drug+Resistance%2C+Microbial">Drug Resistance, Microbial</a>
          </li>
          <li>
            <a href="http://connects.catalyst.harvard.edu/profiles/profile/concept/Germ%2DFree+Life">Germ-Free Life</a>
          </li>
          <li>
            <a href="http://connects.catalyst.harvard.edu/profiles/profile/concept/Microbial+Viability">Microbial Viability</a>
          </li>
          <li>
            <a href="http://connects.catalyst.harvard.edu/profiles/profile/concept/Microbiological+Processes">Microbiological Processes</a>
          </li>
          <li>
            <a href="http://connects.catalyst.harvard.edu/profiles/profile/concept/Virulence">Virulence</a>
          </li>
          <li>
            <a href="http://connects.catalyst.harvard.edu/profiles/profile/concept/Virus+Physiological+Phenomena">Virus Physiological Phenomena</a>
          </li>
        </ul>
      </div>
      <div id="mesh5" style="display: none;">
        <div class="profileKwMeshInfoDesc">Below are MeSH descriptors whose meaning is more specific than "<xsl:value-of select="rdf:RDF/rdf:Description[1]/rdfs:label"/>".</div>Biofilms<ul/>
      </div>
      <div class="sectionHeader">Publications</div>
      <div class="publicationKwMenuBox">
        <div class="publicationMenu" id="pubMenu1" style="display: block;">
          <span class="publicationSelected">Timeline</span>
          <xsl:text> | </xsl:text>
          <a href="javascript:pubView('2');">Most cited</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:pubView('3');">More Recent</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:pubView('4');">Earliest</a>
        </div>
        <div class="publicationMenu" id="pubMenu2" style="display: none;">
          <a href="javascript:pubView('1');">Timeline</a>
          <xsl:text> | </xsl:text>
          <span class="publicationSelected">Most cited</span>
          <xsl:text> | </xsl:text>
          <a href="javascript:pubView('3');">More Recent</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:pubView('4');">Earliest</a>

        </div>
        <div class="publicationMenu" id="pubMenu3" style="display: none;">
          <a href="javascript:pubView('1');">Timeline</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:pubView('2');">Most cited</a>
          <xsl:text> | </xsl:text>
          <span class="publicationSelected">More Recent</span>
          <xsl:text> | </xsl:text>
          <a href="javascript:pubView('4');">Earliest</a>


        </div>
        <div class="publicationMenu" id="pubMenu4" style="display: none;">
          <a href="javascript:pubView('1');">Timeline</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:pubView('2');">Most cited</a>
          <xsl:text> | </xsl:text>
          <a href="javascript:pubView('3');">More Recent</a>
          <xsl:text> | </xsl:text>
          <span class="publicationSelected">Earliest</span>


        </div>
      </div>
      <div id="pub1"  style="display: none;">
        <xsl:text>This graph shows the total number of publications written about "</xsl:text>
        <xsl:value-of select="rdf:RDF/rdf:Description[1]/rdfs:label"/>
        <xsl:text>" by people in Harvard Catalyst Profiles by year, and whether "</xsl:text>
        <xsl:value-of select="rdf:RDF/rdf:Description[1]/rdfs:label"/>
        <xsl:text>" was a major or minor topic of these publication. In all years combined, a total of</xsl:text>
        <xsl:value-of select="/rdf:Description[1]/prns:numberOfAuthors"/>
        <xsl:text>publications were written by</xsl:text>
        <xsl:value-of select="rdf:RDF/rdf:Description[1]/prns:numberOfAuthors"/>
        <xsl:text>author(s) in Profiles."</xsl:text>
      </div>
      <div id="pub2"  style="display: none;">
        <xsl:text>Below are the publications written about "</xsl:text>
        <xsl:value-of select="rdf:RDF/rdf:Description[1]/rdfs:label"/>
        <xsl:text>" that have been cited the most by articles in Pubmed Central.</xsl:text>
      </div>
      <div id="pub3"  style="display: none;">
        <xsl:text>Below are the most recent publications written about "</xsl:text>
        <xsl:value-of select="rdf:RDF/rdf:Description[1]/rdfs:label"/>
        <xsl:text>" by people in Profiles.</xsl:text>
      </div>
      <div id="pub4"  style="display: none;">
        <xsl:text>Below are the earliest publications written about "</xsl:text>
        <xsl:value-of select="rdf:RDF/rdf:Description[1]/rdfs:label"/>
        <xsl:text>" by people in Profiles.</xsl:text>
      </div>
      <script>meshView(1);</script>
      <script>pubView(1);</script>
    </div>
  </xsl:template>
</xsl:stylesheet>