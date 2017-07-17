<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NetworkRadial.ascx.cs"
    Inherits="Profiles.Profile.Modules.NetworkRadial.NetworkRadial" %>
<%-- 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.

    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
--%>



<%--<div style="position: absolute; z-index: 999;">--%>

    <div>


            This radial graph shows the co-authors (inner ring) and top co-authors of co-authors
            (outer ring) of <span style="font-weight: bold; color: #666;">
                <asp:Label ID="lblProfileName" runat="server"></asp:Label></span>. The size
            of the red circle around an author's name is proportional to the number of publications
            that he or she has. The thickness of a line connecting two authors' names is proportional
            to the number of publications that they share. Options for customizing this network
            view are listed below the graph.
        </div>
<div id="divRadialGraph">
        <div style="width: 600px; font-size: 12px; line-height: 16px; border-bottom: 1px dotted #999;
            padding-bottom: 12px; margin-bottom: 6px;"></div>
    <div>
        <div style="margin-top: 8px; font-weight: bold; color: #BD2F3C; border-bottom: none;
            width: 600px; height: 20px; text-align: center;">
            <div id="graph_info">
                <b></b>
            </div>
        </div>
    </div>

    <%--<div runat="server" id="divSwfScript" style="width: 600px; height: 600px; position: relative; top: 35px;">--%>
    <div runat="server" id="divSwfScript" style="height: 510px;" class="clusterView">
        <svg  id="radial_view" height="100%" width="100%" fill="#999900" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="visibility:hidden;"></svg>
    </div>

    <%--<div style="padding: 0px; width: 600px; text-align: center; position: absolute; top: 770px; z-index: 999;">--%>
    <div style="margin-top: 15px">
        <table id="viz_sliders">
            <tr style="font-size: 11px;">
                <td style="text-align: left; line-height: 12px; padding-bottom: 10px; padding-top: 0px; font-size:11px">
                    Minimum number of publications
                </td>
                <td style="text-align: left; line-height: 12px; padding-bottom: 10px; padding-top: 0px; font-size:11px">
                    Minimum number of co-publications
                </td>
                <td style="text-align: left; line-height: 12px; padding-bottom: 10px; padding-top: 0px; font-size:11px">
                    Year of most recent co-publication
                </td>
            </tr>
            <tr>
                <td>
                    <div id="copubs" class="slider">
                        <div id="copubs_handle" class="handle">
                        </div>
                        <div id="copubs_track" class="span">
                        </div>
                    </div>
                </td>
                <td>
                    <div id="pub_cnt" class="slider">
                        <div id="pub_cnt_handle" class="handle">
                        </div>
                        <div id="pub_cnt_track" class="span">
                        </div>
                    </div>
                </td>
                <td>
                    <div id="pub_date" class="slider">
                        <div id="pub_date_handle" class="handle">
                        </div>
                        <div id="pub_cnt_track" class="span">
                        </div>
                    </div>
                </td>
            </tr>
            <tr style="line-height: 10px; text-align: right; color: #555; font-size: 10px; margin-top: 12px;
                padding-top: 0px;">
                <td style="padding-right: 16px; font-size:11px" id="lbl_pubs">
                    any number
                </td>
                <td style="padding-right: 16px; font-size:11px" id="lbl_copubs">
                    any collaboration
                </td>
                <td style="padding-right: 16px; font-size:11px" id="lbl_recent">
                    any year
                </td>
            </tr>
        </table>
        <div id="viz_instructions" style="border-top: 1px dotted #999; font-size: 12px; line-height: 16px; padding-top: 12px;
            margin-top: 8px; text-align: left;" >
            Use the <span style="font-weight: bold; color: #666;">sliders</span> to 1) hide
            authors who have fewer than the selected minimum number of publications, 2) hide
            lines that represent fewer than the selected minimum number of co-publications,
            or 3) hide lines that represent co-publications that were written before the selected
            year. <span style="font-weight: bold; color: #666;">Click</span> the name of any
            author to re-center the graph on that person. <span style="font-weight: bold; color: #666;">
                Ctrl-click</span> a name to view that person's network of co-authors. <span style="font-weight: bold;
                    color: #666;">Alt-click</span> a name to view that person's full profile. <span style="font-weight: bold;
                    color: #666;">Shift-click</span> a name to highlight the mutual co-authorships of that person's co-authors.
        </div>
        <br />
        To see the data from this visualization as text, <a id="divShowTimelineTable" tabindex="0" class="jQueryLink">click here.</a>
        <br />
        To view this visualization using Flash (for older browsers), <a id="divShowFlash" tabindex="0" class="jQueryLink">click here.</a>                    
    </div>
