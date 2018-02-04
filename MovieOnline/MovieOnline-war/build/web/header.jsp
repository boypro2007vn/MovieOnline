<%@page import="java.util.ArrayList"%>
<%@page import="java.util.AbstractList"%>
<%@page import="java.util.List"%>
<%@page import="entity.Genre"%>
<%@page import="entity.Country"%>
<%@page import="com.google.gson.Gson"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<% Cookie[] cookies = request.getCookies(); 
    String usernamecookie="";
    String passwordcookie="";
    JSONArray arrGenre= new JSONArray();
    JSONArray arrCountry= new JSONArray();
    List<Country> arrCountryL = new ArrayList<Country>();
    List<Genre> arrGenreL = new ArrayList<Genre>();
    if(cookies!=null){
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("GenreCookie")) {
                arrGenre = new JSONArray(cookie.getValue());
            }
            if (cookie.getName().equals("CountryCookie")) {
                arrCountry = new JSONArray(cookie.getValue());
            }
            if (cookie.getName().equals("loginCookie")) {
                usernamecookie =cookie.getValue();
                passwordcookie = "xxxxxx";
            }
        }
    }else{
        arrCountryL = (List<Country>)request.getAttribute("CountryCookie");
        arrGenreL = (List<Genre>)request.getAttribute("GenreCookie");
    }
