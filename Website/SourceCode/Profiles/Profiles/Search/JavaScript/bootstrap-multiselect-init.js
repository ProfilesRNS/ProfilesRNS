$(document).ready(function () {
    $('#faculty-multiple-selected').multiselect({
        buttonWidth: '250px',
        maxHeight: 400,
        numberDisplayed: 2,
        onChange: function (option, checked, select) {
            $("#hidList").val((checked) ? $("#hidList").val() + "," + $(option).val() : $("#hidList").val().replace($(option).val() + ',', ''));
        }
    });
    $('#multiple-optgroups-classes').multiselect({
        enableClickableOptGroups: false,
        enableCollapsibleOptGroups: false,
        enableFiltering: false,
        includeSelectAllOption: false,
        maxHeight: 400,
        buttonWidth: '250px',
        numberDisplayed: 2,
        onChange: function (option, checked, select) {
            $("#hdnSelectedText").val((checked) ? $("#hdnSelectedText").val() + "," + $(option).val() : $("#hdnSelectedText").val().replace($(option).val() + ',', ''));
        }
    });
    $('#multiple-cols').multiselect({
        buttonWidth: '120px',
        maxHeight: 200,
        numberDisplayed: 2,
        onDropdownHide: function (event) {
            GetPageData();
            NavToPage();
        },
        onChange: function (option, checked, select) {
            $("#txtshowcolumns").val((checked) ? $("#txtshowcolumns").val() | $(option).val() : $("#txtshowcolumns").val() & ~$(option).val());
        }
    });

    $('#selSort').multiselect({
        buttonWidth: '120px',
        numberDisplayed: 2,
        maxHeight: 400

    });

    $('#institution').multiselect({
        buttonWidth: '250px',
        maxHeight: 400
    });

    $('#department').multiselect({
        buttonWidth: '250px',
        maxHeight: 400

    });



    $('#division').multiselect({
        buttonWidth: '250px',
        maxHeight: 400
    });
    //pull all of the checkboxs in a bit.
    $('.checkbox').attr('style', 'margin-left: -15px !important');



});



