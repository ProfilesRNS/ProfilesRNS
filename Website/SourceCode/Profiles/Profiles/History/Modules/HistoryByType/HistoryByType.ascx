<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HistoryByType.ascx.cs"
    Inherits="Profiles.History.Modules.HistoryByType.HistoryByType" %>

<div style="padding-left:25px"></div>
<asp:Repeater runat="server" ID="rptHistory" OnItemDataBound="rptHistory_OnItemDataBound">
    <HeaderTemplate>    
    </HeaderTemplate>
    <ItemTemplate>
      <asp:Literal runat="server" ID="litType"></asp:Literal>      
      <div style="padding-left:25px;padding-top:10px">
        <asp:Repeater runat="server" ID="rptHistoryTypes" OnItemDataBound="rptHistoryTypes_OnItemDataBound">
            <HeaderTemplate>
                <ui>
            </HeaderTemplate>
            <ItemTemplate>
                <li>
                    <asp:Literal runat="server" ID="litHistoryItem"></asp:Literal>
                </li>
            </ItemTemplate>
            <FooterTemplate>
                </ui>
              </FooterTemplate>
        </asp:Repeater>
        </div>
        <br />
    </ItemTemplate>
    <FooterTemplate>
    </FooterTemplate>
</asp:Repeater>
