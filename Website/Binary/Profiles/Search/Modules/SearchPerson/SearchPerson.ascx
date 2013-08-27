<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchPerson.ascx.cs"
    Inherits="Profiles.Search.Modules.SearchPerson.SearchPerson" EnableViewState="true" %>
<%@ Register Src="ComboTreeCheck.ascx" TagName="ComboTreeCheck" TagPrefix="uc1" %>

<script type="text/javascript">


    function runScript(e) {
        if (e.keyCode == 13) {
            search();            
        }
        return false;
    }

    function search() {

        document.getElementById("<%=hdnSearch.ClientID%>").value = "true"
        document.forms[0].submit();
    }

    function showdiv() {
        document.getElementById("divChkList").style.display = "block";

        document.getElementById('chkLstItem_0').focus()
    }

    function showdivonClick() {
        var objDLL = document.getElementById("divChkList");
        if (objDLL.style.display == "block")
            objDLL.style.display = "none";
        else
            objDLL.style.display = "block";
    }

    function getSelectedItem(lstValue, lstNo, lstID, ctrlType) {


        var noItemChecked = 0;
        var ddlChkList = document.getElementById("ddlChkList");
        var selectedItems = "";
        var selectedValues = "";
        var arr = document.getElementById("chkLstItem").getElementsByTagName('input');
        var arrlbl = document.getElementById("chkLstItem").getElementsByTagName('label');
        var objLstId = document.getElementById('hidList');

        for (i = 0; i < arr.length; i++) {
            checkbox = arr[i];
            if (i == lstNo) {
                if (ctrlType == 'anchor') {
                    if (!checkbox.checked) {
                        checkbox.checked = true;
                    }
                    else {
                        checkbox.checked = false;
                    }
                }
            }

            if (checkbox.checked) {                

                var buffer;
                if (arrlbl[i].innerText == undefined)
                    buffer = arrlbl[i].textContent;
                else
                    buffer = arrlbl[i].innerText;

                if (selectedItems == "") {

                    selectedItems = buffer;
                }
                else {
                    selectedItems = selectedItems + "," + buffer;
                }
                noItemChecked = noItemChecked + 1;
            }
        }

        ddlChkList.title = selectedItems;

        if (noItemChecked != "0")
            ddlChkList.options[ddlChkList.selectedIndex].text = selectedItems;
        else
            ddlChkList.options[ddlChkList.selectedIndex].text = "";

        document.getElementById('hidList').value = ddlChkList.options[ddlChkList.selectedIndex].text;


    }

    document.onclick = check;
    function check(e) {
        var target = (e && e.target) || (event && event.srcElement);
        var obj = document.getElementById('divChkList');
        var obj1 = document.getElementById('ddlChkList');
        if (target.id != "alst" && !target.id.match("chkLstItem")) {
            if (!(target == obj || target == obj1)) {
                //obj.style.display = 'none'
            }
            else if (target == obj || target == obj1) {
                if (obj.style.display == 'block') {
                    obj.style.display = 'block';
                }
                else {
                    obj.style.display = 'none';
                    document.getElementById('ddlChkList').blur();
                }
            }
        }
    }
</script>

