<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomViewPersonSameDepartment.ascx.cs"
    Inherits="Profiles.Profile.Modules.CustomViewPersonSameDepartment.CustomViewPersonSameDepartment" %>
<asp:Repeater ID='rptSameDepartment' runat="server" OnItemDataBound="SameDepartmentItemBound">
    <HeaderTemplate>
        <div class="passiveSectionHead">
            <div style="white-space: nowrap; display: inline">
                Same Department <a href="JavaScript:toggleVisibility('sdDescript');">
                    <asp:Image runat="server" ID="imgQuestion" AlternateText="Expand Description" />
                </a>
            </div>
            <div id="sdDescript" class="passiveSectionHeadDescription" style="display: none;">
				People who are also in this person's primary department.
			</div>
        </div>        
        <div class="passiveSectionBody">
            <ul>
    </HeaderTemplate>
    <ItemTemplate>
        <asp:Literal runat="server" ID="litListItem"></asp:Literal>
    </ItemTemplate>
    <FooterTemplate>
         </ul>   
        </div>
           <asp:HyperLink runat="server" ID="moreurl" Text="Explore" CssClass="prns-explore-btn"></asp:HyperLink>
        <div class="passiveSectionLine">_</div>
    </FooterTemplate>
</asp:Repeater>
