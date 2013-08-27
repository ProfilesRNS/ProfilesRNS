<%Server.Transfer("~/DIRECT/Modules/DirectSearch/DirectService.aspx?Request=" & Request.QueryString("Request") & "&SearchPhrase=" & Request.QueryString("SearchPhrase"))
response.End()


  %>