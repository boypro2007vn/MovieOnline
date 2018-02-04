function removeWhiteSpace(text) {
    var textStrim = text.trim();
    return text.trim().replace(/\s+/g, ' ');
}
function showError(div,msg){
    if(div!=''){
        document.getElementById(div).classList.add('has-error');
    }
    document.getElementById(msg).style.display = 'block';
}
function hideError(div,msg){
    if(div!=''){
        document.getElementById(div).classList.remove("has-error");
    }
    document.getElementById(msg).style.display = 'none';
}

var pat1 = /^[a-zA-Z0-9 :()ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠ-ỹ]{6,100}$/;
var pat2 = /^[a-zA-Z0-9 ,\.ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠ-ỹ]{4,200}$/;
var pat3= /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/;
var pat4 = /^[a-zA-Z0-9 ,\.ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠ-ỹ]{4,50}$/;

function validateUpload() {
    var title = document.getElementById("title");
    if (!pat1.test(removeWhiteSpace(title.value))) {
        showError("title-div","error-msg-title");
    } else {
        hideError("title-div","error-msg-title")
    }

    var realTitle = document.getElementById("realTitle");
    if (!pat1.test(removeWhiteSpace(realTitle.value))) {
        showError("real-title-div","error-msg-realtitle");
    } else {
        hideError("real-title-div","error-msg-realtitle")
    }
    
    var tag = document.getElementById("tag");
    if (tag.value != '') {
        if (!pat2.test(removeWhiteSpace(tag.value))) {
            showError("tag-div","error-msg-tag");
        } else {
            hideError("tag-div","error-msg-tag");
        }
    }
    
    var director = document.getElementById("director");
    if (!pat4.test(removeWhiteSpace(director.value))) {
        showError("dir-div","error-msg-dir");
    } else {
        hideError("dir-div","error-msg-dir")
    }
    
    var actor = document.getElementById("actor");
    if (!pat2.test(removeWhiteSpace(actor.value))) {
        showError("actor-div","error-msg-actor");
    } else {
        hideError("actor-div","error-msg-actor")
    }

    var genre = document.querySelectorAll("input[name=genreCb]:checked");
    if(genre.length ===0){
        document.getElementById("error-msg-genre").style.display = 'inline';
    }else{
        hideError('',"error-msg-genre");
    }
    
    var releaseDay = document.getElementById("releaseDay");
    if (releaseDay.value.length ==0) {
        showError("releaseday-div","error-msg-releaseday");
    } else {
        hideError("releaseday-div","error-msg-releaseday")
    }
    var duration = document.getElementById("duration");
    if (duration.value.length ==0) {
        duration.value=0;
    } else {
        if(duration.value <0 || duration.value>10000000){
            showError("duration-div","error-msg-duration");
        }else{
            hideError("duration-div","error-msg-duration")
        }
        
    }
    
    var trailer = document.getElementById("trailer");
    if(trailer.value.length !=0){
        if (!pat3.test(trailer.value)) {
            showError("trailer-div","error-msg-trailer");
        } else {
            hideError("trailer-div","error-msg-trailer")
        }
    }else{
        hideError("trailer-div","error-msg-trailer")
    }
    var imdb = document.getElementById("imbd");
    if(imdb.value.length ==0){
        imdb.value=0;
    }else{
        if(imdb.value <0 || imdb.value >10){
            showError("imbd-div","error-msg-imdb");
        }else{
            hideError("imbd-div","error-msg-imdb")
        }
    }
}

function validateKeyUp(field){
    if(field.id =="title"){
        if (!pat1.test(removeWhiteSpace(field.value))) {
            showError("title-div","error-msg-title");
        } else {
            hideError("title-div","error-msg-title")
        }
    }
    if(field.id =="realTitle"){
        if (!pat1.test(removeWhiteSpace(field.value))) {
            showError("real-title-div","error-msg-realtitle");
        } else {
            hideError("real-title-div","error-msg-realtitle")
        }
    }
    
    if(field.id =="tag"){
        if (field.value != '') {
            if (!pat2.test(removeWhiteSpace(field.value))) {
                showError("tag-div","error-msg-tag");
            } else {
                hideError("tag-div","error-msg-tag");
            }
        }
    }
    
    if(field.id =="director"){
        if (!pat4.test(removeWhiteSpace(field.value))) {
            showError("dir-div","error-msg-dir");
        } else {
            hideError("dir-div","error-msg-dir")
        }
    }
    
    if(field.id =="actor"){
        if (!pat2.test(removeWhiteSpace(field.value))) {
            showError("actor-div","error-msg-actor");
        } else {
            hideError("actor-div","error-msg-actor")
        }
    }
    
    if(field.id == "episode-name"){
        if(field.value <1){
            showError("episode-name-div","error-msg-episode-name");
        }else{
            hideError("episode-name-div","error-msg-episode-name")
        }
    }
    
    if(field.id == "re-episode-name"){
        if(field.value <1){
            showError("re-episode-name-div","error-msg-re-episode-name");
        }else{
            hideError("re-episode-name-div","error-msg-re-episode-name")
        }
    }
    
    if(field.id == "imbd"){
        if (field.value.length == 0 || field.value < 0 || field.value > 10) {
            showError("imbd-div", "error-msg-imdb");
        } else {
            hideError("imbd-div", "error-msg-imdb")
        }
    }
    
    if(field.id == "duration"){
        if(field.value.length == 0 || field.value <0 || field.value>10000000){
            showError("duration-div","error-msg-duration");
        }else{
            hideError("duration-div","error-msg-duration")
        }
    }
    if(field.id == "trailer"){
        if(field.value.length !=0){
            if (!pat3.test(field.value)) {
                showError("trailer-div","error-msg-trailer");
            } else {
                hideError("trailer-div","error-msg-trailer")
            }
        }else{
            hideError("trailer-div","error-msg-trailer")
        }
    }
    
}