</div>
    <div id="divTimelineTable" class="listTable" style="display:none;margin-top:12px;margin-bottom:8px;">
            To return to the radial graph, <a id="dirReturnToTimeline1" tabindex="0" class="jQueryLink">click here.</a>   
                    <div style="width: 600px; font-size: 12px; line-height: 16px; border-bottom: 1px dotted #999;
            padding-bottom: 12px; margin-bottom: 6px;"></div>
            <asp:Literal runat="server" ID="litNetworkText"></asp:Literal> 
            <br />
            To return to the radial graph, <a id="dirReturnToTimeline" tabindex="0" class="jQueryLink">click here.</a>
    </div>
 <div id="divFlashGraph" style="display:none; position: relative;" class="clusterView">
 <div style="width: 600px; font-size: 12px; line-height: 16px; border-bottom: 1px dotted #999;
            padding-bottom: 12px; margin-bottom: 6px;"></div>
       <asp:HtmlIframe> <iframe id="iFrameFlashGraph" runat="server" width="610px" height="610px" frameborder="0" style="overflow:hidden;"></iframe></asp:HtmlIframe>
                <div style="border-top: 1px dotted #999; font-size: 12px; line-height: 16px; padding-top: 12px;
            margin-top: 8px; text-align: left;">
            Use the <span style="font-weight: bold; color: #666;">sliders</span> to 1) hide
            authors who have fewer than the selected minimum number of publications, 2) hide
            lines that represent fewer than the selected minimum number of co-publications,
            or 3) hide lines that represent co-publications that were written before the selected
            year. <span style="font-weight: bold; color: #666;">Click</span> the name of any
            author to re-center the graph on that person. <span style="font-weight: bold; color: #666;">
                Ctrl-click</span> a name to view that person's network of co-authors. <span style="font-weight: bold;
                    color: #666;">Alt-click</span> a name to view that person's full profile. <span style="font-weight: bold;
                    color: #666;">Shift-click</span> a name to highlight the mutual co-authorships of that person's co-authors.
        <br /><br />
        To return to the HTML5 visulization, <a id="divReturnToHTML5" tabindex="0" class="jQueryLink">click here.</a>                    
    </div>
    </div>

<script type="text/javascript">
    jQuery(function () {
        // global scope name for watchdog timer
        // call watchdog.cancel() to prevent error message from showing in HTML
        watchdog = new WatchdogTimer(30000, function () {
            jQuery("#viz_sliders").remove();
            jQuery("#viz_instructions").remove();
            var el = jQuery("#radial_view");
            el = el[0].parentNode;
            el.innerHTML = "<h2>There was a problem loading this visualization. You might need to upgrade your browser or select one of the options below.</h2>";
            el.style.height = "auto";
        });
    });


    jQuery(function () {
        jQuery("#divShowTimelineTable").bind("click", function () {

            jQuery("#divTimelineTable").show();
            jQuery("#divRadialGraph").hide();
        });

        jQuery("#divShowTimelineTable").bind("keypress", function (e) {
            if (e.keyCode == 13) {
                jQuery("#divTimelineTable").show();
                jQuery("#divRadialGraph").hide();
            }
        });
    });

    jQuery(function () {
        jQuery("#divShowFlash").bind("click", function () {

            jQuery("#divFlashGraph").show();
            jQuery("#divRadialGraph").hide();
            var item = jQuery("$iframe[id*='iFrameFlashGraph']")[0];
            item.src = item.getAttribute("data-src");
        });

        jQuery("#divShowFlash").bind("keypress", function (e) {
            if (e.keyCode == 13) {
                jQuery("#divFlashGraph").show();
                jQuery("#divRadialGraph").hide();
                var item = jQuery("$iframe[id*='iFrameFlashGraph']")[0];
                item.src = item.getAttribute("data-src");
            }
        });
    });

    jQuery(function () {
        jQuery("#divReturnToHTML5").bind("click", function () {

            jQuery("#divFlashGraph").hide();
            jQuery("#divRadialGraph").show();
        });

        jQuery("#divReturnToHTML5").bind("keypress", function (e) {
            if (e.keyCode == 13) {
                jQuery("#divFlashGraph").hide();
                jQuery("#divRadialGraph").show();
            }
        });
    });

    jQuery(function () {
        jQuery("#dirReturnToTimeline").bind("click", function () {
            jQuery("#divTimelineTable").hide();
            jQuery("#divRadialGraph").show();
        });

        jQuery("#dirReturnToTimeline").bind("keypress", function (e) {
            if (e.keyCode == 13) {
                jQuery("#divTimelineTable").hide();
                jQuery("#divRadialGraph").show();
            }
        });

        jQuery("#dirReturnToTimeline1").bind("click", function () {
            jQuery("#divTimelineTable").hide();
            jQuery("#divRadialGraph").show();
        });

        jQuery("#dirReturnToTimeline1").bind("keypress", function (e) {
            if (e.keyCode == 13) {
                jQuery("#divTimelineTable").hide();
                jQuery("#divRadialGraph").show();
            }
        });
    });
</script>