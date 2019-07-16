<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchEverything.ascx.cs"
    Inherits="Profiles.Search.Modules.SearchEverything.SearchEverything" %>

<script type="text/javascript">

    function submitEverythingSearch() {
        if (document.getElementById("<%=searchfor.ClientID%>").value.length > 1) {
            document.location = "default.aspx?searchtype=everything&searchfor=" + document.getElementById("<%=searchfor.ClientID%>").value + "&exactphrase=" + document.getElementById("<%=chkExactPhrase.ClientID%>").checked;
        }
        else {
            alert("Search is too broad");
        }
    }
    function runScript(e) {
        $(document).keypress(function(e) {
            if (e.keyCode == 13) {
                submitEverythingSearch();
                return false;
            }
            return;
        });
    }
    
</script>

<input type="hidden" id="classgroupuri" name="classgroupuri" value="" />
<input type="hidden" id="classuri" name="classuri" value="" />
<input type="hidden" id="searchtype" name="searchtype" value="everything" />
<input type="hidden" id="txtSearchFor" name="txtSearchFor" value="" />
<div class="content_container">
    <div class="tabContainer" style="margin-top: 0px;">
        <div class="searchForm">
            <table width="100%">
                <tr>
                    <td colspan='3'>
                        <%-- Replaced inline styles with class below --%>
                        <div class="headings">
                            Find publications, research, concepts and more
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <%-- Inline "margin-bottom:15px;" has been removed as it wasnt making a big enough improvement --%>
                        <div class="searchSection">
                            <table width="100%" class='searchForm' onkeypress="JavaScript:runScript(event);">
                                <tr>
                                    <th>
                                        Keywords
                                    </th>
                                    <td colspan="2" class="fieldOptions">
                                        <asp:TextBox EnableViewState="false" runat="server" ID="searchfor" CssClass="inputText" title="Keywords" />
                                    </td>
                                    <%-- Inline style="padding-right:50px" removed due to lacklustre effect on style  --%>
                                    <td>
                                        <asp:CheckBox runat="server" ID="chkExactPhrase" text="&nbsp;Search for exact phrase"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                    </th>
                                    <td colspan="2">
                                        <div class="search-button-container">
                                            <a href="JavaScript:submitEverythingSearch();" class="search-button">
                                                <%--<img src="images/search.jpg" alt="submit search" style="border: 0px; position: relative; top: 9px;" />--%>
                                                Search
                                            </a>
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
