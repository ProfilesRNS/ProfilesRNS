<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ManageProxies.ascx.cs"
    Inherits="Profiles.Proxy.Modules.ManageProxies.ManageProxies" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<style>

    .empty-cell{margin-left:5px;margin-top:2px; margin-bottom:2px; height:15px;}

</style>

<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />    

        <div style="margin-top: 16px;">
            Proxies are people who can edit other people's profiles on their behalf. For example,
faculty can designate their assistants as proxies to edit their profiles. If you
have a profile, then one or more proxies might be assigned to you automatically
by your department or institution. You also have the option of designation your
own proxies.    
        </div>

        <div style="font-weight: bold; margin-top: 25px;">
            Users who can edit your profile
        </div>
        <div style="margin-top: 8px;">
            If one of the people listed below has a icon in the Delete column, then you may
    remove that person as your proxy.    
        </div>
        <div style="margin-top: 8px;">
            <asp:GridView Width="100%" ID="gvMyProxies" EmptyDataText="<div style='margin-top:5px;margin-left:5px;margin-bottom:5px;'>None</div>" AutoGenerateColumns="false"
                runat="server" OnRowDataBound="gvMyProxies_OnRowDataBound" CssClass="SearchResults">
                <HeaderStyle CssClass="topRow"/>
                <RowStyle CssClass="oddRow" />
                <AlternatingRowStyle CssClass="evenRow" />
                <EmptyDataRowStyle CssClass="empty-cell" />
                <Columns>
                    <asp:TemplateField ItemStyle-CssClass="editLeftPaddedCol" HeaderStyle-CssClass="leftCol" HeaderText="Name" ItemStyle-Width="220px">
                        <ItemTemplate>
                            <asp:Literal runat="server" ID="litName"></asp:Literal>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Institution" HeaderText="Institution" HeaderStyle-CssClass="center" ReadOnly="true" ItemStyle-CssClass="editLeftPaddedCol" ItemStyle-Width="260px" />
                    <asp:TemplateField HeaderText="Email" ItemStyle-CssClass="editLeftPaddedCol" HeaderStyle-CssClass="center">
                        <ItemTemplate>
                            <asp:Literal runat="server" ID="litEmail"></asp:Literal>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Delete" ItemStyle-CssClass="center" HeaderStyle-CssClass="center" ItemStyle-VerticalAlign="Middle">
                        <ItemTemplate>
                            <asp:ImageButton OnClick="lnkDelete_OnClick" ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif" AlternateText="delete"
                                OnClientClick="Javascript:return confirm('Are you sure you want to delete this entry?');"></asp:ImageButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <asp:Panel runat="server" ID="pnlAddProxy" Visible='false'>
            <div style="padding-top: 6px;">
                <div style="float: left; padding-right: 5px; padding-top: 7px;">
                    <asp:Image runat="server" ID="imgAdd" AlternateText=" " />
                </div>
                &nbsp;
            <div style="float: left; padding-top: 8px;">
                <asp:Literal runat="server" ID='lnkAddProxyTmp' Text="Add a Proxy"></asp:Literal>
            </div>
            </div>
        </asp:Panel>
        <div style="font-weight: bold; margin-top: 34px; margin-bottom: 8px;">Users who have given you permission to edit their profiles</div>
        <asp:GridView Width="100%" ID="gvWhoCanIEdit" EmptyDataText="<div style='margin-top:5px;margin-left:5px;margin-bottom:5px;'>None</div>" EmptyDataRowStyle-CssClass="empty-cell"  AutoGenerateColumns="false" 
            runat="server" OnRowDataBound="gvWhoCanIEdit_OnRowDataBound" CssClass="SearchResults">
            <RowStyle CssClass="oddRow " />
            <AlternatingRowStyle CssClass="evenRow " />
            <HeaderStyle CssClass="topRow" />
            <EmptyDataRowStyle CssClass="empty-cell" />
            <Columns>
                <asp:TemplateField HeaderText="Name" ItemStyle-CssClass="editLeftPaddedCol" HeaderStyle-CssClass="editLeftPaddedCol" ItemStyle-Width="220px">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litName"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Institution" HeaderText="Institution" ReadOnly="true" ItemStyle-CssClass="editLeftPaddedCol" HeaderStyle-CssClass="center" ItemStyle-Width="260px" />
                <asp:TemplateField HeaderText="Email" ItemStyle-CssClass="editLeftPaddedCol" HeaderStyle-CssClass="center">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litEmail"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

         <div style="font-weight: bold; margin-top: 34px; padding-bottom: 8px">Groups of users whose profiles you can edit</div>
               <div style="margin-bottom: 8px;">You can edit the profiles of any user belonging to any of the organizations listed below. The Visible column indicates whether users in an organization can see that you have permission to edit their profiles.</div>
               <div class="editPage">
               <asp:GridView Width="100%" ID="gvYouCanEdit" AutoGenerateColumns="false" 
                   runat="server" CssClass="SearchResults">
                   <HeaderStyle CssClass="topRow"/>
                   <RowStyle CssClass="oddRow" />                   
                   <AlternatingRowStyle CssClass="evenRow" />            
                   <EmptyDataTemplate>
                       <div style="margin: 5px !important;">None</div>
                   </EmptyDataTemplate>
                   <Columns>
                       <asp:BoundField ItemStyle-CssClass="editLeftPaddedCol" HeaderStyle-CssClass="alignLeft" DataField="Institution" HeaderText="Institution" ReadOnly="true" />
                       <asp:BoundField ItemStyle-CssClass="editLeftPaddedCol" HeaderStyle-CssClass="alignCenter" DataField="Department" HeaderText="Department" ReadOnly="true" />
                       <asp:BoundField ItemStyle-CssClass="alignCenter" HeaderStyle-CssClass="alignCenter" DataField="Visible" HeaderText="Visible" ReadOnly="true" />
                   </Columns>
               </asp:GridView>
               </div>
           </ContentTemplate>
</asp:UpdatePanel>