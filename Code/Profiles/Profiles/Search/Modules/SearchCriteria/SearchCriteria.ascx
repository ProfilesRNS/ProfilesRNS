<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchCriteria.ascx.cs"
    Inherits="Profiles.Search.Modules.SearchCriteria.SearchCriteria" %>
<%--
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
 --%>
<div id="divSearchCriteria" style="padding-top: 10px">
    <div class="passiveSectionHead">
        <div style="white-space: nowrap; display: inline">
            Search Criteria
        </div>
    </div>
    <div class="passiveSectionBody">
        <ul>
            <asp:Literal runat="server" ID="litSearchCriteria"></asp:Literal>
            <asp:Literal runat="server" ID="litSearchOtherInstitutions"></asp:Literal>
        </ul>
        <div class="passiveSectionLine">
        </div>
    </div>
</div>
</div> 