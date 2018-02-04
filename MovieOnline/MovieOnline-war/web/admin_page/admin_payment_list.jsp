<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>Title</title>

        <link href="./public/css/bootstrap.min.css" rel="stylesheet">
        <link href="./public/css/metisMenu.min.css" rel="stylesheet">
        <link href="./public/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">
        <link href="./public/datatables-responsive/dataTables.responsive.css" rel="stylesheet">
        <link href="./public/css/sb-admin-2.css" rel="stylesheet">
        <link href="./public/css/sweetalert.css" rel="stylesheet">
        <link href="./public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
        <link rel="stylesheet" type="text/css" href="./public/css/daterangepicker.css" />
        <style rel="stylesheet" type="text/css">
            .page-header div div{
                font-size: medium;
                margin-right: 5px;
                background: #fff; 
                cursor: pointer; 
                padding: 5px 10px; 
                border: 1px solid #ccc; 
                border-radius: 5px;
                float: right;
            }
            #page-wrapper div div h1 button{
                padding: 4px 12px;
            }
        </style>
    </head>
    <body>

        <div id="wrapper">
            <!-- Navigation -->
            <%@include file="admin_header.jsp" %>
            <div id="page-wrapper">
                <div class="row page-header">
                    <div>
                        <strong class="title-header"><i class="fa fa-home fa-title"></i> <a class="text-black" href="${pageContext.request.contextPath}/admin">Dashboard</a></strong><span style="color: gray"> / Payment VIP Management</span>
                        <button class="btn btn-primary" onclick="printReport()" style="float: right">Export Report</button>
                        <div id="reportrange" class="pull-right">
                            <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>&nbsp;
                            <span id="reportday"></span> <b class="caret"></b>
                        </div>
                    </div>
                </div>
                <!--Noi dung-->
                <div class="row">
                    <div class="col-lg-12">
                        <div class="panel panel-info">
                            <div class="panel-heading">
                                Payment VIP list
                            </div>
                            <div class="panel-body">
                                <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-paymentList">
                                    <thead>
                                        <tr>
                                            <th>History ID</th>                                            
                                            <th>User Name</th>
                                            <th>Email</th>
                                            <th>VIP Package Name</th>
                                            <th>Price</th>
                                            <th>Payment Date</th>

                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${list}" var="items">
                                            <tr>
                                                <td>${items.historyId}</td>
                                                <td>${items.accountId.userName}</td>
                                                <td>${items.accountId.email}</td>
                                                <td>${items.typeVipId.name}</td>
                                                <td>
                                                    <fmt:setLocale value = "vi_VN"/>
                                                    <fmt:formatNumber type = "currency"  value = "${items.typeVipId.price}" />
                                                </td>                                               
                                                <td>${items.dateRegister}</td>

                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>    
                </div>
                <!--Noi dung-->
            </div>
        </div>
        <script src="./public/js/jquery.min.js"></script>
        <script src="./public/js/bootstrap.min.js"></script>
        <script src="./public/js/metisMenu.min.js"></script>
        <script src="./public/js/bootstrap-confirmation.js"></script>
        <script src="./public/js/raphael.min.js"></script>
        <script src="./public/datatables/js/jquery.dataTables.min.js"></script>
        <script src="./public/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="./public/datatables-responsive/dataTables.responsive.js"></script>
        <script src="./public/js/sb-admin-2.js"></script>
        <script src="./public/js/sweetalert.js"></script>
        <script type="text/javascript" src="./public/js/moment.min.js"></script>
        <script type="text/javascript" src="./public/js/daterangepicker.js"></script>
        <script>
                            $(document).ready(function() {
                                var table = $('#dataTables-paymentList').DataTable({
                                    responsive: true,
                                    "order": [[0, "desc"]]
                                });
                            });
                            function printContent(paymentlist) {
                                var winPrint = window.open('', 'PrintWindow', 'left=50,top=50,width=800,height=600,toolbar=no,scrollbars=yes,status=0,resizable=yes');
                                winPrint.document.writeln('<!DOCTYPE html>');
                                winPrint.document.writeln('<html><head><title></title>');
                                winPrint.document.writeln('<link rel="stylesheet" type="text/css" media="print" href="./public/css/bootstrap.min.css"/>');
                                winPrint.document.writeln('<style type="text/css">');
                                winPrint.document.writeln('@media print{.table th { background-color: #d9edf7 !important; } .text-primary{color:blue!important;} h4{font-family: "Times New Roman", Times, serif;}}')
                                winPrint.document.writeln('</style>');
                                winPrint.document.writeln('</head><body style="-webkit-print-color-adjust:exact">');
                                winPrint.document.writeln('<p><img src="./public/images/coollogo.png" height="80px"/></p>');
                                winPrint.document.writeln('<h4><i>Add: 590 CMT8, Dis.3- FPT Aptech</i></h4><h4><i>Phone: 0121893573</i></h4>');
                                winPrint.document.writeln('<h1 style="text-align: center" class="text-primary center">Payment Report</h1>');
                                winPrint.document.writeln('<h4 style="text-align: center"><i>Time: ' + $('#reportday').html() + '</i></h4>');
                                winPrint.document.writeln('<hr>');
                                winPrint.document.writeln('<table class="table table-bordered">');
                                winPrint.document.writeln('<tr><th>ID</th><th>User Name</th><th>Email</th><th>VIP Package Name</th><th>Price</th><th>Payment Date</th><tr>');
                                var obj = $.parseJSON(paymentlist);
                                if (obj.length != 0) {
                                    $.each(obj, function(key, value) {
                                        winPrint.document.writeln('<tr>');
                                        winPrint.document.writeln('<td>' + value.id + '</td>');
                                        winPrint.document.writeln('<td>' + value.name + '</td>');
                                        winPrint.document.writeln('<td>' + value.email + '</td>');
                                        winPrint.document.writeln('<td>' + value.typevip + '</td>');
                                        winPrint.document.writeln('<td>' + value.price + '</td>');
                                        winPrint.document.writeln('<td>' + value.date + '</td>');
                                        winPrint.document.writeln('</tr>');
                                    })
                                }
                                winPrint.document.writeln('</table>');
                                winPrint.document.writeln('<h3 style="float:right"><i>Total Payment: ' + obj.length + '</i></h3>')
                                winPrint.document.writeln('</body></html>');
                                winPrint.document.close();
                                setTimeout(function() {
                                    winPrint.focus();
                                    winPrint.print();
                                    winPrint.close();
                                }, 250);
                            }
                            function printReport()
                            {
                                $.ajax({
                                    type: "POST",
                                    url: "reportServlet",
                                    data: {sub: "payment", day: $('#reportday').html()},
                                    success: function(resultData) {
                                        if (resultData == 'false') {
                                            swal("Error!", "Cannot export report. Something wrong.", "error");
                                        } else {
                                            printContent(resultData);
                                        }
                                    },
                                    error: function() {
                                        swal("Error!", "Cannot export report. Something wrong.", "error");
                                    }
                                })
                            }
                            var start = moment().subtract(29, 'days');
                            var end = moment();

                            function cb(start, end) {
                                $('#reportrange span').html(start.format('MM/DD/YYYY') + ' - ' + end.format('MM/DD/YYYY'));
                            }

                            $('#reportrange').daterangepicker({
                                startDate: start,
                                endDate: end,
                                ranges: {
                                    'Today': [moment(), moment()],
                                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
                                }
                            }, cb);
                            cb(start, end);
        </script>
    </body>
</html>
