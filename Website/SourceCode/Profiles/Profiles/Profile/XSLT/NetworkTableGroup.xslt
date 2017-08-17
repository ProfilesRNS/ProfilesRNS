<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:geo="http://aims.fao.org/aos/geopolitical.owl#" xmlns:afn="http://jena.hpl.hp.com/ARQ/function#" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:obo="http://purl.obolibrary.org/obo/" xmlns:dcelem="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:event="http://purl.org/NET/c4dm/event.owl#" xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:vann="http://purl.org/vocab/vann/" xmlns:vitro07="http://vitro.mannlib.cornell.edu/ns/vitro/0.7#" xmlns:vitro="http://vitro.mannlib.cornell.edu/ns/vitro/public#" xmlns:vivo="http://vivoweb.org/ontology/core#" xmlns:pvs="http://vivoweb.org/ontology/provenance-support#" xmlns:scirr="http://vivoweb.org/ontology/scientific-research-resource#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:swvs="http://www.w3.org/2003/06/sw-vocab-status/ns#" xmlns:skco="http://www.w3.org/2004/02/skos/core#" xmlns:owl2="http://www.w3.org/2006/12/owl2-xml#" xmlns:skos="http://www.w3.org/2008/05/skos#" xmlns:foaf="http://xmlns.com/foaf/0.1/">
  <xsl:output method="html"/>
  <xsl:template match="/">
    <xsl:variable name="subjectID" select="LocalNetwork/NetworkPeople/NetworkPerson[@d='0']/@id"></xsl:variable>
    <xsl:variable name="subjectName">
      <xsl:value-of select="LocalNetwork/NetworkPeople/NetworkPerson[@d='0']/@fn"/>&#160;<xsl:value-of select="LocalNetwork/NetworkPeople/NetworkPerson[@d='0']/@ln"/>
    </xsl:variable>
    <xsl:variable name="subjectURI" select="LocalNetwork/NetworkPeople/NetworkPerson[@d='0']/@uri"></xsl:variable>
    <xsl:variable name="onehop">
      <xsl:text>-</xsl:text>
      <xsl:for-each select="LocalNetwork/NetworkPeople/NetworkPerson[@d='1']">
        <xsl:value-of select="@id" />
        <xsl:text>-</xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <br/>
    <br/>
    <b>
      Members
    </b>
    <br/><br/>
    <div class="listTable" style="margin-top: 12px, margin-bottom:8px ">
      <table>
        <tr>
          <th>Name</th>
          <th>Total Publications</th>
          <!--<th>Weight</th>-->
        </tr>
        <xsl:for-each select="LocalNetwork/NetworkPeople/NetworkPerson[@d='1']">
          <xsl:sort select="@w2" data-type="number" order="descending"/>
          <xsl:variable name="nodeId" select="@id"/>
          <xsl:variable name="uri" select="@uri"/>
          <xsl:variable name="w2" select="@w2"/>
          <tr>
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">
                <xsl:attribute name="class">
                  <xsl:value-of select="'evenRow'"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">
                  <xsl:value-of select="'oddRow'"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>

            <td style="text-align:left">
              <a href="{$uri}">
                <xsl:value-of select="@ln"/>,&#160;<xsl:value-of select="@fn"/>
              </a>
            </td>
            <td>
              <xsl:value-of select="@pubs"/>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </div>
    <br/>
    <br/>
    <b>Co-Author Connections</b>
    <br/>
    <br/>
    <div class="listTable" style="margin-top: 12px, margin-bottom:8px ">
      <table>
        <tr>
          <th>Person 1</th>
          <th>Person 2</th>
          <th>Number of Co-Publications</th>
          <th>Most Recent Co-Publication</th>
          <!--<th>Weight</th>-->
        </tr>
        <xsl:for-each select="LocalNetwork/NetworkCoAuthors/NetworkCoAuthor">
          <xsl:sort select="@n" data-type="number" order="descending"/>
          <xsl:variable name="lid1" select="@lid1"/>
          <xsl:variable name="uri1" select="@uri1"/>
          <xsl:variable name="lid2" select="@lid2"/>
          <xsl:variable name="uri2" select="@uri2"/>
          <xsl:variable name="id2" select="@id2"/>
          <xsl:variable name="n" select="@n"/>
          <xsl:variable name="y2" select="@y2"/>
          <xsl:variable name="w" select="@w"/>
          <tr>
            <xsl:choose>
              <xsl:when test="position() mod 2 = 0">
                <xsl:attribute name="class">
                  <xsl:value-of select="'evenRow'"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">
                  <xsl:value-of select="'oddRow'"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <td style="text-align:left">
              <a href="{$uri1}">
                <xsl:value-of select="/LocalNetwork/NetworkPeople/NetworkPerson[@lid=$lid1]/@ln"/>,&#160;<xsl:value-of select="/LocalNetwork/NetworkPeople/NetworkPerson[@lid=$lid1]/@fn"/>
              </a>
            </td>
            <td style="text-align:left">
              <a href="{$uri2}">
                <xsl:value-of select="/LocalNetwork/NetworkPeople/NetworkPerson[@lid=$lid2]/@ln"/>,&#160;<xsl:value-of select="/LocalNetwork/NetworkPeople/NetworkPerson[@lid=$lid2]/@fn"/>
              </a>
            </td>
            <td>
              <a href="{$uri1}/Network/CoAuthors/{$id2}">
                <xsl:value-of select="@n"/>
              </a>
            </td>
            <td>
              <xsl:value-of select="@y2"/>
            </td>
            <!--<td>
              <xsl:value-of select="@w"/>
            </td>-->
          </tr>
        </xsl:for-each>
      </table>
    </div>
  </xsl:template>
</xsl:stylesheet>