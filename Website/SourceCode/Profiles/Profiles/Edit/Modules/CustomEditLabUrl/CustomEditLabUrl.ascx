<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditLabUrl.ascx.cs" Inherits="Profiles.Edit.Modules.CustomEditLabUrl.CustomEditLabUrl" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>

<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100px; width: 100px; top: 0; right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 25px; left: 40%; top: 40%;">
                        <img alt="Loading..." src="../edit/images/loader.gif" /></span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />

        <table id="tblEditLabUrl" width="100%">
            <tr>
                <td>
                    <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td>
                    <div style="padding: 10px 0px;">
                        <asp:Panel runat="server" ID="pnlSecurityOptions">
                            <security:Options runat="server" ID="securityOptions"></security:Options>
                        </asp:Panel>
                        <br />

                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <table style="width: 100%;" border="1" cellspacing="2" cellpadding="4" style="border-collapse:collapse">
                        <tr class="topRow" style="border-width: 1px; border-style: solid">
                            <td>Lab Url</td>
                            <td>Actions</td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Panel runat="server" ID="pnlViewLabUrl" Visible="true">
                                    <div>
                                        <asp:Literal ID="litLabUrlText" runat="server"></asp:Literal>
                                    </div>
                                </asp:Panel>
                                <asp:Panel runat="server" ID="pnlEditLabUrl" Visible="false">
                                    <asp:TextBox runat="server"  ClientIDMode="Static" Width="100%" TextMode="Url" ID="txtLabUrlInput"></asp:TextBox>
                                    <div>
                                        <asp:RegularExpressionValidator 
                                        Display="Dynamic" 
                                        ControlToValidate="txtLabUrlInput"
                                        ID="maxLengthValidator"
                                        ValidationExpression="^[\s\S]{0,400}$"
                                        runat="server"
                                        ErrorMessage="Needs to be a webpage url"></asp:RegularExpressionValidator>
                                    </div>
                                </asp:Panel>
                            </td>
                            <td style="width: 100px" valign="top" align="center">
                                <asp:Panel runat="server" ID="pnlSaveCancel" Visible="false">
                                    <table class="actionbuttons">
                                        <tr>
                                            <td>
                                                <asp:ImageButton ID="lnkUpdate" OnClick="btnSave_OnClick" runat="server" ImageUrl="~/Edit/Images/button_save.gif"
                                                    CausesValidation="True" Text="Update" AlternateText="Update"></asp:ImageButton>
                                            </td>
                                            <td>
                                                <asp:ImageButton ID="lnkCancel" runat="server" OnClick="btnCancelEdit_OnClick" ImageUrl="~/Edit/Images/button_cancel.gif"
                                                    CausesValidation="False" Text="Cancel" AlternateText="Cancel"></asp:ImageButton>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                                <asp:Panel runat="server" ID="pnlEditButton" Visible="true">
                                    <div class="actionbuttons">
                                        <asp:ImageButton ID="lnkEdit" runat="server" OnClick="btnEditProperty_OnClick" ImageUrl="~/Edit/Images/icon_edit.gif" CausesValidation="False" Text="Edit" AlternateText="Edit"></asp:ImageButton>
                                    </div>
                                </asp:Panel>

                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>