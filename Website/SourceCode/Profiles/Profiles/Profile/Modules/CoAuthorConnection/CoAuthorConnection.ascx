<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CoAuthorConnection.ascx.cs" Inherits="Profiles.Profile.Modules.CoAuthorConnection.CoAuthorConnection" %>
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

<div class="publications">
    <ol>
        <%  int first = 0;
            this.ConnectionDetails.ForEach(pub =>
            {
            first++;
        %>
        <li <%= (first==1) ? "class='first'" : "" %>>
            <%= pub.Description %>
            <div class='viewIn'>
                <span class="viewInLabel">View in</span>: <a href="//www.ncbi.nlm.nih.gov/pubmed/<%= pub.PMID %>" target="_blank">PubMed</a>
            </div>
            <div class='viewIn'>
                <span class="viewInLabel">Score</span>: <%= String.Format("{0:0.000}", pub.Score)%>
            </div>
        </li>
        <%  });
        %>
    </ol>
</div>
