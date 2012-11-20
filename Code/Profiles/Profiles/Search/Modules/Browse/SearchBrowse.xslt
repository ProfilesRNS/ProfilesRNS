<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml search.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:geo="http://aims.fao.org/aos/geopolitical.owl#" xmlns:afn="http://jena.hpl.hp.com/ARQ/function#" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:obo="http://purl.obolibrary.org/obo/" xmlns:dcelem="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:event="http://purl.org/NET/c4dm/event.owl#" xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:vann="http://purl.org/vocab/vann/" xmlns:vitro07="http://vitro.mannlib.cornell.edu/ns/vitro/0.7#" xmlns:vitro="http://vitro.mannlib.cornell.edu/ns/vitro/public#" xmlns:vivo="http://vivoweb.org/ontology/core#" xmlns:pvs="http://vivoweb.org/ontology/provenance-support#" xmlns:scirr="http://vivoweb.org/ontology/scientific-research-resource#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:swvs="http://www.w3.org/2003/06/sw-vocab-status/ns#" xmlns:skco="http://www.w3.org/2004/02/skos/core#" xmlns:owl2="http://www.w3.org/2006/12/owl2-xml#" xmlns:skos="http://www.w3.org/2008/05/skos#" xmlns:foaf="http://xmlns.com/foaf/0.1">
  <xsl:output method="html"/>
  <xsl:param name="root"/>
  <xsl:template match="/">
    <div class="searchSection">
      <h3>Browse by Type</h3>
    </div>
    <ul style="padding:0px;margin:5px 0px 15px 10px;list-style-type: none;">
      <xsl:for-each select="rdf:RDF/rdf:Description/prns:matchesClassGroup">
        <li role="listitem" style="margin-bottom:5px;">
          <xsl:value-of select="rdfs:label"/>
          <!--<xsl:for-each select="rdf:RDF/rdf:Description/prns:matchesClassGroup">-->
          <xsl:variable name="resource" select="@rdf:resource"/>
          <ul style="padding:0px;margin:0px 0px 0px 5px;list-style-type: none;">
            <xsl:variable name="link">
              <xsl:value-of select="$root"/><![CDATA[/Search/Default.aspx?browsefor=]]><![CDATA[&classgroupuri=]]><xsl:value-of select="translate($resource, '#','!')"/>
            </xsl:variable>
            <xsl:for-each select="prns:matchesClass">
              <xsl:variable name="resource2" select="@rdf:resource"/>
              <xsl:variable name="linkFull">
                <xsl:value-of select="$link"/><![CDATA[&classuri=]]><xsl:value-of select="translate($resource2, '#','!')"/>
              </xsl:variable>
              <li>
                -
                <a href="{$linkFull}" >
                  <xsl:value-of select="rdfs:label"/>
                  <span class="count-classes">
                    (<xsl:value-of select="prns:numberOfConnections"/>)
                  </span>
                </a>
              </li>
            </xsl:for-each>
          </ul>
          <!--</xsl:for-each>-->
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
</xsl:stylesheet>
