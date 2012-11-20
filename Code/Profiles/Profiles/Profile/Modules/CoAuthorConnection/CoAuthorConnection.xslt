<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml CoauthorConnection.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:geo="http://aims.fao.org/aos/geopolitical.owl#" xmlns:afn="http://jena.hpl.hp.com/ARQ/function#" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:obo="http://purl.obolibrary.org/obo/" xmlns:dcelem="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:event="http://purl.org/NET/c4dm/event.owl#" xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:vann="http://purl.org/vocab/vann/" xmlns:vitro07="http://vitro.mannlib.cornell.edu/ns/vitro/0.7#" xmlns:vitro="http://vitro.mannlib.cornell.edu/ns/vitro/public#" xmlns:vivo="http://vivoweb.org/ontology/core#" xmlns:pvs="http://vivoweb.org/ontology/provenance-support#" xmlns:scirr="http://vivoweb.org/ontology/scientific-research-resource#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:swvs="http://www.w3.org/2003/06/sw-vocab-status/ns#" xmlns:skco="http://www.w3.org/2004/02/skos/core#" xmlns:owl2="http://www.w3.org/2006/12/owl2-xml#" xmlns:skos="http://www.w3.org/2008/05/skos#" xmlns:foaf="http://xmlns.com/foaf/0.1/">
  <xsl:output method="html"/>
  <xsl:param name="root"/>
  <xsl:param name="person1pubs"/>
  <xsl:param name="person2pubs"/>
  <xsl:template match="/">
    <xsl:variable name="subjectURI" select="rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource"/>
    <xsl:variable name="objectURI" select="rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource"/>
    <xsl:variable name="connectionURI" select="rdf:RDF/rdf:Description[1]/prns:hasConnectionDetails/@rdf:resource"/>
    <html>
      <head>
        <script type="text/javascript">

          function myGetElementById(id)
          {
          if (document.getElementById)
          var returnVar = document.getElementById(id);
          else if (document.all)
          var returnVar = document.all[id];
          else if (document.layers)
          var returnVar = document.layers[id];
          return returnVar;
          }

          function NavToProfile(entityType,entityid) {
          document.location = '/profile/' + entityType + '/' + entityid ;}

          function doNavToConcept(entityid) {
          document.location = '/profile/concept/' + entityid ;}

          function doURL(x){
          document.location = x;
          }
        </script>
      </head>
      <body>
        <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
        <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
        <!--<div class="pageSubTitle">
          <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=$subjectURI]/foaf:firstName"/>
          <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=$subjectURI]/foaf:lastName"/>
          <xsl:text> to </xsl:text>
          <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=$objectURI]/rdfs:label"/>
        </div>
        <div class="pageSubTitleCaption">
          <xsl:text>This is a "connection" page, showing publications </xsl:text>
          <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=$subjectURI]/foaf:firstName"/>
          <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=$subjectURI]/foaf:lastName"/>
          <xsl:text> has written about </xsl:text>
          <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=$objectURI]/rdfs:label"/>
        </div>-->
        <div class="connectionContainer">
          <table class="connectionContainerTable">
            <tbody>
              <tr>
                <td class="connectionContainerItem">
                  <div>
                    <a href="JavaScript:doURL('{$subjectURI }')">
                      <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=$subjectURI]/foaf:firstName"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=$subjectURI]/foaf:lastName"/>
                    </a>
                  </div>
                  <div class="connectionItemSubText">
                    <xsl:value-of select="$person1pubs"/> Total Publications
                  </div>
                </td>
                <td class="connectionContainerArrow">
                  <table class="connectionArrowTable">
                    <tbody>
                      <tr>
                        <td/>
                        <td>
                          <div class="connectionDescription">
                            <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=$connectionURI]/prns:numberOfPublications"/> Co-Authored Publications
                          </div>
                        </td>
                        <td/>
                      </tr>
                      <tr>
                        <td class="connectionLine">
                          <img src="{$root}/Framework/Images/connection_left.gif"/>
                        </td>
                        <td class="connectionLine">
                          <div/>
                        </td>
                        <td class="connectionLine">
                          <img src="{$root}/Framework/Images/connection_right.gif"/>
                        </td>
                      </tr>
                      <tr>
                        <td/>
                        <td>
                          <div class="connectionSubDescription">
                            Connection Strength = <xsl:value-of select="rdf:RDF/rdf:Description[1]/prns:connectionWeight"/>
                          </div>
                        </td>
                        <td/>
                      </tr>
                    </tbody>
                  </table>
                </td>
                <td class="connectionContainerItem">
                  <div>
                    <a href="JavaScript:doURL('{$objectURI }')">
                      <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=$objectURI]/foaf:firstName"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=$objectURI]/foaf:lastName"/>
                    </a>
                  </div>
                  <div class="connectionItemSubText">
                    <xsl:value-of select="$person2pubs"/> Total Publications
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <script>
          function doShowHidePubScoreDetails(n)
          {
          var p = myGetElementById('publicationScoreDetails_'+n);
          if (p.style.display == 'block')
          {	p.style.display = 'none';}
          else
          {p.style.display = 'block';}
          }

          function doHoverOver(x,n,s)
          {
          var p = myGetElementById('publicationScoreDetailsDescription_'+n);
          p.innerHTML = s;
          x.style.backgroundColor = '#E7EEFF';
          }

          function doHoverOut(x,n)
          {
          var p = myGetElementById('publicationScoreDetailsDescription_'+n);
          p.innerHTML = 'Move your mouse over highighted numbers for more information.';
          x.style.backgroundColor = '';
          }
        </script>
        <div class="publications">
          <ol>
            <xsl:for-each select="Connection/Details/MatchingPublications/PublicationList/Publication">
              <li>
                <xsl:value-of select="Reference"/>
                <div class="viewIn">
                  <span class="viewInLabel">View in</span>: <a target="_blank" href="{URL}">PubMed</a>
                </div>
                <xsl:variable name="position" select="position()"/>
                <div id="publicationScore_{$position}" style="display: block;" class="viewIn publicationScore">
                  <span class="viewInLabel">Score</span>: <a href="JavaScript:doShowHidePubScoreDetails('{$position}');">
                    <xsl:value-of select="UniquenessWeight * TopicWeight * AuthorWeight * YearWeight"/>
                  </a>
                  <div id="publicationScoreDetails_{$position}" class="publicationScoreDetails">
                    The score for this publication (the overall weight) is the product of each of the individual weights. (<a href="JavaScript:doShowHidePubScoreDetails('{$position}');">hide</a>)<table class="publicationScoreDetailsCoAuthor" style="width: 100%;">
                      <tbody>
                        <tr>
                          <th>
                            Uniqueness<br>Weight</br>
                          </th>
                          <th>
                            Topic<br>Weight</br>
                          </th>
                          <th>
                            Author<br>Weight</br>
                          </th>
                          <th>
                            Year<br>Weight</br>
                          </th>
                          <th>
                            Overall<br>(Product)</br>
                          </th>
                        </tr>
                        <tr>
                          <td class="publicationScoreDetailsSpacer" colspan="4">
                            <div/>
                          </td>
                        </tr>
                        <tr>
                          <td onmouseout="doHoverOut(this,{$position});" onmouseover="doHoverOver(this,{$position},'This phrase is used in  publications by {//@ConceptTotalPublications} authors.');">
                            <xsl:value-of select="UniquenessWeight"/>
                          </td>
                          <td onmouseout="doHoverOut(this,{$position});" onmouseover="doHoverOver(this,{$position},'MeSH major topic');">
                            <xsl:value-of select="TopicWeight"/>
                          </td>
                          <td onmouseout="doHoverOut(this,{$position});" onmouseover="doHoverOver(this,{$position},'First or senior author');">
                            <xsl:value-of select="AuthorWeight"/>
                          </td>
                          <td onmouseout="doHoverOut(this,{$position});" onmouseover="doHoverOver(this,{$position},'Published in {Year} ');">
                            <xsl:value-of select="YearWeight"/>
                          </td>
                          <td class="pubScoreDetailsOverall">
                            <xsl:value-of select="UniquenessWeight * TopicWeight * AuthorWeight * YearWeight"/>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <div id="publicationScoreDetailsDescription_{$position}" class="publicationScoreDetailsDescription">Move your mouse over highighted numbers for more information.</div>
                    <div class="pubScoreDetailsKey">
                      <table>
                        <tbody>
                          <tr>
                            <th>Uniqueness Weight</th>
                            <td>How unusual the publication phrase is (inverse of weighted frequency).</td>
                          </tr>
                          <tr>
                            <th>Topic Weight</th>
                            <td>How relevant the publication phrase is to the overall topic of the publication (max = 1).</td>
                          </tr>
                          <tr>
                            <th>Author Weight</th>
                            <td>Whether the person was the first, middle, or senior author of the publication (max = 1).</td>
                          </tr>
                          <tr>
                            <th>Year Weight</th>
                            <td>How long ago the publication was written (0.5^(age in years/10)).</td>
                          </tr>
                          <tr>
                            <th>Overall (Product)</th>
                            <td>The overall weight given to this publication (product of individual weights).</td>
                          </tr>
                        </tbody>
                      </table>
                      <script type="text/javascript">
                        document.getElementsByTagName("li")[0].className += " first";
                      </script>
                    </div>
                  </div>
                </div>
              </li>
            </xsl:for-each>
          </ol>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
