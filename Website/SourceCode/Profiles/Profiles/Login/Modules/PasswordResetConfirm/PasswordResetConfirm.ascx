﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PasswordResetConfirm.ascx.cs" 
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
Please enter and confirm your new password below.  Click submit to reset your password.<br /><br />
<div class="content_container">
    <div class="tabContainer" style="margin-top: 0px;">
        <div class="passwordResetForm">
            <table width="100%">
                <tr>
                    <td colspan="3">
                        <div class="searchSection" style="text-align: center; margin: 0px auto;">
                            <table class="searchForm" style="display: inline;" border="0">
                                <tr>
                                    <td colspan='3'>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Enter Password</b>
                                    </td>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtPassword" value="" TextMode="Password" MaxLength="254"
                                            Width="250" title="EmailAddress"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Confirm Password</b>
                                    </td>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtPasswordConfirm" value="" TextMode="Password" MaxLength="254"
                                            Width="250" title="EmailAddress"></asp:TextBox>
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
                                        <div style="padding-top: 12px">
                                            <asp:Label runat="server" ID="lblError" ForeColor="Red" Font-Bold="true"></asp:Label>
                                        </div>
                                    </td>

                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>
