<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PassiveList.ascx.cs" Inherits="Profiles.Profile.Modules.PassiveList.PassiveList" %>
<asp:Repeater ID="passiveList" runat="server" OnItemDataBound="passiveList_OnItemDataBound">
    <HeaderTemplate>
        <div class="passiveSectionHead">
            <div style="white-space: nowrap; display: inline">
                <asp:Literal runat="server" ID="InfoCaption" />
                <asp:Literal runat="server" ID="TotalCount"></asp:Literal>
                <asp:HyperLink runat="server" ID="Info" CssClass="questionImage" ></asp:HyperLink>
            </div>
            <asp:Literal runat="server" ID="divStart"></asp:Literal>
                <asp:Literal runat="server" ID="Description"></asp:Literal>
            <asp:Literal runat="server" ID="divEnd"></asp:Literal>
        </div>

        <div class="passiveSectionBody">
            <ul>
    </HeaderTemplate>
    <ItemTemplate>
        <li>
            <asp:HyperLink runat="server" ID="itemUrl"></asp:HyperLink>
        </li>
    </ItemTemplate>
    <FooterTemplate>
        </ul>
            </div>         
             <asp:HyperLink runat="server" ID="moreurl" Text="Explore" CssClass="prns-explore-btn"></asp:HyperLink>
        <div class="passiveSectionLine">_</div>
    </FooterTemplate>
</asp:Repeater>
