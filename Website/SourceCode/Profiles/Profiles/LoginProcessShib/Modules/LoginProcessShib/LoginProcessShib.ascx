<%@ Control Language="C#" EnableViewState="true" AutoEventWireup="true" CodeBehind="LoginProcessShib.ascx.cs"
    Inherits="Profiles.LoginProcessShib.Modules.LoginProcessShib" %>
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
                                        <asp:Panel ID="panelLoginSuccessful" runat="server" Visible="false">
                                            You have been successfully logged into Profiles.  Click the button below to proceed to the search page.
                                        </asp:Panel>
                                        <asp:Panel ID="panelLoginFailed" runat="server" Visible="false">
                                            Login to profiles failed.  You don't have a profiles account.  Please contact the profiles Administrator.  
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
                                        <asp:Button ID="cmdProceedToSearch" runat="server" Text="Proceed To Search" CssClass="login-button" OnClick="cmdProceedToSearch_Click" visible="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td >
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