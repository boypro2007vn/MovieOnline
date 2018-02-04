<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>S&E Online | Login Admin</title>
	
    <link href="./public/css/bootstrap.min.css" rel="stylesheet">
    <link href="./public/css/metisMenu.min.css" rel="stylesheet">
    <link href="./public/css/sb-admin-2.css" rel="stylesheet">
    <link href="./public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <style>
        body{
            background-image: linear-gradient(to right bottom, #021531, #00223b, #002e3b, #003832, #064023);
            height: 100%;
            margin: 0;
            background-repeat: no-repeat;
            background-attachment: fixed
        }
        #login {
            padding-top: 100px;
        }
        #login .form-wrap,.login-panel {
            width: 30%;
            margin: 0 auto;
        }
        #login h1 {
            color: #1fa67b;
            font-size: 18px;
            text-align: center;
            font-weight: bold;
            padding-bottom: 20px;
        }
        #login .form-group {
            margin-bottom: 25px;
        }

        #login .btn.btn-custom {
            font-size: 14px;
                margin-bottom: 20px;
        }
        #login .forget {
            font-size: 13px;
                text-align: center;
                display: block;
        }

        .form-control {
            color: #212121;
        }
        .btn-custom {
            color: #fff;
                background-color: #1fa67b;
        }
        .btn-custom:hover,
        .btn-custom:focus {
            color: #fff;
        }

        #footer {
            color: #6d6d6d;
            font-size: 12px;
            text-align: center;
        }
/*        #footer p {
            margin-bottom: 0;
        }*/
        #footer a {
            color: inherit;
        }
    </style>
</head>    
<body>
    <section id="login">
        <div class="container">
            <div class="row">
                <div class="col-xs-12">
                    <div class="login-panel">${error}</div>
                        <div class="form-wrap">
                    <h1>Log in with your admin account</h1>
                        <form role="form" action="AdminLoginServlet" method="post" id="login-form" autocomplete="off">
                            <input type="hidden" name="csrfSalt" value="<c:out value='${csrfSalt}'/>"/>
                            <div class="form-group">
                                <label for="username" class="sr-only">Username</label>
                                <input type="text" name="username" id="username" class="form-control" placeholder="Username">
                            </div>
                            <div class="form-group">
                                <label for="password" class="sr-only">Password</label>
                                <input type="password" name="password" id="password" class="form-control" placeholder="Password">
                            </div>
                            <input name="action" type="submit" id="btn-login" class="btn btn-custom btn-lg btn-block" value="Log in">
                        </form>
                        <a href="javascript:;" class="forget" data-toggle="modal" data-target=".forget-modal">Forgot your password?</a>
                        <hr>
                        </div>
                    </div> <!-- /.col-xs-12 -->
            </div> <!-- /.row -->
        </div> <!-- /.container -->
    </section>

    <footer id="footer">
        <div class="container">
            <div class="row">
                <div class="col-xs-12">
                    <p>Page © - 2017</p>
                    <p>Powered by <strong><a href="http://www.facebook.com/tavo.qiqe.lucero" target="_blank">S&E Online</a></strong></p>
                </div>
            </div>
        </div>
    </footer>
    <script src="./public/js/jquery.min.js"></script>
    <script src="./public/js/bootstrap.min.js"></script>
</body>
</html>

