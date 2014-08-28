<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vivo="http://vivoweb.org/ontology/core#">
  <xsl:template match="/">
    <xsl:if test="rdf:RDF/rdf:Description[1]/vivo:educationalTraining">
     
      <div class="awardsList">
        <table>
          <tbody>
            <xsl:for-each select="rdf:RDF/rdf:Description[1]/vivo:educationalTraining">
              <xsl:variable name="educationalTrainingUri" select="@rdf:resource"/>              
              <tr>
                <td>
                  <xsl:value-of select="/rdf:RDF[1]/rdf:Description[@rdf:about=$educationalTrainingUri]/prns:endDate"/>
                </td>
                <td>
                  <xsl:value-of select="/rdf:RDF[1]/rdf:Description[@rdf:about=$educationalTrainingUri]/vivo:degreeEarned"/>
                </td>
                <td stlye="white-space:nowrap;">
                  <xsl:value-of select="/rdf:RDF[1]/rdf:Description[@rdf:about=$educationalTrainingUri]/vivo:trainingAtOrganization"/>
                </td>
                <td>
                  <xsl:value-of select="/rdf:RDF[1]/rdf:Description[@rdf:about=$educationalTrainingUri]/vivo:departmentOrSchool"/>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </div>

    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
