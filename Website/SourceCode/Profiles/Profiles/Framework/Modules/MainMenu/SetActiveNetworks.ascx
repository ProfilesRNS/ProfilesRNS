<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SetActiveNetworks.ascx.cs"
    Inherits="Profiles.Framework.Modules.MainMenu.SetActiveNetworks" %>


<script type="text/javascript">
    
    function toggleSelectionRepeater(obj) {
        debugger;
        var check_text = $("label[for='" + $(obj).attr("id") + "']").text();
        var subject = $("#<%=hdSubject.ClientID%>").val();
        $.ajax({
            type: "POST",
            url: "<%=ResolveUrl("~/Framework/Modules/MainMenu/Default.aspx/chkRelationshipTypes_OnCheckedChanged")%>",
            data: "{subject: '" + subject + "', check_text: '" + check_text + "', is_checked: '" + obj.checked + "' }",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {
                //debugger;
                //alert(response.d + " " + check_text + " " + obj.checked);

            }
        });
    }
    function OnSuccess(response) {
        //debugger;
        //alert(response.d);
      

    }

</script>
<asp:HiddenField runat="server" ID="hdSubject" />
<ul id="alignNetworkLeft" class="drop" style="width: 155px;">
    <asp:Repeater ID="rptRelationshipTypes" runat="server" OnItemDataBound="rptRelationshipTypes_ItemBound">
        <ItemTemplate>
            <li style="padding: 10px">
                <asp:CheckBox runat="server" CssClass="network-checkbox" AutoPostBack="false" ID="chkRelationshipType" CausesValidation="false" onclick="toggleSelectionRepeater(this);"  />                        
            </li>
        </ItemTemplate>
    </asp:Repeater>
</ul>
