<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="public/css/bootstrap.min.css" rel="stylesheet">
        <link href="public/css/template.css" rel="stylesheet">
        <link href="public/css/VIP.css" rel="stylesheet">
        <link href="public/font-awesome/css/font-awesome.css" rel="stylesheet">
        <link rel="stylesheet" href="public/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="public/css/m.luong.css?ver=1.0"/>        
        <link rel="stylesheet" href="public/css/userInfo.css"/>

    </head>
    <body>
        <%@include file="header.jsp" %>
        <div class="container body-contain">
            <div class="row">
                <div class="col-md-3">
                    <%@include  file="u_infoSidebar.jsp"%>   
                </div>
                <div class="col-md-8 col-md-offset-1" style="margin-top: 50px; color: white">
                    <h2 style="color: #f15f24">PAYMENT HISTORY</h2>
                    <table class="table exotic-table table-striped" style="margin-top: 20px">
                        <thead>
                        <th>No.</th>
                        <th>Value</th>
                        <th>Duration (Days)</th>
                        <th>Date</th>
                        </thead>
                        <tbody>
                            <c:forEach items="${list}" var="history">
                            <tr>
                                <td>${history.historyId}</td>
                                <td>
                                    <fmt:setLocale value = "vi_VN"/>
                                    <fmt:formatNumber type = "currency"  value = "${history.price}"/>
                                </td>
                                <td>${history.duration}</td>
                                <td>
                                    ${history.dateRegister}
                                </td>
                            </tr>
                            </c:forEach>
<!--                            <tr>
                                <td>1</td>
                                <td>20,000</td>
                                <td>7</td>
                                <td>14-12-2017</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>300,000</td>
                                <td>180</td>
                                <td>16-12-2017</td>
                            </tr>-->
                            
                        </tbody>
                    </table>
                </div>
            </div>
        </div>        
        <%@include file="footer.jsp" %>
        <script src="public/js/loginHeader.js"></script>
        <script src="public/js/jquery.min.js"></script>
        <script src="public/js/bootstrap.min.js"></script>
        
    </body>
</html>
