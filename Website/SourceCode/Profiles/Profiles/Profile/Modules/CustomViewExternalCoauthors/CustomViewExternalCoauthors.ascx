<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomViewExternalCoauthors.ascx.cs"
    Inherits="Profiles.Profile.Modules.CustomViewExternalCoauthors.CustomViewExternalCoauthors" %>
<asp:Repeater ID='rptExternalCoauthor' runat="server" OnItemDataBound="ExternalCoauthorItemBound">
    <HeaderTemplate>
        <div class="passiveSectionHead">
            <div style="white-space: nowrap; display: inline">
                External Co-Authors 
    	    </div>
            <div id="Div1" class="passiveSectionHeadDescription" style="display:block;">
				People at other institutions who have published with this person.
            </div>
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
        <div class='passiveSectionBodyDetails'>
            <asp:Literal runat="server" ID="litFooter"></asp:Literal>
        </div>
        <div class="passiveSectionLine">
        </div>
        </div>
    </FooterTemplate>
</asp:Repeater>
