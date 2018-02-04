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
            <div>
                <div class="col-xs-12 col-md-12">
                    <h1 style="text-transform: uppercase; color: #FFFFFF; text-align: center">Purchase VIP packages</h1>
                    
                </div>
                <div class="row db-padding-btm db-attached col-md-10 col-lg-offset-1">
                    <c:forEach items="${vipList}" var="vip" varStatus="i">
                        <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3">
                            <div class="db-wrapper">
                                <div class="db-pricing-eleven popular db-bk-color-one" name="divColor" style="">
                                    
                                    <div class="price">
                                        <label id="price">
                                            <fmt:setLocale value = "vi_VN"/>
                                            <fmt:formatNumber type="currency" value="${vip.price}"/>
                                        </label>
                                        
                                    </div>
                                    <div class="type">
                                        ${vip.name} <br/>PLAN
                                    </div>
                                    <ul>
                                        <li><i class="glyphicon glyphicon-time"></i>${vip.duration} Days </li>
                                        <li><i class="glyphicon glyphicon-hd-video"></i>Full HD </li>
                                        <li><i class="glyphicon glyphicon-ban-circle"></i>No ads</li>
                                    </ul>
                                    <div class="pricing-footer">
                                        <fmt:formatNumber var="number" type="number" pattern="###" value="${vip.price}"/>
                                        <a href="${pageContext.request.contextPath}/VisaPayment?price=${number}" class="btn db-button-color-square btn-lg">BUY</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <script type="text/javascript">
                        var ar =["#46A6F7","#f55039","#47887E","#F59B24"]
                        var div =document.getElementsByName("divColor");
                        for(var i=0;i<ar.length;i++){
                            div.item(i).style.background =ar[i];
                        }            
                    </script>                    
                </div>   
            </div>
        </div>
        <%@include file="footer.jsp" %>
        <script src="public/js/jquery.min.js"></script>
        <script src="public/js/bootstrap.min.js"></script>
        <script src="public/js/loginHeader.js"></script>
    </body>
</html>
