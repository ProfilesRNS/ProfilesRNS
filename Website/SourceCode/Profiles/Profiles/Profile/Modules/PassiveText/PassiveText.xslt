<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:output method="html"/>
  <xsl:template match="/">
    <div class="passiveSectionHead">
      <xsl:value-of select="PassiveText/@Title"/>
    </div>
    <br/>
     <div class="passiveSectionBody">
      <xsl:value-of select="PassiveText/@Text"/>
    </div>
  </xsl:template>
</xsl:stylesheet>
