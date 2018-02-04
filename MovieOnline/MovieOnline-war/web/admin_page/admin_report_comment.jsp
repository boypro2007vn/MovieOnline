<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <META charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>Title</title>

        <!-- Bootstrap core CSS -->
        <link href="./public/css/bootstrap.min.css" rel="stylesheet">
        <link href="./public/css/metisMenu.min.css" rel="stylesheet">
        <link href="./public/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">
        <link href="./public/datatables-responsive/dataTables.responsive.css" rel="stylesheet">
        <link href="./public/css/sb-admin-2.css?ver=1.2" rel="stylesheet">
        <link rel="stylesheet" href="./public/css/sweetalert.css?ver=1.1">
        <link href="./public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    </head>
    <body>
        <div id="wrapper">
            <!-- Navigation -->
            <%@include file="admin_header.jsp" %>

            <div id="page-wrapper">
                <div class="row page-header">
                    <div>
                        <strong class="title-header"><i class="fa fa-home fa-title"></i> <a class="text-black" href="${pageContext.request.contextPath}/admin">Dashboard</a></strong><span style="color: gray"> / Report Comments</span>
                    </div>
                </div>

                <!--Noi dung-->
                <div class="row page-content">
                    <div class="col-lg-12">
                        <div class="panel panel-info">
                            <div class="panel-heading">
                                Report Comments
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <input type="hidden" name="csrfSalt" value="<c:out value='${csrfSalt}'/>"/>
                                <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-report">
                                    <thead>
                                        <tr>

                                            <th>ID</th>
                                            <th>Sender</th>                                            
                                            <th>Title</th>
                                            <th>Content</th>
                                            <th>Time</th>     
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${list}" var="items">
                                            <c:if test="${items.isUnread}">
                                                <tr id="${items.notiId}" name="${items.notiId}" class="odd gradeX">
                                                </c:if>
                                                <c:if test="${!items.isUnread}">
                                                <tr id="${items.notiId}" name="${items.notiId}" class="odd gradeX info">
                                                </c:if>       

                                                <td>${items.notiId}</td>                                               
                                                <td>${items.name}</td> 
                                                <td>${items.title}</td>
                                                <td class="overflow-string">${items.content}</td>
                                                <td>${items.time}</td>
                                                <td>                                                    
                                                    <c:if test="${items.content != 'This comment has been deleted'}">
                                                        <button id="" class="btn btn-danger pull-left" 
                                                                data-toggle="confirmation1"
                                                                data-placement="left"
                                                                data-btn-ok-label="OK" data-btn-ok-icon="glyphicon glyphicon-ok"
                                                                data-btn-ok-class="btn-success"
                                                                data-btn-cancel-label="Cancel" data-btn-cancel-icon="glyphicon glyphicon-ban-circle"
                                                                data-btn-cancel-class="btn-danger"
                                                                data-title="Are You Sure?">
                                                            Delete Comment
                                                        </button>
                                                    </c:if> 
                                                </td>
                                            </tr>
                                        </c:forEach>    
                                    </tbody>
                                </table>
                            </div>
                            <!-- /.panel-body -->
                        </div>
                    </div>
                </div>
                <!--Noi dung-->                
            </div>
        </div>
        <!-- /#wrapper -->
        <!-- Alert Modal -->
        <div id="detailNotiModal" class="modal fade">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content trailer-model-content">
                    <div class="modal-header">
                        <button type="button" class="close white" data-dismiss="modal">&times;</button>
                        <h4 id="title-detail-Noti" class="modal-title"></h4>
                    </div>
                    <div id="body-detail-Noti" class="modal-body">

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </div>

            </div>
        </div>
        <script src="./public/js/jquery.min.js"></script>
        <script src="./public/js/bootstrap.min.js"></script>
        <script src="./public/js/bootstrap-confirmation.js"></script>
        <script src="./public/js/sweetalert.js"></script>
        <script src="./public/js/metisMenu.min.js"></script>
        <script src="./public/js/raphael.min.js"></script>
        <script src="./public/datatables/js/jquery.dataTables.min.js"></script>
        <script src="./public/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="./public/datatables-responsive/dataTables.responsive.js"></script>
        <script src="./public/js/sb-admin-2.js?ver=1.2"></script>
        <script>
            $(document).ready(function() {
                var notiTable = $('#dataTables-report').DataTable({
                    responsive: true,
                    "order": [[0, "desc"]]

                });
                notiTable.on('dblclick', 'tr', function() {
                    var row = $(this);
                    var name = $(this).attr("name");
                    var sender = $(this).children().siblings(":nth-child(2)").html();
                    var time = $(this).children().siblings(":nth-child(5)").html();
                    var content = $(this).children().siblings(":nth-child(4)").html();
                    if ($('input[name=role]').val() == "ROLE_ADMIN") {
                        $.ajax({
                            type: "POST",
                            url: "notificationServlet",
                            data: {notiID: $(this).attr("name"), type: "changeSeen"},
                            success: function(resultData) {
                                if (resultData == 'success') {
                                    row.removeClass("info");
                                } else {
                                    swal("Error!", resultData, "error");
                                }
                            },
                            error: function() {
                                swal("Error!", "Cannot sent request.", "error");
                            }
                        });
                    }
                    $('#title-detail-Noti').html("Detail: <span class='text-primary'>" + name + "</span>");
                    $('#body-detail-Noti').html("<p><strong>Sender: </strong>" + sender + "</br><strong>Time: </strong>" + time + "</br><strong>Content: </strong><div class='panel panel-default'><div class='panel-body'>" + content + "</div></div></p>");
                    $('#detailNotiModal').modal('show');

                });                
                $('[data-toggle=confirmation1]').confirmation({
                    onConfirm: function() {
                        var commentContent = $(this).parent().siblings("td:nth-child(4)").html()
                        var regex = /<a>[0-9]+<\/a>/
                        var findCommnent = commentContent.match(regex);
                        var commentId = findCommnent.toString().replace("<a>", "").replace("</a>", "");
                        var notiId = $(this).parent().siblings(":nth-child(1)").text();
                        $.ajax({
                            type: 'POST',
                            url: "AdminDeleteComment",
                            data: {
                                condition: "deleteComment",
                                commentId: commentId,
                                notiId: notiId
                            },
                            success: function(resultData) {
                                if (resultData == 'false') {
                                    swal('An error occurred while processing the request', 'Something error when deleting comment.', 'error');
                                }
                                if (resultData == 'true') {
                                    location.reload();
                                }
                            }
                        });                        
                    }                    
                })                
            });
        </script>
    </body>
</html>
