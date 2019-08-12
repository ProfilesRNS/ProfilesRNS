<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MainMenu.ascx.cs" Inherits="Profiles.Framework.Modules.MainMenu.MainMenu" %>
<%@ Register TagName="History" TagPrefix="HistoryItem" Src="~/Framework/Modules/MainMenu/History.ascx" %>
<%@ Register TagName="Lists" TagPrefix="MyLists" Src="~/Framework/Modules/MainMenu/MyLists.ascx" %>
<div id="prns-nav">
    <!-- MAIN NAVIGATION MENU -->
    <nav>
        <ul class="prns-main">
            <li class="main-nav">
                <a href="<%=ResolveUrl("~/search")%>">Home</a>
            </li>
            <li class="main-nav">
                <a href='#'>About</a>
                <ul class="drop">
                    <li>
                        <a id="about" style="border-left: 1px solid  #999; border-right: 1px solid  #999; border-bottom: 1px solid #999; width: 200px !important" href="<%=ResolveUrl("~/about/default.aspx?tab=overview")%>">Overview</a>
                    </li>
                    <li>
                        <a id="data" style="border-left: 1px solid  #999; border-right: 1px solid  #999; border-bottom: 1px solid #999; width: 200px !important" href="<%=ResolveUrl("~/about/default.aspx?tab=data")%>">Sharing Data</a>
                    </li>
                    <li>
                        <a id="orcid" style="border-left: 1px solid  #999; border-right: 1px solid  #999; border-bottom: 1px solid #999; width: 200px !important" href="<%=ResolveUrl("~/about/default.aspx?tab=orcid")%>">ORCID</a>
                    </li>
                </ul>

            </li>
            <li class="main-nav">
                <a href="<%=ResolveUrl("~/about/default.aspx?tab=faq")%>">Help</a>
            </li>
            <%-- <li class="main-nav">
                <a href="<%=ResolveUrl("~/about/default.aspx?type=UseOurData")%>">Use Our Data</a>
                <ul class="drop">
                    <li>
                        <a id="useourdata" style="border-left: 1px solid  #383737; border-right: 1px solid  #383737; border-bottom: 1px solid #383737; width: 200px !important" href="<%=ResolveUrl("~/about/default.aspx?type=UseOurData")%>">Overview</a>
                    </li>
                    <asp:Literal runat="server" ID="litExportRDF"></asp:Literal>
                </ul>
            </li>--%>
            <HistoryItem:History runat="server" ID="ProfileHistory" Visible="true" />
            <li class="search main-nav" style="width: 492px;">
                <input name="search" id="menu-search" placeholder="Search Profiles (people, publications, concepts, etc.)" type="text" style="padding-left: 5px;" />
                <img style="cursor: pointer" alt="search" id="img-mag-glass" src="<%=ResolveUrl("~/framework/images/blackMagnifyGlass.png")%>" />
            </li>
            <li id="search-drop" class="last main-nav" style="float: right !important; width: 25px;">
                <a href="#" style="padding: 0px; padding-top: 9px; margin: 0px;">
                    <img src="<%=ResolveUrl("~/framework/images/arrowDown.png") %>" /></a>
                <ul class="drop" style="top: 39px; left: 835px;">
                    <asp:Literal runat="server" ID="litSearchOptions"></asp:Literal>
                </ul>
            </li>
        </ul>
        <!-- USER LOGIN MSG / USER FUNCTION MENU -->
        <div id="prns-usrnav" class="pub" class-help="class should be [pub|user]">
            <div class="loginbar">
                <asp:Literal runat="server" ID="litLogin"></asp:Literal>
            </div>
            <!-- SUB NAVIGATION MENU (logged on) -->
            <ul class="usermenu">
                <asp:Literal runat="server" ID="litViewMyProfile"></asp:Literal>
                <li style="margin-top: 0px !important;">
                    <div class="divider"></div>
                </li>
                <asp:Literal runat="server" ID="litEditThisProfile"></asp:Literal>
                <li>
                    <div class="divider"></div>
                </li>
                <asp:Literal runat="server" ID="litProxy"></asp:Literal>               
                <li id="ListDivider">
                    <div class="divider"></div>
                </li>
                <%--<li id="navMyLists">
                   <a href="#">My Person List (<span id="list-count">0</span>)</a>
                    <MyLists:Lists runat="server" ID="MyLists" Visible="false" />
                </li>
                 <li>
                    <div class="divider"></div>
                </li>--%>
              <%--  <li>
                    <asp:Literal ID="litDashboard" runat="server" /></li>
                <li>
                    <div class="divider"></div>
                </li>--%>
                <asp:Literal runat="server" ID="litGroups"></asp:Literal>
                <li id="groupListDivider" visible="false" runat="server">
                    <div class="divider"></div>
                </li>
                <asp:Literal runat="server" ID="litLogOut"></asp:Literal>
            </ul>
        </div>
    </nav>
</div>

<asp:Literal runat="server" ID="litJs"></asp:Literal>
<script type="text/javascript">

    $(function () {
        setNavigation();
    });

    function setNavigation() {
        var path = $(location).attr('href');
        path = path.replace(/\/$/, "");
        path = decodeURIComponent(path);

        $(".prns-main li").each(function () {

            var href = $(this).find("a").attr('href');
            var urlParams = window.location.search;

            if ((path + urlParams).indexOf(href) >= 0) {
                $(this).addClass('landed');
            }
        });


        return true;
    }
    $(document).ready(function () {
        $("#menu-search").on("keypress", function (e) {
            if (e.which == 13) {
                minisearch();
                return false;
            }
            return true;
        });

        $("#img-mag-glass").on("click", function () {
            minisearch();
            return true;
        });
    });
    function minisearch() {
        var keyword = $("#menu-search").val();
        var classuri = 'http://xmlns.com/foaf/0.1/Person';
        document.location.href = '<%=ResolveUrl("~/search/default.aspx")%>?searchtype=people&searchfor=' + keyword + '&classuri=' + classuri;
        return true;
    }

</script>


