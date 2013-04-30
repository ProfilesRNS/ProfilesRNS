$(document).ready(function(){
  $('.profilesMainColumnLeft').each(function(idx,el){
    el.style.width='900px';
  });
  $('.profilesContentMain').each(function(idx,el){
    el.style.width='900px';
  });
  $('#profile-components table tr td:nth-child(2)').css('color','#FFFFFF');
  $('#profile-components table tr td:nth-child(1)').addClass('first');  
//  $('#profile-visibility table tr:nth-child(3)').css('display','none');
  $("#cls").hide();


$("#namedegree").hover( 
  function () { 
    $("#cls").show(); 
    $("#public").hide();
  }, 
  function () { 
    $("#cls").hide(); 
    $("#public").show();
  } 
);

// edit overview help text
if ($('#ctl00_ContentMain_rptMain_ctl00_ctl00_ctl00_GridViewProperty tr.topRow th:first-child').text() == 'Overview') {
    $('#ctl00_ContentMain_rptMain_ctl00_ctl00_ctl00_GridViewProperty tr.topRow th:first-child').append(' <span style="font-weight:normal">(Note: to see paragraph breaks, edit overview or view profile)</span>');
}

});
