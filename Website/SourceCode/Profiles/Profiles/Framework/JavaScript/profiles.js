/*  
 
Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
National Center for Research Resources and Harvard University.


Code licensed under a BSD License. 
For details, see: LICENSE.txt 
  
*/


// create global code object if not already created
if (undefined == ProfilesRNS) var ProfilesRNS = {};
//if (undefined == ProfilesRNS.Search) var ProfilesRNS.Search = {};
//if (undefined == ProfilesRNS.Search.Everything) var ProfilesRNS.Search.Everything = {};
//if (undefined == ProfilesRNS.Search.People) var ProfilesRNS.Search.People = {};


function NavTo(root, location) {

    document.location = root + location;

    return null;
}
function GoTo(location) {

    document.location = location;

    return null;
}
function toggleBlock(key, id) {


    toggleVisibility(id);
    toggleImage(key,id);

}

function toggleVisibility(id) {
    var e = document.getElementById(id);
    if (e.style.display == 'none')
        e.style.display = 'block';
    else
        e.style.display = 'none';
        
}

function toggleImage(key,id) {

    var object = document.getElementById(key + id);

    if (object.src == document.getElementById("imgoff" + id).value) {
        object.src = document.getElementById("imgon" + id).value;        
    } else {
        object.src = document.getElementById("imgoff" + id).value; ;
        
    }


}



// ********* List Table *********

var hasClickedListTable = false;

function doListTableRowOver(x) {
    
    //x.className = 'overRow';
    x.style.backgroundColor = '#5A719C';
    x.style.color = '#FFF';
    x.style.cursor = 'pointer';    
    for (var i = 0; i < x.childNodes.length; i++) {
    	if (x.childNodes[i].childNodes.length > 0) {
    		if (x.childNodes[i].children[0] != undefined)
    			if (x.childNodes[i].children[0].className == 'listTableLink') {
    				x.childNodes[i].children[0].style.color = '#FFF';
				}
        }
    }    
}

function doListTableRowOut(x, eo) {
    
    if (eo == 1) {
        x.className = 'oddRow';
        x.style.backgroundColor = '#FFFFFF';
    } else {
        x.className = 'evenRow';
        x.style.backgroundColor = '#F0F4F6';
    }
    x.style.color = '';
    for (var i = 0; i < x.childNodes.length; i++) {
    	if (x.childNodes[i].childNodes.length > 0) {
    		if (x.childNodes[i].children[0] != undefined)
				if (x.childNodes[i].children[0].className == 'listTableLink') {
            		x.childNodes[i].children[0].style.color = '#36C';
				}
        }
    }
}

function doListTableCellOver(x) {
    //x.className = 'listTableLinkOver';
    x.style.backgroundColor = '#36C';
}

function doListTableCellOut(x) {
    //x.className = 'listTableLink';
    x.style.backgroundColor = '';
}

function doListTableCellClick(x) {
    hasClickedListTable = true;
}

function myGetElementById(id) {
    if (document.getElementById)
        var returnVar = document.getElementById(id);
    else if (document.all)
        var returnVar = document.all[id];
    else if (document.layers)
        var returnVar = document.layers[id];
    return returnVar;
}

function meshView(x) {
    myGetElementById('meshMenu1').style.display = 'none';
    myGetElementById('meshMenu2').style.display = 'none';
    myGetElementById('meshMenu3').style.display = 'none';
    myGetElementById('meshMenu4').style.display = 'none';
    myGetElementById('meshMenu5').style.display = 'none';
    myGetElementById('mesh1').style.display = 'none';
    myGetElementById('mesh2').style.display = 'none';
    myGetElementById('mesh3').style.display = 'none';
    myGetElementById('mesh4').style.display = 'none';
    myGetElementById('mesh5').style.display = 'none';
    myGetElementById('meshMenu' + x).style.display = 'block';
    myGetElementById('mesh' + x).style.display = 'block';
}

function pubView(x) {
    myGetElementById('pubMenu1').style.display = 'none';
    myGetElementById('pubMenu2').style.display = 'none';
    myGetElementById('pubMenu3').style.display = 'none';
    myGetElementById('pubMenu4').style.display = 'none';
    myGetElementById('pub1').style.display = 'none';
    myGetElementById('pub2').style.display = 'none';
    myGetElementById('pub3').style.display = 'none';
    myGetElementById('pub4').style.display = 'none';
    myGetElementById('pubMenu' + x).style.display = 'block';
    myGetElementById('pub' + x).style.display = 'block';
}