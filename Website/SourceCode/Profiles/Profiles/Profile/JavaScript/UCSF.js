$(document).ready(function () {
    //move other position below primary title
    if ($('.sectionHeader2').length) {
        $('<br><span id="othpos">&nbsp;</span>').appendTo('.basicInfo tr:nth-child(1) td:nth-child(2)');
        $('.sectionHeader2').siblings().addClass('otherpos');
        $('.otherpos th').html('');
        var str = $('.otherpos').text();
        str = str.replace(";", "<br>");
        $("#othpos").html(str);
        $('.sectionHeader2').parents('.content_two_columns').hide();
    }

    //remove duplicate pubs heading & border
    $('.sectionHeader:contains("Publications")').hide();
    if ($('#gadgets-view').length) {
        $('.PropertyItemHeader:contains("Publications")').css('border-top', 'none').css('line-height', '35px');
    }

    //TOC
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
 
    // important to grab this BEFORE drawing gadgets so that we do not pick up Featured Publications
    var pubs = $('#toc ul li:contains("Publications")');
    //drawGadgetsTOC
    for (var i = 0; (typeof my !== 'undefined') && (i < my.gadgets.length); i++) {
        if (my.gadgets[i].chrome_id == 'gadgets-view') {
            var gadg = my.gadgets[i].name;
            $('#toc ul').append('<li><a href="#remote_iframe_' + i + '_title">' + gadg + '</a></li>');
        }
    }
    //$('#gadgets_toc').html(gadgetsTOC).css('display', 'inline'); ;
    //$('#toc ul li:contains("Publications")').insertAfter('#toc ul li:last-child');

    // Add another thing to TOC
    for (var i = 0; (typeof my !== 'undefined') && (i < my.gadgets.length); i++) {
        if (my.gadgets[i].chrome_id == 'gadgets-view-bottom') {
            var gadg = my.gadgets[i].name;
            var gadg = my.gadgets[i].name;
            $('#toc ul').append('<li><a href="#remote_iframe_' + i + '_title">' + gadg + '</a></li>');
        }
    }
    if ($('#toc ul li').length < 2) {
        $('#toc').hide();
    }
    if (pubs) {
    	pubs.appendTo('#toc ul');
    }
    $('#toc ul li').last().css('border-right', 'none');
    $('#toc ul li').last().css('margin-right', '0');

    //remove border for 1st section
    $('.PropertyItemHeader').first().css('border', 'none');

    //Awards table 
    $('.awardsList td:nth-child(2)').css('white-space', 'nowrap').css('width', '36px');
    if ($('.awardsList tr').length > 4) {
        $('.awardsList tr:gt(2)').hide();
        $("<div class='atog' id='moreawards'><span> <strong>...</strong> Show more</span> <img src='" + _rootDomain + "/Framework/Images/expandRound.gif' alt='+' style='vertical-align:top' /></div>").appendTo('.awardsList tr:nth-child(3) td:last-child');
        $("<div class='atog' id='lessawards'><span>Show less</span> <img src='" + _rootDomain + "/Framework/Images/collapseRound.gif' alt='-' style='vertical-align:top' /></div>").appendTo('.awardsList tr:last-child td:last-child');
    }
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


    //Overview expand/collapse
    $('.PropertyItemHeader:contains("Overview")').next('.PropertyGroupData').attr("id","narrative");
    if ($('#narrative').text().length > 800) {
        $('#narrative').addClass('box');
    }
    $('.box').addClass('box-collapsed');
    $('.box').first().prepend("<div class='plusbutton'><span> <strong>&nbsp;...</strong> Show more</span> <img src='" +_rootDomain + "/Framework/Images/expandRound.gif' alt='+' style='vertical-align:top' /></div><div class='minusbutton'><span>Show less</span> <img src='" + _rootDomain + "/Framework/Images/collapseRound.gif' alt='-' style='vertical-align:top' /></div>");
    $('.minusbutton').hide();
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

});


