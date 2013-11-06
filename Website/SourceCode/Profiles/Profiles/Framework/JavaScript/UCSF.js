$(document).ready(function () {
    // logged in/out subnav
  if ($('#defaultmenu') && $('#defaultmenu').length) {
    $('#defaultmenu ul').addClass('mainmenu');
    $(".mainmenu li:contains('RDF')").addClass('rdf').appendTo('.profilesMainColumnRight').hide();
    if ($('.mainmenu li').last().text() == 'Login to Profiles') {
        var login = $('.mainmenu li:last-child a').attr('href');
        $('#signinlink').attr('href', login);
    }
    if ($('.mainmenu li').last().text() == 'Sign out' ||
      $('.mainmenu li').last().text() == 'Logout') {
        $("#signin").hide();
        for (var index = 3; index < $('.mainmenu li').length; index++) {
            $('.mainmenu li').eq(index).clone().appendTo('#editmenu');
        }
        $("#active-nav").css('background-color', '#EEEEEE');
        $('#editmenu li').last().css('border-right', 'none');
        $("#editmenu li:contains('Sign out')").addClass('logout');
        if ($('#editmenu li:first-child img').length) {
            $('#editmenu li:first-child img').prependTo('#editmenu li:nth-child(2) a').wrap('<div id="menuthumb" />');
            $('#editmenu li:first-child').remove();
        }
        if ($('.mainmenu li:nth-child(4)').text() == 'Edit My Profile' ||
         $('.mainmenu li:nth-child(5)').text() == 'Edit My Profile') {
            $('#editmenu li:first-child').append(' <span>is signed in</span>');
        }
    }
  }

    // navbarsearch
    // move & hide on main search pages
  if ($('#navbarsearch') && $('#navbarsearch').length) {
    $('#navbarsearch').appendTo('#suckerfishmenu');
    if ($('.nonavbar').length) {
        $('#navbarsearch').remove();
    }
    // placeholder text
    function initiateSearchText() {
        $("#searchterm").css('color', '#999');
        $("#searchterm").attr('value', 'e.g. Smith or HIV');
    }
    initiateSearchText();

    var default_value = $("#searchterm").value;
    $("#searchterm").focus(function () {
        if ($("#searchterm").value == default_value) {
            this.value = '';
            $(this).css('color', '#000');
        }
    });
    $("#searchterm").blur(function () {
        if ($("#searchterm").value == '') {
            $("#searchterm").css('color', '#999');
            $("#searchterm").value = default_value;
        }
    });
  }

  if(window.location.href.indexOf("coauthors") == -1) {
    $("table").removeAttr("border").removeAttr("rules");

    // get links count
    $.ajax({
        type: "GET",
        url: _rootDomain + "/CustomAPI/v1/Statistics.aspx",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) { buildGadgetAds(response.links); },
        failure: function (response) { buildGadgetAds('2147'); }
    });

    // Back to top http://typicalwhiner.com/116/effortless-jquery-floating-back-to-top-script-v2/
    var pxShow = 300; //height on which the button will show  
    var fadeInTime = 1000;  //how slow/fast you want the button to show  
    var fadeOutTime = 1000;  //how slow/fast you want the button to hide  
    var scrollSpeed = 1000;  //how slow/fast you want the button to scroll to top
    $(window).scroll(function () {
        if ($(window).scrollTop() >= pxShow) {
            $("#backtotop").fadeIn(fadeInTime);
        } else {
            $("#backtotop").fadeOut(fadeOutTime);
        }
    });

    $('#backtotop a').click(function () {
        $('html, body').animate({ scrollTop: 0 }, scrollSpeed);
        if (window.location.hash.length > 1) {
            window.location.hash = "";
        }
        return false;
    });

  }
});

 function buildGadgetAds(linksCount) {
    //Gadget ads  
    var links = "<li><div class='badge'>"
            + "<p><span class='counter'>" + linksCount + "</span> profiles now<br />"
            + "include <strong>links</strong> to departments, labs and other websites.</p>"
            + "<p class='linkAd'>"
            + "<a href='" + _rootDomain + "/login/default.aspx?method=login&amp;edit=true'>Add web links <br />to your profile</a></p>"
            + "</div></li>";
    var videointro = "<li><a href='https://www.youtube.com/watch?v=YCOA2GWyplY' target='_blank'>"
            + "<div class='badge'><p style='padding-left:3px'>"
            + "<img src='" + _rootDomain + "/framework/images/video-ad.png' /></p>"
            + "<p><strong>Watch UCSF Profiles video introduction!</strong></p></div></a></li>";
    // for individual profile pages
    if ($('.basicInfo').length) {
        var badge = "<ul id='badge'>" + chattergroup + chatterfollow + "</ul>";
        $(badge).insertAfter('.profilesContentPassive');
        $(".badge").css('width', '192px');
        var login = $('#ctl00_ContentActive_rptActive_ctl01_ctl00_panelMenu li:last-child a').attr('href');
        $('.chatterlink').attr('href', login);
        $("#badge li").hide();
        randomtip();
    }
    // for search form pages
    if ($('.nonavbar').length && !$('#FSSiteDescription').length) {
        var badge = "<ul id='badge'>" + links + videointro + "</ul>";
        $(badge).insertAfter('.profilesContentPassive');
        var login = $('#ctl00_ContentActive_rptActive_ctl00_ctl00_panelMenu li:last-child a').attr('href');
        $('.chatterlink').attr('href', login);
        $("#badge li").hide();
        randomtip();
    }
    if ($('.mainmenu li').last().text() == 'Sign out') {
        $("#badge").hide();
    }

}


        this.randomtip = function () {
            var length = $("#badge li").length;
            var ran = Math.floor(Math.random() * length) + 1;
            $("#badge li:nth-child(" + ran + ")").show();
        };
