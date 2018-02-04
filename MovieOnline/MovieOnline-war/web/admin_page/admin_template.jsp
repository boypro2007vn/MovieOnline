<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>S&E Online | Admin HomePage</title>

        <link href="./public/css/bootstrap.min.css" rel="stylesheet">
        <link href="./public/css/metisMenu.min.css" rel="stylesheet">
        <link href="./public/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">
        <link href="./public/datatables-responsive/dataTables.responsive.css" rel="stylesheet">
        <link href="./public/css/sb-admin-2.css?ver=1.2" rel="stylesheet">
        <link href="./public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
        <link href="./public/css/admin-template.css?ver=1.2" rel="stylesheet" type="text/css">
        
    </head>
    <body onload="startTime()">

        <div id="wrapper">
            <!-- Navigation -->
            <%@include file="admin_header.jsp" %>
            
            <div id="page-wrapper">
                <div class="row page-header">
                    <div>
                        <strong class="title-header"><i class="fa fa-home fa-title"></i> <a class="text-black" href="${pageContext.request.contextPath}/admin">Dashboard</a></strong>
                    </div>
                </div>
                <!--Noi dung-->
                <div class="row page-content" style="margin-bottom: 30px">
                    <div class="col-lg-3 col-md-6">
                        <div class="static-panel static-primary">
                            <div class="row static-panel-header">
                                <div class="col-xs-3" style="padding-top: 7px">
                                    <i class="fa fa-film fa-5x"></i>
                                </div>
                                <div class="col-xs-9 text-right">
                                    <div style="font-size: 35px">${countMovie}</div>
                                    <div style="padding-bottom: 3px">Movie Uploaded</div>
                                    <div><i class="fa fa-clock-o fa-fw"></i> ${countMovieday} Today</div>
                                </div>
                                <a href="${pageContext.request.contextPath}/adminMovieList">
                                    <div class="static-footer">
                                        <span class="pull-left">View Details</span>
                                        <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                        <div class="clearfix"></div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="static-panel static-success">
                            <div class="row static-panel-header">
                                <div class="col-xs-3" style="padding-top: 7px">
                                    <i class="fa fa-eye fa-5x"></i>
                                </div>
                                <div class="col-xs-9 text-right">
                                    <div style="font-size: 35px">${viewcount}</div>
                                    <div style="padding-bottom: 3px">Views Movie</div>
                                    <div><i class="fa fa-clock-o fa-fw"></i> ${viewcountday} Today</div>
                                </div>
                                <a href="#" data-toggle="modal" data-target="#modal-countview">
                                    <div class="static-footer">
                                        <span class="pull-left">View Details</span>
                                        <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                        <div class="clearfix"></div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                    <!-- Modal -->
                    <div id="modal-countview" class="modal fade" role="dialog">
                      <div class="modal-dialog">

                        <!-- Modal content-->
                        <div class="modal-content">
                          <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title">List View of Movie Today</h4>
                          </div>
                            <div class="modal-body" style="height: 300px;overflow-y: scroll">
                                <table class="table">
                                    <thead>
                                      <tr>
                                        <th>Name</th>
                                        <th>View Count</th>
                                      </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${listviewcountday}" var="item">
                                            <tr>
                                                <td>${item.movie.realTitle}</td>
                                                <td>${item.view}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                          </div>
                        </div>

                      </div>
                    </div>            
                    <div class="col-lg-3 col-md-6">
                        <div class="static-panel static-warning">
                            <div class="row static-panel-header">
                                <div class="col-xs-3" style="padding-top: 7px">
                                    <i class="fa fa-user-plus fa-5x"></i>
                                </div>
                                <div class="col-xs-9 text-right">
                                    <div style="font-size: 35px">${countUser}</div>
                                    <div style="padding-bottom: 3px">User Registrations</div>
                                    <div><i class="fa fa-clock-o fa-fw"></i> ${countUserday} Today</div>
                                </div>
                                <a href="#">
                                    <div class="static-footer">
                                        <span class="pull-left">View Details</span>
                                        <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                        <div class="clearfix"></div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="static-panel static-danger">
                            <div class="row static-panel-header">
                                <div class="col-xs-3" style="padding-top: 7px">
                                    <i class="fa fa-credit-card fa-5x"></i>
                                </div>
                                <div class="col-xs-9 text-right">
                                    <div style="font-size: 35px">${countPayment}</div>
                                    <div style="padding-bottom: 3px">User Payment</div>
                                    <div><i class="fa fa-clock-o fa-fw"></i> ${countPaymentday} Today</div>
                                </div>
                                <a href="${pageContext.request.contextPath}/notificationServlet?type=searchnoti&title=task&isread=0">
                                    <div class="static-footer">
                                        <span class="pull-left">View Details</span>
                                        <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                        <div class="clearfix"></div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row page-content">
                    <div class="col-lg-9">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <i class="fa fa-bar-chart-o fa-fw"></i> Statistics Chart
                                <i class="fa fa-refresh fa-fw pull-right" onclick="changeChart(0,true)"></i>
                            </div>
                            <div class="panel-body" style="padding-bottom: 0px">
                                <div>
                                    <canvas id="userPaymentChart" height="140px"></canvas>
                                </div>
                                <div class="row" style="background-color: #f8f9fa;padding: 15px 0 10px 0;border-top: 1px solid #cccccc;display: flex;flex-direction:row;justify-content:center">
                                    <div class="col-md-3" style="text-align: center;padding-bottom: 7px">
                                        <span style="color: #95989a">Total: </span>
                                        <div id="statotal" style="color: black;font-weight: bold">${totalPayment}</div>
                                    </div>
                                    <div id="avgyear" class="col-md-3" style="text-align: center;padding-bottom: 7px">
                                        <span id="avgyear-label" style="color: #95989a">Average Year: </span>
                                        <div id="avgyear-value" style="color: black;font-weight: bold">0</div>
                                    </div>
                                    <div id="avgmonth" class="col-md-3" style="text-align: center;padding-bottom: 7px;display: none">
                                        <span style="color: #95989a">Average Monthly: </span>
                                        <div id="staavgmonth" style="color: black;font-weight: bold">0</div>
                                    </div>
                                    <div class="col-md-3" style="text-align: center;padding-bottom: 7px">
                                        <span style="color: #95989a">Count User: </span>
                                        <div id="stacountpay" style="color: black;font-weight: bold">${countUserPay}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div id="datetime-panel" class="tile tile-img tile-time" style="height: 200px">
                            <p class="time-widget">
                                <span class="time-widget-heading">It Is Currently</span>
                                <br>
                                <strong>
                                    <span id="datetime">Sunday<br>November 26th, 2017<br>10:18:59 PM</span>
                                </strong>
                            </p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="tile light-gray" style="height: 320px">
                            <h4><i class="fa fa-bolt"></i> Server Load <a href="javascript:;"><i class="fa fa-refresh pull-right"></i></a>
                            </h4>
                            <p class="small text-faded">
                                <strong>130 GB </strong>of
                                <strong>1024 GB </strong>used
                            </p>
                            <div class="flot-chart flot-chart-dashboard">
                                <div class="flot-chart-content" id="flot-chart-moving-line" style="padding: 0px; position: relative;">
                                    <div class="flot-chart-bg"></div>
                                    <canvas id="mycanvas" class="base" width="230" height="220"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--Noi dung-->
            </div>
        </div>
        <!-- /#wrapper -->

        <script src="./public/js/jquery.min.js"></script>
        <script src="./public/js/bootstrap.min.js"></script>
        <script src="./public/js/metisMenu.min.js"></script>
        <script src="./public/js/raphael.min.js"></script>
        <script src="./public/datatables/js/jquery.dataTables.min.js"></script>
        <script src="./public/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="./public/datatables-responsive/dataTables.responsive.js"></script>
        <script src="./public/js/sb-admin-2.js?ver=1.4"></script>
        <script type="text/javascript" src="./public/js/smoothie.js"></script>
        <script src="./public/js/chart.js"></script>
        <script type="text/javascript">
            var listUserStatistic = <%=request.getAttribute("listStatistic")%>;
        </script>
        <script src="./public/js/showdatetime.js?ver=1.2"></script>
    </body>
</html>
