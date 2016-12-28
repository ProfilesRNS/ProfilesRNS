<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PasswordResetConfirm.ascx.cs" 
    Inherits="Profiles.Login.Modules.PasswordReset.PasswordResetConfirm" %>
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

                        <!-- Password Reset Confirm Form -->
                        <asp:Panel ID="PanelPasswordResetConfirmForm" runat="server" Visible="true">

                        Please enter and confirm your new password below.  Click submit to reset your password.<br /><br />

                        <div class="searchSection" style="text-align: center; margin: 0px auto;">
                            <table class="searchForm" style="display: inline;" border="0">
                                <tr>
                                    <td colspan='3'>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">
                                        <b>Enter Password</b>
                                    </td>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtPassword" value="" TextMode="Password" MaxLength="128"
                                            Width="250" title="Password"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">
                                        <b>Confirm Password</b>
                                    </td>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtPasswordConfirm" value="" TextMode="Password" MaxLength="128"
                                            Width="250" title="Password Confirm"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                       
                                    </td>
                                    <td> 
                                        <div class="reset-button-container">
                                            <asp:Button Text="Submit" id="cmdSubmit" runat="server" OnClick="cmdSubmit_Click" CssClass="reset-button"/>
                                        </div>
                                    </td>

                                <tr>
                                    
                                    <td colspan='2'>
                                        <div style="padding-top: 12px; width: 400px">

                                            <asp:RegularExpressionValidator ID="regexPasswordValidator" runat="server"     
                                            ErrorMessage="" 
                                            ControlToValidate="txtPassword"     
                                            ValidationExpression="" Display="Dynamic"/>

                                            <asp:RequiredFieldValidator id="requiredFieldPassword" runat="server"
                                              ControlToValidate="txtPassword"
                                              ErrorMessage="Password field is required."
                                              ForeColor="Red" Display="Dynamic">
                                            </asp:RequiredFieldValidator>

                                            <asp:RequiredFieldValidator id="requiredFieldPasswordConfirm" runat="server"
                                              ControlToValidate="txtPasswordConfirm"
                                              ErrorMessage="Password Confirm field is required."
                                              ForeColor="Red" Display="Dynamic">
                                            </asp:RequiredFieldValidator>

                                            <asp:CompareValidator runat="server" id="comparePasswordFields" controltovalidate="txtPassword" 
                                                controltocompare="txtPasswordConfirm" operator="Equal" type="String" 
                                                errormessage="Password and Confirm Password values don't match."  Display="Dynamic" />

                                            <asp:Label runat="server" ID="lblError" ForeColor="Red"></asp:Label>
                                        </div>
                                    </td>

                                </tr>
                            </table>

                        </div>
                        </asp:Panel>

                        <!-- Password Reset Successfully -->
                        <asp:Panel ID="PanelPasswordResetSuccess" runat="server" Visible="false">
                            <div class="searchSection" style="text-align: left; margin: 0px auto;">
                                <br />
                                <h2>Password Reset Successfully</h2><br />
                                Your password has been successfully reset.  You can now <a href="default.aspx?method=login&edit=true">login</a> to profiles.
                                <br /><br />
                            </div>
                        </asp:Panel>

                        <!-- Password Reset Failed -->
                        <asp:Panel ID="PanelPasswordResetFailed" runat="server" Visible="false">
                            <div class="searchSection" style="text-align: left; margin: 0px auto;">
                                <br />
                                <h2>Password Reset Failed</h2><br />
                                Password reset failed, contact your administrator.
                                <br /><br />
                            </div>
                        </asp:Panel>

                        <!-- Invalid Reset Request -->
                        <asp:Panel ID="PanelInvalidResetRequest" runat="server" Visible="false">
                            <div class="searchSection" style="text-align: left; margin: 0px auto;">
                                <br />
                                <h2>Invalid Reset Request</h2><br />
                                Reset request invalid.  Reset requests are only valid for 24 hours.  <a href="PasswordReset.aspx">Retry</a> your request or contact your administrator.
                             
                                <br /><br />
                            </div>
                        </asp:Panel>

                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>
