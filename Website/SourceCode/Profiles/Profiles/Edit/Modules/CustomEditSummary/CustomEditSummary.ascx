<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditSummary.ascx.cs" Inherits="Profiles.Edit.Modules.CustomEditSummary.CustomEditSummary" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>

<script type="text/javascript">
    $(document).ready(function () {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);
    });

    function endRequestHandler(sender, args) {

        if (sender._postBackSettings.sourceElement.id.endsWith("Edit")) {
            // wire up the events for tracking keystrokes
            // and initialize the character count

            doTextCount($("#txtSummaryInput").val().length);

            $("#txtSummaryInput").keypress(function (evt) {
                doTextCount($("#txtSummaryInput").val().length);
            });

            $("#txtSummaryInput").bind('paste', function (evt) {
                doTextCount($("#txtSummaryInput").val().length);
            });	
        }
    }

    function doTextCount(count) {
        $("#textCount").text(count);
        if (count > 400) {
            $("#textCount").css("color", "red");
        }
        else {
            $("#textCount").css("color", "inherit");
        }
    }
</script>


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

        <table id="tblEditSummary" width="100%">
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
                    <table style="width: 100%;" border="0" cellspacing="2" cellpadding="4">
                        <tr class="topRow" style="border-width: 1px; border-style: solid">
                            <td>Summary</td>
                            <td>Actions</td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Panel runat="server" ID="pnlViewSummary" Visible="true">
                                    <div>
                                        <asp:Literal ID="litSummaryText" runat="server"></asp:Literal>
                                    </div>
                                </asp:Panel>
                                <asp:Panel runat="server" ID="pnlEditSummary" Visible="false">
                                    <div style="display:flex;flex-flow:row nowrap;align-items:center;">
                                        <div style="flex:1;">Max 400 Characters</div>
                                        <div style="display:flex;flex-flow:row nowrap;flex:0 1 auto">
                                            <span id="textCount">0</span>
                                            <span>/</span>
                                            <span >400</span>
                                        </div>
                                    </div>
                                    <asp:TextBox runat="server"  ClientIDMode="Static" MaxLength="400" Width="100%" Height="300" TextMode="MultiLine" ID="txtSummaryInput"></asp:TextBox>
                                    <div>
                                        <asp:RegularExpressionValidator 
                                        Display="Dynamic" 
                                        ControlToValidate="txtSummaryInput"
                                        ID="maxLengthValidator"
                                        ValidationExpression="^[\s\S]{0,400}$"
                                        runat="server"
                                        ErrorMessage="400 Character Max on this bad boy."></asp:RegularExpressionValidator>
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
