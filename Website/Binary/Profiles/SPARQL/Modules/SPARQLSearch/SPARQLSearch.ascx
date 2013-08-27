<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SPARQLSearch.ascx.cs"
    Inherits="Profiles.Search.Modules.SPARQLSearch.SPARQLSearch" %>
<%/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/ %>

<div>
    <table>
        <tr>
            <td>
                <b>Query:</b>
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtQuery" TextMode="MultiLine" Width="500px" Height="250px"></asp:TextBox><br />
            </td>
        </tr>
        <tr>
            <td colspan='2' style="padding-left: 65px">
                <asp:Button runat="server" ID="cmdRun" Text="Run" OnClick="cmdRun_Click" />
            </td>
        </tr>
        <tr>
            <td colspan='2'>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                <b>Results:</b>
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtResults" Height="300px" Width="500px" TextMode="MultiLine" />
            </td>
        </tr>
    </table>
</div>

