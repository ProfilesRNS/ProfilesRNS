<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ActivityHistory.ascx.cs"
    Inherits="Profiles.Activity.Modules.ActivityHistory.ActivityHistory" %>

<script type="text/javascript">
    var activitySize;

    $(document).ready(function () {
        if ("<%=FixedSize()%>") {
            $(".activities").css({ overflow: 'hidden' });
        }
        setInterval(function () { GetRecords(true) }, 30000);
    });

    function ScrollAlert() {
        var scrolltop = $('.clsScroll').attr('scrollTop');
        var scrollheight = $('.clsScroll').attr('scrollHeight');
        var windowheight = $('.clsScroll').attr('clientHeight');
        var scrolloffset = 20;
        if (scrolltop >= (scrollheight - (windowheight + scrolloffset))) {
            GetRecords(false);
        }
    }

    function GetRecords(newActivities) {
        var referenceActivityId = newActivities ? $(".act-id").first().text() : $(".act-id").last().text();
        // only set this the first time
        activitySize = activitySize || $(".act-id").length;
        $.ajax({
            type: "POST",
            url: "<%=GetURLDomain()%>/Activity/Modules/ActivityHistory/ActivityDetails.aspx/GetActivities",
            data: '{"referenceActivityId": "' + referenceActivityId + '", "count": "' + activitySize + '", "newActivities": "' + newActivities + '"}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {
                alert(response.d);
            },
            error: function (response) {
                alert(response.d);
            }
        });
    }

    function OnSuccess(response) {
        var activities = JSON.parse(response.d);
        // if we don't have any activities, bail now
        if (!activities.length) {
            // uncomment to test push from above during periods of no activity
            //$(".activities").height($(".activities").height());
            //$(".actTemplate").first().before('<div class="actTemplate" style="display:none">' + $(".actTemplate").last().html() + '</div>');
            //$(".actTemplate").first().slideDown("slow", function () {
            //    // now allow the height to go back to automatic
            //    $(".actTemplate").last().remove();
            //    $(".activities").height("auto");
            //});
            return;
        }
        $("#divStatus").show();
        var addToBottom = activities.length && activities[0].Id < $(".act-id").first().text();
        if (addToBottom) {
            // we want to invert the array so that we add the most recent one last
            activities.reverse();
        }
        $.each(activities, function (index, newActivity) {
            var activityTemplate = addToBottom ? $(".actTemplate").last().clone(true) : $(".actTemplate").first().clone(true);
            // bail if it is for the same person. Can only happen on a new fetch being stitched into the existing one
            // because each fetch is already declumped against itself
            if (activityTemplate.find("a").first().attr("href") == newActivity.Profile.URL) {
                return true;
            }
            activityTemplate.find("a").attr("href", newActivity.Profile.URL);
            activityTemplate.find(".act-image").find("img").attr("src", newActivity.Profile.Thumbnail);
            activityTemplate.find(".act-user").find("a").html(newActivity.Profile.Name);
            activityTemplate.find(".act-date").html(newActivity.Date);
            activityTemplate.find(".act-msg").html(newActivity.Message);
            activityTemplate.find(".act-id").text(newActivity.Id);
            if (addToBottom) {
                // add to the bottom
                $(".actTemplate").last().after('<div class="actTemplate">' + activityTemplate.html() + '</div>');
            }
            else {
                // if it is a fixed size, remove the last one to make room
                if ("<%=FixedSize()%>") {
                    // temporarily freeze the height so that things are less jarring
                    $(".activities").height($(".activities").height());
                }
                // prepend to the top and slide down
                $(".actTemplate").first().before('<div class="actTemplate" style="display:none">' + activityTemplate.html() + '</div>');
                $(".actTemplate").first().slideDown("slow", function () {
                    if ("<%=FixedSize()%>") {
                    $(".actTemplate").last().remove();
                    // now allow the height to go back to automatic
                    $(".activities").height("auto");
                }
            });
        }
        });
    $("#divStatus").hide();
}
</script>
<div class="activities">
    <div class="act-heading-live-updates">Recent Updates</div>
    <asp:Panel runat="server" ID="pnlActivities" CssClass="clsScroll">
        <asp:Repeater runat="server" ID="rptActivityHistory" OnItemDataBound="rptActivityHistory_OnItemDataBound">
            <ItemTemplate>
                <div class="actTemplate">
                    <div class="act">
                        <div class="act-body">
                            <div class="act-image">
                                <asp:HyperLink runat="server" ID="linkThumbnail"></asp:HyperLink>
                            </div>
                            <div class="act-userdate">
                                <div class="act-user">
                                    <asp:HyperLink runat="server" ID="linkProfileURL"></asp:HyperLink>
                                </div>
                                <div class="date">
                                    <asp:Literal runat="server" ID="litDate"></asp:Literal>
                                </div>
                            </div>
                            <div class="act-msg">
                                <asp:Literal runat="server" ID="litMessage"></asp:Literal>
                            </div>
                        </div>
                        <div class="act-id" style="display: none">
                            <asp:Literal runat="server" ID="litId"></asp:Literal>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>
</div>
<asp:HyperLink ID="linkSeeMore" runat="server" NavigateUrl="~/Activity/Modules/ActivityHistory/ActivityDetails.aspx"><img src="../Framework/Images/icon_squareArrow.gif" /> See more Activities</asp:HyperLink>
<div id="divStatus" style="display: none">
    <div class="loader">
        <span>
            <img alt="Loading..." id="loader" src="<%=GetURLDomain()%>/Edit/Images/loader.gif" width="400" height="213" /></span>
    </div>
</div>
