<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Profile.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vivo="http://vivoweb.org/ontology/core#" >
  <xsl:template match="/">
				<xsl:choose>
					<xsl:when test="rdf:RDF/rdf:Description/vivo:hasMemberRole  !=''">
						<div class="sectionHeader">Narrative</div>
						<div class="narrative">
							translate(<xsl:value-of select="rdf:RDF/rdf:Description/vivo:hasMemberRole "/>,"&#10;&#13;","<br/>")             
						</div>
					</xsl:when>
				</xsl:choose>
      <div class="passiveSectionBody">
      <ul class="prns-details-list">
        <xsl:for-each select="//rdf:RDF/rdf:Description/vivo:hasMemberRole">
          <xsl:variable name="resource" select="@rdf:resource"></xsl:variable>
          <xsl:for-each select="//rdf:RDF/rdf:Description[@rdf:about=$resource]/vivo:roleContributesTo">
            <xsl:variable name="groupResource" select="@rdf:resource"></xsl:variable>
            <li>
              <a href="{$groupResource}">
                <xsl:value-of select="//rdf:RDF/rdf:Description[@rdf:about=$groupResource]/rdfs:label"/></a>&#160;(<xsl:value-of select="//rdf:RDF/rdf:Description[@rdf:about=$resource]/rdfs:label"/>)
            </li>
          </xsl:for-each>
        </xsl:for-each>
      </ul>
    </div>
	</xsl:template>
</xsl:stylesheet>
