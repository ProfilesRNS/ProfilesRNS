<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditPropertyContainer.ascx.cs"
 Inherits="Profiles.Edit.Modules.EditPropertyContainer.EditPropertyContainer"  %>
<%@ Register Src="~/Profile/Modules/HRFooter/HRFooter.ascx" TagName="Footer" TagPrefix="HRFooter" %>
<asp:PlaceHolder runat="server" ID="phControlContainer"></asp:PlaceHolder>
<HRFooter:Footer runat="server" ID="footer" />