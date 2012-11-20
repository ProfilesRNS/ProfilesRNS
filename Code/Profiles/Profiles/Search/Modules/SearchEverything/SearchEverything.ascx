<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchEverything.ascx.cs"
    Inherits="Profiles.Search.Modules.SearchEverything.SearchEverything" %>
    
    <script type="text/javascript">

        function submitEverythingSearch() {
            
            document.forms[0].submit();

        }
        function runScript(e) {
            if (e.keyCode == 13) {
                submitEverythingSearch();
                return true;
            }
            return false;
        }
    
    </script>
<input type="hidden" id="classgroupuri" name="classgroupuri" value="" />
<input type="hidden" id="classuri" name="classuri" value="" />
<input type="hidden" id="searchtype" name="searchtype" value="everything" />

Search or browse for people, publications, concepts, and other items in Profiles.

<div class="content_container">
    <div class="tabContainer" style="margin-top: 0px;">
        <div class="searchForm">
            <table width="100%">
                <tr>
                    <td colspan='3'>
                        <div style="font-size: 18px; color: #b23f45; font-weight: bold; margin-bottom: 3px;">
                            Search by keywords
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <div class="searchSection" style="margin-bottom: 15px;">
                            <table width="100%" class='searchForm' onkeypress="JavaScript:runScript(event);" >
                                <tr>
                                    <th>
                                        Keywords
                                    </th>
                                    <td colspan="2" class="fieldOptions">
                                        <input type="TextBox" id="txtSearchFor" name="txtSearchFor" size="50" style="margin: 0px 5px;" />
                                    </td>
                                </tr>
                                <tr>
                                    <tr>
                                        <th>
                                        </th>
                                        <td style="text-decoration: none" colspan="2">
                                            <div style="float: left; display: inline">
                                                <a href="JavaScript:submitEverythingSearch();">
                                                    <img src="images/search.jpg" style="border: 0px; position: relative; top: 9px;" />
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>
