<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="History.ascx.cs" Inherits="Profiles.Framework.Modules.MainMenu.History" %>
<%--
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.

    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
    
 --%>
<div class="activeSection" id="activenetworks">
    <div class="activeSectionHead">
        History</div>
    <div class="activeSectionBody">
        <asp:Repeater runat="server" ID="rptHistory" OnItemDataBound="rptHistoryOnItemBound">
            <ItemTemplate>
                <div style="overflow: hidden;padding-left: 1em;	text-indent: -1em;">
                    <asp:Literal runat="server" ID="lblHistoryItem"></asp:Literal>
                </div>
            </ItemTemplate>
        </asp:Repeater>        
        <div>
            <asp:Literal runat="server" ID="litSeeAll"></asp:Literal>
        </div>
    </div>
</div>
