$(document).ready(function () {
    //move other position below primary title
    if ($('.sectionHeader2') && $('.sectionHeader2').length) {
        $('<br><span id="othpos">&nbsp;</span>').appendTo('.basicInfo:first-child tr:nth-child(1) td:nth-child(2)');
        $('.sectionHeader2').siblings().addClass('otherpos');
        $('.otherpos th').html('');
	$('.otherpos td:not(:empty)').append('%');
        var str = $('.otherpos').text();
 	str = str.replace(/\%/g, "<br>");
 	str = str.replace(/\;/g, "<br>");
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
        $("<div class='atog' id='moreawards'><span> <strong>...</strong> Show more</span> <img src='" + _rootDomain + "/Framework/Images/expandRound.gif' alt='+' style='vertical-align:top'  width='28' height='17'/></div>").appendTo('.awardsList tr:nth-child(3) td:last-child');
        $("<div class='atog' id='lessawards'><span>Show less</span> <img src='" + _rootDomain + "/Framework/Images/collapseRound.gif' alt='-' style='vertical-align:top' width='28' height='17'/></div>").appendTo('.awardsList tr:last-child td:last-child');
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

    //Education expand/collapse
    if ($('.education') && $('.education tr').length > 4) {
        $('.education tr:gt(3)').hide();
        $("<div class='atog' id='moreeduc'><span> <strong>...</strong> Show more</span> <img src='" + _rootDomain + "/Framework/Images/expandRound.gif' alt='+' style='vertical-align:top'  width='28' height='17'/></div>").appendTo('.education');
        $("<div class='atog' id='lesseduc' style='display:none'><span>Show less</span> <img src='" + _rootDomain + "/Framework/Images/collapseRound.gif' alt='-' style='vertical-align:top' width='28' height='17'/></div>").appendTo('.education');
    }
  if ($('#moreeduc') && $('#moreeduc').length) {
    $('#moreeduc').click(function () {
        $('.education tr:gt(3)').toggle();
        $('#moreeduc').hide();
        $('#lesseduc').show();
    });
 
    $('#lesseduc').click(function () {
        $('.education tr:gt(3)').toggle();
        $('#moreeduc').show();
        $('#lesseduc').hide();
    });
  }

    //Overview expand/collapse
  if ($('.basicInfo') && $('.basicInfo').length) {
    $('.PropertyItemHeader:contains("Overview")').next('.PropertyGroupData').attr("id","narrative");
    if ($('#narrative').text().length > 800) {
        $('#narrative').addClass('box').addClass('box-collapsed');
        $('.box').first().prepend("<div class='plusbutton'><span> <strong>&nbsp;...</strong> Show more</span> <img src='" + _rootDomain + "/Framework/Images/expandRound.gif' alt='+' style='vertical-align:top'  width='28' height='17'/></div><div class='minusbutton'><span>Show less</span> <img src='" + _rootDomain + "/Framework/Images/collapseRound.gif' alt='-' style='vertical-align:top' width='28' height='17'/></div>");
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




