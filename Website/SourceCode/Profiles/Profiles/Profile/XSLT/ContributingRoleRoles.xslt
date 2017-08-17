<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Profile.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vivo="http://vivoweb.org/ontology/core#" xmlns:foaf="http://xmlns.com/foaf/0.1/" >
  <xsl:template match="/">
    <div class="passiveSectionBody">
      <xsl:for-each select="//rdf:RDF/rdf:Description/prns:hasConnection">
      </xsl:for-each>
      <ul  class="prns-details-list">
        <xsl:for-each select="//rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://vivoweb.org/ontology/core#Role']/rdfs:label[not(. = ../following-sibling::rdf:Description/rdfs:label)]">
          <xsl:sort select="text()" data-type="text" order="ascending"/>
          <xsl:variable name="roleName" select="text()"></xsl:variable>
          <li>
            <span class="prns-text-large">
              <xsl:value-of select="$roleName"/>
            </span>

            <ul  class="prns-details-inner-list">
            <xsl:for-each select="//rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://vivoweb.org/ontology/core#Role']/vivo:memberRoleOf[../rdfs:label/text()=$roleName]">
              <xsl:variable name="personResource" select="@rdf:resource"></xsl:variable>
              <li>
                <a href="{$personResource}">
                  <xsl:value-of select="//rdf:RDF/rdf:Description[@rdf:about=$personResource]/rdfs:label"/>
                </a>
              </li>
            </xsl:for-each>
            </ul>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>
</xsl:stylesheet>