function twitterParser(json, moduleTitle, miscInfo, explicitTarget) {
    let resultDiv = $('<div></div>');

    for (let i=0; i<json.length; i++) {
        let elt = json[i];
        let name = elt.data;
        let url = `https://x.com/${name}`;

        let p = $(`<p></p>`);
        p.append($(`<a class="link-ish" href="${url}">Tweets by ${name}</a>`));

        resultDiv.append(p);
    }
    return resultDiv;
}
