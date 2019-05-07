<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MyLists.ascx.cs" Inherits="Profiles.Framework.Modules.MainMenu.MyLists" %>
<ul class="drop">
    <li class="view-list-reports">
        <a href="<%=string.Format("{0}/lists/default.aspx",Profiles.Framework.Utilities.Root.Domain)%>">View my list and generate reports</a>
    </li>
    <li id="add-people-to-list">
        <asp:HyperLink runat="server" ID="hlAddToList">Add matching people to my list</asp:HyperLink>
    </li>
    <li id="remove-people-from-list">
        <asp:HyperLink runat="server" ID="hlRemoveFromList">Remove matching people from my list</asp:HyperLink>
    </li>
    <li id="remove-all-people-from-list">
        <asp:HyperLink runat="server" ID="hlRemoveAllFromList">Clear my list</asp:HyperLink>
    </li>
</ul>
<asp:Literal runat="server" ID="litJS"></asp:Literal>
<asp:Panel runat="server" Visible="false" ID="pnlPersonScript">
    <script type="text/javascript">


        function AddPerson(ownerid, listid, personid) {
            jQuery.ajax({
                type: "POST",
                url: "<%=ResolveUrl(Profiles.Framework.Utilities.Root.Domain + "/Lists/Default.aspx/AddPersonToList")%>",
                data: "{ownernodeid: '" + ownerid + "', listid: '" + listid + "', personid: '" + personid + "' }",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnListASuccess,
                failure: function (response) {
                    //  debugger;
                    // alert(response.d + " " + check_text + " " + obj.checked);
                }
            });
        }
        function OnListASuccess(response) {  //debugger; alert(response.d); 
            jQuery("#list-count").html(response.d);
            var text = jQuery("#<%=hlAddToList.ClientID%>").text();
            var onclick = jQuery("#<%=hlAddToList.ClientID%>").attr("onclick");

            jQuery("#<%=hlAddToList.ClientID%>").text(jQuery("#<%=hlAddToList.ClientID%>").attr("alt-text"));
            jQuery("#<%=hlAddToList.ClientID%>").attr("onclick", jQuery("#<%=hlAddToList.ClientID%>").attr("alt-onclick"));
            jQuery("#<%=hlAddToList.ClientID%>").attr("alt-text", text);
            jQuery("#<%=hlAddToList.ClientID%>").attr("alt-onclick", onclick);
        }

        function RemovePerson(listid, personid) {
            jQuery.ajax({
                type: "POST",
                url: "<%=ResolveUrl(Profiles.Framework.Utilities.Root.Domain + "/Lists/Default.aspx/DeleteSingle")%>",
                data: "{listid: '" + listid + "', personid: '" + personid + "' }",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnListRSuccess,
                failure: function (response) {
                    //  debugger;
                    // alert(response.d + " " + check_text + " " + obj.checked);

                }
            });
        }
        function OnListRSuccess(response) {  //debugger; alert(response.d); 
            jQuery("#list-count").html(response.d);
            var text = jQuery("#<%=hlAddToList.ClientID%>").text();
            var onclick = jQuery("#<%=hlAddToList.ClientID%>").attr("onclick");
            jQuery("#<%=hlAddToList.ClientID%>").text(jQuery("#<%=hlAddToList.ClientID%>").attr("alt-text"));
            jQuery("#<%=hlAddToList.ClientID%>").attr("onclick", jQuery("#<%=hlAddToList.ClientID%>").attr("alt-onclick"));
            jQuery("#<%=hlAddToList.ClientID%>").attr("alt-text", text);
            jQuery("#<%=hlAddToList.ClientID%>").attr("alt-onclick", onclick);

        }
        

    </script>
</asp:Panel>
<script>
        
        function ClearList(listid) {
            if (confirm('Are you sure you want to remove all people from your list?')) {
                jQuery.ajax({
                    type: "POST",
                    url: "<%=ResolveUrl(Profiles.Framework.Utilities.Root.Domain + "/Lists/Default.aspx/ClearList")%>",
                    data: "{ListID: '" + listid + "' }",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnListCSuccess,
                    failure: function (response) {
                        //  debugger;
                        // alert(response.d + " " + check_text + " " + obj.checked);

                    }
                });
            }
        }
        function OnListCSuccess(response) {  //debugger; alert(response.d); 
            jQuery("#list-count").html('0');
      }
    
</script>
