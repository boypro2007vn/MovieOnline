
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Payment Page</title>        
        <link href="public/css/bootstrap.min.css" rel="stylesheet">
        <link href="public/css/template.css" rel="stylesheet">
        <link href="public/css/VIP.css" rel="stylesheet">
        <link href="public/font-awesome/css/font-awesome.css" rel="stylesheet">
        <link href="public/css/sweetalert.css" rel="stylesheet">
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div class="container content-payment">
            <div class="col-md-12 visa-detail-header">
                <div class="col-md-4 col-md-offset-2">
                    <h3 class="merchant-name">Merchant Name</h3>
                    <h4 class="merchant-name">S&E Online</h4>
                </div>               
                <div class="col-md-4 col-md-offset-2">
                    <h3 class="merchant-name">Total</h3>
                    <h4 class="merchant-name" id="price">
                        <fmt:setLocale value = "vi_VN"/>
                        <fmt:formatNumber type = "currency"  value = "${price}" />
                    </h4>
                </div>
            </div>
            <div class="col-md-6 col-md-offset-1" style="padding-top: 50px;">
                <form class="form-horizontal" id="visaForm" method="post" action="CardPayment">
                    <input type="hidden" value = "${price}" name="pricehidden"/>
                    <div class="form-group" id="cardNo-div">
                        <label class="control-label col-md-6" for="cardNo">Card No.</label>
                        <div class="col-md-6">
                            <input type="text" id="cardNo" class="form-control" name="cardNo" onkeyup="validateKeyUp(this)" placeholder="Input card number"/>
                            <span id="error-msg-cardNo" class="text-danger" style="margin: 5px;display: none;">Card number is invalid</span>
                        </div>
                    </div>
                    <div class="form-group" id="cardName-div">
                        <label class="control-label col-md-6" for="cardName">Card Holder's Name</label>
                        <div class="col-md-6">
                            <input type="text" id="cardName" class="form-control" name="cardName" onkeyup="validateKeyUp(this)" placeholder="Input Card Holder's Name"/>
                            <span id="error-msg-cardName" class="text-danger" style="margin: 5px;display: none;">Card name is invalid</span>
                        </div>
                    </div>
                    <div id="expiredDate-div" class="form-group">
                        <label class="control-label col-md-6" for="expiredDate">Expired Date</label>
                        <div class="col-md-6 form-inline">
                            <select name="cardMonth" id="cardMonth" class="form-control" onchange="validateExpired()">
                                <option value="0">January</option>
                                <option value="1">February</option>
                                <option value="2">March</option>
                                <option value="3">April</option>
                                <option value="4">May</option>
                                <option value="5">June</option>
                                <option value="6">July</option>
                                <option value="7">August</option>
                                <option value="8">September</option>
                                <option value="9">October</option>
                                <option value="10">November</option>
                                <option value="11">December</option>
                            </select>
                            <span>/</span>
                            <select name="cardYear" id="cardYear" class="form-control" onchange="validateExpired()"></select>
                            <br/>
                            <span id="error-msg-cardMonth" class="text-danger" for="cardMonth" style="display: none">Current month is invalid</span>
                            <p>Month / Year</p>
                        </div>                        
                    </div>
                    <div class="form-group" id="CVV-div">
                        <label class="control-label col-md-6" for="CCV">CVV</label>
                        <div class="col-md-6">
                            <input type="text" id="CVV" class="form-control" name="CCV" placeholder="Input CVV" onkeyup="validateKeyUp(this)"/>
                            <span id="error-msg-CVV" class="text-danger" style="margin: 5px;display: none;">CVV is invalid</span>
                        </div>
                    </div>                    
                    <div class="form-group"> 
                        <div class="col-sm-offset-5 col-md-6" style="margin-top: 20px">
                            <button type="button" class="btn btn-success text-primary" id="submitVisa" >Submit</button>
                            <a class="btn btn-danger pull-right" style="color: white" href="${pageContext.request.contextPath}/buyvip">Cancel Transaction</a>
                        </div>
                    </div>
                </form>
            </div>
            <div class="col-md-5" id="image-visa-number" style="display: block">
                <img src="public/images/card_number_visa1.jpg" style="margin: 60px" />
            </div>
            <div class="col-md-5" id="image-visa-name" style="display: none">
                <img src="public/images/card_holdername_visa.jpg" style="margin: 60px" />
            </div>
            <div class="col-md-5" id="image-visa-date" style="display: none">
                <img src="public/images/card_date_visa1.jpg" style="margin: 60px" />
            </div>
            <div class="col-md-5" id="image-visa-cvv" style="display: none">
                <img src="public/images/card_cvv.png" style="margin: 60px" />
            </div>
        </div>
        <%@include file="footer.jsp" %>
    </body>       


    <script src="public/js/jquery.min.js"></script>
    <script src="public/js/bootstrap.min.js"></script>
    <script src="public/js/jquery.validate.min.js"></script>
    <script src="public/js/additional-methods.min.js"></script>
    <script src="public/js/sweetalert.js"></script>
    <script src="public/js/loginHeader.js"></script>
    <script src="public/js/visa-payment-validate.js"></script>
    <script>
                                $(document).ready(function() {
                                    var frm = $("#visaForm");
                                    $("#submitVisa").on('click', function() {
                                        validateSubmit();
                                        validateExpired();
                                        if (!$('div[class*="has-error"]').html()) {
                                            frm.trigger("submit");
                                        }
                                    });
                                    $("#cardNo").focus(function() {
                                        $("#image-visa-number").css("display", "block");
                                        $("#image-visa-name").css("display", "none");
                                        $("#image-visa-date").css("display", "none");
                                        $("#image-visa-cvv").css("display", "none");
                                    });
                                    $("#cardName").focus(function() {
                                        $("#image-visa-number").css("display", "none");
                                        $("#image-visa-name").css("display", "block");
                                        $("#image-visa-date").css("display", "none");
                                        $("#image-visa-cvv").css("display", "none");
                                    });
                                    $("#cardMonth").change(function() {
                                        $("#image-visa-number").css("display", "none");
                                        $("#image-visa-name").css("display", "none");
                                        $("#image-visa-date").css("display", "block");
                                        $("#image-visa-cvv").css("display", "none");
                                    });
                                    $("#cardYear").change(function() {
                                        $("#image-visa-number").css("display", "none");
                                        $("#image-visa-name").css("display", "none");
                                        $("#image-visa-date").css("display", "block");
                                        $("#image-visa-cvv").css("display", "none");
                                    });
                                    $("#CVV").focus(function() {
                                        $("#image-visa-number").css("display", "none");
                                        $("#image-visa-name").css("display", "none");
                                        $("#image-visa-date").css("display", "none");
                                        $("#image-visa-cvv").css("display", "block");
                                    });
                                });
                                var min = new Date().getFullYear(),
                                        max = min + 20,
                                        select = document.getElementById('cardYear');
                                for (var i = min-1; i <= max; i++) {
                                    var opt = document.createElement('option');
                                    opt.value = i;
                                    opt.innerHTML = i;
                                    select.appendChild(opt);
                                }
    </script>   
</body>
</html>
