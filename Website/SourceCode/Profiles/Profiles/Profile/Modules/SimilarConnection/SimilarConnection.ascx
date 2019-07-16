<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SimilarConnection.ascx.cs" Inherits="Profiles.Profile.Modules.SimilarConnection.SimilarConnection" %>
	
<div class="connectionTable">
    <div class="connectionTableRow">
        <div class="connectionContainerItem">
            <a href="<%= this.Subject.Uri%>"><%= this.Subject.Name %></a>
        </div>
        <div class="connectionContainerLeftArrow">
            <img style="vertical-align: unset;" src="<%=GetRootDomain()%>/Framework/Images/connection_left.gif" alt="" />
        </div>
        <div>
            <div class="connectionSubDescription">Connection Strength</div>
            <div class="connectionLineToArrow">
                <hr />
            </div>
            <div class="connectionSubDescription" style="position: relative;"><%= String.Format("{0:0.000}", this.ConnectionStrength) %></div>
        </div>
        <div class="connectionContainerRightArrow">
            <img style="vertical-align: unset;" src="<%=GetRootDomain()%>/Framework/Images/connection_right.gif" alt="" />
        </div>
        <div class="connectionContainerItem">
            <a href="<%= this.Object.Uri %>"><%= this.Object.Name %></a>
        </div>
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
			<tr class="<%= even_odd %>" onmouseover="doListTableRowOver(this);" onfocus="doListTableRowOver(this);" onmouseout="doListTableRowOut(this,<%= even_odd_flag %>);" onblur="doListTableRowOut(this,<%= even_odd_flag %>);" onclick="doGoMesh('<%= concept.ConceptProfile %>');" onkeypress="if (event.keyCode == 13) doGoMesh('<%= concept.ConceptProfile %>');" tabindex="0">
				<td class="alignLeft" style="text-align:left;">
					<div style="width:353px;"><%= concept.MeshTerm %></div>
				</td>
				<td onmouseover="doListTableCellOver(this);" onfocus="doListTableCellOver(this);" onmouseout="doListTableCellOut(this);" onblur="doListTableCellOut(this);" onclick="doListTableCellClick(this);doGoPersonMesh('<%= concept.Subject.ConceptConnectionURI %>');" onkeypress="if (event.keyCode == 13) doGoPersonMesh('<%= concept.Subject.ConceptConnectionURI %>');" tabindex="0">
					<div style="width: 68px; color: rgb(51, 102, 204);" class="listTableLink"><%= String.Format("{0:0.000}", concept.Subject.KeywordWeight) %></div>
				</td>
				<td onmouseover="doListTableCellOver(this);" onfocus="doListTableCellOver(this);" onmouseout="doListTableCellOut(this);" onblur="doListTableCellOut(this);" onclick="doListTableCellClick(this);doGoPersonMesh('<%= concept.Object.ConceptConnectionURI %>');" onkeypress="if (event.keyCode == 13) doGoPersonMesh('<%= concept.Object.ConceptConnectionURI %>');" tabindex="0">
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
