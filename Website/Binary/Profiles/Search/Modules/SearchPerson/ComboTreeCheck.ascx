<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ComboTreeCheck.ascx.cs"
    Inherits="Profiles.Search.Modules.SearchPerson.ComboTreeCheck" %>
<%--
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
 --%>
<div id='<%= "divCTC_" + ClientID %>' class="comboTreeCheck" onmouseover="overCTC(this)"
    onmouseout="outCTC(this);">
    <div class="comboTreeCheckBox">
        <asp:ImageButton ID="ibExpand" runat="server" />
    </div>
    <div id="divMasterContent">
        <asp:Repeater ID="rMasters">
            <ItemTemplate>
            </ItemTemplate>
        </asp:Repeater>
        <input type='hidden' name="hdnSelectedText" id="hdnSelectedText" />
        <asp:Repeater runat="server" ID="rMaster" OnItemDataBound="rMaster_ItemDataBound">
            <ItemTemplate>
                <div id='<%# "divMaster_CTC" + DataBinder.Eval(Container.DataItem, DataMasterIDField)%>'>
                    <img runat="server" id="imgExpand" alt="click to expand" src="~/Images/blank.gif" />
                    <asp:Label ID="lMasterText" runat="server" />
                    <asp:HiddenField ID="hdnIsExpand" Value="0" runat="server" />
                    <asp:HiddenField ID="hdnMasterID" runat="server" />
                    <div id="divDetail" runat="server">
                        <asp:Repeater runat="server" ID="rDetail" OnItemDataBound="rDetail_ItemDataBound">
                            <ItemTemplate>
                                <div id="divDetailCheck">
                                    <asp:HiddenField ID="hdnDetailID" runat="server" />
                                    <asp:HiddenField ID="hdnDetailText" runat="server" />
                                    <asp:CheckBox ID="checkDetailText" runat="server" />
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>
<asp:Literal runat="server" ID="litFilterScript"></asp:Literal>
