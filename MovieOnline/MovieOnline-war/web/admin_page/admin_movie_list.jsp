<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>S&E Online | Movie List</title>

        <link href="./public/css/bootstrap.min.css" rel="stylesheet">
        <link href="./public/css/metisMenu.min.css" rel="stylesheet">
        <link href="./public/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">
        <link href="./public/datatables-responsive/dataTables.responsive.css" rel="stylesheet">
        <link href="./public/css/sb-admin-2.css?ver=1.2" rel="stylesheet">
        <link rel="stylesheet" href="./public/css/sweetalert.css?ver=1.1">
        <link href="./public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
        <link rel="stylesheet" type="text/css" href="./public/css/daterangepicker.css" />
        <style rel="stylesheet" type="text/css">
            .page-header div #reportrange{
                font-size: medium;
                margin-right: 5px;
                background: #fff; 
                cursor: pointer; 
                padding: 5px 10px; 
                border: 1px solid #ccc; 
                border-radius: 5px;
                float: right;
            }
            .report-movie ul li a:hover{
                cursor: pointer
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
                        <strong class="title-header"><i class="fa fa-home fa-title"></i> <a class="text-black" href="${pageContext.request.contextPath}/admin">Dashboard</a></strong><span style="color: gray"> / <a class="text-gray" href="${pageContext.request.contextPath}/adminMovieList">Movie Management</a></span>
                        <div class="dropdown pull-right report-movie">
                            <button class="btn btn-primary dropdown-toggle" data-toggle="dropdown">Export Report <span class="caret"></span></button>
                            <ul class="dropdown-menu">
                                <li><a onclick="printReport(0)">All Movie</a></li>
                                <li><a onclick="printReport(5)">Top 5 Movie By View</a></li>
                            </ul>
                        </div>
                        
                        <div id="reportrange" class="pull-right">
                            <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>&nbsp;
                            <span id="reportday"></span> <b class="caret"></b>
                        </div>
                    </div>
                </div>
                <!--Noi dung-->
                <div class="row page-content">
                    <div class="col-lg-12">
                        <div class="panel panel-info">
                            <div class="panel-heading">
                                Lists of Films
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <input type="hidden" name="csrfSalt" value="<c:out value='${csrfSalt}'/>"/>
                                <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-Movies">
                                    <thead>
                                        <tr>
                                            <th>Movie ID</th>
                                            <th>Real Title</th>
                                            <th>Tag</th>
                                            <th>Upload Day</th>
                                            <th>Country</th>
                                            <th>Genre</th>
                                            <th>Type</th>
                                            <th>Poster</th>
                                            <th>Status</th>
                                            <th>Views</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${list}" var="items">
                                            <tr id="${items.movieId}" name="${items.movieId}" class="odd gradeX">
                                                <td>${items.movieId}</td>
                                                <td>${items.realTitle}</td>
                                                <td class="overflow-string">${items.titleTag}</td>
                                                <td>${items.uploadDay}</td>
                                                <td>${items.countryId.countryName}</td>
                                                <td class="overflow-string"><c:forEach items="${items.genreCollection}" var="gen">
                                                        ${gen.genreName},
                                                    </c:forEach></td>
                                                <td><c:choose>
                                                        <c:when test="${items.type == false}">Movie</c:when><c:otherwise>TV series</c:otherwise>
                                                    </c:choose></td>
                                                <td><img src="moviesSource/mv_${items.movieId}/poster.medium.jpg" height="60px"></td>
                                                <td><c:choose>
                                                        <c:when test="${items.status == false}"><button class="btn btn-danger btn-xs">Deactivate</button></c:when><c:otherwise><button class="btn btn-success btn-xs">Active</button></c:otherwise>
                                                    </c:choose></td>
                                                <td>${items.views}</td>
                                                <td><button id="${items.movieId}" class="btn btn-danger btn-delete" 
                                                            data-toggle="confirmation"
                                                            data-placement="left"
                                                            data-btn-ok-label="OK" data-btn-ok-icon="glyphicon glyphicon-ok"
                                                            data-btn-ok-class="btn-success"
                                                            data-btn-cancel-label="Cancel" data-btn-cancel-icon="glyphicon glyphicon-ban-circle"
                                                            data-btn-cancel-class="btn-danger"
                                                            data-title="Are You Sure?">
                                                        Delete</button></td>
                                             </tr>
                                        </c:forEach>    
                                    </tbody>
                                </table>
                            </div>
                            <!-- /.panel-body -->
                        </div>
                        <!-- /.panel -->
                    </div>      
                </div>
            </div>
        </div>
        <!-- /#wrapper -->

        <script src="./public/js/jquery.min.js"></script>
        <script src="./public/js/bootstrap.min.js"></script>
        <script src="./public/js/bootstrap-confirmation.js"></script>
        <script src="./public/js/sweetalert.js"></script>
        <script src="./public/js/metisMenu.min.js"></script>
        <script src="./public/js/raphael.min.js"></script>
        <script src="./public/datatables/js/jquery.dataTables.min.js"></script>
        <script src="./public/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="./public/datatables-responsive/dataTables.responsive.js"></script>
        <script type="text/javascript" src="./public/js/sb-admin-2.js"></script>
        <script type="text/javascript" src="./public/js/moment.min.js"></script>
        <script type="text/javascript" src="./public/js/daterangepicker.js"></script>
        <script>
        $(document).ready(function() {
            $('body,.btn-delete').on('click', function (e) {
                $('.btn-delete').each(function(){
                    if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.btn-delete').has(e.target).length === 0) {
                        $(this).confirmation('hide');
                    }
                });
            });
            $('[data-toggle=confirmation]').confirmation({ 
                onConfirm: function() {
                    var currentRow = $(this).parent().parent();
                    var id =$(this).parent().siblings(":nth-child(1)").text()
                    $.ajax({
                        type: "POST",
                        url: "deleteMovie",
                        data: {movieId:id,csrfSalt:$('input[name=csrfSalt]').val(),user:$('input[name=accId]').val()},
                        success: function(resultData){
                            if(resultData=='false'){
                                swal("Error!", "Something error when delete movie. Make sure all process is completed", "error");
                            }
                            if(resultData=='true'){
                                var cur = $('tr[name='+id+']');
                                table.row(cur).remove().draw();
                                swal("Success!", "Movie ID: <span style='color: red'>"+id+"</span> has been deleted", "success");
                            }
                                
                        },
                        error:function () {
                            swal("Error!", "Something error when delete movie.", "error");
                        }
                    });
                }
            });
            var table =$('#dataTables-Movies').DataTable({
                responsive: true,
                "order": [[ 0, "desc" ]]
            });
            $('input[name="daterange"]').daterangepicker();
            
            $("#dataTables-Movies").on('dblclick','tr',function(e){
                e.preventDefault();
                var url = "${pageContext.request.contextPath}/adminUploadMovie?action=update&id=" + $(this).attr('name');
                window.location.replace(url);
            });
        });
        function printContent(movielist,num){
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
            winPrint.document.writeln('<h1 style="text-align: center" class="text-primary center">Movie Report</h1>');
            winPrint.document.writeln('<h4 style="text-align: center"><i>Time: '+$('#reportday').html()+'</i></h4>');
            winPrint.document.writeln('<hr>');
            winPrint.document.writeln('<table class="table table-bordered">');
            winPrint.document.writeln('<tr><th>ID</th><th>Name</th><th>Country</th><th>Genre</th><th>Actor</th><th>Director</th><th>Release Day</th><th>Upload Day</th><th>Type</th><th>Duration</th><th>View</th><th>Rating</th><th>Quantity</th><th>Total Episode</th><th>Status</th><tr>');
            var obj = $.parseJSON(movielist);
            if(obj.length != 0){
                var index = 0;
                $.each(obj,function (key,value){
                    if(index !=0 && index ==num){
                        return ;
                    }
                    winPrint.document.writeln('<tr>');
                    winPrint.document.writeln('<td>'+value.id+'</td>');
                    winPrint.document.writeln('<td>'+value.name+'</td>');
                    winPrint.document.writeln('<td>'+value.country+'</td>');
                    winPrint.document.writeln('<td>'+value.genre+'</td>');
                    winPrint.document.writeln('<td>'+value.actor+'</td>');
                    winPrint.document.writeln('<td>'+value.director+'</td>');
                    winPrint.document.writeln('<td>'+value.releaseDay+'</td>');
                    winPrint.document.writeln('<td>'+value.uploadDay+'</td>');
                    winPrint.document.writeln('<td>'+value.type+'</td>');
                    winPrint.document.writeln('<td>'+value.duration+'</td>');
                    winPrint.document.writeln('<td>'+value.views+'</td>');
                    winPrint.document.writeln('<td>'+value.rate+'</td>');
                    winPrint.document.writeln('<td>'+value.quantity+'</td>');
                    winPrint.document.writeln('<td>'+value.totalEpisode+'</td>');
                    winPrint.document.writeln('<td>'+value.status+'</td>');
                    winPrint.document.writeln('</tr>');
                    index ++;
                }) 
            }
            winPrint.document.writeln('</table>');
            winPrint.document.writeln('<h3 style="float:right"><i>Total Movie: '+obj.length+'</i></h3>')
            winPrint.document.writeln('</body></html>');
            winPrint.document.close();
            setTimeout(function() {
                winPrint.focus();
                winPrint.print();
                winPrint.close();
            }, 250);
        }
        function printReport(num){    
            $.ajax({
                type: "POST",
                url: "reportServlet",
                data: {sub:"movie",day:$('#reportday').html()},
                success: function(resultData){
                    if(resultData=='false'){
                        swal("Error!", "Cannot export report. Something wrong.", "error");
                    }else{
                        printContent(resultData,num) 
                    }
                                
                },
                error:function () {
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
