<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vivo="http://vivoweb.org/ontology/core#"  exclude-result-prefixes="prns rdf bibo skco owl2 swvs rdfs scirr vivo vitro07 event obo pvs foaf skos owl dcterms vann dcelem afn geo vitro xsd">
  <xsl:param name="root" />
  <xsl:template match="/">
    <div>
      <ul style="list-style-type: none; padding-left: 8px;">
        <xsl:for-each select="rdf:RDF/rdf:Description[1]/vivo:freetextKeyword">
          <li>
            <xsl:variable name="t" select="."/>
            <a href="{$root}/search/default.aspx?searchtype&#61;everything&amp;searchfor&#61;{$t}&amp;exactphrase&#61;false">
              <xsl:value-of select="$t"/>
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>
</xsl:stylesheet>
