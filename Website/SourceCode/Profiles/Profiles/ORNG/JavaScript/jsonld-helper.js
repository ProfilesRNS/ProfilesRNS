
var osapi = {};
osapi.rdf = {};

// from rdfhelpers.js in Shindigorng
/**
* Function to rebuild references in the graph.
*/
osapi.rdf.deserialize = function (uri, rdf) {
    var map = {};
    var root;
    // put everything in a map keyed by ID
    for (var i = 0; i < rdf['@graph'].length; i++) {
        var item = rdf['@graph'][i];
        map[item['@id']] = item;
        if (item['@id'] == uri) {
            root = item;
        }
    }

    // now go through root and swap out URI's with actual objects
    for (var key in root) {
        osapi.rdf._swap(map, root, key);
    }
    return root;
};

osapi.rdf._swap = function (map, base, key) {
    if (key.charAt(0) == '@') {
        return;
    }
    var obj = base[key];
    if (typeof (obj) == 'string') {
        if (map[obj]) {
            base[key] = map[obj];
        }
    }
    else if (typeof (obj) == 'object') {
        for (var key in obj) {
            osapi.rdf._swap(map, obj, key)
        }
    }
};