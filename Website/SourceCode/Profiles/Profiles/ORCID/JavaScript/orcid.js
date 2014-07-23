function textCounter(field, countfield, maxlimit) {
    if (field.value.length > maxlimit) {
        countfield.className = 'countererror';
        countfield.innerHTML = 'You have used ' + (field.value.length - maxlimit) + ' characters more than the maximum of ' + maxlimit + '.';
    }
    else {
        countfield.className = 'counter';
        countfield.innerHTML = maxlimit - field.value.length + ' characters left out of ' + maxlimit + '.';
    }
}

function toggledivbycheckbox(ctlchk, ctldivid) {
    ctldiv = document.getElementById(ctldivid);
    if (ctlchk.checked) {
        ctldiv.className = 'show';
    }
    else {
        ctldiv.className = 'hidden';
    }
}