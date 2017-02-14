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
            <table width="100%">
                <tr>
                    <td colspan="3">
                        <div class="aboutText" style="text-align: center; margin: 0px auto;">

                            <table style="display: inline;" border="0">
                                <tr>
                                    <td>
                                        <br />
                                        Profiles uses integrated authentication using your UMass login and password.  Click below to proceed 
                                        to the sign in page. If you have no profiles account an error message will be shown when you return
                                        to this page. 
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