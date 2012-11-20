<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ConceptConnection.ascx.cs" Inherits="Profiles.Profile.Modules.ConceptConnection.ConceptConnection" %>

	
	<div class="content_container">					
				
		<div class="connectionContainer">
			<table class="connectionContainerTable">
			<tbody><tr>
			<td class="connectionContainerItem">
				<div><a href="<%= this.Subject.Uri%>"><%= this.Subject.Name %></a></div>
				<%--<div class="connectionItemSubText">25 Total Publications</div>--%>
			</td>
			<td class="connectionContainerArrow">
				<table class="connectionArrowTable">
				<tbody><tr>
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
				</tbody></table>
			</td>
			<td class="connectionContainerItem">
				<div><a href="<%= this.Object.Uri %>"><%= this.Object.Name %></a></div>
				<%--<div class="connectionItemSubText">229 Total Publications</div>--%>
			</td>
			</tr>
			</tbody></table>
		</div>
	</div>	
	
	<div class="publications">
		<ol>
		<%
			int first = 0;
			this.ConnectionDetails.ForEach(pub => {		
				first ++;
		%>
			<li <%= (first==1) ? "class='first'" : "" %> >
				<%= pub.Description %>	
				<div class='viewIn'>
					<span class="viewInLabel">View in</span>: <a href="http://www.ncbi.nlm.nih.gov/pubmed/<%= pub.PMID %>" target="_blank">PubMed</a>			
				</div>
				<div class='viewIn'>
					<span class="viewInLabel">Score</span>: <%= String.Format("{0:0.000}", pub.Score)%>
				</div>
			</li>
		<%
			});
		%>
		</ol>
	</div>
