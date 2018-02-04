


<%@page import="entity.Accounts"%>
<% Accounts accDetail = (Accounts) request.getAttribute("accDetail");%>
<div class="container info-container">
    <div class="row">
        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
            <div class="col3-content">
                <div class="info">
                    <div class="member-avatar"><img id="info-avatar" src="public/images/img_avatar1.png"/></div>
                    <div class="short-info">
                        <div id="account-name">${accDetail.email}</div>
                        <div id="VIP-account">VIP: ${vipdays} DAYS</div>
                        <p id="demo"></p>
                        <div><a href="${pageContext.request.contextPath}/buyvip" class="btn btn-primary" id="buyVIP">Buy VIP</a></div>
                    </div>

                </div>
                <div class="option">
                    <ul>
                        <li style="padding:3px 0px;"><a href="${pageContext.request.contextPath}/userInfo" id="personal-info" class="btn" ><i class="glyphicon glyphicon-user"></i>Detail Information</a></li>
                        <li style="padding:5px 0px;"><a href="${pageContext.request.contextPath}/UserHistory" id="mall-his" class="btn" ><i class="glyphicon glyphicon-ok"></i>Payment History</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
