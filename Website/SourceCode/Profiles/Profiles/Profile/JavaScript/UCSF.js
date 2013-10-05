$(document).ready(function () {
    //move other position below primary title
    if ($('.sectionHeader2') && $('.sectionHeader2').length) {
        $('<br><span id="othpos">&nbsp;</span>').appendTo('.basicInfo tr:nth-child(1) td:nth-child(2)');
        $('.sectionHeader2').siblings().addClass('otherpos');
        $('.otherpos th').html('');
        var str = $('.otherpos').text();
        str = str.replace(";", "<br>");
        $("#othpos").html(str);
        $('.sectionHeader2').parents('.content_two_columns').hide();
    }


  //TOC
  if ($('#toc') && $('#toc').length) {
    $('.panelMain .PropertyItemHeader').addClass('toc-item');
    $('.toc-item').attr("id", function (arr) {
        return 'toc-id' + arr;
    });
    $('.toc-item').each(function () {
        var id = $(this).attr('id');
        var txt = $.trim($(this).text());
        var alink = '<li><a href=#' + id + '>' + txt + '</a></li>';
        $('#toc ul').append(alink);
    });

    if ($('#toc ul li').length < 3) {
        $('#toc').hide();
    }
   // $('#toc ul li:contains("Publications")').appendTo('#toc ul');
    $('#toc ul li').last().css('border-right', 'none').css('margin-right', '0');

    //remove border for 1st section
    $('.PropertyItemHeader').first().css('border', 'none');
  }

    //Awards table 
  if ($('.awardsList') && $('.awardsList').length) {
    $('.awardsList td:nth-child(2)').css('white-space', 'nowrap').css('width', '36px');
  }
    if ($('.awardsList') && $('.awardsList tr').length > 4) {
        $('.awardsList tr:gt(2)').hide();
        $("<div class='atog' id='moreawards'><span> <strong>...</strong> Show more</span> <img src='" + _rootDomain + "/Framework/Images/expandRound.gif' alt='+' style='vertical-align:top' /></div>").appendTo('.awardsList tr:nth-child(3) td:last-child');
        $("<div class='atog' id='lessawards'><span>Show less</span> <img src='" + _rootDomain + "/Framework/Images/collapseRound.gif' alt='-' style='vertical-align:top' /></div>").appendTo('.awardsList tr:last-child td:last-child');
    }
  if ($('#moreawards') && $('#moreawards').length) {
    $('#moreawards').click(function () {
        $('.awardsList tr:gt(2)').toggle();
        $('#moreawards').hide();
        $('#lessawards').show();
    });
 
    $('#lessawards').click(function () {
        $('.awardsList tr:gt(2)').toggle();
        $('#moreawards').show();
        $('#lessawards').hide();
    });
  }


    //Overview expand/collapse
  if ($('.basicInfo') && $('.basicInfo').length) {
    $('.PropertyItemHeader:contains("Overview")').next('.PropertyGroupData').attr("id","narrative");
    if ($('#narrative').text().length > 800) {
        $('#narrative').addClass('box').addClass('box-collapsed');
        $('.box').first().prepend("<div class='plusbutton'><span> <strong>&nbsp;...</strong> Show more</span> <img src='" +_rootDomain + "/Framework/Images/expandRound.gif' alt='+' style='vertical-align:top' /></div><div class='minusbutton'><span>Show less</span> <img src='" + _rootDomain + "/Framework/Images/collapseRound.gif' alt='-' style='vertical-align:top' /></div>");
        $('.minusbutton').hide();
    }
   // $('.box').addClass('box-collapsed');
    $('.plusbutton').click(function () {
        $(this).parent().removeClass('box-collapsed');
        $(this).parent().addClass('box');
        $('.minusbutton').show();
        $(this).hide();
    });
    $('.minusbutton').click(function () {
        $(this).parent().addClass('box-collapsed');
        $(this).parent().removeClass('box');
        $('.plusbutton').show();
        $(this).hide();
        location.href = "#narrative";
    });
  }

});




