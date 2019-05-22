<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml EverythingResults_new.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:vivo="http://vivoweb.org/ontology/core#"
                exclude-result-prefixes="xsl fo xs fn prns rdf rdfs vivo">
  <xsl:output method="html"/>
  <xsl:param name="root"/>
  <xsl:param name="searchfor"/>
  <xsl:param name="exactphrase"/>
  <xsl:param name="perpage" select="number(15)"/>
  <xsl:param name="classGrpURIpassedin"/>
  <xsl:param name="classURIpassedin"/>
  <xsl:param name="total"/>
  <xsl:template match="/">
    <div class="passiveSectionHead">
      <xsl:text>Filter by Type</xsl:text>
    </div>
    <div class="passiveSectionBody" style="margin-top: 6px;">
      <xsl:variable name="allURL">
        
        <xsl:value-of select="$root"/><![CDATA[/Search/Default.aspx?searchtype=everything&searchfor=]]><xsl:value-of select="$searchfor"/><![CDATA[&exactphrase=]]><xsl:value-of select="$exactphrase"/><![CDATA[&perpage=15&offset=]]>
      </xsl:variable>
      <ul>
        <li>
          <xsl:choose>
            <xsl:when test="$classGrpURIpassedin=''">
              <a href="{$allURL}" id="type" style="color:#888">
				  <strong>
					  <xsl:value-of select="'All'"/>
				  </strong>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <a href="{$allURL}"  id="type">
                <xsl:value-of select="'All'"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="$total"/>
          <xsl:text>)</xsl:text>
        </li>
      </ul>
      <xsl:for-each select="rdf:RDF/rdf:Description/vivo:overview/prns:matchesClassGroupsList/prns:matchesClassGroup">
        <xsl:variable name="classGrpURI" select="@rdf:resource"/>
        <xsl:variable name="typeURL">
          <xsl:value-of select="$root"/><![CDATA[/Search/Default.aspx?searchtype=everything&searchfor=]]><xsl:value-of select="$searchfor"/><![CDATA[&exactphrase=]]><xsl:value-of select="$exactphrase"/><![CDATA[&ClassGroupURI=]]><xsl:value-of select="translate($classGrpURI, '#','!')"/><![CDATA[&perpage=15&offset=]]>
        </xsl:variable>
        <ul>
          <li>
            <xsl:choose>
              <xsl:when test="$classGrpURI !=$classGrpURIpassedin">
                <a href="{$typeURL}" id="type">
                  <xsl:value-of select="rdfs:label"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$typeURL}" style="color:#888" id="type">
					<strong>
						<xsl:value-of select="rdfs:label"/>
					</strong>
                </a>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="prns:numberOfConnections"/>
            <xsl:text>)</xsl:text>
          </li>
        </ul>
      </xsl:for-each>

    </div>
    <div>
      <div class="passiveSectionLine"></div>
    </div>
   
  </xsl:template>
</xsl:stylesheet>
