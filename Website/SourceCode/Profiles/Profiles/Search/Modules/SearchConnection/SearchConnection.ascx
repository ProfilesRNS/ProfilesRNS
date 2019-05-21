<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchConnection.ascx.cs"
    Inherits="Profiles.Search.Modules.SearchConnection" %>

<div class="connectionTable">
    <div class="connectionTableRow">
        <div class="connectionContainerItem">
            <asp:Literal runat="server" ID="litSearchURL"></asp:Literal>
        </div>
        <div class="connectionContainerLeftArrow">
            <img style="vertical-align: unset;" src="<%=GetURLDomain()%>/Framework/Images/connection_left.gif" alt="" />
        </div>
        <div class="connectionLineToArrow">
            <hr />
        </div>
        <div class="connectionContainerRightArrow">
            <img style="vertical-align: unset;" src="<%=GetURLDomain()%>/Framework/Images/connection_right.gif" alt="" />
        </div>
        <div class="connectionContainerItem">
            <asp:Literal runat="server" ID="litNodeURI"></asp:Literal>
        </div>
    </div>
</div>
<asp:Panel runat="server" ID="pnlDirectConnection" Visible="false">
    <div style="padding-top: 12px; padding-bottom: 12px;">
        One or more keywords matched the following properties of
        <asp:Literal runat="server" ID="litPersonURI"></asp:Literal>
    </div>
    <div>
        <asp:GridView Width="100%" ID="gvConnectionDetails" AutoGenerateColumns="false" GridLines="Both"
            CellSpacing="-1" runat="server" OnRowDataBound="gvConnectionDetails_OnRowDataBound" CssClass="listTable">
            <HeaderStyle CssClass="topRow" BorderStyle="None" />
            <RowStyle CssClass="oddRow"/>
            <AlternatingRowStyle CssClass="evenRow" />
            <Columns>
                <asp:TemplateField HeaderText="Property"
                    HeaderStyle-Width="200px">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litProperty"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Value">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litValue"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Panel>
<asp:Panel runat="server" ID="pnlIndirectConnection" Visible="false">
    <div style="padding-top: 12px; padding-bottom: 12px;">
        One or more keywords matched the following items that are connected to
        <asp:Literal runat="server" ID="litSubjectName"></asp:Literal>
    </div>
    <div>
        <asp:GridView Width="100%" ID="gvIndirectConnectionDetails" AutoGenerateColumns="false"
            GridLines="Both" CellSpacing="-1" runat="server" OnRowDataBound="gvIndirectConnectionDetails_OnRowDataBound" CssClass="listTable">
            <HeaderStyle CssClass="topRow" BorderStyle="None" />
            <RowStyle CssClass="oddRow" />
            <AlternatingRowStyle CssClass="evenRow"/>
            <Columns>
                <asp:TemplateField HeaderText="Item Type"
                    HeaderStyle-Width="200px">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litProperty"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Name">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litValue"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Panel>

<script type="text/javascript">
    var url = $('.masterpage-backlink').attr('href');
    url = url.replace("[[[discovertab]]]", GetParameterValues('tab'));    


    function GetParameterValues(param) {
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < url.length; i++) {
            var urlparam = url[i].split('=');
            if (urlparam[0] == param) {
                return urlparam[1];
            }
        }
    }
</script>




