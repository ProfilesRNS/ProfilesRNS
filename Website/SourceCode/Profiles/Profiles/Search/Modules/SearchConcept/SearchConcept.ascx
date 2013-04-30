<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchConcept.ascx.cs"
    Inherits="Profiles.Search.Modules.SearchConcept.SearchConcept" %>
    
<style type="text/css">
.profiles .profilesContentMain { width: 584px; }
.profiles .profilesContentPassive { margin-right: 20px; }
.profiles .profilesContentMain .pageTitle h2 { display: none; }
</style>

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
<input type="hidden" id="classgroupuri" name="classgroupuri" value="http://profiles.catalyst.harvard.edu/ontology/prns!ClassGroupConcepts" />
<input type="hidden" id="classuri" name="classuri" value="" />
<input type="hidden" id="searchtype" name="searchtype" value="everything" />

<div class="content_container">
    <div class="tabContainer" style="margin-top: 0px;">
        <div class="searchForm nonavbar">
            <table width="100%">
                <tr>
                    <td colspan='3'>
                        <div class='header'>
                            Find Research Publications by Topic
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <div class="searchSection" style="margin-bottom: 15px;">
                            <table width="100%" class='searchForm' onkeypress="JavaScript:runScript(event);" >
                                <tr>
                                    <th style="width: 80px">
                                        Keywords
                                    </th>
                                    <td colspan="2" class="fieldOptions">
                                        <input type="TextBox" id="txtSearchFor" name="txtSearchFor" size="50" style="margin: 0px 5px;" />
                                    </td>
<!--
                                </tr>
                                <tr>
                                    <tr>
                                        <th>
                                        </th>
-->
                                        <td style="text-decoration: none" colspan="2">
                                            <div style="float: left; display: inline">
                                                <a href="JavaScript:submitEverythingSearch();">
                                                    <img src="images/search.jpg" style="border: 0px; padding-top:4px;" />
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
<!--
       <p><img src="images/icon_squareArrow.gif" /> <a href="../">Search for people only</a></p>
-->
    </div>
</div>
