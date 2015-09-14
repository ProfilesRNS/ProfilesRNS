<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NetworkCluster.ascx.cs"
    Inherits="Profiles.Profile.Modules.NetworkCluster.NetworkCluster" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%-- 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.

    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
--%>

<div id="divClusterGraph">
<div>
	<div class="clusterWarning">
		Please note that this visualization requires a fast computer and video card. It might cause web browsers on slower machines to become unresponsive.
		<div style='margin-top: 10px;'>
		<a id='showClusterViewLink'>
			<img src="<%= Profiles.Framework.Utilities.Root.Domain %>/Framework/images/icon_squareArrow.gif" border="0" alt="" style="position:relative;top:1px;">&nbsp;Continue to Cluster View
		</a>
		</div>
	</div>
	
<%--<div style="position: absolute; z-index: 999;">--%>
	<div style='display:none;'>
		<div style="width: 600px; font-size: 12px; line-height: 16px; border-bottom: 1px dotted #999;
			padding-bottom: 12px; margin-bottom: 6px;">
			This cluster graph shows the co-authors (green circles) and top co-authors of co-authors (blue circles) of <span style="font-weight: bold; color: #666;">
				<asp:Label ID="lblProfileName" runat="server"></asp:Label></span> (red circle). 
			The size of a circle is proportional to the number of publications that author has. The thickness of a line connecting two authors' names 
			is proportional to the number of publications that they share. Options for customizing this network view are listed below the graph.
		</div>
		<div style="margin-top: 8px; font-weight: bold; color: #BD2F3C; border-bottom: none;
			width: 600px; height: 20px; text-align: center;">
			<div id="person_name">
				<b></b>
			</div>
		</div>
	</div>


<%--<div runat="server" id="divSwfScript" style="width: 600px; height: 600px; position: relative; top: 35px;">--%>
	<div runat="server" id="divSwfScript" class='clusterView' style="height: 485px; position: relative; display: none;">
	   

	</div>

<%--<div style="padding: 0px; width: 600px; text-align: center; position: absolute; top: 770px; z-index: 999;">--%>
	<div style='display:none;'>
		<div style="border-top: 1px dotted #999; font-size: 12px; line-height: 16px; padding-top: 12px;
			margin-top: 8px; text-align: left;">
			<span style="font-weight: bold; color: #666;">Click and drag</span> the name of any author to adjust the clusters. 
			<span style="font-weight: bold; color: #666;">Ctrl-click</span> a name to view that person's network of co-authors. 
			<span style="font-weight: bold; color: #666;">Alt-click</span> a name to view that person's full profile. Please note that it 
			might take several minutes for the clusters in this graph to form, and each time you view the page the graph might look slightly different.	
		</div>
	</div>
</div>
    <br />
    To see the data from this visualization as text, <a id="divShowTimelineTable" tabindex="0">click here.</a>
        
    </div>
    <div id="divDataText" style="display:none;margin-top:12px;margin-bottom:8px;">
		<div style="width: 600px; font-size: 12px; line-height: 16px; border-bottom: 1px dotted #999;
			padding-bottom: 12px; margin-bottom: 6px;">
			This cluster graph shows the co-authors (green circles) and top co-authors of co-authors (blue circles) of <span style="font-weight: bold; color: #666;">
				<asp:Label ID="lblProfileName1" runat="server"></asp:Label></span> (red circle). 
			The size of a circle is proportional to the number of publications that author has. The thickness of a line connecting two authors' names 
			is proportional to the number of publications that they share. Options for customizing this network view are listed below the graph.
                    <br /><br />
        To return to the cluster graph, <a id="dirReturnToTimeline1" tabindex="0">click here.</a>   
		</div>

        <asp:Literal runat="server" ID="litNetworkText"></asp:Literal> 
        <br />
        To return to the cluster graph, <a id="dirReturnToTimeline" tabindex="0">click here.</a>                       
    </div>

<script type="text/javascript">
	// Use jQuery instead of $ to avoid conflicts
	jQuery(function() {
		jQuery('#showClusterViewLink').bind('click', function() {			
			jQuery('div.clusterWarning').hide().siblings('div').show();			
			loadClusterView();
		});
});

jQuery(function () {
    jQuery("#divShowTimelineTable").bind("click", function () {

        jQuery("#divDataText").show();
        jQuery("#divClusterGraph").hide();
    });

    jQuery("#divShowTimelineTable").bind("keypress", function (e) {
        if (e.keyCode == 13) {
            jQuery("#divDataText").show();
            jQuery("#divClusterGraph").hide();
        }
    });
});

jQuery(function () {
    jQuery("#dirReturnToTimeline").bind("click", function () {
        jQuery("#divDataText").hide();
        jQuery("#divClusterGraph").show();
    });

    jQuery("#dirReturnToTimeline").bind("keypress", function (e) {
        if (e.keyCode == 13) {
            jQuery("#divDataText").hide();
            jQuery("#divClusterGraph").show();
        }
    });

    jQuery("#dirReturnToTimeline1").bind("click", function () {
        jQuery("#divDataText").hide();
        jQuery("#divClusterGraph").show();
    });

    jQuery("#dirReturnToTimeline1").bind("keypress", function (e) {
        if (e.keyCode == 13) {
            jQuery("#divDataText").hide();
            jQuery("#divClusterGraph").show();
        }
    });
});
</script>