<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vivo="http://vivoweb.org/ontology/core#">
  <xsl:param name="root" />
  <xsl:template match="/">
    <div id="view_links_table" style="padding:10px 0px 10px 20px;">
      <table cellspacing="10" cellpadding="10" border="0">
        <tbody>
          <tr/>
          <xsl:for-each select="rdf:RDF/rdf:Description[1]/prns:mediaLinks">
            <xsl:variable name="resource" select="@rdf:resource"></xsl:variable>
            <tr>

              <xsl:variable name="t" select="//rdf:RDF/rdf:Description[@rdf:about=$resource]/vivo:linkAnchorText"/>
              <xsl:variable name="l" select="//rdf:RDF/rdf:Description[@rdf:about=$resource]/rdfs:label"/>
              <xsl:variable name="p" select="//rdf:RDF/rdf:Description[@rdf:about=$resource]/prns:publicationDate"/>
              <td>
                <img src="https://www.google.com/s2/favicons?domain={$l}" width="16'" height="16" />
              </td>
              <td>
                <a href="{$l}">
                  <xsl:value-of select="$t"/>
                </a>
                <xsl:if test="//rdf:RDF/rdf:Description[@rdf:about=$resource]/prns:publicationDate">
                  (<xsl:value-of select="//rdf:RDF/rdf:Description[@rdf:about=$resource]/prns:publicationDate"/>)
                </xsl:if>
              </td>
            </tr>
          </xsl:for-each>
      	</tbody>
			</table>          
    </div>
  </xsl:template>
</xsl:stylesheet>
