function removeWhiteSpace(text) {
    var textStrim = text.trim();
    return text.trim().replace(/\s+/g, ' ');
}


function showError(div, msg) {
    if (div != '') {
        document.getElementById(div).classList.add('has-error');
    }
    document.getElementById(msg).style.display = 'block';
}
function hideError(div, msg) {
    if (div != '') {
        document.getElementById(div).classList.remove("has-error");
    }
    document.getElementById(msg).style.display = 'none';
}
var pat1 = /^[a-zA-Z :()ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠ-ỹ]{4,100}$/;
function validateUpload() {
    var typevip = document.getElementById("viptype");
    if (!pat1.test(removeWhiteSpace(typevip.value))) {
        showError("viptype-div", "error-msg-viptype");
    } else {
        hideError("viptype-div", "error-msg-viptype");
    }
    var duration = document.getElementById("duration");
    if (duration.value < 0 || duration.value > 1000 || duration.value == 0) {
        showError("duration-div", "error-msg-duration");
    } else {
        hideError("duration-div", "error-msg-duration");
    }
    var price = document.getElementById("price");
    var priceNum = parseFloat(price.value.toString().replace(/,/g,""));
    if (isNaN(priceNum) || priceNum < 0 || priceNum > 10000000 || priceNum == 0) {
        showError("price-div", "error-msg-price");
    } else {
        hideError("price-div", "error-msg-price");
    }
}
function validateKeyUp(field) {
    if (field.id == "viptype") {
        if (!pat1.test(removeWhiteSpace(field.value))) {
            showError("viptype-div", "error-msg-viptype");
        } else {
            hideError("viptype-div", "error-msg-viptype");
        }
    }
    if (field.id == "duration") {
        var durationNum = parseInt(field.value);
        if (isNaN(field.value) || durationNum < 0 || durationNum > 1000) {
            showError("duration-div", "error-msg-duration");
        } else {
            hideError("duration-div", "error-msg-duration");
        }
    }
    if (field.id == "price") {
        var priceNum = parseFloat(field.value.toString().replace(/,/g,""));
        if (isNaN(priceNum) || priceNum < 0 || priceNum > 10000000) {
            showError("price-div", "error-msg-price");
        } else {
            hideError("price-div", "error-msg-price");
        }
    }
}

