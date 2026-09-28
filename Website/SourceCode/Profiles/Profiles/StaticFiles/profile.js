
async function getPageJSON() {
    try {
        let json = JSON.parse(g.dataURLs);

        // you say tomato-array, I might say tomahto-object
        let dataPath = Array.isArray(json) ? json[0].dataURL : json;

        let r = "";
        if (sessionInfo.canEditPage) r = "&r=" + Math.random().toString(36).slice(2, 5);;

        if (dataPath) {
            let jsonTmp = [];
            for (let k=0; k<json.length; k++) {
                let jsonK = json[k]
                let jsonURL = g.apiBasePath + "/getdata?" + jsonK.dataURL + r;
                await jQuery.getJSON(jsonURL, function (json2) {
                    for (let j2=0; j2<json2.length; j2++) {
                        let jsonJ2 = json2[j2];
                        jsonTmp.push(jsonJ2)
                    }
                    g.pageJSON = jsonTmp;
                });
            }
            console.log('page json: ', g.pageJSON);
        }
    }
    catch (error) {
        console.log("Oops: ", error);
        g.pageJSON = [];
    }
    return; // handy for breakpoint
}
