<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style rel="stylesheet" type="text/css">
    a.text-black{
        color: #333333;
    }
    a.text-black:hover{
        text-decoration: none;
        color: #0000cc;
    }
    a.text-gray{
        color: gray;
    }
    a.text-gray:hover{
        text-decoration: none;
        color: #0000cc;
    }
</style>
<!-- Navigation -->
<div class="navbar-default sidebar col-lg-4" role="navigation">
    <div class="sidebar-nav navbar-collapse">
        <ul class="nav" id="side-menu">
            <li class="sidebar-title" style="border-bottom: 1px solid #cccccc;">
                <a href="${pageContext.request.contextPath}/admin"><i class="fa fa-film fa-2x"></i> <span>S&E ONLINE</span></a>
            </li>
            <li class="sidebar-avata">
                <div class="input-group custom-avatar">
                    <c:choose>
                        <c:when test="${sessionScope.user.image ==null || sessionScope.user.image ==''}">
                            <img class="avatar" src="./public/images/avatar/empty_avatar.png" alt="avatar" />
                        </c:when>
                        <c:otherwise>
                            <img class="avatar" src="./public/images/avatar/${sessionScope.user.image}" alt="avatar" />
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="custom-avatar-name">
                    <label>${sessionScope.user.userName}</label>
                </div>
                <hr style="border-top: 1px solid #cccccc;">
            </li>
            <li>
                <a href=""><i class="fa fa-video-camera fa-fw"></i> Movie Management<span class="fa arrow"></span></a>
                <ul class="nav nav-second-level">
                    <li>
                        <a href="${pageContext.request.contextPath}/adminUploadMovie?action=upload"><i class="fa fa-upload fa-fw"></i> Upload Movie</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/adminMovieList"><i class="fa fa-list-alt fa-fw"></i> Movie List</a>
                    </li>
                </ul>
            </li>
            <li>
                <a href=""><i class="fa fa-user fa-fw"></i> Account Management<span class="fa arrow"></span></a>
                <ul class="nav nav-second-level">
                    <li>
                        <a href="${pageContext.request.contextPath}/adminaccount" onclick="return check_role();"><i class="fa fa-user fa-fw"></i> Account</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/ReportComment?type=reportList&title=REPORT COMMENT" onclick="return check_role();"><i class="fa fa-comment-o fa-fw"></i> User Comment</a>
                    </li>
                </ul>
            </li>
            <li>
                <a href=""><i class="fa fa-money fa-fw"></i> VIP Management<span class="fa arrow"></span></a>
                <ul class="nav nav-second-level">
                    <li>
                        <a href="${pageContext.request.contextPath}/Adminvip" onclick="return check_role();"><i class="fa fa-plus-circle fa-fw"></i>Insert new VIP package</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/adminVipList" onclick="return check_role();"><i class="fa fa-list fa-fw"></i>VIP List</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/AdminPaymentList" onclick="return check_role();"><i class="fa fa-list fa-fw"></i>Payment List</a>
                    </li>
                </ul>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/notificationServlet?type=searchnoti&isread=0"><i class="fa fa-history fa-fw"></i> Server History</a>
            </li>
            <li>
                <a href=""><i class="fa fa-cog fa-fw"></i> Settings<span class="fa arrow"></span></a>
                <ul class="nav nav-second-level">
                    <li>
                        <a href="${pageContext.request.contextPath}/adsServlet?type=get"><i class="fa fa-buysellads fa-fw"></i> Advertisement</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/adminMovieList" onclick="return check_role()"><i class="fa fa-list-alt fa-fw"></i> Other</a>
                    </li>
                </ul>
            </li>
        </ul>         
    </div>
    <div class="info-summary">
        <label>INFORMATION SUMMARY</label>
        <div class="row summary-content">
            <div class="summary-content-left">
                <span>BANDWIDTH</span><br/>
                <label><span id="network-bankwidth">0</span> Mbps</label>
            </div>
            <div class="summary-content-right">
                <div class="circle-bankwidth" id="circle-c">
                    <div class="barOverflow">
                        <div id="bar-bankwidth" class="bar"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row summary-content">
            <div class="summary-content-left">
                <span>DISK USAGE</span><br/>
                <label><span id="disk-usager">82.2</span> %</label>
            </div>
            <div class="summary-content-right">
                <div class="circle-diskspace" id="circle-b">
                    <div class="barOverflow">
                        <div class="bar"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>                
    <!-- /.sidebar-collapse -->
</div>
<!-- /.navbar-static-side -->
<div class="navbar navbar-default" role="navigation" style="margin-bottom: 0;background-color: white">
    <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin">S&E Online</a>
    </div>