%>
<link href="public/css/template.css" rel="stylesheet">
<link href="public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<div class="container-header">
    <!-- Second navbar for search -->
    <nav class="navbar navbar-inverse nav-header" style="margin-top: 20px">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse-3">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="./"><img src="public/images/logo.png" height="120"/></a>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="navbar-collapse-3">
                <ul class="nav navbar-nav navbar-left" style="width: 100%">
                    <li><a href="Search?searchType=filter&order=1&type=0">Latest Movie</a></li>
                    <li><a href="Search?searchType=filter&order=1&type=1">TV Series</a></li>
                    <li class="dropdown show-on-hover"><a href="" class="dropdown-toggle" data-toggle="dropdown">Genre <span class="caret"></span></a>
                        <ul class="dropdown-menu" id="quad" style="background-color: #252525;">
                        <%if(cookies==null){
                            for(int i = 0;i<arrGenreL.size();i++){%>
                                <li><a id="listTopMenu" href="Search?searchType=filter&order=1&genreName=<%=arrGenreL.get(i).getGenreName()%>"><%=arrGenreL.get(i).getGenreName()%></a></li>
                            <%}
                        }else{
                            for (int i = 0; i < arrGenre.length(); i++) {
                                JSONObject obj = arrGenre.getJSONObject(i);%>
                                <li><a id="listTopMenu" href="Search?searchType=filter&order=1&genreName=<%= obj.getString("genreName")%>"><%= obj.getString("genreName")%></a></li>
                            <%}
                        }%>
                        </ul>
                    </li>
                    <li class="dropdown show-on-hover"><a href="" class="dropdown-toggle" data-toggle="dropdown">Country <span class="caret"></span></a>
                        <ul class="dropdown-menu" id="double" style="width: 300px;background-color: #252525;">
                            <%if(cookies==null){
                                for(int i = 0;i<arrCountryL.size();i++){%>
                                    <li><a id="listTopMenu" href="Search?searchType=filter&order=1&countryName=<%=arrCountryL.get(i).getCountryName()%>"><%=arrCountryL.get(i).getCountryName()%></a></li>
                                <%}
                            }else{
                                for (int i = 0; i < arrCountry.length(); i++) {
                                    JSONObject obj = arrCountry.getJSONObject(i);%>
                                    <li><a id="listTopMenu" href="Search?searchType=filter&order=1&countryName=<%= obj.getString("countryName")%>"><%= obj.getString("countryName")%></a></li>
                                <%}
                            }%>
                        </ul>
                    </li>   
                    <li><a href="">News</a></li>
                    <li><a href="">About</a></li>
                    <li style="float: right;" class="dropdown show-on-hover">
                        <input type="hidden" name="pathname" value="home"/>
                        <c:choose>
                            <c:when test="${sessionScope.user !=null}">
                                <a class="dropdown-toggle user-nav" data-toggle="dropdown">
                                    <span class="avatar">
                                        <c:choose>
                                            <c:when test="${sessionScope.user.image ==null || sessionScope.user.image ==''}">
                                                <img src="public/images/avatar/empty_avatar.png" width="35px" height="35px"/>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="public/images/avatar/${sessionScope.user.image}" width="35px" height="35px"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </span><b style="color: ${sessionScope.user.role.color}">${sessionScope.user.userName}</b> <span class="caret"></span></a>
                                <ul class="dropdown-menu dropdown-menu-right dropdown-user">
                                    <li><a href="${pageContext.request.contextPath}/userInfo"><i class="fa fa-user fa-fw"></i> User Profile</a></li>
                                    <li><a href="${pageContext.request.contextPath}/bookmark?action=get"><i class="fa fa-archive fa-fw"></i> Movie Box</a></li>
                                    <li><a href="${pageContext.request.contextPath}/buyvip"><i class="fa fa-diamond fa-fw"></i> Buy VIP</a></li>
                                    <li class="divider"></li>
                                    <li><a id="logout-header" href="${pageContext.request.contextPath}/loginTemplate?type=logout&pathname=home"><i class="fa fa-sign-out fa-fw"></i> Logout</a></li>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <a id="btnLogin-header" class="dropdown-toggle btn btn-default btn-outline btn-circle collapsed" data-toggle="dropdown"><b>Login</b> <span class="caret"></span></a>
                                <ul id="login-dp" class="dropdown-menu dropdown-menu-right">
                                    <li>
                                        <div class="col-md-12">
                                            <h3 style="color: white">Login</h3> 
                                            <span id="error-login-header" style="color: red"></span>
                                            <form id="login-nav" class="form" method="post" action="loginServlet" accept-charset="UTF-8" >
                                                <input type="hidden" name="csrfSalt" value="<c:out value='${csrfSalt}'/>"/>
                                                <div id="login-username-header" class="form-group">
                                                    <label class="sr-only" for="loginEmail">Username</label>
                                                    <input type="username"  id="loginUsername" name="txtUsername" class="form-control" placeholder="Username" value="<%=usernamecookie%>" required/>
                                                </div>
                                                <div id="login-password-header"class="form-group">
                                                    <label class="sr-only" for="loginPassword">Password</label>
                                                    <input type="password" id="loginPassword" name="txtPassword" class="form-control" placeholder="Password" value="<%=passwordcookie%>" required/>
                                                    <div class="help-block text-right"><a href="">Forget the password ?</a></div>
                                                </div>
                                                <div class="form-group">
                                                    <button type="button" id="btnLoginHeader" class="btn btn-primary btn-block" >Sign in</button>
                                                </div>
                                                <div class="checkbox">
                                                    <label>
                                                        <input name="remember" type="checkbox" value="true"> Remember me
                                                    </label>
                                                </div>
                                            </form>
                                        </div>
                                        <div class="bottom text-center">
                                            New here ? <a href="#"><b>Register Now</b></a>
                                        </div>
                                    </li>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                        
                    </li>
                    <c:if test="${sessionScope.user !=null}">
                        <li style="float: right;margin-right: 66px">
                    </c:if>
                    <c:if test="${sessionScope.user ==null}">
                        <li style="float: right;margin-right: 20px">
                    </c:if>
                        <a  class="btn btn-default btn-outline btn-circle collapsed" data-toggle="collapse" href="#nav-collapse3" aria-expanded="false" aria-controls="nav-collapse3">Search</a>
                    </li>
                </ul>
                <div class="collapse nav navbar-nav nav-collapse slide-down" id="nav-collapse3" style="width: 70%;">
                    <form class="navbar-form navbar-right" action="Search" role="search" method="post" onsubmit="return validateSearch()">
                        <div class="input-group">
                            <input name="searchType" type="hidden" value="header"/>
                            <input id="searchContent" name="titleHeader" type="text" class="form-control nav-search" placeholder="Search: movie title, actors, directors" style="border-radius: 50px 0 0 50px;width: 400px"/>
                            <div class="input-group-btn">
                                <button type="submit" class="btn btn-default" style="border-radius: 0px 50px 50px 0px"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
                            </div>
                        </div>
                        
                    </form>
                </div>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container -->
    </nav><!-- /.navbar -->
</div><!-- /.container-fluid -->
<script>
    var fullpath = window.location.href;
    var pathname='home';
    if(fullpath){
        pathname = fullpath.split("/").pop();
        pathname = pathname.replace(/&/g,"%26")
    }
    var logoutLink = document.getElementById('logout-header');
    if(logoutLink != undefined){
        logoutLink.href="${pageContext.request.contextPath}/loginTemplate?type=logout&pathname="+pathname;
    }
</script>