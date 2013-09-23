$(document).ready(function(){
// HP placeholder text (not used)
  function initiateSearchText(){
    $(".keywordsName").css('color','#999');
    $(".keywordsName").attr('value','e.g. latina HIV or John Smith');
  }
//  initiateSearchText();

    var default_value = $(".keywordsName").value;
    $(".keywordsName").focus(function() {
        if($(".keywordsName").value == default_value) {
            this.value = '';
            $(this).css('color','#000');
        }
    });
    $(".keywordsName").blur(function() {
        if($(".keywordsName").value == '') {
            $(".keywordsName").css('color','#999');
            $(".keywordsName").value = default_value;
        }
  });

  // Skip placeholder & just focus
  $("#txtSearchFor").focus();

  // hide researcher type list when user clicks outside of it
  $("body").click(function() {
      $("#divChkList").hide();
  });
  $("#ddlChkList").click(function(e) {
      e.stopPropagation();
  });
  $("#divChkList").click(function(e) {
      e.stopPropagation();
  });

  //search results adjustments
  $('#tblSearchResults tr').find('td:eq(0)').addClass('linky');
  $('#ctl00_ContentMain_rptMain_ctl00_ctl00_gvIndirectConnectionDetails td:last-child').addClass('linky');
  $('#ctl00_ContentMain_rptMain_ctl00_ctl00_gvConnectionDetails td:last-child').addClass('linky');
  $("th:contains('Why')").css("text-align","center");
  $("#tblSearchResults th:contains('Type')").css("text-align","center");
  $("#tblSearchResults th:contains('Researcher Type')").css("text-align","left");
  
});