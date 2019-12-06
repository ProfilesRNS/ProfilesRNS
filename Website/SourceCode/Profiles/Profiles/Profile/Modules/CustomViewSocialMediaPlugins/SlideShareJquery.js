var g_slideshares = [];
var g_ownerID = false;

// ========================================
rssCallback = function (strobj) {

    // process all the items found
    var links = JSON.parse(JSON.stringify(strobj));
    var extracted_data = [];

    // empty any previous slide list
    $(".profile-view-slideshare .ss_list").empty();
    
    for (var i = 0; i < $(links).length; i++) {

        var t = {};
        t = $(links)[i];
        var rec_el = document.createElement("li");
        $(rec_el).attr("data-id", t.id);
        $(rec_el).data(t).appendTo($(".profile-view-slideshare .ss_list"))
      
        t.embed = t.embed.replace("<![CDATA[", "");
        t.embed = t.embed.replace("]]>", "");
        t.embed = t.embed.replace("http://", "https://");
        t.start = t.embed.indexOf("<iframe src=") + 13;
        t.end = t.embed.indexOf('"', t.start);
        t.embed = t.embed.substring(t.start, t.end);     
        //need to find the embed to set the width and height     
        extracted_data.push(t);
    }

    g_slideshares = extracted_data;
    showSlide(0);

    // create the images
    $('.profile-view-slideshare .ss_list li').append(function () {
        $(this).attr("data-id", $(this).data("id"));
        return "<img src='" + $(this).data("thumb") + "'/>";
    });

    // create the text labels
    $('.profile-view-slideshare .ss_list li').append(function () {
        var rtn =$(this).data("title");
        if (rtn.length > 55) {
            rtn = rtn.substring(0,55) + "..."
        }
        return "<div>" + rtn + "</div>";
    });

    $(".profile-view-slideshare .ss_list li").on("click", function (evt) {
        showSlide($(evt.currentTarget).data("id"));
    });

};


// ========================================
showSlide = function (idx) {
    setTimeout(function () {
        $("#slideshow-canvas iframe").attr('src', g_slideshares[idx].embed);
    },100);
}