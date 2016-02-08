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

network_sliders = {
    viz_ref: false,
    sliders: { ranges: {}, callbacks: {} },
    Init: function (vizRef) {
        this.viz_ref = vizRef;
        // vizualisation is loaded, import data ranges to initialize the sliders
        this.sliders.ranges = {
            pubs: this.viz_ref.data.ranges.nodes.pubs,
            n: this.viz_ref.data.ranges.edges.n,
            y2: this.viz_ref.data.ranges.edges.y2
        };
        var t = this.sliders.ranges;
        // initialize the scriptaculous sliders
        this.sliders.copubs = new Control.Slider('copubs_handle', 'copubs', {
            range: $R(t.pubs.min, t.pubs.max + 1),
            maximum: 256,
            onChange: network_sliders.sliders.callbacks.pubs,
            onSlide: network_sliders.sliders.callbacks.pubs
        });
        this.sliders.pub_cnt = new Control.Slider('pub_cnt_handle', 'pub_cnt', {
            range: $R(t.n.min, t.n.max + 1),
            maximum: 256,
            onChange: network_sliders.sliders.callbacks.n,
            onSlide: network_sliders.sliders.callbacks.n
        });
        this.sliders.recent_copubs = new Control.Slider('pub_date_handle', 'pub_date', {
            range: $R(t.y2.min, t.y2.max + 1),
            maximum: 256,
            onChange: network_sliders.sliders.callbacks.y2,
            onSlide: network_sliders.sliders.callbacks.y2
        });
    }
};



// ----------------------------------------------------------------------------------------------
//   Filter Sliders
// ----------------------------------------------------------------------------------------------

network_sliders.sliders.callbacks = {
    pubs: function (val, sldr) {
        var v = Math.ceil(val) - 1;
        if (network_sliders.sliders.ranges.pubs.min >= v) {
            network_sliders.viz_ref.setFilter("node", "pubs", null, null);
            $('lbl_pubs').textContent = "any number";
        } else {
            $('lbl_pubs').textContent = parseInt(v) + " or more";
            network_sliders.viz_ref.setFilter("node", "pubs", network_sliders.sliders.ranges.pubs.min, v);
        }
    },
    n: function (val, sldr) {
        var v = Math.ceil(val) - 1;
        if (network_sliders.sliders.ranges.n.min >= v) {
            network_sliders.viz_ref.setFilter("edge", "n", null, null);
            $('lbl_copubs').textContent = "any collaboration";
        } else {
            network_sliders.viz_ref.setFilter("edge", "n", network_sliders.sliders.ranges.n.min, v);
            $('lbl_copubs').textContent = v + " or more";
        }
    },
    y2: function (val, sldr) {
        var v = Math.ceil(val) - 1;
        if (network_sliders.sliders.ranges.y2.min >= v) {
            network_sliders.viz_ref.setFilter("edge", "y2", null, null);
            $('lbl_recent').textContent = "any year";
        } else {
            network_sliders.viz_ref.setFilter("edge", "y2", network_sliders.sliders.ranges.y2.min, v);
            $('lbl_recent').textContent = "during or after " + v;
        }
    }
};