<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml GriffinsProfile.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vivo="http://vivoweb.org/ontology/core#">
  <xsl:template match="/">
    <xsl:if test="rdf:RDF/rdf:Description[@rdf:about = /rdf:RDF[1]/rdf:Description[1]/vivo:personInPosition/@rdf:resource][prns:sortOrder !='1'] !=''">
      <div class="content_two_columns">
        <table>
          <tbody>
            <tr>
              <td class="firstColumn">
                <div class="sectionHeader2">Other Positions</div>
                <div class="basicInfo">
                  <table>
                    <tbody>
                      <xsl:apply-templates select="rdf:RDF/rdf:Description[1]/vivo:personInPosition"/>
                    </tbody>
                  </table>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </xsl:if>
  </xsl:template>
  <!--=============Template for displaying Other Positions============-->
  <xsl:template match="rdf:RDF/rdf:Description[1]/vivo:personInPosition">
    <xsl:variable name="resource" select="@rdf:resource"/>
    <xsl:apply-templates select="//rdf:Description[@rdf:about = $resource][prns:sortOrder !='1']"/>
  </xsl:template>
  <xsl:template match="rdf:Description">
    <tr>
      <xsl:if test="vivo:hrJobTitle !='' ">
        <th>Title</th>
        <td>
          <xsl:value-of select="vivo:hrJobTitle "/>
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:variable name="uriOrganization" select="vivo:positionInOrganization/@rdf:resource"/>
      <xsl:apply-templates select="//rdf:Description[@rdf:about = $uriOrganization]" mode="organization"/>
    </tr>
    <tr>
      <xsl:variable name="uriDepartment" select="prns:positionInDepartment/@rdf:resource"/>
      <xsl:apply-templates select="//rdf:Description[@rdf:about = $uriDepartment]" mode="department"/>
    </tr>
    <tr>
      <xsl:variable name="uriDivision" select="prns:positionInDivision/@rdf:resource"/>
      <xsl:apply-templates select="//rdf:Description[@rdf:about = $uriDivision]" mode="division"/>
    </tr>
    <!--<xsl:if test="position()!= last()">-->
    <tr>
      <th>
        <br/>
      </th>
    </tr>
    <!--</xsl:if>-->
  </xsl:template>
  <xsl:template match="rdf:Description" mode="organization">
    <xsl:if test="rdfs:label !='' ">
      <th>Institution</th>
      <td>
        <xsl:value-of select="rdfs:label"/>
      </td>
    </xsl:if>
  </xsl:template>
  <xsl:template match="rdf:Description" mode="department">
    <xsl:if test="rdfs:label !='' ">
      <th>Department</th>
      <td>
        <xsl:value-of select="rdfs:label"/>
      </td>
    </xsl:if>
  </xsl:template>
  <xsl:template match="rdf:Description" mode="division">
    <xsl:if test="rdfs:label !='' ">
      <th>Division</th>
      <td>
        <xsl:value-of select="rdfs:label "/>
      </td>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
