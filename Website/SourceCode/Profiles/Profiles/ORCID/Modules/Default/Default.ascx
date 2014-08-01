<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Default.ascx.cs" Inherits="Profiles.ORCID.Modules.Default.Default" %>
<asp:Label ID="lblErrors" runat="server" EnableViewState="false" CssClass="uierror" />
<h3>
    Profiles &harr; ORCID Synchronization</h3>
<div runat="server" id="divMessages">
    <asp:Repeater ID="rptMessages" runat="server">
        <HeaderTemplate>
            <h3>
                Data Transfer History</h3>
            <table class="data">
                <thead>
                    <tr class="header">
                        <th>
                            Date
                        </th>
                        <th>
                            Status
                        </th>
                        <th>
                            Data Transfer History
                        </th>
                    </tr>
                </thead>
                <tbody>
        </HeaderTemplate>
        <ItemTemplate>
            <tr class="item">
                <td>
                    <%# Eval("PostDateDesc")%>
                </td>
                <td>
                    <%# Eval("RecordStatus")%>
                </td>
                <td>
                    <%# Eval("UserMessage")%>
                </td>
            </tr>
        </ItemTemplate>
        <AlternatingItemTemplate>
            <tr class="alt">
                <td>
                    <%# Eval("PostDateDesc")%>
                </td>
                <td>
                    <%# Eval("RecordStatus")%>
                </td>
                <td>
                    <%# Eval("UserMessage")%>
                </td>
            </tr>
        </AlternatingItemTemplate>
        <FooterTemplate>
            </tbody> </table>
        </FooterTemplate>
    </asp:Repeater>
</div>
