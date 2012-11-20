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
            return true;
        }
        return false;
    }


    function search() {        
    
        var department = "";
        var institution = "";      

        var lname = document.getElementById("txtLname").value;
        var keyword = document.getElementById("txtKeyword").value;

        var division = "";
        if (document.getElementById("institution") != null) {
            institution = document.getElementById("institution").value;
        }

        if (document.getElementById("department") != null) {
            department = document.getElementById("department").value;
        }

        if (document.getElementById("division") != null) {
            division = document.getElementById("division").value;
        }

        var classuri = 'http://xmlns.com/foaf/0.1/Person';
        document.location.href = '<%=GetURLDomain()%>/search/default.aspx?searchtype=people&lname=' + lname + '&searchfor=' + keyword + '&department=' + department + '&institution=' + institution + '&classuri=' + classuri + '&division=' + division + '&perpage=15&offset=0';

    }

    function clearsearch() {

        document.getElementById("txtLname").value = "";
        document.getElementById("txtKeyword").value = "";
        document.getElementById("institution").selectedIndex = "0";
        document.getElementById("department").selectedIndex = "0";
        document.getElementById("division").selectedIndex = "0";

    }
    
    
    
</script>

<div class="activeContainer" id="minisearch">
    <div class="activeContainerTop"></div>
    <div class="activeContainerCenter">
        <div class="activeSection">
            <div class="activeSectionHead">Find People</div>
            <div class="activeSectionBody">
                <table onkeypress="JavaScript:runScript(event);"   width="100%" class='searchForm'>
                    <tr><td>Keyword</td></tr>
                    <tr><td><input type="text" name="txtKeyword" id="txtKeyword" style="width: 150px" /></td></tr>
                    <tr><td>Last Name</td></tr>
                    <tr><td><input type="text" name="txtLname" id="txtLname" style="width: 150px" /></td></tr>
                    <tr runat="server" id="trInstitution">
                        <td>Institution</td>
                    </tr>
                    <tr>
                        <td><asp:Literal runat="server" ID="litInstitution"></asp:Literal></td>
                    </tr>
                    <tr runat="server" id="trDepartment">
                        <td>Department</td>
                    </tr>
                    <tr>
                        <td><asp:Literal runat="server" ID="litDepartment"></asp:Literal></td>
                    </tr>
                    <tr runat="server" id="trDivision">
                        <td>Division</td>
                    </tr>
                    <tr><td><asp:Literal runat="server" ID="litDivision"></asp:Literal></td>
                    </tr>
                    <tr>
                        <td align="center">
                            <input style="width: 65px" type="button" onclick="JavaScript:search();" value="Search" />&nbsp;
                            <input style="width: 65px" type="button" onclick="JavaScript:clearsearch();" value="Clear" />
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <a href="<%=GetURLDomain()%>/search/people">More Search Options </a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="activeContainerBottom"></div>
</div>
