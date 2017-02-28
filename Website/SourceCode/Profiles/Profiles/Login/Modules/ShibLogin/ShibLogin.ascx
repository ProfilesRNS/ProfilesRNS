<%@ Control Language="C#" EnableViewState="true" AutoEventWireup="true" CodeBehind="ShibLogin.ascx.cs"
    Inherits="Profiles.Login.Modules.ShibLogin.ShibLogin" %>
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
        <div class="searchForm">
            <table width="100%" border="0">
                <tr>
                    <td colspan="3">
                        <div class="aboutText" style="text-align: left; margin: 0px auto;">

                            <table style="display: inline;" border="0">
                                <tr>
                                    <td>
                                        <br />
                                        <asp:Panel ID="panelLoginInfo" runat="server" Visible="true">
                                            Profiles requires a campus network username and password for login.  If you have no profiles account an error message 
                                            will be shown when you return to this page.  If you have trouble logging in please contact the helpdesk at 508-856-8643 or via 
                                        email at <a href="mailto: UMWHelpdesk@umassmed.edu">UMWHelpdesk@umassmed.edu</a>.  Click below to proceed 
                                            to the sign in page.
                                        </asp:Panel>
                                        <asp:Panel ID="panelLoggedOut" runat="server" Visible="false">
                                            You have been successfully logged out of profiles.  Click the button below to proceed to the search page.
                                        </asp:Panel>
                                        <asp:Panel ID="panelAlreadyLoggedIn" runat="server" Visible="false">
                                            You already have an active profiles session.  Click the button below to proceed to the search page.
                                        </asp:Panel>
                                    </td>
                                </tr>
                                 <tr>
                                    <td> 
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td> 
                                        <asp:Button ID="cmdProceedToLogin" runat="server" Text="Proceed To Login" CssClass="login-button" OnClick="cmdProceedToLogin_Click" />
                                        <asp:Button ID="cmdProceedToSearch" runat="server" Text="Proceed To Search" CssClass="login-button" visible="false" OnClick="cmdProceedToSearch_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                        <asp:Label runat="server" ID="lblError" ForeColor="Red" Font-Bold="true"></asp:Label>
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