<!--     .navbar-header -->

    <ul class="nav navbar-top-links navbar-right">
        <li class="dropdown">
            <a class="dropdown-toggle notif" data-toggle="dropdown" href="#" onclick="loadNoti()">
                <i id="noti-icon" class="fa fa-bell fa-fw"></i> <i class="fa fa-caret-down"></i>
                <span id="noti-icon-num" class="noti-num">!</span>
            </a>
            <ul class="dropdown-menu dropdown-alerts">
                <li>
                    <a href="${pageContext.request.contextPath}/notificationServlet?type=searchnoti&title=upload movie&isread=0">
                        <div>
                            <i class="fa fa-upload fa-fw"></i> New Movie <span id="uploaded-movie-count" class="badge">5</span>
                            <span id="uploaded-movie-time" class="pull-right text-muted small">4 minutes ago</span>
                        </div>
                    </a>
                </li>
                <li class="divider"></li>
                <li>
                    <a href="${pageContext.request.contextPath}/notificationServlet?type=searchnoti&title=payment&isread=0">
                        <div>
                            <i class="fa fa-credit-card fa-fw"></i> New Payment <span id="payment-count" class="badge">3</span>
                            <span id="payment-time" class="pull-right text-muted small">4 minutes ago</span>
                        </div>
                    </a>
                </li>
                <li class="divider"></li>
                <li>
                    <a href="${pageContext.request.contextPath}/notificationServlet?type=searchnoti&title=task&isread=0">
                        <div>
                            <i class="fa fa-tasks fa-fw"></i> New Task <span id="task-count" class="badge">4</span>
                            <span id="task-time" class="pull-right text-muted small">4 minutes ago</span>
                        </div>
                    </a>
                </li>
                <li class="divider"></li>
                <li>
                    <a href="${pageContext.request.contextPath}/notificationServlet?type=searchnoti&title=error report&isread=0">
                        <div>
                            <i class="fa fa-exclamation-triangle fa-fw"></i> Error Report <span id="error-count" class="badge">4</span>
                            <span id="error-time" class="pull-right text-muted small">4 minutes ago</span>
                        </div>
                    </a>
                </li>
                <li class="divider"></li>
                <li>
                    <a class="text-center" href="${pageContext.request.contextPath}/notificationServlet?type=searchnoti&isread=0">
                        <strong>See All Alerts</strong>
                        <i class="fa fa-angle-right"></i>
                    </a>
                </li>
            </ul>
            <!-- /.dropdown-alerts -->
        </li>
        <!-- /.dropdown -->
        <li class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
            </a>
            <ul class="dropdown-menu dropdown-user">
                <li><a href="${pageContext.request.contextPath}/admin/adminprofile"><i class="fa fa-user fa-fw"></i> User Profile</a>
                </li>
                <li><a href="#"><i class="fa fa-gear fa-fw"></i> Settings</a>
                </li>
                <li class="divider"></li>
                <input type="hidden" name="accId" value="${sessionScope.user.accountId}">
                <input type="hidden" name="role" value="${sessionScope.user.role.name}">
                <input type="hidden" name="csrfSalt" value="<c:out value='${csrfSalt}'/>"/>
                <li><a href="${pageContext.request.contextPath}/AdminLoginServlet?csrfSalt=${csrfSalt}&action=logout"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                </li>
            </ul>
            <!-- /.dropdown-user -->
        </li>
        <!-- /.dropdown -->
    </ul>
    <!-- /.navbar-top-links -->
</div>

<!-- Alert Modal -->
<div id="alertModal" class="modal fade">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content trailer-model-content">
            <div class="modal-header">
                <button type="button" class="close white" data-dismiss="modal">&times;</button>
                <h4 id="title-alert" class="modal-title"></h4>
            </div>
            <div id="body-alert" class="modal-body">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>

    </div>
</div>                
<script>var ctx = "${pageContext.request.contextPath}"</script>
<script src="./public/js/socketNoti.js?ver=1.1"></script>
<script type="text/javascript">
    function getUsedLocalStorageSpace() {
        if(window.localStorage != undefined){
            return Object.keys(window.localStorage).map(function(key) { return localStorage[key].length;}).reduce(function(a,b) { return a+b;},0);
        }
        return 0
    };
    var connection = navigator.connection || navigator.mozConnection || navigator.webkitConnection;
    // Check for browser support
    var network = document.getElementById("network-bankwidth");
    if (connection) {
        network.innerHTML = connection.downlink;
        connection.addEventListener('change', function(){
              var speed = connection.downlink
              network.innerHTML = speed;
              document.getElementById("bar-bankwidth").style.transform= "rotate(" + (45 + (speed * 1.8)) + "deg)";
        });
    }else{
      network.innerHTML = 0;
    }
    openSocket();
    checkNoti();
    function check_role(){
        var role = $('input[name=role]').val();
        if(role=='ROLE_ADMIN'){
            return true;
        }else{
            $('#title-alert').html("<span style='color: red'>Access Declined</span>");
            $('#body-alert').html("You dont have permission to access this");
            $('#alertModal').modal('show')
            return false;
        }
    }
    document.getElementById("disk-usager").innerHTML = getUsedLocalStorageSpace();
</script>
