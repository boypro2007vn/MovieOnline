<%-- 
    Document   : u_Info
    Created on : Oct 25, 2017, 12:59:48 PM
    Author     : DUNG KHI
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MEMBER INFORMATION</title>
        
        <link rel="stylesheet" href="public/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="public/css/m.luong.css"/>
        
        <link rel="stylesheet" href="public/css/userInfo.css"/>
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div class="container body-contain">
            <div class="row">
                <div class="col-md-3">                    
                    <%@include  file="u_infoSidebar.jsp"%>
                </div>
                <div class="col-md-9 info">
                    <form class="form-horizontal">
                            <fieldset>

                                <!-- Form Name -->
                                <legend id="title" style="color: white;">Detail Information</legend>

                                <!-- Text input-->
                                <div class="form-group">
                                    <label class="col-md-4 control-label" for="email">Email</label>  
                                    <div class="col-md-4">
                                        <input id="email" name="email" type="text" placeholder="Input Email" class="form-control input-md" required="">

                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="form-group">
                                    <label class="col-md-4 control-label" for="cellphone">Cellphone</label>  
                                    <div class="col-md-4">
                                        <input id="cellphone" name="cellphone" type="text" placeholder="Input Cellphone" class="form-control input-md">

                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="form-group">
                                    <label class="col-md-4 control-label" for="username">Username</label>  
                                    <div class="col-md-4">
                                        <input id="username" name="username" type="text" placeholder="Enter Username" class="form-control input-md" required="">

                                    </div>
                                </div>

                                <!-- Text input-->
                                <div class="form-group">
                                    <label class="col-md-4 control-label" for="birthday">Birthday</label>  
                                    <div class="col-md-4">
                                        <input id="birthday" name="birthday" type="text" placeholder="birthday" class="form-control input-md">

                                    </div>
                                </div>

                                <!-- Multiple Radios (inline) -->
                                <div class="form-group">
                                    <label class="col-md-4 control-label" for="radios">Sex</label>
                                    <div class="col-md-4"> 
                                        <label class="radio-inline" for="radios-0">
                                            <input type="radio" name="radios" id="radios-0" value="0" checked="checked">
                                            Female
                                        </label> 
                                        <label class="radio-inline" for="radios-1">
                                            <input type="radio" name="radios" id="radios-1" value="1">
                                            Male
                                        </label> 
                                        <label class="radio-inline" for="radios-2">
                                            <input type="radio" name="radios" id="radios-2" value="2">
                                            Other
                                        </label>
                                    </div>
                                </div>

                                <!-- Button (Double) -->
                                <div class="form-group">
                                    <label class="col-md-4 control-label" for="update"></label>
                                    <div class="col-md-8">
                                        <button id="update" name="update" class="btn btn-primary">Update</button>
                                        <button id="changepass" name="changepass" class="btn btn-primary">Change Password</button>
                                    </div>
                                </div>

                            </fieldset>
                        </form>

                </div>
            </div>   
        </div>
                <%@include file="footer.jsp" %>
    </body>
</html>
