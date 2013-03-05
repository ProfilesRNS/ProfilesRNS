<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HistoryList.ascx.cs"
    Inherits="Profiles.History.Modules.HistoryList.HistoryList" %>
<asp:Repeater runat="server" ID="rptHistory" OnItemDataBound="rptHistory_OnItemDataBound">
    <HeaderTemplate>
        <ul>
    </HeaderTemplate>
    <ItemTemplate>
        <li>
        <asp:Literal runat="server" ID="litHistory"></asp:Literal>        
        </li>
    </ItemTemplate>
    <FooterTemplate>
        </ul>
    </FooterTemplate>
</asp:Repeater>
