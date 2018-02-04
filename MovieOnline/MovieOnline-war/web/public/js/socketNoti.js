var webSocket;
var notiAlert;
function openSocket() {
    // Ensures only one connection is open at a time
    if (webSocket !== undefined && webSocket.readyState !== WebSocket.CLOSED) {
        console.log("WebSocket is already opened.");
        return;
    }
    // Create a new instance of the websocket
    
    webSocket = new WebSocket('ws://localhost:8080'+ctx+'/adminnoti');

    /**
     * Binds functions to the listeners for the websocket.
     */
    webSocket.onopen = function(event) {
        console.log("WebSocket opened")
    };
    
    webSocket.onmessage = function(event) {
        var noti = JSON.parse(event.data);
        var role = document.getElementsByName("role").item(0).value
        if (noti.subject == 'changeRes' && role =="ROLE_UPLOADER") {
            var content = noti.content.split(";");
            alertModel("Notification",content[0]);
            var name = "statusUploadMovie-"+ content[1];
            if(document.getElementById(name)){
                document.getElementById(name).innerHTML = "Completed"
            }
        }
        if (noti.subject == 'system-admin' && (role =="ROLE_UPLOADER" || role =="ROLE_ADMIN")) {
            var content = noti.content;
            if(content !="" && content != undefined){
                if(!notiAlert){
                    notiAnimation(true);
                }
                
            }
        }
    };
    webSocket.onclose = function(event) {
        console.log("Connection closed")
    };
    
    webSocket.onerror = function(event) {
        console.log("Connection Error")
    }; 
}
function notiAnimation(active){
    var icon = document.getElementById("noti-icon").classList;
    var num = document.getElementById("noti-icon-num");
    if(active){
        if(!icon.contains("bell")){
            icon.add('bell');
            num.style.display = "block";
        }
    }else{
        if(icon.contains("bell")){
            icon.remove('bell');
            num.style.display = "none";
        }
    }
}

function alertModel(title, content) {
    $('#title-alert').html('<strong>' + title + '</strong>')
    $('#body-alert').empty();
    $('#body-alert').append(content);
    $('#alertModal').modal('show');
}
function getLastTimeNoti(fileCount, fieldTime, value) {
    document.getElementById(fileCount).innerHTML = value["count"];
    var newTime = '';
    if(!isNaN(value["count"]) && parseInt(value["count"]) !=0){
        var time = value["lastTime"]
        if (time < 60) {
            newTime = time + ' minutes ago';
        } else {
            if(time < 1440){
                newTime = Math.floor(time/60) + ' hours ago';
            }
            else{
                if(time < 43800){
                    newTime = Math.floor(time/1440) + ' days ago'; 
                }else{
                    if(time < 525600){
                        newTime = Math.floor(time/43800) + ' months ago';
                    }else{
                        newTime = Math.floor(time/525600) + ' years ago';
                    }
                }
            }

        }
    }
    document.getElementById(fieldTime).innerHTML = newTime;
}

//count noti unread
function loadNoti() {
    notiAnimation(false);
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            var res = JSON.parse(this.responseText);
            var uploadMovie = JSON.parse(res[0][0]);
            var payment = JSON.parse(res[1][0]);
            var task = JSON.parse(res[2][0]);
            var error = JSON.parse(res[3][0]);
            getLastTimeNoti("uploaded-movie-count", "uploaded-movie-time", uploadMovie)
            getLastTimeNoti("payment-count", "payment-time", payment)
            getLastTimeNoti("task-count", "task-time", task)
            getLastTimeNoti("error-count", "error-time", error)
        }
    }
    xhttp.open("POST", "notificationServlet", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send("type=getCountNoti");
}

function checkNoti(){
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            var res = this.responseText
            if(res == 'true'){
                notiAnimation(true);
            }else{
                notiAnimation(false);
            }
        }
    }
    xhttp.open("POST", "notificationServlet", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send("type=isNoti");
}
