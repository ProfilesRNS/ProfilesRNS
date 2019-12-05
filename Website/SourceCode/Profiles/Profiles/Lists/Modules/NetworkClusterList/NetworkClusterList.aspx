<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="NetworkClusterList.aspx.cs"
    Inherits="Profiles.Lists.Modules.NetworkClusterList.NetworkClusterList" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">div {font-family:Arial;}</style>
</head><body id="bodyMaster" style="width:100%" runat="server">
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<div id="divClusterGraph" style="margin-top:16px;width:100%">
    <div>
        <div>
            <div style="width: 99%; font-size: 12px; line-height: 16px; border-bottom: 1px dotted #999; padding-bottom: 12px; margin-bottom: 6px;">
                This cluster graph shows the coauthor relationships among people in this list.  The size of a circle is proportional to the number of publications that author has. The thickness of a line connecting two authors' names is proportional to the number of publications that they share. Options for customizing this network view are listed below the graph.
            </div>
            <div style="margin-top: 8px; font-weight: bold; color: #BD2F3C; border-bottom: none; width: 100%; height: 20px; text-align: center;">
                <div id="person_name">
                    <b></b>
                </div>
            </div>
        </div>

        <div runat="server" id="divSwfScript" class='clusterView' style="position: relative;">
        </div>

        <div>
            <div style="border-top: 1px dotted #999; font-size: 12px; line-height: 16px; padding-top: 12px; margin-top: 8px; text-align: left;">
                <span style="font-weight: bold; color: #666;">Click and drag</span> the name of any author to adjust the clusters. 
			    <span style="font-weight: bold; color: #666;">Shift-click and drag</span> the name of any author to move them and pin it to a fixed location. Click again to unlock the position.
			    <span style="font-weight: bold; color: #666;">Alt-click</span> a name to view that person's full profile. Please note that it 
			    might take several minutes for the clusters in this graph to form, and each time you view the page the graph might look slightly different.	
            </div>
        </div>
    </div>  
</div>

    <script type="text/javascript">

        // Use jQuery instead of $ to avoid conflicts
        jQuery(function () {
            // global scope name for watchdog timer
            // call watchdog.cancel() to prevent error message from showing in HTML
            watchdog = new WatchdogTimer(30000, function () {
                var el = jQuery(".clusterView");
                el = el[0];
                el.innerHTML = "<h2>There was a problem loading this visualization. You might need to upgrade your browser or select one of the options below.</h2>";
                el.style.height = "auto";
                jQuery(el.nextSibling).remove();
            });
            // load the visualization
            loadClusterView();
        });
    </script>
</body>
</html>
