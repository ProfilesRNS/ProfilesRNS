<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditGroupSettings.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditGroupSettings.CustomEditGroupSettings" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<table width="100%">
    <tr>
        <td align="left" style="padding-right: 12px">
            <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
        </td>
    </tr>
</table>
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div class="progress">
                    <span><img alt="Loading..." src="../edit/Images/loader.gif" width="400" height="213"/></span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <table id="tblEditProperty" width="100%">
            <tr>
                <td colspan='3'>
                    <asp:Literal runat="server" ID="Literal1"></asp:Literal>                    
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <div style="padding: 10px 0px;">
                        <asp:PlaceHolder ID="phSecurityOptions" runat="server">
                            <security:Options runat="server" ID="securityOptions"></security:Options>
                            <br />
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phEditProperty" runat="server">
                            <asp:LinkButton ID="btnEditProperty" runat="server" OnClick="btnUpdateDateCancel_OnClick" 
                                CssClass="profileHypLinks"><asp:Image runat="server" ID="imbAddArror" AlternateText=" " ImageUrl="../../../Framework/Images/icon_squareArrow.gif"/>&nbsp;Edit End Date</asp:LinkButton>
                            <br />
                        </asp:PlaceHolder>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="3">                  
                    <asp:Repeater ID="RptrEditProperty" runat="server" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblEditProperty" runat="server" Text='<%#Eval("Label").ToString() %>' />
                            <br />
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlInsertProperty" runat="server" Style="background-color: #EEE;
                        margin-bottom: 5px; border: solid 1px #ccc; padding-top:5px; padding-left:5px;" 
                        Visible="false">
                    <asp:Label ID="txtEndDateLabel" runat="server" Text="<b>End Date</b> (MM/DD/YYYY)" AssociatedControlID="txtEndDate"></asp:Label><br /><br />
                        <asp:TextBox ID="txtEndDate" runat="server" MaxLength="10" CssClass="textBoxDate"></asp:TextBox>
                        <asp:ImageButton ID="btnCalendar" runat="server" ImageUrl="~/Edit/Images/cal.gif" AlternateText="Calendar picker" />
                        <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtEndDate"
                            PopupButtonID="btnCalendar">
                        </asp:CalendarExtender>
                        <br /><br />
                        <div style="padding-bottom: 5px; text-align: left;">
                            <asp:LinkButton ID="btnUpdateDateSave" runat="server" CausesValidation="False" OnClick="btnUpdateDateSave_OnClick"
                                Text="Save" ></asp:LinkButton>
                            &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                            <asp:LinkButton ID="btnUpdateDateCancel" runat="server" CausesValidation="False" OnClick="btnUpdateDateCancel_OnClick"
                                Text="Cancel" ></asp:LinkButton>
                        </div>
                    </asp:Panel>

                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>