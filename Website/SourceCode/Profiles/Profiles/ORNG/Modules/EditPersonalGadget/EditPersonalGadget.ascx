<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditPersonalGadget.ascx.cs" Inherits="Profiles.ORNG.Modules.Gadgets.EditPersonalGadget" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100px; width: 100px; top: 0;
                    right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
                        font-size: 25px; left: 40%; top: 40%;"><img alt="Loading..." src="../edit/images/loader.gif" width="400" height="213"/></span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <table id="tblEditOntologyGadget" width="100%">
            <tr>
                <td colspan='3'>
                    <asp:Literal runat="server" ID="litBackLink"></asp:Literal>&nbsp;&nbsp;
                    <asp:HyperLink runat="server" ID="lnkOrng" Visible="true" ImageUrl="~/ORNG/Images/orng.gif" NavigateUrl="http://orng.info" Target="_blank"/>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <div style="padding: 10px 0px;">
                        <asp:Panel runat="server" ID="pnlSecurityOptions">
                            <security:Options runat="server" ID="securityOptions"></security:Options>
                        </asp:Panel>
                        <br />
                        <asp:LinkButton ID="btnAddORNGApplication" runat="server" CommandArgument="Show" OnClick="btnAddORNGApplication_OnClick"
                            CssClass="profileHypLinks" Visible="false">
                            <asp:Image runat="server" ID="imbAddArror" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif"/>&nbsp;
                            <asp:Literal runat="server" ID="litAddORNGApplicationProperty">Add ORNG Application</asp:Literal>                           
                        </asp:LinkButton>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:LinkButton ID="lnkDelete" runat="server"
                        CausesValidation="False" OnClick="deleteOne_Onclick" CommandName="Delete" AlternateText=" " Visible="false"
                        OnClientClick="Javascript:return confirm('Are you sure you want to remove this ORNG Application from your profile page?');">
                            <asp:Image runat="server" ID="imgDelete" AlternateText=" " ImageUrl="~/Framework/Images/delete.png" />&nbsp;
                            <asp:Literal runat="server" ID="litDeleteORNGApplicationProperty">Remove ORNG Application</asp:Literal>       
                    </asp:LinkButton>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:Literal runat="server" ID="litGadget"/>

