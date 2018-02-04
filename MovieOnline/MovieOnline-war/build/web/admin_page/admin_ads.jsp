<%-- 
    Document   : admin_notification
    Created on : Nov 22, 2017, 10:45:38 PM
    Author     : namin
--%>

<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
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
        <title>S&E Online | ADS Setting</title>

        <!-- Bootstrap core CSS -->
        <link href="./public/css/bootstrap.min.css" rel="stylesheet">
        <link href="./public/css/metisMenu.min.css" rel="stylesheet">
        <link href="./public/css/fileinput.min.css" media="all" rel="stylesheet" type="text/css" />
        <link href="./public/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">
        <link href="./public/datatables-responsive/dataTables.responsive.css" rel="stylesheet">
        <link href="./public/css/sb-admin-2.css?ver=1.2" rel="stylesheet">
        <link rel="stylesheet" href="./public/css/sweetalert.css?ver=1.1">
        <link href="./public/css/jquery-ui.css" rel="stylesheet">
        <link href="./public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
        <style type="text/css">
            .btn-tool{
                padding-left: 20px;
                padding-right: 20px;
                margin-right: 5px;
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
                        <strong class="title-header"><i class="fa fa-home fa-title"></i> <a class="text-black" href="${pageContext.request.contextPath}/admin">Dashboard</a></strong><span style="color: gray"> / <a class="text-gray" href="${pageContext.request.contextPath}/adsServlet?type=get">ADS Setting</a></span>
                    </div>
                </div>
                <!--Noi dung-->
                <div class="row page-content">
                    <div class="row col-md-11" style="margin: 20px 4% 30px 4%">
                        <div>
                            <button class="btn btn-tool" data-toggle="modal" data-target="#uploadsub"><i class="fa fa-upload fa-fw"></i> Upload</button>
                            <button class="btn btn-tool ads-save"><i class="fa fa-save fa-fw"></i> Save</button>
                        </div>
                    </div>
                    <div class="row col-md-8 timeline-main" style="margin-left: 4%;margin-bottom: 20px">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                Video ADS Timeline
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <table class="table table-striped table-bordered table-hover" id="dataTables-Timeline">
                                    <thead>
                                        <tr>
                                            <th>Time Start (seconds)</th>
                                            <th>File</th>
                                            <th>Duration</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%JSONArray arrL = new JSONArray((String)request.getAttribute("list"));
                                            for(int i = 0;i<arrL.length();i++){
                                                 JSONObject obj = arrL.getJSONObject(i);%>
                                                 <tr name="listTimeline">
                                                        <td><%= obj.getInt("time")%></td>
                                                        <td><%= obj.getString("ad")%></td>
                                                        <td><%= obj.getInt("duration")%></td>
                                                        <td><button name="del-timeline" class="btn btn-danger">Delete</button></td>
                                                 </tr>
                                            <%}%>
                                    </tbody>
                                </table>
                            </div>
                            <!-- /.panel-body -->
                        </div>
                        <span>* Please click <i class="fa fa-save fa-fw"></i> to apply the change after edit video ads timeline</span>
                    </div>
                    
                    <div class="row col-md-8" style="margin-left: 4%;">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                Lists of Video
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <table class="table table-striped table-bordered table-hover" id="dataTables-Ads">
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th>Video</th>
                                            <th>Duration (seconds)</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%JSONArray arr = new JSONArray((String)request.getAttribute("listVideo"));
                                            for(int i = 0;i<arr.length();i++){
                                                 JSONObject obj = arr.getJSONObject(i);%>
                                                 <tr>
                                                     <td></td>
                                                        <td><%= obj.getString("name")%></td>
                                                        <td><%= obj.getInt("duration")%></td>
                                                        <td>
                                                        <button name="addTimeline" class="btn btn-success">Add</button>
                                                        <button name="del-video" class="btn btn-danger">Delete</button></td>
                                                 </tr>
                                            <%}%>
                                    </tbody>
                                </table>
                            </div>
                            <!-- /.panel-body -->
                        </div>
                    </div>
                    
                </div>
                <!-- Modal -->
                <div id="uploadsub" class="modal fade" role="dialog">
                  <div class="modal-dialog">

                    <!-- Modal content-->
                    <div class="modal-content">
                      <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Upload ADS</h4>
                      </div>
                      <div class="modal-body">
                        <div class="file-loading">
                            <input id="file-ads" name="file-ads" class="file" type="file" data-msg-placeholder="Select {files} for upload..." data-allowed-file-extensions='["mp4", "flv","avi"]'>
                        </div>
                      </div>
                      <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                      </div>
                    </div>

                  </div>
                </div>
                
                <!-- Modal -->
                <div id="addtimeline" class="modal fade" role="dialog">
                  <div class="modal-dialog">

                    <!-- Modal content-->
                    <div class="modal-content">
                      <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Add Timeline</h4>
                      </div>
                      <div class="modal-body">
                          <span id="error-Modal" style="color: red"></span>
                          <p><label style="color: #999999">Video: </label> <strong id="name-Modal"> </strong></p>
                          <p><label style="color: #999999">Duration: </label> <strong id="duration-Modal"> </strong></p>
                          <p><label style="color: #999999">Start At: </label> <input name="time-Modal" type="number" value="0" class="form-control" style="width: 20%;display: inline-block"></input> seconds</p>
                      </div>
                      <div class="modal-footer">
                        <button name="addConfirm" type="button" class="btn btn-success">Confirm</button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                      </div>
                    </div>

                  </div>
                </div>
                <!--Noi dung-->
            </div>
        </div>

        <script src="./public/js/jquery.min.js"></script>
        <script src="./public/js/jquery-ui.js"></script>
        <script src="./public/js/bootstrap.min.js"></script>
        <script src="./public/js/bootstrap-confirmation.js"></script>
        <script src="./public/js/fileinput.min.js"></script>
        <script src="./public/js/sweetalert.js"></script>
        <script src="./public/js/metisMenu.min.js"></script>
        <script src="./public/js/raphael.min.js"></script>
        <script src="./public/datatables/js/jquery.dataTables.min.js"></script>
        <script src="./public/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="./public/datatables-responsive/dataTables.responsive.js"></script>
        <script src="./public/js/sb-admin-2.js"></script>
        <script>
            $(document).ready(function(){
                var adsTable = $('#dataTables-Ads').DataTable({
                    "columnDefs": [ {
                        "searchable": false,
                        "orderable": false,
                        "targets": 0
                    } ],
                    "order": [[ 1, 'asc' ]]
                });
                var timeTable = $('#dataTables-Timeline').DataTable({
                    'createdRow': function( row, data, dataIndex ) {
                        $(row).attr('name', 'listTimeline');
                    },
                    "columnDefs": [ {
                        "searchable": false,
                        "orderable": false,
                        "targets": 0
                    } ],
                    "order": [[ 0, 'asc' ]],
                });
                adsTable.on( 'order.dt search.dt', function () {
                    adsTable.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
                        cell.innerHTML = i+1;
                    } );
                } ).draw();
                $('.ads-save').click(function(){
                    var arrAds = $('tr[name=listTimeline]');
                    var arr=[]
                    arrAds.each(function(){
                        var row = $(this).children();
                        var startTime = row.siblings(":nth-child(1)").html()
                        var file = row.siblings(":nth-child(2)").html()
                        var duration = row.siblings(":nth-child(3)").html()
                        arr.push({"time":parseInt(startTime),"ad":file,"duration":parseInt(duration)})
                    })
                    var arrS =JSON.stringify(arr);
                    $.ajax({
                        type: "POST",
                        url: "adsServlet",
                        data: {type:"saveAds",list:arrS},
                        success: function(resultData){
                            if(resultData =='success'){
                                swal("Success!", "Save success", "success"); 
                            }else{
                                swal("Failed!", "Cannot save! Error: "+resultData, "error"); 
                            }
                        },
                        error:function () {
                            swal("Failed!", "Cannot save!", "error"); 
                        }
                    });
                })
                $('#file-ads').on('filebatchuploadsuccess', function(event, data, previewId, index) {
                    var data = data.response;
                    if(data.SUCCESS == 'Exist'){
                        swal("Warning!", "File is exited in resource folder", "warning");
                    }else{
                        swal("Success!", "Upload ads success.", "success");
                        adsTable.row.add(['',data.SUCCESS,data.Duration,'<button name="addTimeline" class="btn btn-success">Add</button> <button name="del-video" class="btn btn-danger">Delete</button>']).draw();
                        actionVideoList();
                    }
                    $('#file-ads').fileinput('clear');
                    
                })
                function actionVideoList(){
                    $('button[name=addTimeline]').on('click',function(){
                        var row = $(this).parent();
                        var name = row.siblings(":nth-child(2)").html();
                        var duration = row.siblings(":nth-child(3)").html();
                        $('#name-Modal').html(name)
                        $('#duration-Modal').html(duration)
                        $('#addtimeline').modal('show');
                    })
                    $('button[name=del-video]').confirmation({
                        title:"Warning! Any timeline has video will be remove",
                        onConfirm: function() {
                            var row = $(this).parent().parent();
                            var name = row.children().siblings(":nth-child(2)").html()
                            var duration = row.children().siblings(":nth-child(3)").html()
                            $.ajax({
                                type: "POST",
                                url: "adsServlet",
                                data: {type:"delVideo",name:name,duration:duration},
                                success: function(resultData){
                                    if(resultData =='success'){
                                        swal("Success!", "Save success", "success");
                                        adsTable.row(row).remove().draw();
                                        var arrAds = $('tr[name=listTimeline]');
                                        arrAds.each(function(){
                                            var row = $(this);
                                            var child = row.children();
                                            var file = child.siblings(":nth-child(2)").html()
                                            var duration = child.siblings(":nth-child(3)").html()
                                            if(file.includes("/"+name) &&duration==duration){
                                                timeTable.row($(this)).remove().draw();
                                            }
                                        })
                                        
                                    }else{
                                        swal("Failed!", "Cannot delete video! Error: "+resultData, "error"); 
                                    }
                                },
                                error:function () {
                                    swal("Failed!", "Error! Cannot send request", "error"); 
                                }
                            });
                        },
                    })
                }
                
                actionVideoList();
                $('button[name=addConfirm]').on('click',function(){
                    if($('input[name=time-Modal]').val() == '' || $('input[name=time-Modal]').val() == undefined || $('input[name=time-Modal]').val() <0){
                         $('#error-Modal').html('Invalid start time of ads');
                         return;
                    }else{
                        var flag = false;
                        var arrAds = $('tr[name=listTimeline]');
                        arrAds.each(function(){
                            var row = $(this).children();
                            var startTime = row.siblings(":nth-child(1)").html()
                            if(startTime == $('input[name=time-Modal]').val()){
                                flag = true;
                                return
                            }
                        })
                        if(!flag){
                            $('#error-Modal').html('');
                            timeTable.row.add([$('input[name=time-Modal]').val(),"moviesSource/ads/"+$('#name-Modal').html(),$('#duration-Modal').html(),'<button name="del-timeline" class="btn btn-danger">Delete</button>']).draw();
                            timeTable.order([0, 'asc']).draw();
                            $('button[name=del-timeline]').confirmation({
                                onConfirm: function() {
                                    var row = $(this).parent().parent();
                                    timeTable.row(row).remove().draw();
                                },
                            })
                            $('#addtimeline').modal('hide');
                        }else{
                            $('#error-Modal').html('Time start is existed. Pls re-enter');
                        }
                    }
                })
                $('body,button[name=del-timeline]').on('click', function (e) {
                    $('button[name=del-timeline]').each(function(){
                        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('button[name=del-timeline]').has(e.target).length === 0) {
                            $(this).confirmation('hide');
                        }
                    });
                });
                $('body,button[name=del-video]').on('click', function (e) {
                    $('button[name=del-video]').each(function(){
                        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('button[name=del-video]').has(e.target).length === 0) {
                            $(this).confirmation('hide');
                        }
                    });
                });
                $('button[name=del-timeline]').confirmation({
                    onConfirm: function() {
                        var row = $(this).parent().parent();
                        timeTable.row(row).remove().draw();
                    },
                })
                $('button[name=del-video]').confirmation({
                    title:"Warning! Any timeline has video will be remove",
                    onConfirm: function() {
                        var row = $(this).parent().parent();
                        timeTable.row(row).remove().draw();
                    },
                })
                
            })
            $("#file-ads").fileinput({
                'theme': 'explorer-fa',
                'uploadUrl': '${pageContext.request.contextPath}/adsServlet',
                overwriteInitial: false,
                autoReplace :true,
                initialPreviewAsData: true,
                uploadAsync: false,
                fileActionSettings: {
                    showUpload: false,
                }        
            });
        </script>
    </body>
</html>
