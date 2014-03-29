
var jsonldParser = {};

// Basically from rdfhelpers.js in Shindigorng
/**
* Function to rebuild references in the graph and return the item originally requested.
*/
jsonldParser.parse = function (data) {
    var jsonld = data.jsonld;
    var retval = {};
    // when this happens, just return the jsonld as the only entry
    if (!jsonld.hasOwnProperty('@graph')) {
        retval[data.uris[0]] = jsonld;
        return retval;
    }

    // put everything in a map keyed by ID
    var fatObjMap = {};
    for (var i = 0; i < jsonld['@graph'].length; i++) {
        var item = jsonld['@graph'][i];
        fatObjMap[item['@id']] = item;
    }

    // now go through map and swap out thin object with the fat one from the map
    for (var key in fatObjMap) {
        var obj = fatObjMap[key];
        for (var prop in obj) {
            if (obj[prop] instanceof Array) {
                for (var i = 0; i < obj[prop].length; i++) {
                    var thin = obj[prop][i];
                    if (typeof (thin) == 'object' && thin.hasOwnProperty('@id')) {
                        // replace the thin one with the fat one
                        obj[prop][i] = fatObjMap[thin['@id']];
                    }
                }
            }
            else {
                var thin = obj[prop];
                if (typeof (thin) == 'object' && thin.hasOwnProperty('@id')) {
                    // replace the thin one with the fat one
                    obj[prop] = fatObjMap[thin['@id']];
                }
            }
        }
    }

    // there are many items in the fatObjMap all wired together, return the ones they 
    // specifically asked for aka. data.uris in a map keyed by uri 
    for (var i = 0; i < data.uris.length; i++) {
        var uri = data.uris[i];
        retval[uri] = fatObjMap[uri];
    }
    return retval;
};
