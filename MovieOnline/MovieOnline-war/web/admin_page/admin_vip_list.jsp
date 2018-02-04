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
    </head>
    <body>

        <div id="wrapper">

            <!-- Navigation -->
            <%@include file="admin_header.jsp" %>

            <div id="page-wrapper">
                <div class="row page-header">
                    <div>
                        <strong class="title-header"><i class="fa fa-home fa-title"></i> <a class="text-black" href="${pageContext.request.contextPath}/admin">Dashboard</a></strong><span style="color: gray"> / VIP Management</span>
                    </div>
                </div>

                <!--Noi dung-->
                <div class="row">
                    <div class="col-lg-12">
                        <div class="panel panel-info">
                            <div class="panel-heading">
                                Package VIP list
                            </div>
                            <div class="panel-body">
                                <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-Vip">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Name</th>
                                            <th>Duration(Days)</th>
                                            <th>Price</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${list}" var="items">
                                            <tr id="${items.typeVipId}" name="${items.typeVipId}">
                                                <td>${items.typeVipId}</td>
                                                <td>${items.name}</td>
                                                <td>${items.duration}</td>
                                                <td>
                                                    <fmt:setLocale value = "vi_VN"/>
                                                    <fmt:formatNumber type = "currency"  value = "${items.price}" />
                                                </td>
                                                <td>
                                                    <button id="${items.typeVipId}" class="btn btn-danger" 
                                                            data-toggle="confirmation"
                                                            data-placement="left"
                                                            data-btn-ok-label="OK" data-btn-ok-icon="glyphicon glyphicon-ok"
                                                            data-btn-ok-class="btn-success"
                                                            data-btn-cancel-label="Cancel" data-btn-cancel-icon="glyphicon glyphicon-ban-circle"
                                                            data-btn-cancel-class="btn-danger"
                                                            data-title="Are You Sure?">
                                                        Delete
                                                    </button>
                                                    <a id="${items.typeVipId}" class="btn btn-info" href="${pageContext.request.contextPath}/AdminVipUpdate?id=${items.typeVipId}">
                                                        Update   
                                                    </a>        
                                                </td>
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

        </div>-->
    </div>
    <!-- /#wrapper -->

    <script src="./public/js/jquery.min.js"></script>
    <script src="./public/js/bootstrap.min.js"></script>
    <script src="./public/js/metisMenu.min.js"></script>
    <script src="./public/js/bootstrap-confirmation.js"></script>
    <script src="./public/js/raphael.min.js"></script>
    <script src="./public/datatables/js/jquery.dataTables.min.js"></script>
    <script src="./public/datatables-plugins/dataTables.bootstrap.min.js"></script>
    <script src="./public/datatables-responsive/dataTables.responsive.js"></script>
    <script src="./public/js/sb-admin-2.js"></script>
    <script src="public/js/sweetalert.js"></script>

    <script>
        $(document).ready(function() {            
            $('[data-toggle=confirmation]').confirmation({
                onConfirm: function() {
                    var currentRow = $(this).parent().parent();
                    var id = $(this).parent().siblings(":nth-child(1)").text();
                    var name = $(this).parent().siblings(":nth-child(2)").text();
                    $.ajax({
                        type: "POST",
                        url: "deleteVip",
                        data:   {typeVipId: id, 
                                name: name, 
                                csrfSalt: $('input[name=csrfSalt]').val(),
                                user: $('input[name=accId]').val()
                                },
                        success: function(resultData) {
                            if (resultData == 'false') {
                                swal('An error occurred while processing the request', 'Something error when delete vip package.', 'error');
                            }
                            if (resultData == 'true') {
                                var cur = $('tr[name=' + id + ']');
                                table.row(cur).remove().draw();
                                swal("Success", "Delete " + name + (" pack successfully"), 'success');
                            }
                        },
                        error: function() {
                            alertModel('An error occurred while processing the request', 'Something error when delete movie.');
                        }
                    });
                }
            });
            var table = $('#dataTables-Vip').DataTable({
                responsive: true,
                "order": [[0, "asc"]]
            });
        });
    </script>
</body>
</html>
