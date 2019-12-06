<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FeaturedVideos.ascx.cs" EnableTheming="true"
    Inherits="Profiles.Profile.Modules.CustomViewSocialMediaPlugins.FeaturedVideos" %>
<div class="youtube">			
  <div class="yt_div">
    <iframe class="yt_player" 
            frameborder="0" allowfullscreen="1" 
            allow="autoplay; encrypted-media; picture-in-picture" 
            sandbox="allow-scripts allow-same-origin allow-presentation allow-popups allow-popups-to-escape-sandbox"
            width="500" height="400"               
            src="https://www.youtube.com/embed/e?autoplay=0&amp;enablejsapi=1&amp;version=3&amp;showinfo=1&amp;&rel=0">
    </iframe>
  </div>
  <ul class="yt_list">
  </ul>
</div>

<asp:Literal runat="server" ID="litjs" />







