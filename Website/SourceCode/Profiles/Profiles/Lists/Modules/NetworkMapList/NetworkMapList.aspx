<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="NetworkMapList.aspx.cs" Inherits="Profiles.Lists.Modules.NetworkMapList.NetworkMapList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head id="head" runat="server">
    <title></title>

    <style type="text/css">
        body {
            font-family: arial, sans-serif;
            font-size: 13px;
        }

        div.slider div.handle {
            top: -7px !important;
        }


        #map_canvas {
            height: 500px;
            border: 1px solid #999;
            text-align: center;
        }

        a {
            color: #3366CC;
            text-decoration: none;
        }
        a:hover{text-decoration:underline;}
    </style>
</head>
<body id="bodyMaster" runat="server">
    <script type="text/javascript">
        var longitude;
        var latitude;
        if (typeof ProfilesRNS.currentPage === "undefined") ProfilesRNS.currentPage = {};
        if (typeof ProfilesRNS.currentPage.data === "undefined") ProfilesRNS.currentPage.data = {};
        if (typeof ProfilesRNS.currentPage.data.people === "undefined") ProfilesRNS.currentPage.data.people = {};
        if (typeof ProfilesRNS.currentPage.data.network === "undefined") ProfilesRNS.currentPage.data.network = {};
        if (typeof ProfilesRNS.currentPage.gmap === "undefined") ProfilesRNS.currentPage.gmap = {};
        if (typeof ProfilesRNS.currentPage.gmap.setCenter === "undefined") ProfilesRNS.currentPage.gmap.setCenter = {};


    </script>
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script type="text/javascript" src="//maps.googleapis.com/maps/api/js<%= googleKey %>"></script>
    <script type="text/javascript">
        function zoomMap(zoom, latitude, longitude) {
            ProfilesRNS.currentPage.gmap.setCenter(new google.maps.LatLng(latitude, longitude));
            ProfilesRNS.currentPage.gmap.setZoom(zoom);
        }
    </script>
    <asp:Literal ID="litGoogleCode" runat="server"></asp:Literal>
    <div>
        <div id="divData">
            <div style="width: 100%; margin-top: 16px; font-size: 13px; line-height: 16px; border-bottom: 1px dotted #999; padding-bottom: 12px; margin-bottom: 6px;">
                <span style="color: #C00; font-weight: bold;">Red markers</span> indicate the
                <asp:Literal ID="litRedMapType" runat="server" />.
            <asp:Label ID="lblPerson" runat="server"></asp:Label>
                <span style="color: #00C; font-weight: bold;">Blue lines</span> connect people who
         have published papers together.
            </div>

            <div style="margin-bottom: 5px;">
                <b>Zoom</b>:&nbsp;&nbsp;
        <asp:DataList ID="dlGoogleMapLinks" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
            <ItemTemplate>
                <a style="cursor: pointer" id="lnkMapLink" runat="server" onkeypress='<%# "if (event.keyCode == 13) JavaScript:zoomMap(" + Eval("ZoomLevel") + "," + Eval("Latitude") + "," + Eval("Longitude") + "); "%>' onclick='<%# "JavaScript:zoomMap(" + Eval("ZoomLevel") + "," + Eval("Latitude") + "," + Eval("Longitude") + "); "%>' tabindex="0">
                    <asp:Label ID="lblMapLink" runat="server" Text='<%#Eval("Label")%>'></asp:Label></a>
            </ItemTemplate>
            <SeparatorTemplate>
                &nbsp;|&nbsp;
            </SeparatorTemplate>
        </asp:DataList>
            </div>
            <div id="map_canvas">
            </div>
        </div>

        <script type="text/javascript">
            ProfilesRNS.currentPage.data.mapCenter = new google.maps.LatLng(latitude, longitude);
            ProfilesRNS.currentPage.clickLocation = function () {
                // This function is called when the user clicks on a marker
                ProfilesRNS.currentPage.ginfowindow.setContent(this.dataRecord.txt);
                ProfilesRNS.currentPage.ginfowindow.open(ProfilesRNS.currentPage.gmap, this);
            };
            ProfilesRNS.currentPage.loadData = function () {
                // create markers for people
                // var l = ProfilesRNS.currentPage.data.people.length; <== bug: thanks Microsoft
                for (var i = 0; typeof ProfilesRNS.currentPage.data.people[i] !== "undefined"; i++) {
                    if (typeof ProfilesRNS.currentPage.data.people[i].pin === "undefined") {
                        var pin = new google.maps.Marker({
                            position: new google.maps.LatLng(ProfilesRNS.currentPage.data.people[i].lt, ProfilesRNS.currentPage.data.people[i].ln),
                            title: ProfilesRNS.currentPage.data.people[i].name,
                            dataRecord: ProfilesRNS.currentPage.data.people[i]
                        });

                        // click event handler
                        google.maps.event.addListener(pin, 'click', ProfilesRNS.currentPage.clickLocation);

                        // drop animation
                        setTimeout("ProfilesRNS.currentPage.data.people[" + i + "].pin.setMap(ProfilesRNS.currentPage.gmap);", 100 * i);

                        // save reference to data array
                        ProfilesRNS.currentPage.data.people[i].pin = pin;
                        pin = null;
                    }
                }
                // create network lines
                //var l = ProfilesRNS.currentPage.data.network.length; <== bug: thanks Microsoft IE8
                for (var i = 0; typeof ProfilesRNS.currentPage.data.network[i] !== "undefined"; i++) {
                    if (typeof ProfilesRNS.currentPage.data.network[i].overlay === "undefined") {
                        var conData = ProfilesRNS.currentPage.data.network[i];
                        var conOptions = {
                            map: ProfilesRNS.currentPage.gmap,
                            strokeOpacity: 0.5,
                            path: [new google.maps.LatLng(conData.p1[0], conData.p1[1]),
                            new google.maps.LatLng(conData.p2[0], conData.p2[1])]
                        };
                        if (conData.zm == 1) {
                            conOptions.strokeColor = '#9900CC';
                            conOptions.strokeWeight = 6;
                        } else {
                            conOptions.strokeColor = '#0000FF';
                            conOptions.strokeWeight = 2;
                        };
                        // save back to data array
                        ProfilesRNS.currentPage.data.network[i].overlay = new google.maps.Polyline(conOptions);
                    }
                }
            };


            ProfilesRNS.currentPage.InitPage = function () {
                // Google map options
                var goptions = {
                    zoom: 13,
                    center: ProfilesRNS.currentPage.data.mapCenter,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };

                // create google map object
                ProfilesRNS.currentPage.gmap = new google.maps.Map(document.getElementById("map_canvas"), goptions);

                // create our info window object
                ProfilesRNS.currentPage.ginfowindow = new google.maps.InfoWindow;

                // load the points in a second (allow map render)
                setTimeout(ProfilesRNS.currentPage.loadData, 500);
            }        // INITIALIZE ON PAGE LOAD
            $(document).ready(function () {
                ProfilesRNS.currentPage.InitPage();
                ProfilesRNS.currentPage.InitPage();
            });
            jQuery('a[href*="<%=Profiles.Framework.Utilities.Root.Domain%>"]').attr('target', '_parent');

        </script>

    </div>
</body>
</html>
