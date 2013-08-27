<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:output method="html"/>
  <xsl:key name="EntityList" match="Profile" use="@EntityID"/>
  <xsl:template match="/">
    
        <script type="text/javascript">
          <xsl:text disable-output-escaping="yes">
          var hasClickedListTable = false;
          function doListTableRowOver(x) {
          x.className = 'overRow';
          x.style.backgroundColor = '#5A719C';
          x.style.color = '#FFF';
          for (var i = 0; i &lt; x.childNodes.length; i++) {
          if (x.childNodes[i].childNodes.length > 0) {
          if (x.childNodes[i].childNodes[0].className == 'listTableLink') {
          x.childNodes[i].childNodes[0].style.color = '#FFF';
          }
          }
          }
          }
          function doListTableRowOut(x, eo) {
          if (eo == 1) {
          x.className = 'oddRow';
          x.style.backgroundColor = '#FFFFFF';
          } else {
          x.className = 'evenRow';
          x.style.backgroundColor = '#F0F4F6';
          }
          x.style.color = '';
          for (var i = 0; i &lt; x.childNodes.length; i++) {
          if (x.childNodes[i].childNodes.length > 0) {
          if (x.childNodes[i].childNodes[0].className == 'listTableLink') {
          x.childNodes[i].childNodes[0].style.color = '#36C';
          }
          }
          }
          }
          function doListTableCellOver(x) {
          x.className = 'listTableLinkOver';
          x.style.backgroundColor = '#36C';
          }
          function doListTableCellOut(x) {
          x.className = 'listTableLink';
          x.style.backgroundColor = '';
          }
          <!--function doListTableCellClick(x) {
          hasClickedListTable = true;
          }-->

		  function doKeywordSelect(x) {
		  
		  alert(x);
		  return null;
		  if (!hasClickedListTable) { document.location = '/profile/concept/' + x;}
		  }

		  function doRowClick(url) {
		  document.location = url;}
		  function doWhyClick(url) {
		  document.location = url;}
</xsl:text>
	  </script>
      <div class="tabInfoText">
		  <xsl:value-of select="DetailTable/@InfoCaption"/>
	  </div>
      <div class="listTable" style="margin-top: 12px, margin-bottom:12px ">
        <table id="thetable1">
          <tbody>
            <xsl:for-each select="DetailTable/Row[@type='header'] ">
              <tr class="evenRow">
                <xsl:for-each select="Column">
					<xsl:choose>
						<xsl:when test="position()=1">
							<th class="alignLeft">
								<xsl:value-of select="."/>
							</th>							
						</xsl:when>
						<xsl:otherwise>
							<th>
								<xsl:value-of select="."/>
							</th>							
						</xsl:otherwise>
					</xsl:choose>                  
                </xsl:for-each>
				  
              </tr>
            </xsl:for-each>
            <xsl:for-each select="DetailTable/Row[@type='data'] ">
              <xsl:choose>
                <xsl:when test="position() mod 2 = 0">
                  <tr class="evenRow" onmouseover="doListTableRowOver(this)" onmouseout="doListTableRowOut(this,0)" >
                    <xsl:for-each select="Column">
                      <xsl:choose>
                        <xsl:when test=".!='Why?'">
                          <xsl:choose>
                            <xsl:when test="position()=1">
                              <td style="text-align: left;" class="alignLeft" onclick="doRowClick('{../@url}')">
                                <xsl:value-of select="."/>
                              </td>
                            </xsl:when>
                            <xsl:otherwise>
                              <td onclick="doRowClick('{../@url}')">
                                <xsl:value-of select="."/>
                              </td>
                            </xsl:otherwise>
                          </xsl:choose>

                        </xsl:when>
                        <xsl:otherwise>
                          <td onclick="doWhyClick('{@url}')" onmouseout="doListTableCellOut(this)" onmouseover="doListTableCellOver(this)">
                            <div class="listTableLink" style="width: 38px;">
                              <xsl:value-of select="."/>
                            </div>
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>

                    </xsl:for-each>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr class="oddRow"  onmouseover="doListTableRowOver(this)" onmouseout="doListTableRowOut(this,1)" >
                    <xsl:for-each select="Column">
                      <xsl:choose>
                        <xsl:when test=".!='Why?'">
                          <xsl:choose>
                            <xsl:when test="position()=1">
                              <td style="text-align: left;" class="alignLeft" onclick="doRowClick('{../@url}')">
                                <xsl:value-of select="."/>
                              </td>
                            </xsl:when>
                            <xsl:otherwise>
                              <td onclick="doRowClick('{../@url}')">
                                <xsl:value-of select="."/>
                              </td>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <td onclick="doWhyClick('{@url}')" onmouseout="doListTableCellOut(this)" onmouseover="doListTableCellOver(this)">
                            <div class="listTableLink" style="width: 38px;">
                              <xsl:value-of select="."/>
                            </div>
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </tbody>
        </table>
      </div>
   
  </xsl:template>
</xsl:stylesheet>
