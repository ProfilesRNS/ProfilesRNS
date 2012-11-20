<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TopSearchPhrase.ascx.cs"
    Inherits="Profiles.Search.Modules.TopSearchPhrase.TopSearchPhrase" %>

<script type="text/javascript">

    function searchThisPhrase(keyword,classuri,searchtype) {        
        document.location.href = '<%=GetURLDomain()%>/search/default.aspx?searchtype=' + searchtype + '&searchfor=' + keyword + '&classuri=' + classuri;
    }    
    
</script>

<div class="passiveSectionHead">
    <asp:Literal runat="server" ID="litDescription"></asp:Literal>
</div>
<div class="passiveSectionBody">
    <asp:Literal runat="server" ID="litTopSearchPhrase"></asp:Literal>
    <div class="passiveSectionLine">
    </div>
</div>
