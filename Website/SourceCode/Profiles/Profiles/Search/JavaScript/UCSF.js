$(document).ready(function(){
// HP placeholder text
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

});