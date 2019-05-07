<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MyActiveNetwork.ascx.cs"
    Inherits="Profiles.Framework.Modules.MainMenu.MyActiveNetwork" %>

<script type="text/javascript">

    function toggleSelectionRepeater(obj) {
        
        var check_text = $(obj).text();
        var subject = $("#<%=hdSubject.ClientID%>").val();
        var checked = false;
        if ($("#" + $(obj)[0].id + " span:first").hasClass('checkmark')) {
            $("#" + $(obj)[0].id + " span:first").removeClass("checkmark").addClass("xcheckmark");
            checked = false;
        } else {
            $("#" + $(obj)[0].id + " span:first").removeClass("xcheckmark").addClass("checkmark");
            checked = true;
        }
        $.ajax({
            type: "POST",
            url: "<%=ResolveUrl("~/ActiveNetwork/Default.aspx/chkRelationshipTypes_OnCheckedChanged")%>",
            data: "{subject: '" + subject + "', check_text: '" + check_text + "', is_checked: '" + checked + "' }",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {
                //debugger;
                //alert(response.d + " " + check_text + " " + obj.checked);
            }
        });
    }
    function OnSuccess(response) {/*debugger;alert(response.d);*/ }

    $("#personismy").hover(function () {
        $("#personismy").parent().css("background-color", "#dcdada !important");
        $('#personismy').parent().siblings(':first-child').css("font-weight", "bold !important");
        $('#personismy').parent().siblings(':first-child').css("border-left", "1px solid #383737");
        $('#personismy').parent().siblings(':first-child').css("border-right", "1px solid #383737");
        $('#personismy').parent().siblings(':first-child').css("text-decoration", "none");
        $('#personismy').parent().siblings(':first-child').css("background-color", " #383737 !important");
    }); 

   
</script>

<asp:HiddenField runat="server" ID="hdSubject" />
<ul class="drop" style="xdisplay:block !important;">
    <asp:Repeater ID="rptRelationshipTypes" runat="server" OnItemDataBound="rptRelationshipTypes_ItemBound">
        <HeaderTemplate>
            <li><a id="personismy" href="#" style="border-left:1px solid #383737;border-right:1px solid #383737;">
                <asp:Literal runat="server" ID="lblName"></asp:Literal>
               </a></li>
        </HeaderTemplate>
        <ItemTemplate>
            <li style="height:25px !important">
                <asp:Literal runat="server" ID="litRelationshipType" />
            </li>
        </ItemTemplate>
    </asp:Repeater>
    <asp:Repeater runat="server" ID="gvActiveNetwork" OnItemDataBound="gvActiveNetwork_ItemBound">
        <ItemTemplate>
            <asp:Literal runat="server" ID="lbPerson"></asp:Literal>
        </ItemTemplate>
    </asp:Repeater>    
     <asp:Literal runat="server" Text="Details" ID="litActiveNetworkDetails"></asp:Literal>    
</ul>
