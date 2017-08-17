/*  
 
Copyright (c) 2008-2015 by the President and Fellows of Harvard College. All rights reserved.  
Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
National Center for Research Resources and Harvard University.


Code licensed under a BSD License. 
For details, see: LICENSE.txt 
  
HTML5/d3-Based Network Visualizer  

Author(s): Nick Benik

*/

network_browser = {
    sliders: { ranges: {}, callbacks: {} },
    _clusterEngine_ref: false,
    center_id: false,
    over_node: false,
    over_edge: false,
    _cfg: {
        height: 485,
        width: 600,
        targetEl: ".clusterView"
    },
    Init: function (network_browser_URL) {
        if (!network_browser_URL) { return false; }
        network_browser._cfg.baseURL = network_browser_URL;
        if (network_browser._clusterEngine_ref === false) {
            network_browser._clusterEngine_ref = ProfilesRNS_ClusterView;
            network_browser._clusterEngine_ref.Init(network_browser._cfg.width, network_browser._cfg.height, network_browser._cfg.targetEl);
        }
        network_browser._clusterEngine_ref.registerCallback(network_browser._flashEventHandler);
    },
    loadNetwork: function (centerID) {
        network_browser.center_id = centerID;
        network_browser._clusterEngine_ref.loadNetwork(network_browser._cfg.baseURL, centerID);
    },
    centerOn: function (nodeID) {
        network_browser._clusterEngine_ref.centerOn(nodeID);
    },
    clearNetwork: function () {
        network_browser._clusterEngine_ref.clearNetwork();
    },
    getDataRange: function (objType, objAttrib) {
        network_browser._clusterEngine_ref.getDataAttributeRange(objType, objAttrib);
    },
    dumpEdges: function () {
        network_browser._clusterEngine_ref.dumpEdges();
    },
    dumpNodes: function () {
        network_browser._clusterEngine_ref.dumpNodes();
    },
    _flashEventHandler: function (eventName, dataObject) {
        switch (eventName) {
            case "NODE_ALT_CLICK":
                window.open(dataObject.uri, "_self");
                break;
            case "NODE_CTRL_CLICK":
                //window.open(dataObject.uri + "/network/coauthors/cluster", "_self");
                break;
            case "NODE_CLICK":
            case "NODE_SHIFT_CLICK":
            case "NODE_SHIFT_ALT_CLICK":
            case "NODE_SHIFT_CTRL_CLICK":
            case "NODE_ALT_CTRL_CLICK":
            case "NODE_SHIFT_ALT_CTRL_CLICK":
            case "NODE_IN":
                var t = dataObject.fn + ' ' + dataObject.ln + ' (' + dataObject.pubs + ' publication';
                t += (dataObject.pubs != 1) ? 's)' : ')';
                document.getElementById("person_name").innerHTML = t;
                break;
            case "NODE_OUT":
                document.getElementById("person_name").innerHTML = "";
                break;
            case "EDGE_IN":
            case "EDGE_CLICK":
            case "EDGE_SHIFT_CLICK":
                document.getElementById("person_name").innerHTML = dataObject.infoText;
                break;
            case "EDGE_OUT":
                document.getElementById("person_name").innerHTML = "";
                break;
            case "DATA_RANGE":
                if (dataObject.invalidAttribute) {
                    alert("Invalid data attribute: [" + dataObject.attribute + "]");
                } else {
                    network_browser.sliders.ranges[dataObject.attribute] = dataObject;
                }
                break;
            case "DUMP_NODES":
            case "DUMP_EDGES":
            case "NETWORK_LOADED":
                break;
            default:
                // unremark these lines to see what other events can be handled
                //				alert(eventName+" is unhandled.");
                //				debugger;
        }
    }
};