<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PasswordReset.ascx.cs" 
    Inherits="Profiles.Login.Modules.PasswordReset.PasswordReset" %>
<%--
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
 --%>
<div class="content_container">
    <div class="tabContainer" style="margin-top: 0px;">
        <div class="searchForm">
        </div>
    </div>
</div>

<div class="content_container">
    <div class="tabContainer" style="margin-top: 0px;">
        <div class="passwordResetForm">
            <table width="100%">
                <tr>
                    <td colspan="3">
                        
                        <asp:Panel ID="PanelPasswordResetForm" runat="server" Visible="true">
                        <br />
                        Enter your email address below and we will send you a link you can use to reset your password.<br /><br />
                        <div class="searchSection" style="text-align: center; margin: 0px auto;">
                            <table class="searchForm" style="display: inline;">
                                <tr>
                                    <td colspan='3'>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Email Address</b>
                                    </td>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtEmailAddress" value="" TextMode="SingleLine" MaxLength="254"
                                            Width="250" title="EmailAddress"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                       
                                    </td>
                                    <td> 
                                        <div class="reset-button-container">
                                            <asp:Button Text="Send Reset Email" id="cmdSendResetEmail" runat="server" OnClick="cmdSendResetEmail_Click" CssClass="reset-button"/>
                                        </div>
                                    </td>

                                <tr>
                                    
                                    <td colspan='2'>
                                        <div style="padding-top: 12px">
                                            <asp:Label runat="server" ID="lblError" ForeColor="Red" Font-Bold="true"></asp:Label>

                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator" runat="server" ErrorMessage="Please Enter Valid Email Address" 
                                            ControlToValidate="txtEmailAddress" CssClass="requiredFieldValidateStyle" ForeColor="Red"  
                                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"  Display="Dynamic">
                                            </asp:RegularExpressionValidator>

                                            <asp:RequiredFieldValidator id="requiredFieldEmail" runat="server"
                                              ControlToValidate="txtEmailAddress"
                                              ErrorMessage="Email Address field is required."
                                              ForeColor="Red" Display="Dynamic">
                                            </asp:RequiredFieldValidator>

                                        </div>
                                    </td>

                                </tr>
                            </table>
                        </div>
                        </asp:Panel>

                        <!-- Email Sent Successfully -->
                        <asp:Panel ID="PanelEmailSent" runat="server" Visible="false">
                            <div class="searchSection" style="text-align: left; margin: 0px auto;">
                                <br />
                                <h2>Reset Request Sent</h2><br />
                                A password reset request has been sent to email address <asp:Label ID="lblEmailAddressEmailSent" runat="server" Text="" CssClass="emailAddressResetSent"></asp:Label> and should arrive in the next few minutes.  
                                <br /><br />
                                If the email doesn't arrive in your inbox please check your spam folder.
                                <br /><br />
                            </div>
                        </asp:Panel>

                        <!-- Email Resent Successfully -->
                        <asp:Panel ID="PanelEmailResent" runat="server" Visible="false">
                            <div class="searchSection" style="text-align: left; margin: 0px auto;">
                                <br />
                                <h2>Reset Request Re-Sent</h2><br />
                                A password reset request has been re-sent to email address: <asp:Label ID="lblEmailAddressEmailReSent" runat="server" Text="" CssClass="emailAddressResetSent"></asp:Label> and should arrive in the next few minutes.  
                                <br /><br />
                                If the email doesn't arrive in your inbox please check your spam folder.
                                <br /><br />
                            </div>
                        </asp:Panel>

                        <!-- Email Resent Resends Exceeded -->
                        <asp:Panel ID="PanelEmailResentRetryExceeded" runat="server" Visible="false">
                            <div class="searchSection" style="text-align: left; margin: 0px auto;">
                                <br />
                                <h2>Reset Request Already Sent</h2><br />
                                A password reset request has already been sent to email address: <asp:Label ID="lblEmailAddressEmailReSentRetryExceeded" runat="server" Text="" CssClass="emailAddressResetSent"></asp:Label>.  
                                <br /><br />
                                If you can't find the email in your inbox please check your spam folder.
                                <br /><br />
                            </div>
                        </asp:Panel>

                        <!-- Email Send Failed -->
                        <asp:Panel ID="PanelEmailSendFailed" runat="server" Visible="false">
                            <div class="searchSection" style="text-align: left; margin: 0px auto;">
                                <br />
                                <h2>Reset Request Send Failed</h2><br />
                                <div class="emailSendErrorText">
                                    Unable to send password reset request to the email specified.  The address entered may not be associated with a profiles account.  If you believe you are getting this 
                                    message in error please contact your administrator.
                                </div>
                                <br /><br />
                            </div>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>
