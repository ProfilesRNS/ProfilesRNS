

FeaturedVideos = {};

FeaturedVideos.init = function (playlist) {    
    playlist_render(JSON.parse(playlist));
};


// ========================================================================= //
playlist_render = function (data) {    

    // empty any previous video list
    $(".youtube .yt_list").empty();

    // set the player to show the first video [IFRAMES load asynchronously ]
    select_video(data[0].id);

    // create the list items and associate the data to the element [jQuery.data() operation]
    for (var i = 0; i < data.length; i++) {
        var rec_el = document.createElement("li");
        $(rec_el).data(data[i]).appendTo($(".youtube .yt_list"));

    }

    // create the images
    $('.youtube .yt_list li').append(function () {
        $(this).attr("data-id", $(this).data("id"));
        return "<img src='https://i.ytimg.com/vi/" + $(this).data("id") + "/default.jpg' />";
    });

    // create the text labels
    $('.youtube .yt_list li').append(function () {        
        return "<div>" + $(this).data("name") + "</div>";       
    });


    // attach event handlers to handle click events on the list
    $(".youtube .yt_list li").on("click", function (evt) {
        //console.dir($(evt.currentTarget).data("id"));
        select_video($(evt.currentTarget).data("id"));
    });
};

// ========================================================================= //
select_video = function (video_id) {
    $(".youtube iframe.yt_player").attr("src", "https://www.youtube.com/embed/" + video_id + "?autoplay=0&amp;version=3&amp;showinfo=1&amp;&rel=0");
};
