<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Profile.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vivo="http://vivoweb.org/ontology/core#" >
  <xsl:template match="/">
      <div class="passiveSectionBody">
      <ul>
        <!--<xsl:for-each select="//rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://profiles.catalyst.harvard.edu/ontology/prns#Connection']">-->
        <xsl:for-each select="//rdf:RDF/rdf:Description/prns:hasConnection">
          <xsl:variable name="resource" select="@rdf:resource"></xsl:variable>
          <xsl:for-each select="//rdf:RDF/rdf:Description[@rdf:about=$resource]/rdf:object">
            <xsl:variable name="connectionResource" select="@rdf:resource"></xsl:variable>
            <xsl:for-each select="//rdf:RDF/rdf:Description[@rdf:about=$connectionResource]/vivo:memberRoleOf">
              <xsl:variable name="personResource" select="@rdf:resource"></xsl:variable>
              <li>
                <a href="{$personResource}">
                  <xsl:value-of select="//rdf:RDF/rdf:Description[@rdf:about=$personResource]/rdfs:label"/>
                </a>
              </li>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
      </ul>
    </div>
	</xsl:template>
</xsl:stylesheet>
