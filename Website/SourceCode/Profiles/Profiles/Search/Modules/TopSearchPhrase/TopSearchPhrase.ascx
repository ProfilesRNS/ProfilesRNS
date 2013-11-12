<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TopSearchPhrase.ascx.cs"
    Inherits="Profiles.Search.Modules.TopSearchPhrase.TopSearchPhrase" %>

<script type="text/javascript">

    function searchThisPhrase(keyword,classuri,searchtype) {        
        document.location.href = '<%=GetURLDomain()%>/search/default.aspx?searchtype=' + searchtype + '&searchfor=' + keyword + '&exactphrase=false&classuri=' + classuri;
    }    
    
</script>

<div class="passiveSectionHead">
    <asp:Literal runat="server" ID="litDescription"></asp:Literal>
</div>
<div class="passiveSectionBody">
    <asp:Literal runat="server" ID="litTopSearchPhrase"></asp:Literal>
    <div class="passiveSectionLine" style="border-top:none">
    </div>
</div>


<div style="border: 1px solid #CCC;">
<p style="margin: 0; padding: 3px 8px 6px"><strong>Updates</strong></p>
<div style="">
<a class="twitter-timeline"  href="https://twitter.com/scctsi"  data-widget-id="353227474164936704" data-chrome="nofooter noborders noheader" data-tweet-limit="2">Updates by @ResidentsatCTSI</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
</div>
<p style="margin: 0; padding: 12px 8px 6px;text-align:center">
<a href="https://twitter.com/scctsi" class="twitter-follow-button" data-show-count="false">Follow @scctsi</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
</p>
</div>

<div class="tour"><a href="<%=GetURLDomain()%>/about/AboutUCSFProfiles.aspx">Tour Profiles <span>»</span></a></div>
