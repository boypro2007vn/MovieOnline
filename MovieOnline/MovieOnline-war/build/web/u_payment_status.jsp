<%-- 
    Document   : u-buyvip
    Created on : Oct 10, 2017, 8:42:31 PM
    Author     : chris
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Purchase VIP</title>        
        <link href="public/css/bootstrap.min.css" rel="stylesheet">
        <link href="public/css/VIP.css" rel="stylesheet">                
    </head>
    <body>        
        <%@include file="header.jsp" %>
        <div class="container">            
            <div class="col-md-8 col-md-offset-3">
                <div class="notify successbox" id="${statusSuccess}">
                    <h1>Success!<span class="alerticon"><img src="public/images/check.png" alt="checkmark" /></span></h1>                    
                    <p>Thanks so much for your payment. Your account has been updated to VIP for ${duration} days more.</p>
                    <p>You will be redirect to Package choosing page in <span id="timeout">5</span> seconds</p>
                </div>
                <div class="notify errorbox" id="${statusError}">
                    <h1>Warning!<span class="alerticon"><img src="public/images/error.png" alt="error" /></span></h1>                    
                    <p>The payment is not successful. There are some problems in your input information. Please click <a href="javascript:history.back()">here</a> to try again</p>
                </div>
            </div>
        </div>
        <%@include file="footer.jsp" %>
        <script src="public/js/jquery.min.js"></script>
        <script src="public/js/bootstrap.min.js"></script>
        <script src="public/js/loginHeader.js"></script>
        <script src="public/js/sweetalert.js"></script>
        <script>
            $(document).ready(function() {
                var time = 5;
                
                setInterval(function() {
                    $('#timeout').html(time);//hien time tren div
                    if (time == 0) {
                        window.location.replace("${pageContext.request.contextPath}/buyvip");
                    }
                    time--;

                }, 1000)
            });

        </script>
    </body>
</html>
