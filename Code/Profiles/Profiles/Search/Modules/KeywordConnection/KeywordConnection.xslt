<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="html"/>
	<xsl:param name="root"/>
	<xsl:template match="/">
		
		<html>
			<head>
				<script type="text/javascript">

          function myGetElementById(id)
          {
          if (document.getElementById)
          var returnVar = document.getElementById(id);
          else if (document.all)
          var returnVar = document.all[id];
          else if (document.layers)
          var returnVar = document.layers[id];
          return returnVar;
          }

          function NavToProfile(root,nodeid) {
          document.location =  root + '/display/' + nodeid ;}

          function NavToResults(root,queryid) {
          document.location =  root + '/search/people/results/' + queryid ;}

        </script>
			</head>
			<body>
				<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
				<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
				<div class="connectionContainer">
					<table class="connectionContainerTable">
						<tbody>
							<tr>
								<td class="connectionContainerItem">
									<div>
										
										<a href="JavaScript:NavToResults('{$root}','{PersonList/@QueryID}')">
											<xsl:value-of select="'Search Results'"/>
										</a>
									</div>
									<div class="connectionItemSubText">
										<xsl:value-of select="PersonList/Person/PublicationList/Publication/PublicationMatchDetailList/PublicationMatchDetail/@SearchPhrase[1]"/> 
									</div>
								</td>
								<td class="connectionContainerArrow">
									<table class="connectionArrowTable">
										<tbody>
											<tr>
												<td/>
												<td>
													<div class="connectionDescription">
														<xsl:value-of select="PersonList/Person/BasicStatistics/MatchingPublicationCount"/> Matching Publications
													</div>
												</td>
												<td/>
											</tr>
											<tr>
												<td class="connectionLine">
													<img src="{$root}/Framework/Images/connection_left.gif"/>
												</td>
												<td class="connectionLine">
													<div/>
												</td>
												<td class="connectionLine">
													<img src="{$root}/Framework/Images/connection_right.gif"/>
												</td>
											</tr>
											<tr>
												<td/>
												<td>
													<div class="connectionSubDescription">
														Connection Strength = <xsl:value-of select="PersonList/Person/BasicStatistics/MatchScore"/>
													</div>
												</td>
												<td/>
											</tr>
										</tbody>
									</table>
								</td>
								<td class="connectionContainerItem">
									<div>
										
										<a href="JavaScript:NavToProfile('{$root}','{PersonList/Person/InternalIDList/InternalID[@Name='NodeID']}')">
											<xsl:value-of select="//FullName"/>
										</a>
									</div>
									<div class="connectionItemSubText">
										<xsl:value-of select="PersonList/Person/BasicStatistics/PublicationCount"/> Total Publications
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<script>
					

					function doShowHidePhraseDetails(n,m) {
					var p = myGetElementById('phraseScore_'+n);
					var q;
					if (p.style.display == 'block') {
					p.style.display = 'none';
					for (var i = 0; i &lt; m; i++) {
					q = myGetElementById('publicationScore_'+n+'_'+i);
					q.style.display = 'none';
				}
			} else {
				p.style.display = 'block';
				for (var i = 0; i &lt; m; i++) {
					q = myGetElementById('publicationScore_'+n+'_'+i);
					q.style.display = 'block';
				}

			}
		}

					function doShowHidePubScoreDetails(n)
					{
					var p = myGetElementById('publicationScoreDetails_'+n);
					if (p.style.display == 'block')
					{	p.style.display = 'none';}
					else
					{p.style.display = 'block';}
					}

					function doHoverOver(x,n,s)
					{
					var p = myGetElementById('publicationScoreDetailsDescription_'+n);
					p.innerHTML = s;
					x.style.backgroundColor = '#E7EEFF';
					}

					function doHoverOut(x,n)
					{
					var p = myGetElementById('publicationScoreDetailsDescription_'+n);
					p.innerHTML = 'Move your mouse over highighted numbers for more information.';
					x.style.backgroundColor = '';
					}
				</script>
				<div class="connectionSearchPhraseHeading connectionFirstSearchPhrase">
					
					Publications matching phrase: <span class="connectionSearchPhraseText">
						<xsl:value-of select="PersonList/Person/PublicationList/Publication/PublicationMatchDetailList/PublicationMatchDetail/@SearchPhrase[1]"/>
					</span>
				</div>
				<div class="connectionSearchPhraseInfo">
					Search phrase match score = <a href="JavaScript:doShowHidePhraseDetails(0,256);">
						<xsl:value-of select="PersonList/Person/BasicStatistics/MatchScore"/>
					</a><div class="phraseScoreDetails" id="phraseScore_0">
						The total match score for this search phrase is the sum of the match scores for each of the publications below. (<a href="JavaScript:doShowHidePhraseDetails(0,256);">hide</a>)
					</div>
				</div>
				<div class="publications">
					<ol>
						<xsl:for-each select="PersonList/Person/PublicationList/Publication">
							<li>
								<xsl:value-of select="PublicationReference"/>
								<div class="viewIn">
									<span class="viewInLabel">View in</span>: <a target="_blank" href="{PublicationSourceList/PublicationSource/@URL}">
										<xsl:value-of select="PublicationSourceList/PublicationSource/@Name"/>
									</a>
								</div>
								<xsl:variable name="position" select="position()"/>
								<!--<div id="publicationScore_{$position}" style="display: block;" class="viewIn publicationScore">
									<span class="viewInLabel">Score</span>: <a href="JavaScript:doShowHidePubScoreDetails('{$position}');">
										<xsl:value-of select="'Data Missing in XML'"/>
									</a>
									<div id="publicationScoreDetails_{$position}" class="publicationScoreDetails">
										The score for this publication (the overall weight) is the product of each of the individual weights. (<a href="JavaScript:doShowHidePubScoreDetails('{$position}');">hide</a>)<table class="publicationScoreDetailsCoAuthor" style="width: 100%;">
											<tbody>
												<tr>
													<th>
														Author 1<br>Weight</br>
													</th>
													<th>
														Author 2<br>Weight</br>
													</th>
													<th>
														Year<br>Weight</br>
													</th>
													<th>
														Overall<br>(Product)</br>
													</th>
												</tr>
												<tr>
													<td class="publicationScoreDetailsSpacer" colspan="4">
														<div/>
													</td>
												</tr>
												<tr>
													<td onmouseout="doHoverOut(this,{$position});" onmouseover="doHoverOver(this,{$position},'{AuthorWeight1/@AuthorPosition}');">
														<xsl:value-of select="AuthorWeight1"/>
													</td>
													<td onmouseout="doHoverOut(this,{$position});" onmouseover="doHoverOver(this,{$position},'{AuthorWeight2/@AuthorPosition}');">
														<xsl:value-of select="AuthorWeight2"/>
													</td>
													<td onmouseout="doHoverOut(this,{$position});" onmouseover="doHoverOver(this,{$position},'Published in {Year}');">
														<xsl:value-of select="YearWeight"/>
													</td>
													<td class="pubScoreDetailsOverall">
														<xsl:value-of select="Score"/>
													</td>
												</tr>
											</tbody>
										</table>
										<div id="publicationScoreDetailsDescription_{$position}" class="publicationScoreDetailsDescription">Move your mouse over highighted numbers for more information.</div>
										<div class="pubScoreDetailsKey">
											<table>
												<tbody>
													<tr>
														<th>Author Weight</th>
														<td>Whether the person was the first, middle, or senior author of the publication (max = 1).</td>
													</tr>
													<tr>
														<th>Year Weight</th>
														<td>How long ago the publication was written (0.5^(age in years/10)).</td>
													</tr>
													<tr>
														<th>Overall (Product)</th>
														<td>The overall weight given to this publication (product of individual weights).</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>-->
							</li>
						</xsl:for-each>
						<script type="text/javascript">
							document.getElementsByTagName("li")[0].className += "first";
						</script>
					</ol>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
