<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditGroupSettings.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditGroupSettings.CustomEditGroupSettings" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>

<script type="text/javascript">
    var verifyDate = (function () {
        var re = /^(0?\d|1[12])\/([012]?\d|3[01])\/\d\d\d\d/;
        return function () {
            var str = $(".textBoxDate").val();
            if (str == "") { return true; }
            if (!re.test(str)) { alert("End date format invalid. \n\nPlease edit your entry."); return false; }
            var d = new Date(str);
            var today = new Date();
            if (d > today) { return true; }
            if (d <= today) { alert("End date must be in the future. \n\nPlease edit your entry."); return false; }
            alert("End date format invalid. \n\nPlease edit your entry."); return false;
        }
    })();
    $(document).ready(function () { $(".SupportText").remove(); });
</script>
<div class="editBackLink">
    <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
</div>
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div class="progress">
                    <span>
                        <img alt="Loading..." src="../edit/Images/loader.gif" width="400" height="213" /></span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:Panel ID="phSecurityOptions" runat="server">
            <security:Options runat="server" ID="securityOptions"></security:Options>
        </asp:Panel>
        <asp:Panel ID="phEditProperty" runat="server">
            <div class="EditMenuItem">
                <asp:ImageButton CssClass="EditMenuLinkImg" runat="server" ID="imbAddArror" OnClick="btnUpdateDateCancel_OnClick" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
                <asp:LinkButton ID="btnEditProperty" runat="server" OnClick="btnUpdateDateCancel_OnClick">Edit End Date</asp:LinkButton>
            </div>
        </asp:Panel>
        <asp:Repeater ID="RptrEditProperty" runat="server" Visible="false">
            <ItemTemplate>
                <asp:Label ID="lblEditProperty" runat="server" Text='<%#Eval("Label").ToString() %>' />
            </ItemTemplate>
        </asp:Repeater>
        <asp:Panel ID="pnlInsertProperty" runat="server"  CssClass="EditPanel"      Visible="false">
            <div><span style="font-weight: bold;">End Date</span> (MM/DD/YYYY)</div>

            <asp:TextBox ID="txtEndDate" runat="server" MaxLength="10" CssClass="textBoxDate"></asp:TextBox>
            <asp:ImageButton ID="btnCalendar" runat="server" Width="15px" ImageUrl="~/Edit/Images/cal.png" AlternateText="Calendar picker" />
            <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtEndDate"
                PopupButtonID="btnCalendar">
            </asp:CalendarExtender>

            <div class="actionbuttons">
                <asp:LinkButton ID="btnUpdateDateSave" runat="server" CausesValidation="False" OnClick="btnUpdateDateSave_OnClick" OnClientClick="Javascript:return verifyDate();"
                    Text="Save"></asp:LinkButton>
                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;                           
                <asp:LinkButton ID="btnUpdateDateCancel" runat="server" CausesValidation="False" OnClick="btnUpdateDateCancel_OnClick"
                    Text="Cancel"></asp:LinkButton>
            </div>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>
