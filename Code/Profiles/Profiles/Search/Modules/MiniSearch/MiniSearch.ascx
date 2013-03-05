<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MiniSearch.ascx.cs"
    Inherits="Profiles.Search.Modules.MiniSearch.MiniSearch" %>
<%--
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
 --%>

<script type="text/javascript">


    function runScript(e) {
       
        if (e.keyCode == 13) {
            search();
            return false;
        }
        return true;
    }


    function search() {
        
        var department = "";
        var institution = "";

        var lname = document.getElementById("txtLname").value;
        var keyword = document.getElementById("txtKeyword").value;


        if (document.getElementById("institution") != null) {
            institution = document.getElementById("institution").value;
        }
        
        var classuri = 'http://xmlns.com/foaf/0.1/Person';
        document.location.href = '<%=GetURLDomain()%>/search/default.aspx?searchtype=people&lname=' + lname + '&searchfor=' + keyword + '&institution=' + institution + '&classuri=' + classuri + '&perpage=15&offset=0';
        return false;
    }

    
</script>

<div class="activeContainer" id="minisearch">
    <div class="activeContainerTop">
    </div>
    <div class="activeContainerCenter">
        <div class="activeSection">
            <div class="activeSectionHead">
                <table onkeypress="JavaScript:runScript(event);" width="100%" class='searchForm'>
                    <tr>
                        <td style="color: #000000; font-weight: bold">
                            Keywords
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="text" name="txtKeyword" id="txtKeyword" style="width: 150px" />
                        </td>
                    </tr>
                    <tr>
                        <td style="color: #000000; font-weight: bold">
                            Last Name
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="text" name="txtLname" id="txtLname" style="width: 150px" />
                        </td>
                    </tr>
                    <tr runat="server" id="trInstitution">
                        <td style="color: #000000; font-weight: bold">
                            Institution
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal runat="server" ID="litInstitution"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <td >
                            <div align="center" style="padding-top:15px"> 
                                               
                                <input type="button" onclick="JavaScript:search();" value="Find People" />
                                <br />
                                <br />
                                <a href="<%=GetURLDomain()%>/search/people">More Search Options </a>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="activeContainerBottom">
    </div>
</div>
