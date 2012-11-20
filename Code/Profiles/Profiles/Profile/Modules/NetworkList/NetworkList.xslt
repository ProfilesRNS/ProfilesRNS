<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="totalCount" select="count(//Item)"/>
	<xsl:variable name="columns" select="ListView/@Columns"/>
	<xsl:variable name="style" select="ListView/@Bullet"/>
  <xsl:param name="Count">
		<xsl:choose>
			<xsl:when test="$totalCount mod $columns = 0">
				<xsl:value-of select="($totalCount div $columns) + 1"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="floor($totalCount div $columns) + 2"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
	<xsl:template match="/">
		<xsl:param name="Count2">
			<xsl:choose>
				<xsl:when test="$totalCount mod $columns = 0">
					<xsl:value-of select="(number(2)*floor($totalCount div $columns)) + 1"/>
				</xsl:when>
				<xsl:when test="$totalCount mod $columns = 1">
					<xsl:value-of select="(number(2)*floor($totalCount div $columns)) + 3"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="(number(2)*floor($totalCount div $columns)) + 3"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:if test="ListView/@InfoCaption!=''">
			<div class="tabInfoText">
				<xsl:value-of select="ListView/@InfoCaption"/>
			</div>
		</xsl:if>
		<table>
			<tbody>
				<xsl:choose>
					<xsl:when test="$columns = 1">
						<tr>
							<td>
								<xsl:choose>
									<xsl:when test="$style = 'decimal'">
										<ol style="list-style-type:decimal">
                      <xsl:apply-templates select="ListView/Item"/>
										</ol>
									</xsl:when>
									<xsl:when test="$style = 'disc'">
										<ul style="list-style-type:disc">
                      <xsl:apply-templates select="ListView/Item"/>
                    </ul>
									</xsl:when>
									<xsl:otherwise>
										<ul style="list-style-type:none;padding:0px;margin:0px;">
                      <xsl:apply-templates select="ListView/Item"/>
                    </ul>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:when>
					<xsl:when test="$columns = 2">
						<tr>
							<td valign="top" style="padding-right:25px">
								<xsl:choose>
									<xsl:when test="$style = 'decimal'">
										<ol style="list-style-type:decimal">
											<xsl:call-template name="column1"/>
										</ol>
									</xsl:when>
									<xsl:when test="$style = 'disc'">
										<ul style="list-style-type:disc">
											<xsl:call-template name="column1"/>
										</ul>
									</xsl:when>
									<xsl:otherwise>
										<ul style="list-style-type:none;padding:0px;margin:0px;">
											<xsl:call-template name="column1"/>
										</ul>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td valign="top" style="padding-right:25px">
								<xsl:choose>
									<xsl:when test="$style = 'decimal'">
										<ol style="list-style-type:decimal" id="test">
											<xsl:call-template name="column2"/>
										</ol>
									</xsl:when>
									<xsl:when test="$style = 'disc'">
										<ul style="list-style-type:disc">
											<xsl:call-template name="column2"/>
										</ul>
									</xsl:when>
									<xsl:otherwise>
										<ul style="list-style-type:none;padding:0px;margin:0px;">
											<xsl:call-template name="column2"/>
										</ul>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:when>
					<xsl:when test="$columns = 3">
						<tr>
							<td valign="top" style="padding-right:25px">
								<xsl:choose>
									<xsl:when test="$style = 'decimal'">
										<ol style="list-style-type:decimal">
											<xsl:call-template name="column1"/>
										</ol>
									</xsl:when>
									<xsl:when test="$style = 'disc'">
										<ul style="list-style-type:disc">
											<xsl:call-template name="column1"/>
										</ul>
									</xsl:when>
									<xsl:otherwise>
										<ul style="list-style-type:none;padding:0px;margin:0px;">
											<xsl:call-template name="column1"/>
										</ul>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td valign="top" style="padding-right:25px">
								<xsl:choose>
									<xsl:when test="$style = 'decimal'">
										<ol style="list-style-type:decimal" id="test">
											<xsl:call-template name="column2"/>
										</ol>
									</xsl:when>
									<xsl:when test="$style = 'disc'">
										<ul style="list-style-type:disc">
											<xsl:call-template name="column2"/>
										</ul>
									</xsl:when>
									<xsl:otherwise>
										<ul style="list-style-type:none;padding:0px;margin:0px;">
											<xsl:call-template name="column2"/>
										</ul>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td valign="top" style="padding-right:25px">
								<xsl:choose>
									<xsl:when test="$style = 'decimal'">
										<ol style="list-style-type:decimal" id="test2">
											<xsl:call-template name="column3"/>
										</ol>
									</xsl:when>
									<xsl:when test="$style = 'disc'">
										<ul style="list-style-type:disc">
											<xsl:call-template name="column3"/>
										</ul>
									</xsl:when>
									<xsl:otherwise>
										<ul style="list-style-type:none;padding:0px;margin:0px;">
											<xsl:call-template name="column3"/>
										</ul>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:when>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>
  
	<xsl:template match="ListView/Item">
		<xsl:choose>
			<xsl:when test="@Weight= 'small'">
				<li class="kwCloud0">
					<xsl:choose>
						<xsl:when test="@ItemURL!=''">
							<a href="{@ItemURL}">
								<xsl:value-of select="@ItemURLText"/>
							</a>
							<xsl:value-of select="."/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</li>	
			</xsl:when>
      <xsl:when test="@Weight='med'">
				<li class="kwCloud1">
					<xsl:choose>
						<xsl:when test="@ItemURL!=''">
							<a href="{@ItemURL}">
								<xsl:value-of select="@ItemURLText"/>
							</a>
							<xsl:value-of select="."/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</li>
			</xsl:when>
     <xsl:when test="@Weight='big'">
				<li class="kwCloud2">
					<xsl:choose>
						<xsl:when test="@ItemURL!=''">
							<a href="{@ItemURL}">
								<xsl:value-of select="@ItemURLText"/>
							</a>
							<xsl:value-of select="."/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</li>
			</xsl:when>
			<xsl:otherwise>
		<li>
			<xsl:choose>
				<xsl:when test="@ItemURL!=''">
					<a href="{@ItemURL}">
						<xsl:value-of select="@ItemURLText"/>
					</a>
          <xsl:value-of select="."/>
          <xsl:choose>
            <xsl:when test="@CoAuthor='true'">
              <font color="red" >*</font>
            </xsl:when>            
          </xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
          <xsl:choose>
            <xsl:when test="@CoAuthor='true'">
              <font color="red" >*</font>
            </xsl:when>
          </xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  
	<xsl:template name="column1">
		<xsl:choose>
			<xsl:when test="$totalCount mod $columns = 0">
				<xsl:variable name="Count" select="$totalCount div $columns"/>
				<xsl:apply-templates select="ListView/Item[position()&lt;=$Count]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="Count">
					<xsl:value-of select="floor($totalCount div $columns) + 1"/>
				</xsl:variable>
				<xsl:apply-templates select="ListView/Item[position()&lt;=$Count]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  
	<xsl:template name="column2">
		<xsl:choose>
			<xsl:when test="$totalCount mod $columns = 0">
				<xsl:variable name="Count" select="$totalCount div $columns"/>
				<xsl:variable name="Count2" select="(number(2)*floor($totalCount div $columns)) + 1"/>
				<xsl:apply-templates select="ListView/Item[position()&gt;$Count and position()&lt;$Count2 ]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="Count" select="floor($totalCount div $columns) + 1"/>
				<xsl:variable name="Count2" select="(number(2)*floor($totalCount div $columns)) + 2"/>
				<xsl:apply-templates select="ListView/Item[position()&gt;$Count and position()&lt;=$Count2 ]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  
	<xsl:template name="column3">
		<xsl:choose>
			<xsl:when test="$totalCount mod $columns = 0">
				<xsl:variable name="Count">
					<xsl:value-of select="(number(2)*floor($totalCount div $columns)) + 1"/>
				</xsl:variable>
				<xsl:apply-templates select="ListView/Item[position()&gt;=$Count]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="Count">
					<xsl:value-of select="(number(2)*floor($totalCount div $columns)) + 2"/>
				</xsl:variable>
				<xsl:apply-templates select="ListView/Item[position()&gt;$Count]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
