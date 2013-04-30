<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchGadgets.ascx.cs"
    Inherits="Profiles.ORNG.Modules.Gadgets.SearchGadgets" %>
<%--
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
 --%>

<%-- Profiles OpenSocial Extension by UCSF --%>   
<asp:Panel ID="pnlOpenSocial" runat="server" Visible="false">
    <script type="text/javascript" language="javascript">
	    // find the 'Search' gadget(s).  
	    var searchGadgets = my.findGadgetsAttachingTo("gadgets-search");
	    var keyword = '<%=GetKeyword()%>';
	    // add params to these gadgets
	    if (keyword) {
		    for (var i = 0; i < searchGadgets.length; i++) {
		        var searchGadget = searchGadgets[i];
		        searchGadget.additionalParams = searchGadget.additionalParams || {};
		        searchGadget.additionalParams["keyword"] = keyword;
		    }
	    }
	    else {  // remove these gadgets
		    my.removeGadgets(searchGadgets);
	    }            
    </script>
    <div id="gadgets-search" class="gadgets-gadget-parent"></div>
</asp:Panel>