<asp:HiddenField ID="hdnSearch" runat="server" Value="hdnSearch"></asp:HiddenField>
<div class="content_container">
    <div class="tabContainer" style="margin-top: 0px;">
        <div class="searchForm">
            <table onkeypress="JavaScript:runScript(event);" width="100%">
                <tbody align="left">
                    <tr>
                        <td colspan='3'>
                            <div style="font-size: 18px; color: #b23f45; font-weight: bold; margin-bottom: 3px;">
                                Find people by keyword</div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <div class="searchSection" id="divSearchSection">
                                <table width="100%" class='searchForm'>
                                    <tr>
                                        <th>
                                            Keywords
                                        </th>
                                        <td colspan="2" class="fieldOptions">
                                            <asp:TextBox runat="server" ID="txtSearchFor" CssClass="inputText"></asp:TextBox>
                                            <asp:CheckBox runat="server" ID="chkExactphrase" />
                                            Search for exact phrase
                                        </td>
                                    </tr>
                                    <tr>
                                        <tr>
                                            <th>
                                            </th>
                                            <td style="text-decoration: none" colspan="2">
                                                <div style="float: left; display: inline">
                                                    <a href="JavaScript:search();">
                                                        <img src="<%=GetURLDomain()%>/Search/Images/search.jpg" style="border: 0;" alt="Search" />
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
            <table width="100%">
                <tr>
                    <td colspan='3'>
                        <div style="font-size: 18px; color: #b23f45; font-weight: bold; margin-bottom: 3px;">
                            Find people by name/organization</div>
                    </td>
                </tr>
                <tr>
                    <td colspan='3'>
                        <div class="searchSection" id="div1">
                            <table width="100%" class='searchForm'>
                                <tr>
                                    <th>
                                        Last Name
                                    </th>
                                    <td colspan="2">
                                        <asp:TextBox runat="server" ID="txtLname" CssClass="inputText"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        First Name
                                    </th>
                                    <td colspan="2">
                                        <asp:TextBox runat="server" ID="txtFname" CssClass="inputText"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr runat="server" id="trInstitution">
                                    <th>
                                        Institution
                                    </th>
                                    <td colspan="2">
                                        <asp:Literal runat="server" ID="litInstitution"></asp:Literal>
                                        <asp:CheckBox runat="server" ID="institutionallexcept" />
                                        All <b>except</b> the one selected
                                    </td>
                                </tr>
                                <tr runat="server" id="trDepartment">
                                    <th>
                                        Department
                                    </th>
                                    <td colspan="2">
                                        <asp:Literal runat="server" ID="litDepartment"></asp:Literal>
                                        <asp:CheckBox runat="server" ID="departmentallexcept" />
                                        All <b>except</b> the one selected
                                    </td>
                                </tr>
                                <tr runat="server" id="trDivision">
                                    <th>
                                        Division
                                    </th>
                                    <td colspan="2">
                                        <asp:Literal runat="server" ID="litDivision"></asp:Literal>
                                        <asp:CheckBox runat="server" id="divisionallexcept" />
                                        All <b>except</b> the one selected
                                    </td>
                                </tr>
                                <tr runat="server" id="trFacultyType">
                                    <th>
                                        Faculty Type
                                    </th>
                                    <td style="padding:0" colspan="2">
                                        <table cellpadding="0" style="padding:0">
                                            <tr>
                                                <td>
                                                    <asp:PlaceHolder ID="phDDLCHK" runat="server"></asp:PlaceHolder>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:PlaceHolder ID="phDDLList" runat="server"></asp:PlaceHolder>
                                                </td>
                                            </tr>
                                        </table>
                                        <asp:Label ID="lblSelectedItem" runat="server"></asp:Label>
                                        <asp:HiddenField ID="hidList" runat="server" />
                                        <asp:HiddenField ID="hidURIs" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        Other Options
                                    </th>
                                    <td colspan='2'>
                                        <input type="hidden" id="hiddenToggle" value="off" />
                                        <select id="selOtherOptions" style="width: 249px; height: 20px">
                                            <option value=""></option>
                                        </select>
                                        <table>
                                            <tr>
                                                <td>
                                                    <div id="divOtherOptions" style="position: absolute; margin-top: -2px; margin-left: -2px;
                                                        width: 255px; border-right: solid 1px #000000; border-bottom: solid 1px #000000;
                                                        border-left: solid 1px gray; padding-left: 3px; height: 150; width: 243px; overflow: auto;
                                                        background-color: #ffffff;">
                                                        <br />
                                                        <uc1:ComboTreeCheck ID="ctcFirst" runat="server" Width="255px" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                    </th>
                                    <td colspan="2">
                                        <div style="float: left; display: inline">
                                            <a href="JavaScript:search();">
                                                <img src="<%=GetURLDomain()%>/Search/Images/search.jpg" style="border: 0;" alt="Search" />
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <asp:Literal runat="server" ID="litFacRankScript"></asp:Literal>
                            
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>