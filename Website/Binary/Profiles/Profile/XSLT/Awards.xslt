<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vivo="http://vivoweb.org/ontology/core#">
  <xsl:template match="/">
    <xsl:if test="rdf:RDF/rdf:Description[1]/vivo:awardOrHonor">
     
      <div class="awardsList">
        <table>
          <tbody>
            <xsl:for-each select="rdf:RDF/rdf:Description[1]/vivo:awardOrHonor">
              <xsl:variable name="awardUri" select="@rdf:resource"/>              
              <tr>
                <td stlye="white-space:nowrap;" width="100px">                  
                  <xsl:value-of select="/rdf:RDF[1]/rdf:Description[@rdf:about=$awardUri]/prns:startDate"/> -               
                  <xsl:value-of select="/rdf:RDF[1]/rdf:Description[@rdf:about=$awardUri]/prns:endDate"/>
                </td>
                <td>
                  <xsl:value-of select="/rdf:RDF[1]/rdf:Description[@rdf:about=$awardUri]/rdfs:label"/>
                </td>              
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </div>

    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
