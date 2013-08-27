<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="html"/>
	<xsl:variable name="totalCount" select="count(//@Category)"/>
	<xsl:template match="/">
    <div class="tabInfoText">
      <xsl:value-of select="Items/@InfoCaption"/>
    </div>
    <div class="keywordCategories">
			<table>
				<tr>
					<td valign="top">
						<xsl:call-template name="column1"/>
					</td>
					<td valign="top">
						<xsl:call-template name="column2"/>
					</td>
					<td valign="top">
						<xsl:call-template name="column3"/>
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<xsl:template name="column1">
		<xsl:choose>
			<xsl:when test="$totalCount mod 3 = 0">
				<xsl:variable name="Count" select="$totalCount div 3"/>
				<xsl:for-each select="Items/DetailList[position()&lt;=$Count]">
					<div class="kwsg">
						<xsl:value-of select="@Category"/>
					</div>
					<div class="kwsgbox">
            <ul>
              <xsl:for-each select="Item[position()&lt;=10]">
                
                <li>
                  <a href="{@URL}">
                  <xsl:value-of select="."/>
                </a>
                </li>
              </xsl:for-each>
            </ul>
					</div>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="Count">
					<xsl:value-of select="floor($totalCount div 3) + 1"/>
				</xsl:variable>
				<xsl:for-each select="Items/DetailList[position()&lt;=$Count]">
					<div class="kwsg">
						<xsl:value-of select="@Category"/>
					</div>
					<div class="kwsgbox">
            <ul>
              <xsl:for-each select="Item[position()&lt;=10]">
                
                <li>
                  <a href="{@URL}">
                    <xsl:value-of select="."/>
                  </a>
                </li>
              </xsl:for-each>
            </ul>
					</div>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="column2">
		<xsl:choose>
			<xsl:when test="$totalCount mod 3 = 0">
				<xsl:variable name="Count" select="$totalCount div 3"/>
				<xsl:variable name="Count2" select="(number(2)*floor($totalCount div 3)) + 1"/>
				<xsl:for-each select="Items/DetailList[position()&gt;$Count and position()&lt;$Count2 ]">
					<div class="kwsg">
						<xsl:value-of select="@Category"/>
					</div>
					<div class="kwsgbox">
            <ul>
						<xsl:for-each select="Item[position()&lt;=10]">            
              <li>
                <a href="{@URL}">
                  <xsl:value-of select="."/>
                </a>
              </li>
						</xsl:for-each>
            </ul>
					</div>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="Count" select="floor($totalCount div 3) + 1"/>
				<xsl:variable name="Count2" select="(number(2)*floor($totalCount div 3)) + 2"/>
				<xsl:for-each select="Items/DetailList[position()&gt;$Count and position()&lt;$Count2 ]">
          
					<div class="kwsg">
						<xsl:value-of select="@Category"/>
					</div>
					<div class="kwsgbox">
            <ul>
						<xsl:for-each select="Item[position()&lt;=10]">
              
              <li><a href="{@URL}">
								<xsl:value-of select="."/>
							</a>
              </li>
						</xsl:for-each>
            </ul>
					</div>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="column3">
		<xsl:choose>
			<xsl:when test="$totalCount mod 3 = 0">
				<xsl:variable name="Count">
					<xsl:value-of select="(number(2)*floor($totalCount div 3)) + 1"/>
				</xsl:variable>
				<xsl:for-each select="Items/DetailList[position()&gt;=$Count]">
					<div class="kwsg"><xsl:value-of select="@Category"/>
				</div>
					<div class="kwsgbox">
            <ul>
						<xsl:for-each select="Item[position()&lt;=10]">
              
              <li><a href="{@URL}">
								<xsl:value-of select="."/>
							</a>
              </li>
						</xsl:for-each>
            </ul>
					</div>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="Count">
					<xsl:value-of select="(number(2)*floor($totalCount div 3)) + 2"/>
				</xsl:variable>
				<xsl:for-each select="Items/DetailList[position()&gt;=$Count]">
					<div class="kwsg">
						<xsl:value-of select="@Category"/>
					</div>
					<div class="kwsgbox">
            <ul>
						<xsl:for-each select="Item[position()&lt;=10]">
              
              <li><a href="{@URL}">
								<xsl:value-of select="."/>
							</a>
              </li>
						</xsl:for-each>
            </ul>
					</div>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
