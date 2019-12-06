<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FeaturedPresentations.ascx.cs"Inherits="Profiles.Profile.Modules.CustomViewSocialMediaPlugins.FeaturedPresentations" %>


<div style="margin-top: 16px; width: 100%">
    <!-- ==================== START PROFILE VIEW =================== -->
    <div class="profile-view-slideshare">
        <div id="slideshow-canvas">
            <iframe src="" height="400"
                width="550"
                frameborder="0"
                marginwidth="0"
                marginheight="0" scrolling="no"
                style="border: 1px solid #CCC; border-width: 1px; margin-bottom: 5px; max-width: 100%;"
                allowfullscreen></iframe>
            <div style="margin-bottom: 5px; overflow: hidden;"></div>
        </div>
        <ul class="ss_list"></ul>
    </div>
</div>

<asp:Literal runat="server" ID="litjs"></asp:Literal>