<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:geo="http://aims.fao.org/aos/geopolitical.owl#" xmlns:afn="http://jena.hpl.hp.com/ARQ/function#" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:obo="http://purl.obolibrary.org/obo/" xmlns:dcelem="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:event="http://purl.org/NET/c4dm/event.owl#" xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:vann="http://purl.org/vocab/vann/" xmlns:vitro07="http://vitro.mannlib.cornell.edu/ns/vitro/0.7#" xmlns:vitro="http://vitro.mannlib.cornell.edu/ns/vitro/public#" xmlns:vivo="http://vivoweb.org/ontology/core#" xmlns:pvs="http://vivoweb.org/ontology/provenance-support#" xmlns:scirr="http://vivoweb.org/ontology/scientific-research-resource#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:swvs="http://www.w3.org/2003/06/sw-vocab-status/ns#" xmlns:skco="http://www.w3.org/2004/02/skos/core#" xmlns:owl2="http://www.w3.org/2006/12/owl2-xml#" xmlns:skos="http://www.w3.org/2008/05/skos#" xmlns:foaf="http://xmlns.com/foaf/0.1/">
  <xsl:param name="email"/>
  <xsl:param name="root"/>
  <xsl:param name="imgguid"/>
  <xsl:template match="/">
    <div class="content_two_columns">
      <table>
        <tbody>
          <tr>
            <td class="firstColumn">
              <div class="basicInfo">
                <table>
                  <tbody>
                    <xsl:call-template name="Name"/>
                  </tbody>
                </table>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </xsl:template>
  <!--=============Template for displaying Name table============-->
  <xsl:template name="Name">
    <xsl:if test="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:personInPrimaryPosition/@rdf:resource]/prns:isPrimaryPosition !=''">
      <tr>
        <th>Title</th>
        <td>
          <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:personInPrimaryPosition/@rdf:resource]/vivo:hrJobTitle "/>
        </td>
      </tr>
    </xsl:if>
    <xsl:variable name="uriOrganization" select="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:personInPrimaryPosition/@rdf:resource]/vivo:positionInOrganization/@rdf:resource"/>
    <xsl:if test="rdf:RDF/rdf:Description[@rdf:about=$uriOrganization]/rdfs:label !=''">
      <tr>
        <th>Institution</th>
        <td>
          <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about= $uriOrganization]/rdfs:label"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:variable name="uriDepartment" select="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/prns:personInPrimaryPosition/@rdf:resource]/prns:positionInDepartment/@rdf:resource"/>
    <xsl:if test="rdf:RDF/rdf:Description[@rdf:about=$uriDepartment]/rdfs:label !=''">
      <tr>
        <th>Department</th>
        <td>
          <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=$uriDepartment]/rdfs:label "/>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/rdf:type/@rdf:resource !=''">
      <tr>
        <th>Address</th>
        <td>
          <span itemprop="address" itemscope="itemscope" itemtype="http://schema.org/PostalAddress">
            <span itemprop="streetAddress">
              <xsl:if test="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:address1 !=''">
                <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:address1 "/>
                <br/>
              </xsl:if>
              <xsl:if test="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:address2 !=''">
                <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:address2 "/>
                <br/>
              </xsl:if>
              <xsl:if test="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:address3 !=''">
                <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:address3 "/>
                <br/>
              </xsl:if>
              <xsl:if test="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:addressCity !=''">
                <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:addressCity"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:addressState"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/vivo:mailingAddress/@rdf:resource]/vivo:addressPostalCode"/>
                <br/>
              </xsl:if>
            </span>
          </span>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="rdf:RDF[1]/rdf:Description[1]/vivo:phoneNumber !=''">
      <tr>
        <th>Phone</th>
        <td>
          <span itemprop="telephone">
            <xsl:value-of select="rdf:RDF[1]/rdf:Description[1]/vivo:phoneNumber"/>
          </span>
        </td>
      </tr>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="rdf:RDF[1]/rdf:Description[1]/vivo:faxNumber !=''">
        <tr>
          <th>Fax</th>
          <td>
            <xsl:value-of select="rdf:RDF[1]/rdf:Description[1]/vivo:faxNumber"/>
          </td>
        </tr>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="$email!=''">
        <tr>
          <th>Email</th>
          <td>
            <img id="{$imgguid}" src="{$email}&amp;rnd={$imgguid}"></img>
          </td>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="rdf:RDF[1]/rdf:Description[1]/vivo:email !=''">
            <tr>
              <th>Email</th>
              <td>
                <a href="mailto:{rdf:RDF[1]/rdf:Description[1]/vivo:email}" itemprop="email">
                  <xsl:value-of select="rdf:RDF[1]/rdf:Description[1]/vivo:email"/>
                </a>
              </td>
            </tr>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
