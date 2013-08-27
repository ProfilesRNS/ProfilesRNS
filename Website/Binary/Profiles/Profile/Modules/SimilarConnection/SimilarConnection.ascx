<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SimilarConnection.ascx.cs" Inherits="Profiles.Profile.Modules.SimilarConnection.SimilarConnection" %>
	
	<div class="content_container">					
		<div class="connectionContainer">
			<table class="connectionContainerTable">
			<tbody>
			<tr>
				<td class="connectionContainerItem">
					<div><a href="<%= this.Subject.Uri%>"><%= this.Subject.Name %></a></div>
					<%--<div class="connectionItemSubText">25 Total Publications</div>--%>
				</td>
				<td class="connectionContainerArrow">
					<table class="connectionArrowTable">
					<tbody>
					<tr>
						<td>&nbsp;</td>
						<td><div class="connectionSubDescription">Connection Strength</div></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="connectionLine"><img src="<%= this.GetRootDomain() %>/Framework/Images/connection_left.gif"></td>
						<td class="connectionLine"><div>&nbsp;</div></td>
						<td class="connectionLine"><img src="<%= this.GetRootDomain() %>/Framework/Images/connection_right.gif"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><div class="connectionSubDescription"><%= String.Format("{0:0.000}", this.ConnectionStrength) %></div></td>
						<td>&nbsp;</td>
					</tr>
					</tbody>
					</table>
				</td>
				<td class="connectionContainerItem">
					<div><a href="<%= this.Object.Uri %>"><%= this.Object.Name %></a></div>
					<%--<div class="connectionItemSubText">229 Total Publications</div>--%>
				</td>
			</tr>
			</tbody>
			</table>
		</div>
	</div>	
	<script type="text/javascript">
		function doGoMesh(uri) {
			if (!hasClickedListTable) {
				document.location = uri;
			}
		}
		function doGoPersonMesh(uri) {
			document.location = uri;
		}
	</script>
	<div class="listTable" style="margin-top:12px;margin-bottom:8px;">
		<table>
			<tbody>
			<tr>
				<th style="width:365px;" class="alignLeft">Concept</th>
				<th style="width:80px;">Person 1</th>
				<th style="width:80px;">Person 2</th>
				<th style="width:80px;">Score</th>
			</tr>
			<%
			// Write concept rows
			int cnt = 11;
			this.ConnectionDetails.ForEach(concept => {		
			
				string even_odd = (cnt % 2 == 0) ? "evenRow" : "oddRow";
				int even_odd_flag = (cnt % 2 == 0) ? 0 : 1;
				cnt++;
			%>				
			<tr class="<%= even_odd %>" onmouseover="doListTableRowOver(this);" onmouseout="doListTableRowOut(this,<%= even_odd_flag %>);" onclick="doGoMesh('<%= concept.ConceptProfile %>');">
				<td class="alignLeft" style="text-align:left;">
					<div style="width:353px;"><%= concept.MeshTerm %></div>
				</td>
				<td onmouseover="doListTableCellOver(this);" onmouseout="doListTableCellOut(this);" onclick="doListTableCellClick(this);doGoPersonMesh('<%= concept.Subject.ConceptConnectionURI %>');">
					<div style="width: 68px; color: rgb(51, 102, 204);" class="listTableLink"><%= String.Format("{0:0.000}", concept.Subject.KeywordWeight) %></div>
				</td>
				<td onmouseover="doListTableCellOver(this);" onmouseout="doListTableCellOut(this);" onclick="doListTableCellClick(this);doGoPersonMesh('<%= concept.Object.ConceptConnectionURI %>');">
					<div class='listTableLink' style="width: 68px; color: rgb(51, 102, 204); "><%= String.Format("{0:0.000}", concept.Object.KeywordWeight) %></div>
				</td>
				<td><div style="width:68px;"><%= String.Format("{0:0.000}", concept.OverallWeight) %></div></td>
			</tr>
			<%
				});
			%>
			</tbody>
		</table>	
	</div>
