<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml GriffinsProfile.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vivo="http://vivoweb.org/ontology/core#">
  <xsl:template match="/">    
      <div class="awardsList">
        <table>
          <tbody>
              <tr>
                <td stlye="white-space:nowrap;">
                  <xsl:value-of select="//rdf:Description/prns:startDate"/> | <xsl:value-of select="//rdf:Description/prns:endDate"/>
                </td>
                <td>
                  <xsl:value-of select="//rdf:Description/rdfs:label"/>
                </td>
              </tr>            
          </tbody>
        </table>
      </div>    
  </xsl:template>
</xsl:stylesheet>
