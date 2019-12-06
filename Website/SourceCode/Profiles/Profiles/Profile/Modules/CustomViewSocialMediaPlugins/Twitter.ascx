<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Twitter.ascx.cs" Inherits="Profiles.Profile.Modules.CustomViewSocialMediaPlugins.Twitter" %>

<script type="text/JavaScript">
    Twitter = {
        init: function (username) {          
            $("div#twitter-link").html('');
            $("div#twitter-link").append("<a data-height='150' data-width='440' class='twitter-timeline' data-tweet-limit='1' href='https://twitter.com/" + username + "'>Tweets by " + username + "</a>");
        }
    }

</script>
<style>
    .twitter-timeline {
        width:400px;
    }
</style>
<div id="twitter-link">    
</div>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
<asp:Literal runat="server" ID="litjs"></asp:Literal>