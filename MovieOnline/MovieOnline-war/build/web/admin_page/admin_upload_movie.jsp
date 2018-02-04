<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>S&E Online | Upload Movie</title>

        <link href="./public/css/bootstrap.min.css" rel="stylesheet">
        <link href="./public/css/fileinput.min.css" media="all" rel="stylesheet" type="text/css" />
        <link href="./public/css/theme.min.css" media="all" rel="stylesheet" type="text/css">
        <link href="./public/css/metisMenu.min.css" rel="stylesheet">
        <link href="./public/css/bootstrap-datetimepicker.css" rel="stylesheet">
        <link href="./public/css/sb-admin-2.css?ver=1.2" rel="stylesheet">
        <link href="./public/css/formwizard.css?ver=1.1" rel="stylesheet">
        <link rel="stylesheet" href="./public/css/sweetalert.css?ver=1.1">
        <link href="./public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
        <style rel="stylesheet" type="text/css">
            div #complete{
                text-align: center;
            }
            div #complete button{
                margin: 20px auto;
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
                        <strong class="title-header"><i class="fa fa-home fa-title"></i> <a class="text-black" href="${pageContext.request.contextPath}/admin">Dashboard</a></strong><span style="color: gray"> / <a class="text-gray" href="${pageContext.request.contextPath}/adminUploadMovie?action=upload">Upload Movie</a></span>
                    </div>
                </div>
                <div class="row">
                    <section>
                        <div class="wizard">
                            <div class="wizard-inner">
                                <div class="connecting-line"></div>
                                <ul class="nav nav-tabs" role="tablist">
                                    <li role="presentation" class="active">
                                        <a href="#step1" data-toggle="tab" aria-controls="step1" role="tab" title="Step 1">
                                            <span class="round-tab">
                                                <i class="glyphicon glyphicon-pencil"></i>
                                            </span>
                                        </a>
                                    </li>

                                    <li role="presentation" class="disabled">
                                        <a href="#step2" data-toggle="tab" aria-controls="step2" role="tab" title="Step 2">
                                            <span class="round-tab">
                                                <i class="fa fa-upload fa-fw"></i>
                                            </span>
                                        </a>
                                    </li>
                                    
                                    <li role="presentation" class="disabled">
                                        <a href="#complete" data-toggle="tab" aria-controls="complete" role="tab" title="Complete">
                                            <span class="round-tab">
                                                <i class="glyphicon glyphicon-ok"></i>
                                            </span>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                            <div role="form">
                                <div class="tab-content">
                                    <div class="tab-pane active" role="tabpanel" id="step1">
                                        <div class="form-group" style="margin-left: 50px">
                                            <form id="insertForm" method="post" role="form">
                                                <div class="col-md-5" style="margin-right: 5%">
                                                    <div id="title-div" class="form-group">
                                                        <label for="title">Title: (*)</label>
                                                        <input type="text" class="form-control" name="title" id="title" onkeyup="validateKeyUp(this)" placeholder="Input...">
                                                        <span id="error-msg-title" class="text-danger" style="margin: 5px;display: none">Field is required. Must be word character, number(6 - 100), ':', '(', ')'</span>
                                                    </div>
                                                    <div id="real-title-div" class="form-group">
                                                        <label for="realTitle">Real Title: (*)</label>
                                                        <input type="text" class="form-control" name="realTitle" id="realTitle" onkeyup="validateKeyUp(this)" placeholder="Input...">
                                                        <span id="error-msg-realtitle" class="text-danger" style="margin: 5px;display: none">Field is required. Must be word character, number(6 - 100), ':', '(', ')'</span>
                                                    </div>
                                                    <div id="tag-div" class="form-group" >
                                                        <label for="tag">Keyword:</label>
                                                        <input type="text" class="form-control" name="tag" id="tag" onkeyup="validateKeyUp(this)" placeholder="Input...">
                                                        <span id="error-msg-tag" class="text-danger" style="margin: 5px;display: none">Field must be word character, number(4 - 200), ','</span>
                                                    </div>
                                                    
                                                    <div id="dir-div" class="form-group">
                                                            <label for="director">Director: (*)</label>
                                                            <input type="text" class="form-control" name="director" id="director" onkeyup="validateKeyUp(this)" placeholder="Input...">
                                                            <span id="error-msg-dir" class="text-danger" style="margin: 5px;display: none">Field must be word character, number(4 - 50), ',','.'</span>
                                                    </div>
                                                    <div id="actor-div" class="form-group">
                                                        <label for="actor">Actor: (*)</label>
                                                        <textarea class="form-control" rows="5" id="actor" name="actor" onkeyup="validateKeyUp(this)"></textarea>
                                                        <span id="error-msg-actor" class="text-danger" style="margin: 5px;display: none">Field must be word character, number(4 - 200), ',','.'</span>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Genre: (*) </label> <span id="error-msg-genre" class="text-danger" style="margin: 0 5px;display: none"> Please choose at least one genre</span>
                                                        <div>
                                                            <c:forEach items="${genreCb}" var="items">
                                                                <div class="col-md-3">   
                                                                    <label class="checkbox-inline"><input name="genreCb" type="checkbox" value="${items.genreId}">${items.genreName}</label>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </div> 


                                                <div class="col-md-5 col-lg-5">
                                                    <div class="form-group">
                                                        <label for="actor">Description: </label>
                                                        <textarea class="form-control" rows="5" id="description" name="description"></textarea>
                                                    </div>
                                                    <div id="releaseday-div" class="form-group">
                                                        <label for="releaseDay">Release Day: (*)</label>
                                                        <div class='input-group date col-md-6' id='releaseDayPicker'>
                                                            <input type='text' class="form-control" name="releaseDay" id="releaseDay"/>
                                                            <span class="input-group-addon">
                                                                <span class="glyphicon glyphicon-calendar"></span>
                                                            </span>
                                                        </div>
                                                        <span id="error-msg-releaseday" class="text-danger" style="margin: 5px;display: none">Please choose release day</span>
                                                    </div>
                                                    <div id="imbd-div" class="form-group col-md-6 col-lg-6 col-xs-6 col-sm-6">
                                                        <label for="imbd">IMBD: <span style="color: gray;font-weight: normal">Default 0</span></label>
                                                        <input type="number" class="form-control" name="imbd" id="imbd" onkeyup="validateKeyUp(this)" placeholder="Input..." value="0">
                                                        <span id="error-msg-imdb" class="text-danger" style="margin: 5px;display: none">IMDB is incorrect. Must be positive number 0 -> 10</span>
                                                    </div>
                                                    <div class="form-group col-md-6">
                                                        <label for="country">Country:</label>
                                                        <select class="form-control" id="country" name="country">
                                                            <c:forEach items="${countrySl}" var="items">
                                                                <option value="${items.countryId}">${items.countryName}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <div class="form-group col-md-6">
                                                        <label for="type">Type:</label>
                                                        <div>
                                                            <label class="radio-inline"><input type="radio" name="MovieType" value="0" checked="">Movie</label>
                                                            <label class="radio-inline"><input type="radio" name="MovieType" value="1">TV Series</label>
                                                        </div>                                
                                                    </div>
                                                    <div id="duration-div" class="form-group col-md-6">
                                                        <label for="duration">Duration: (*)</label> <span style="color: gray;display: inline"> 0 if don't know</span>
                                                        <div>
                                                            <input type="number" class="form-control" style="width: 50%;float: left" name="duration" id="duration" onkeyup="validateKeyUp(this)" value="0">
                                                            <label for="durationType" style="margin: 7px 12px;font-weight: normal">Minutes</label>
                                                        </div>
                                                        <span id="error-msg-duration" class="text-danger" style="margin: 5px;display: none">Please enter duration. Must be positive number</span>
                                                    </div>
                                                    <div id="trailer-div" class="form-group">
                                                        <label for="director">Trailer Link: <span style="font-weight: normal;color: gray">You can put trailer link or upload video file later</span></label>
                                                        <input type="text" class="form-control" name="trailer" id="trailer" onkeyup="validateKeyUp(this)" placeholder="Input...">
                                                        <span id="error-msg-trailer" class="text-danger" style="margin: 5px;display: none">Your link is incorrect. Please re-enter</span>
                                                    </div>
                                                    <div class="form-group col-md-6" style="margin-top: 20px">
                                                            <label for="ageLimit">Age Limit:</label>
                                                            <div class="material-switch pull-right">
                                                                <input id="ageLimit" name="ageLimit" type="checkbox"/>
                                                                <label for="ageLimit" class="label-primary"></label>
                                                            </div>
                                                    </div>
                                                    <div class="form-group col-md-6" style="margin-top: 20px">
                                                        <label for="status">Status:</label>
                                                            <div class="material-switch pull-right">
                                                                <input id="status" name="status" type="checkbox" checked/>
                                                                <label for="status" class="label-primary"></label>
                                                            </div>
                                                    </div>
                                                    <div class="form-group"><span style="margin-left: 10px;color: red">Note:</span> If status is disable. Your movie will not show in homepage</div>
                                                    
                                                </div>
                                                <div class="form-group col-md-3 col-md-offset-4">
                                                    <input type="hidden" name="actionMovie" value="insert"/>
                                                    <button name="action" value="insert" type="button" class="btn btn-primary first-step">Insert</button>
                                                    <input style="margin-left: 20px" name="reset" type="reset" class="btn btn-primary" value="Reset"/>
                                                </div> 
                                            </form>
                                            
                                        </div>
                                    </div>
                                    <div class="tab-pane" role="tabpanel" id="step2">
                                        <div>
                                            <input type="hidden" id="insertedID" value="0"/>
                                            <div class="row" style="margin-left: 2%">
                                                <div class="col-lg-3 col-md-6">
                                                    <div class="panel panel-primary">
                                                        <div class="panel-heading">
                                                            <div class="row">
                                                                <div class="col-xs-3">
                                                                    <i class="fa fa-video-camera fa-5x"></i>
                                                                </div>
                                                                <div class="col-xs-9 text-right">
                                                                    <h4>TRAILER</h4>
                                                                    <div>File Type: MP4,FLV,AVI</div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <a href="#">
                                                            <div class="panel-footer" data-toggle="modal" data-target="#trailermodal">
                                                                <span type="button" class="pull-left">Upload Trailer</span>
                                                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                                                <div class="clearfix"></div>
                                                            </div>
                                                        </a>
                                                    </div>
                                                </div>
                                                
                                                <!-- trailer Modal -->
                                                <div id="trailermodal" class="modal fade" role="dialog">
                                                    <div id="modal-upload-trailer" class="modal-dialog">

                                                        <!-- Modal content-->
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                                <h4 class="modal-title">Upload Movie Trailer</h4>
                                                            </div>
                                                            <div class="modal-body">
                                                                <div class="file-loading">
                                                                    <input id="file-trailer" name="trailer-file" class="file" type="file" data-msg-placeholder="Select {files} for upload..." data-allowed-file-extensions='["mp4", "flv","avi"]'>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </div>
                                                <div class="col-lg-3 col-md-6">
                                                    <div class="panel panel-red">
                                                        <div class="panel-heading">
                                                            <div class="row">
                                                                <div class="col-xs-3">
                                                                    <i class="fa fa-image fa-5x"></i>
                                                                </div>
                                                                <div class="col-xs-9 text-right">
                                                                    <h4>POSTER</h4>
                                                                    <div>File Type: JPG,PNG,GIF</div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <a href="#">
                                                            <div class="panel-footer" data-toggle="modal" data-target="#postermodal">
                                                                <span type="button" class="pull-left">Upload Poster</span>
                                                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                                                <div class="clearfix"></div>
                                                            </div>
                                                        </a>
                                                    </div>
                                                </div>
                                                
                                                <!-- poster Modal -->
                                                <div id="postermodal" class="modal fade" role="dialog">
                                                    <div id="modal-upload-poster" class="modal-dialog">

                                                        <!-- Modal content-->
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                                <h4 class="modal-title">Upload Movie Poster</h4>
                                                            </div>
                                                            <div class="modal-body">
                                                                <div class="file-loading">
                                                                    <input id="file-poster" name="poster-file" class="file" type="file" data-msg-placeholder="Select {files} for upload..." data-allowed-file-extensions='["png", "jpg","gif"]'>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-lg-3 col-md-6">
                                                    <div class="panel panel-green">
                                                        <div class="panel-heading">
                                                            <div class="row">
                                                                <div class="col-xs-3">
                                                                    <i class="fa fa-cc fa-5x"></i>
                                                                </div>
                                                                <div class="col-xs-9 text-right">
                                                                    <h4>Subtitle</h4>
                                                                    <div>File Type: VTT</div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <a href="#">
                                                            <div name="btnAddSub" class="panel-footer" data-toggle="modal">
                                                                <span type="button" class="pull-left">Upload Subtitle</span>
                                                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                                                <div class="clearfix"></div>
                                                            </div>
                                                        </a>
                                                    </div>
                                                </div>
                                                <!-- sub Modal -->
                                                <div id="submodal" class="modal fade" role="dialog">
                                                    <div id="modal-upload-sub" class="modal-dialog">

                                                        <!-- Modal content-->
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                                <h4 class="modal-title">Upload Movie Subtitle</h4>
                                                            </div>
                                                            <div class="modal-body">
                                                                <div class="row">
                                                                    <div class="col-lg-4">
                                                                        <label for="sort" class="control-label">Episode ID: </label> 
                                                                        <span id="sub-episode-id" class="text-primary"></span>
                                                                    </div>
                                                                    <div class="col-lg-6">
                                                                        <label for="sort" class="col-sm-5 control-label">Episode Name: </label>
                                                                        <div class="col-sm-4">
                                                                            <select id="sub-list-episode-name" class="form-control"></select>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <p><label for="sort" class="control-label">Format file: </label><span class="text-primary">VTT</span> | Ex: batman_en_English <span class="text-danger">!important</span></p>
                                                                <div class="file-loading">
                                                                    <input id="file-sub" name="file-sub" class="file" type="file" data-msg-placeholder="Select {files} for upload..." data-allowed-file-extensions='["vtt"]' multiple>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" style="margin-left: 2%">
                                            <hr>
                                            <div class="col-md-7">
                                                <div class="panel panel-success">
                                                    <div class="panel-heading">Add Episode</div>
                                                    <div class="panel-body">
                                                        <div class="row">
                                                            <div class="col-lg-3">
                                                                <div id="episode-name-div" class="form-group" >
                                                                    <label for="tag">Episode Name:</label>
                                                                    <input type="number" class="form-control" name="episode-name" id="episode-name" onkeyup="validateKeyUp(this)" value="1">
                                                                    <span id="error-msg-episode-name" class="text-danger" style="margin: 5px;display: none">Episode Name must be positive number. Minimum: 1</span>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-3">
                                                                <div class="form-group">
                                                                    <label for="sel1">Language:</label>
                                                                    <select class="form-control" id="episode-lang">
                                                                        <option value="English">English</option>
                                                                        <option value="Vietnamese">Vietnamese</option>
                                                                        <option value="Chinese">Chinese</option>
                                                                        <option value="Spanish">Spanish</option>
                                                                        <option value="Russian">Russian</option>
                                                                        <option value="Japanese">Japanese</option>
                                                                        <option value="Thailand">Thailand</option>
                                                                        <option value="Korean">Korean</option>
                                                                        <option value="France">France</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6" >
                                                                <span style="color: red">Note:</span><div style="display: block">Video format: <a>MP4</a>,<a>FLV</a>,<a>AVI</a><br/>You  cannot change episode name and language after upload</div>
                                                            </div>
                                                        </div>
                                                        <div class="row" style="margin-right: 1%">
                                                            <div id="episode-link-div" class="form-group" style="margin-left: 2%">
                                                                <label for="link">File:</label>
                                                                <div class="file-loading">
                                                                    <input id="file-episode" name="episode-file" class="file" type="file" data-msg-placeholder="Select {files} for upload..." data-allowed-file-extensions='["mp4", "flv","avi"]'>
                                                                </div>
                                                                <span id="error-msg-episode-link" class="text-danger" style="margin: 5px;display: none">Please choose a file to upload</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-5" style="width: 39%">
                                                <div class="panel panel-success">
                                                    <div class="panel-heading">Current Episode</div>
                                                    <div id="curEpisode" class="panel-body" style="height: 400px">
                                                        <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-Movies">
                                                            <thead>
                                                                <tr>
                                                                    <th>ID</th>
                                                                    <th>Name</th>
                                                                    <th>Language</th>
                                                                    <th>File Name</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody id="curEpisodeBody">
                                                                
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <ul class="list-inline pull-right">
                                            <li><button type="button" class="btn btn-primary btn-info-full second-step" data-title="You have't upload poster or trailer. Do you want next?">Save and continue</button></li>
                                        </ul>
                                    </div>
                                    <div class="tab-pane" role="tabpanel" id="complete">
                                        <h1 style="text-align: center">Complete</h1>
                                        <h3 style="text-align: center">Upload movie complete. Your movie have been in homepage.</h3>
                                        <button type="button" class="btn btn-primary btn-info-full reset-step center">Insert Another Movie</button>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>
                            </div>
                        </div>
                    </section>   
                </div>
            </div>
        </div>
        <!-- /#wrapper -->

        <script src="./public/js/jquery.min.js"></script>
        <script src="./public/js/piexif.min.js" type="text/javascript"></script>
        <script src="./public/js/purify.min.js" type="text/javascript"></script>
        <script src="./public/js/bootstrap.min.js"></script>
        <script src="./public/js/bootstrap-confirmation.js"></script>
        <script src="./public/js/fileinput.min.js"></script>
        <script src="./public/js/metisMenu.min.js"></script>
        <script src="./public/js/raphael.min.js"></script>
        <script src="./public/js/sb-admin-2.js"></script>
        <script src="./public/js/theme.min.js"></script>
        <script src="./public/js/moment-with-locales.js"></script>
	<script src="./public/js/bootstrap-datetimepicker.js"></script>
        <script src="./public/js/upload-movie-validate.js"></script>
        <script src="./public/js/sweetalert.js"></script>
        <script type="text/javascript">
             var isUploadPoster =false;
             var isUploadTrailer =false;
            $(document).ready(function () {
                $('.nav-tabs > li a[title]').tooltip();
                var frm = $('#insertForm')
                //Wizard
                $('a[data-toggle="tab"]').on('show.bs.tab', function (e) {

                    var $target = $(e.target);

                    if ($target.parent().hasClass('disabled')) {
                        return false;
                    }
                });
                function nextStep(){
                    var $active = $('.wizard .nav-tabs li.active');
                    $active.addClass('disabled');
                    $active.next().removeClass('disabled');
                    nextTab($active);
                }
                $(".reset-step").click(function (e) {
                        isUploadPoster =false;
                        isUploadTrailer = false;
                        var $active = $('.wizard .nav-tabs li.active');
                        $active.addClass('disabled');
                        var $reset = $('.wizard .nav-tabs li:first');
                        $reset.removeClass('disabled');
                        $($reset).find('a[data-toggle="tab"]').click();
                });
                $('#releaseDayPicker').datetimepicker({
                    format: 'L'
                });
                $('input[type=radio][name=MovieType]').change(function() {
                    if (this.value == '0') {
                        $("label[for='durationType']").html("Minutes")
                    }
                    else{
                        $("label[for='durationType']").html("Episode")
                    }
                });
                frm.submit(function (e) {
                    e.preventDefault();
                    $.ajax({
                        type: 'POST',
                        url: "adminUploadInfoMovie",
                        data: frm.serialize(),
                        success: function (data) {
                            if(data == 'true'){
                                swal("Failed!", "Create new movie failed. Something wrong!", "error");
                            }else{
                                try {  
                                    var insertedMovie = parseInt(data);
                                    $('#insertedID').val(insertedMovie);
                                    $('input[name=reset]').click();
                                    swal("Success!", "You have been create new movie success. Now you can upload resource for this movie", "success");
                                    nextStep();
                                }  
                                catch(exception){  
                                     swal("Failed!", "Create new movie failed. Something wrong!", "error"); 
                                }  
                           }
                        },
                        error: function () {
                             swal("Failed!", "Create new movie failed. Something wrong!", "error");
                        }
                     });
                });
                $(".first-step").click(function (e) {
                    validateUpload()
                    if(!$('div[class*="has-error"]').html()){
                        if($('#trailer').val()!=""){
                            isUploadTrailer =true;
                        }
                       frm.trigger('submit')
                    }
                });
                $('.second-step').confirmation({
                    onConfirm: function() {
                        nextStep();
                    }
                })
                $(".second-step").click(function(){
                    if(isUploadPoster && isUploadTrailer){
                        $('.second-step').confirmation('hide');
                        nextStep();              
                    }else{
                        $('.second-step').confirmation('show');
                    }
                    
                })
                $('div[name="btnAddSub"]').click(function(){
                    if(!$('#curEpisodeBody tr').html()){
                        swal("Warning","You need to add episode first.","warning");
                    }else{
                        $.ajax({
                            type: 'POST',
                            url: "adminUploadSubtitle",
                            data:{type:"getListEpisode",movieID:$("#insertedID").val()},
                            success: function (data) {
                                if(data.result == 'success'){
                                    $('#sub-list-episode-name').empty();
                                    $('#sub-episode-id').text($("#insertedID").val());
                                    var listSub = $.parseJSON(data.list);
                                    $.each(listSub, function(i, v) {
                                        $('#sub-list-episode-name').append($('<option>', {
                                            value: v[0].toFixed(1),
                                            text: v[0].toFixed(1)
                                        }));
                                    })
                                    $('#submodal').modal('show');
                                }else{
                                    swal("Failed!", "Cannot get list episode. Something wrong!", "error");
                                }
                            },
                            error: function () {
                                 swal("Failed!", "Cannot get list episode. Something wrong!", "error");
                            }
                        })
                    }   
                })
            });
            function nextTab(elem) {
                $(elem).next().find('a[data-toggle="tab"]').click();
            }
            
            $('#file-poster').fileinput({
                uploadUrl: "${pageContext.request.contextPath}/adminUploadResourceMovie",
                autoReplace :true,
                maxFileSize : 500,
                overwriteInitial : true,
                uploadAsync: false,
                maxImageHeight: 600,
                maxImageWidth: 450,
                maxFileCount:1,
                resizeImage: true,
                uploadExtraData: function() {
                    var info = {"movieDF":$("#insertedID").val()};
                    return info;
                }
            })
            $('#file-poster').on('filebatchuploadsuccess', function(event, data, previewId, index) {
                isUploadPoster = true;
            });
            $('#file-trailer').fileinput({
                uploadUrl: "${pageContext.request.contextPath}/adminUploadResourceMovie",
                autoReplace :true,
                overwriteInitial : true,
                uploadAsync: false,
                maxFileCount:1,
                uploadExtraData: function() {
                    var info = {"movieDF":$("#insertedID").val()};
                    return info;
                }
            })
            $('#file-trailer').on('filebatchuploadsuccess', function(event, data, previewId, index) {
                isUploadTrailer = true;
            });
            $("#file-episode").fileinput({
                'theme': 'explorer-fa',
                'uploadUrl': '${pageContext.request.contextPath}/adminUploadResourceMovie',
                overwriteInitial: false,
                autoReplace :true,
                initialPreviewAsData: true,
                uploadAsync: false,
                maxFileCount:1,
                fileActionSettings: {
                    showUpload: false,
                },
                uploadExtraData: function() {
                    var info = {"movieDF":$("#insertedID").val(),"episodeName":$('#episode-name').val(),"lang":$('#episode-lang').val()};
                    return info;
                }        
            });
            
            $('#file-episode').on('filebatchpreupload', function(event, data) {
                // do your validation and return an error like below
                if($('#episode-name-div').hasClass('has-error')){
                    return {
                       message: 'Cannot upload episode. Some field is invalid',
                       data: {key1: 'Key 1', detail1: 'Detail 1'}
                   };
                }
            });
            
            $('#file-episode').on('filebatchuploadsuccess', function(event, data, previewId, index) {
                var data = data.response;
                if(data.SUCCESS == "OK"){
                    $('#curEpisodeBody').append('<tr id="'+data.episodeId+'"><td>'+data.episodeId+'</td><td>'+data.episodeName+'</td><td>'+data.lang+'</td><td>'+data.filename+'</td></tr>');
                }
                swal("Success!", "Your episode have been uploaded success, but you need to wait until process render resolution complete. Please do not edit anything of this episode to avoid errors.", "success");
                $('#episode-name').val(1);
                $('#episode-lang').val("English");
                $('#file-episode').fileinput('clear');
            });
            $("#file-sub").fileinput({
                'theme': 'explorer-fa',
                'uploadUrl': '${pageContext.request.contextPath}/adminUploadSubtitle',
                overwriteInitial: false,
                autoReplace :true,
                initialPreviewAsData: true,
                uploadAsync: false,
                fileActionSettings: {
                    showUpload: false,
                },
                uploadExtraData: function() {
                    var info = {"movieDF":$("#insertedID").val(),"episodeName":$('#sub-list-episode-name').val()};
                    return info;
                }        
            });
            $('#file-sub').on('filebatchuploadsuccess', function(event, data, previewId, index) {
                swal("Success!", "Upload subtitle success.", "success");
                $("#sub-list-episode-name").val($("#sub-list-episode-name option:first").val());
                $('#file-sub').fileinput('clear');
            })
        </script>
    </body>
</html>
