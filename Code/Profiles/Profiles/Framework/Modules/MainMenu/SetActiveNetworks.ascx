<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SetActiveNetworks.ascx.cs"
    Inherits="Profiles.Framework.Modules.MainMenu.SetActiveNetworks" %>
<%--
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.

    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
    
 --%>
<div class="activeSection" id="activenetworks">
   <asp:Panel runat="server" ID="pnlSetActiveNetworks" Visible="false">
        <div class="activeSectionHead">
            This Person is my...</div>
        <div class="activeSectionBody">
            <asp:Repeater ID="rptRelationshipTypes" runat="server" OnItemDataBound="rptRelationshipTypes_ItemBound">
                <ItemTemplate>
                    <asp:CheckBox runat="server" AutoPostBack="true" ID="chkRelationshipType" OnCheckedChanged="chkRelationshipTypes_OnCheckedChanged" />
                    <br />
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlMyNetwork" runat="server" Visible="false">
        <div class="activeSectionHead">
            My Network</div>
        <div class="activeSectionBody">
            <asp:GridView AutoGenerateColumns="false" runat="server" ID="gvActiveNetwork" EmptyDataText="None"
                GridLines="None" CellSpacing="-1" OnRowDataBound="gvActiveNetwork_OnRowDataBound"
                ShowHeader="False">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Literal runat="server" ID="lbPerson"></asp:Literal>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-Width="64px" ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:ImageButton runat="server" ID="ibRemove" OnClick="ibRemove_OnClick" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Literal runat="server" Text="Details" ID="litActiveNetworkDetails"></asp:Literal>
        </div>
    </asp:Panel>
 
</div>
