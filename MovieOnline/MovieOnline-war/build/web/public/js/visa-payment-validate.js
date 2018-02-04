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

var pat1 = /^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$/;
var pat2 = /^[a-zA-Z :()ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠ-ỹ]{4,100}$/;
var pat3 = /^[0-9]{3}$/;
function validateSubmit() {
    var cardNo = document.getElementById("cardNo");
    if (!pat1.test(cardNo.value)) {
        showError("cardNo-div", "error-msg-cardNo");
    } else {
        hideError("cardNo-div", "error-msg-cardNo");
    }
    var cardName = document.getElementById("cardName");
    if (!pat2.test(cardName.value)) {
        showError("cardName-div", "error-msg-cardName");
    } else {
        hideError("cardName-div", "error-msg-cardName");
    }
    if (!pat3.test(CVV.value)) {
        showError("CVV-div", "error-msg-CVV");
    } else {
        hideError("CVV-div", "error-msg-CVV");
    }
}
function validateExpired() {
    var currentTime = new Date().getTime();
    var selectMonth = $("#cardMonth").val();
    var selectYear = $("#cardYear").val();
    var selectTime = new Date(selectYear, selectMonth, 30).getTime();
    if ((selectTime - currentTime) <= 0) {
        showError("expiredDate-div", "error-msg-cardMonth");
        return false;
    } else {
        hideError("expiredDate-div", "error-msg-cardMonth");
        return true;
    }
}
function validateKeyUp(field) {
    if (field.id == "cardNo") {
        if (!pat1.test(field.value)) {
            showError("cardNo-div", "error-msg-cardNo");
        } else {
            hideError("cardNo-div", "error-msg-cardNo");
        }
    }
    if (field.id == "cardName") {
        if (!pat2.test(field.value)) {
            showError("cardName-div", "error-msg-cardName");
        } else {
            hideError("cardName-div", "error-msg-cardName");
        }
    }
    if (field.id == "CVV") {
        if (!pat3.test(field.value)) {
            showError("CVV-div", "error-msg-CVV");
        } else {
            hideError("CVV-div", "error-msg-CVV");
        }
    }
}
