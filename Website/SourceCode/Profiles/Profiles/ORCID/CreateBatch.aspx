<%@ Page Title="" Language="C#" MasterPageFile="~/Framework/Template.Master" AutoEventWireup="true"
    CodeBehind="CreateBatch.aspx.cs" Inherits="Profiles.ORCID.CreateBatch" %>

<%@ Register Src="~/ORCID/Modules/CreateBatch/CreateBatch.ascx" TagName="CreateBatch"
    TagPrefix="uc1" %>
<asp:Content ID="head2" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function checkOrUncheckAll() {
            var checkAll = document.getElementById('chkAll');
            var c = document.getElementsByTagName("body")[0].getElementsByTagName("*");
            for (var j = 0; j < c.length; j++) {
                if (c[j].type == "checkbox") {
                    if (checkAll.checked) {
                        c[j].checked = true;
                    }
                    else {
                        c[j].checked = false;
                    }
                }
            }
        }
    </script>
    <style type="text/css">
        select { width: 600px; }
    </style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentMain" runat="server">
    <uc1:CreateBatch ID="CreateBatch1" runat="server" />
</asp:Content>
