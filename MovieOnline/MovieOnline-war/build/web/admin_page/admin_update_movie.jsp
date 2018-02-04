<%@page import="main.Check"%>
<%@page import="java.util.List"%>
<%@page import="entity.Genre"%>
<%@page import="entity.Movies"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>S&E Online | Update Movie</title>

        <link href="./public/css/bootstrap.min.css" rel="stylesheet">
        <link href="./public/css/fileinput.min.css" media="all" rel="stylesheet" type="text/css" />
        <link href="./public/css/theme.min.css" media="all" rel="stylesheet" type="text/css">
        <link href="./public/css/metisMenu.min.css" rel="stylesheet">
        <link href="./public/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">
        <link href="./public/datatables-responsive/dataTables.responsive.css" rel="stylesheet">
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
            .nav-tabs { border-bottom: 2px solid #DDD; }
            .nav-tabs > li.active > a, .nav-tabs > li.active > a:focus, .nav-tabs > li.active > a:hover { border-width: 0; }
            .nav-tabs > li > a { border: none; color: #666; }
            .nav-tabs > li.active > a, .nav-tabs > li > a:hover { border: none; color: #4285F4 !important; background: transparent; }
            .nav-tabs > li > a::after { content: ""; background: #4285F4; height: 2px; position: absolute; width: 100%; left: 0px; bottom: -1px; transition: all 250ms ease 0s; transform: scale(0); }
            .nav-tabs > li.active > a::after, .nav-tabs > li:hover > a::after { transform: scale(1); }
            .tab-nav > li > a::after { background: #21527d none repeat scroll 0% 0%; color: #fff; }
            .tab-pane { padding: 15px 0; }
            .tab-content{padding:20px}

            .card {background: #FFF none repeat scroll 0% 0%; box-shadow: 0px 1px 3px rgba(0, 0, 0, 0.3); margin-bottom: 30px; }
        </style>
    </head>    
    <body>

        <div id="wrapper">

            <!-- Navigation -->
            <%@include file="admin_header.jsp" %>
            <div id="page-wrapper">
                <div class="row page-header">
                    <div>
                        <strong class="title-header"><i class="fa fa-home fa-title"></i> <a class="text-black" href="${pageContext.request.contextPath}/admin">Dashboard</a></strong><span style="color: gray"> / Movie Detail (ID: <span class="text-primary">${movieDetail.movieId}</span>)</span>
                    </div>
                </div>
                <div class="row page-content">
                    <div class="card">
                        <ul class="nav nav-tabs" role="tablist">
                            <li role="presentation" class="active col-md-6" style="text-align: center;border-right: 1px solid #cccccc;"><a href="#info" aria-controls="info" role="tab" data-toggle="tab">Information</a></li>
                            <li role="presentation" class="col-md-6" style="text-align: center"><a href="#resource" aria-controls="resource" role="tab" data-toggle="tab">Resource</a></li>
                        </ul>
                            <% Movies movieDetail = (Movies) request.getAttribute("movieDetail");
                                List<Genre> genreList = (List<Genre>)request.getAttribute("genreCb");%>
                            <!-- Tab panes -->
                            <div class="tab-content">
                                <div role="tabpanel" class="tab-pane active" id="info">
                                    <div class="row" style="margin-left: 30px">
                                        <form id="insertForm" method="post" role="form">
                                            <input type="hidden" id="movieId" name="movieId" value="${movieDetail.movieId}"/>
                                            <div class="col-md-5" style="margin-right: 5%">
                                                <div id="title-div" class="form-group">
                                                    <label for="title">Title: (*)</label>
                                                    <input type="text" class="form-control" name="title" id="title" onkeyup="validateKeyUp(this)" value="${movieDetail.title}" placeholder="Input...">
                                                    <span id="error-msg-title" class="text-danger" style="margin: 5px;display: none">Field is required. Must be word character, number(6 - 100), ':', '(', ')'</span>
                                                </div>
                                                <div id="real-title-div" class="form-group">
                                                    <label for="realTitle">Real Title: (*)</label>
                                                    <input type="text" class="form-control" name="realTitle" id="realTitle" onkeyup="validateKeyUp(this)" value="${movieDetail.realTitle}" placeholder="Input...">
                                                    <span id="error-msg-realtitle" class="text-danger" style="margin: 5px;display: none">Field is required. Must be word character, number(6 - 100), ':', '(', ')'</span>
                                                </div>
                                                <div id="tag-div" class="form-group" >
                                                    <label for="tag">Keyword:</label>
                                                    <input type="text" class="form-control" name="tag" id="tag" onkeyup="validateKeyUp(this)" value="${movieDetail.titleTag}" placeholder="Input...">
                                                    <span id="error-msg-tag" class="text-danger" style="margin: 5px;display: none">Field must be word character, number(4 - 200), ','</span>
                                                </div>

                                                <div id="dir-div" class="form-group">
                                                    <label for="director">Director: (*)</label>
                                                    <input type="text" class="form-control" name="director" id="director" onkeyup="validateKeyUp(this)" value="${movieDetail.director}"  placeholder="Input...">
                                                    <span id="error-msg-dir" class="text-danger" style="margin: 5px;display: none">Field must be word character, number(4 - 50), ',','.'</span>
                                                </div>
                                                <div id="actor-div" class="form-group">
                                                    <label for="actor">Actor: (*)</label>
                                                    <textarea class="form-control" rows="5" id="actor" name="actor" onkeyup="validateKeyUp(this)">${movieDetail.actors}</textarea>
                                                    <span id="error-msg-actor" class="text-danger" style="margin: 5px;display: none">Field must be word character, number(4 - 200), ',','.'</span>
                                                </div>
                                                <div class="form-group">
                                                    <label>Genre: (*) </label> <span id="error-msg-genre" class="text-danger" style="margin: 0 5px;display: none"> Please choose at least one genre</span>
                                                    <div>
                                                        <%
                                                            for(Genre genL : genreList){
                                                                boolean flag = false;
                                                                for(Genre genM : movieDetail.getGenreCollection()){
                                                                    if(genL.getGenreId() == genM.getGenreId()){
                                                                        flag =true;
                                                                    }
                                                                }
                                                                if(flag){%>
                                                                    <div class="col-md-3">
                                                                        <label class="checkbox-inline"><input name="genreCb" type="checkbox" value="<%=genL.getGenreId()%>" checked><%=genL.getGenreName()%></label>
                                                                    </div><%;
                                                                }else{%>
                                                                    <div class="col-md-3">
                                                                        <label class="checkbox-inline"><input name="genreCb" type="checkbox" value="<%=genL.getGenreId()%>"><%=genL.getGenreName()%></label>
                                                                    </div>
                                                                <%}
                                                            }
                                                        %>
                                                        
                                                    </div>
                                                </div>
                                            </div> 


                                            <div class="col-md-5">
                                                <div class="form-group">
                                                    <label for="actor">Description: </label>
                                                    <textarea class="form-control" rows="5" id="description" name="description">${movieDetail.description}</textarea>
                                                </div>
                                                <div id="releaseday-div" class="form-group">
                                                    <label for="releaseDay">Release Day: (*)</label>
                                                    <div class='input-group date col-md-6' id='releaseDayPicker'><% String releaseDay = Check.convertDay2(movieDetail.getReleaseDay());%>
                                                        <input type='text' class="form-control" name="releaseDay" id="releaseDay" value="<%= releaseDay%>"/>
                                                        <span class="input-group-addon">
                                                            <span class="glyphicon glyphicon-calendar"></span>
                                                        </span>
                                                    </div>
                                                    <span id="error-msg-releaseday" class="text-danger" style="margin: 5px;display: none">Please choose release day</span>
                                                </div>
                                                <div id="imbd-div" class="form-group col-md-6 col-lg-6 col-xs-6 col-sm-6">
                                                    <label for="imbd">IMBD: <span style="color: gray;font-weight: normal">Default 0</span></label>
                                                    <input type="number" class="form-control" name="imbd" id="imbd" onkeyup="validateKeyUp(this)" placeholder="Input..." value="${movieDetail.imdb}">
                                                    <span id="error-msg-imdb" class="text-danger" style="margin: 5px;display: none">IMDB is incorrect. Must be positive number 0 -> 10</span>
                                                </div>
                                                <div class="form-group col-md-6">
                                                    <input type="hidden" id="curCountry" value="${movieDetail.countryId.countryId}"/>
                                                    <label for="country">Country:</label>
                                                    <select class="form-control" id="country" name="country">
                                                        <c:forEach items="${countrySl}" var="items">
                                                            <option value="${items.countryId}">${items.countryName}</option>
                                                        </c:forEach>
                                                    </select>
                                                    <script>
                                                        document.getElementById("country").selectedIndex = document.getElementById("curCountry").value -1
                                                    </script>
                                                </div>

                                                <div class="form-group col-md-6">
                                                    <label for="type">Type:</label>
                                                    <div>
                                                        <c:choose>
                                                            <c:when test="${movieDetail.type == true}">
                                                                <label class="radio-inline"><input type="radio" name="MovieType" value="0">Movie</label>
                                                                <label class="radio-inline"><input type="radio" name="MovieType" value="1" checked>TV Series</label>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <label class="radio-inline"><input type="radio" name="MovieType" value="0" checked="">Movie</label>
                                                                <label class="radio-inline"><input type="radio" name="MovieType" value="1">TV Series</label>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        
                                                    </div>                                
                                                </div>
                                                <div id="duration-div" class="form-group col-md-6">
                                                    <label for="duration">Duration: (*)</label> <span style="color: gray;display: inline"> 0 if don't know</span>
                                                    <div>
                                                        <c:set var="durationParts" value="${fn:split(movieDetail.duration, ' ')}"/>
                                                        <input type="number" class="form-control" style="width: 50%;float: left" name="duration" id="duration" onkeyup="validateKeyUp(this)" value="${durationParts[0]}">
                                                        <label for="durationType" style="margin: 7px 12px;font-weight: normal">${durationParts[1]}</label>
                                                    </div>
                                                    <span id="error-msg-duration" class="text-danger" style="margin: 5px;display: none">Please enter duration. Must be positive number</span>
                                                </div>
                                                <div id="trailer-div" class="form-group">
                                                    <label for="director">Trailer Link: <span style="font-weight: normal;color: gray">You can put trailer link or upload video file later</span></label>
                                                    <input type="text" class="form-control" name="trailer" id="trailer" onkeyup="validateKeyUp(this)" placeholder="Input..." value="${urlTrailer}">
                                                    <span id="error-msg-trailer" class="text-danger" style="margin: 5px;display: none">Your link is incorrect. Please re-enter</span>
                                                </div>
                                                <div class="form-group col-md-6" style="margin-top: 20px">
                                                    <label for="ageLimit">Age Limit:</label>
                                                    <div class="material-switch pull-right">
                                                        <c:choose>
                                                            <c:when test="${movieDetail.ageLimit=='true'}">
                                                                <input id="ageLimit" name="ageLimit" type="checkbox" checked/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input id="ageLimit" name="ageLimit" type="checkbox"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <label for="ageLimit" class="label-primary"></label>
                                                    </div>
                                                </div>
                                                <div class="form-group col-md-6" style="margin-top: 20px">
                                                    <label for="status">Status:</label>
                                                    <div class="material-switch pull-right">
                                                        <c:choose>
                                                            <c:when test="${movieDetail.status=='true'}">
                                                                <input id="status" name="status" type="checkbox" checked/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input id="status" name="status" type="checkbox"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <label for="status" class="label-primary"></label>
                                                    </div>
                                                </div>
                                                <div class="form-group"><span style="margin-left: 10px;color: red">Note:</span> If status is disable. Your movie will not show in homepage</div>

                                            </div>
                                            <div class="form-group col-md-12" style="margin-top: 10px">
                                                <input type="hidden" name="actionMovie" value="update"/>
                                                <button name="action" value="update" type="button" class="btn btn-primary first-step">Update</button>
                                            </div> 
                                        </form>
                                    </div>
                                    
                                </div>
                                <div role="tabpanel" class="tab-pane" id="resource">
                                    <div class="row" style="margin-left: 30px">
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
                                                        <span type="button" class="pull-left">Update Trailer</span>
                                                        <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                                        <div class="clearfix"></div>
                                                    </div>
                                                </a>
                                            </div>
                                        </div>

                                        <!-- Modal -->
                                        <div id="trailermodal" class="modal fade" role="dialog">
                                            <div id="modal-upload-trailer" class="modal-dialog">

                                                <!-- Modal content-->
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                        <h4 class="modal-title">Update Movie Trailer</h4>
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
                                                        <span type="button" class="pull-left">Update Poster</span>
                                                        <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                                        <div class="clearfix"></div>
                                                    </div>
                                                </a>
                                            </div>
                                        </div>

                                        <!-- Modal -->
                                        <div id="postermodal" class="modal fade" role="dialog">
                                            <div id="modal-upload-poster" class="modal-dialog">

                                                <!-- Modal content-->
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                        <h4 class="modal-title">Update Movie Poster</h4>
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
                                                        <span type="button" class="pull-left">Update Subtitle</span>
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
                                                        <h4 class="modal-title">Update Movie Subtitle</h4>
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
                                                        <hr/>
                                                        <div>
                                                            <table class="table table-striped table-bordered table-hover" id="dataTables-Sub">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Name</th>
                                                                        <th>Code</th>
                                                                        <th>Language</th>
                                                                        <th>Action</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>

                                                                </tbody>
                                                            </table>
                                                        </div>
                                                        <hr/>
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
                                    <div class="row" style="margin-left: 30px">
                                        <hr>
                                        <div class="col-md-8">
                                            <div class="panel panel-success">
                                                <div class="panel-heading">Current Episode</div>
                                                <div class="panel-body">
                                                    <input type="hidden" name="csrfSalt" value="<c:out value='${csrfSalt}'/>"/>
                                                    <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-Movies">
                                                        <thead>
                                                            <tr>
                                                                <th>ID</th>
                                                                <th>Episode Name</th>
                                                                <th>Language</th>
                                                                <th>Status</th>
                                                                <th></th>
                                                                <th></th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach items="${curEpisode}" var="items">
                                                                <tr>
                                                                    <td>${items.episodeId}</td>
                                                                    <td>${items.episodeName}</td>
                                                                    <td>${items.language}</td>
                                                                    <td><c:choose><c:when test="${items.broken == false && (items.res360 == '' || items.res480=='' || items.res720=='' || items.res1080 =='')}">
                                                                                <div id="statusUploadMovie-${items.episodeId}">In Progress</div>
                                                                            </c:when>

                                                                            <c:when test="${items.broken == false && items.res360 != '' && items.res480!='' && items.res720!='' && items.res1080 !=''}">
                                                                                <div id="statusUploadMovie-${items.episodeId}">Completed</div>
                                                                            </c:when>    
                                                                            <c:otherwise><div id="statusUploadMovie-${items.episodeId}">Not Completed</div></c:otherwise>
                                                                        </c:choose></td>
                                                                    <td><button id="${items.episodeId}" name="btnreupload" class="btn btn-primary">Re-Upload</button></td>
                                                                    <td><button id="${items.episodeId}" name="btnDeleteEpisode" class="btn btn-danger btn-delete-episode" data-toggle="deleteEpisodeConfirm">Delete</button></td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                    <!-- Modal -->
                                                    <div id="reuploadmodal" class="modal fade" role="dialog">
                                                        <div id="modal-reupload" class="modal-dialog">

                                                            <!-- Modal content-->
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                                    <h4 class="modal-title">Re-Upload Episode</h4>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <input type="hidden" id="reID" value="0"/>
                                                                    <div class="row">
                                                                        <div class="col-lg-3">
                                                                            <div id="re-episode-name-div" class="form-group" >
                                                                                <label for="tag" class="control-label">Episode Name:</label>
                                                                                <span id="re-episode-name" class="text-primary"></span>
                                                                            </div>
                                                                        </div>
                                                                        <div class="col-lg-3">
                                                                            <div class="form-group">
                                                                                <label for="sel1" class="control-label">Language:</label>
                                                                                <span id="re-episode-lang" class="text-primary"></span>
                                                                            </div>
                                                                        </div>
                                                                        <div class="col-md-6" >
                                                                            <span style="color: red">Note:</span> Video format: <a>MP4</a>,<a>FLV</a>,<a>AVI</a>
                                                                        </div>
                                                                    </div>
                                                                    <div class="file-loading">
                                                                        <input id="file-reupload" name="reupload-file" class="file" type="file" data-msg-placeholder="Select {files} for upload..." data-allowed-file-extensions='["mp4", "flv","avi"]'>
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
                                        </div>            
                                        <div class="col-md-8">
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
                                    </div>
                                </div>
                            </div>
                        </div>
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
        <script src="./public/datatables/js/jquery.dataTables.min.js"></script>
        <script src="./public/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="./public/datatables-responsive/dataTables.responsive.js"></script>
        <script src="./public/js/sweetalert.js"></script>
        <script type="text/javascript">
            
             var isUploadPoster =false
             var isUploadTrailer =false;
             var table =$('#dataTables-Movies').DataTable({
                responsive: true,
                "order": [[ 0, "desc" ]]
            });
            var tableSub =$('#dataTables-Sub').DataTable();
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
                                swal("Failed!", "Update movie failed. Something wrong!", "error");
                            }else{
                                swal("Success!", "Update movie success", "success");
                           }
                        },
                        error: function () {
                            swal("Failed!", "Update movie failed. Something wrong!", "error"); 
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
                $('div[name="btnAddSub"]').click(function(){
                    if(!table.data().count()){
                        swal("Warning","You need to add episode first.","warning");
                    }else{
                        addSub(); 
                    }   
                })
            });
            var listSub=[];
            function addSub() {
                $.ajax({
                    type: 'POST',
                    url: "adminUploadSubtitle",
                    data: {
                        type: "getListEpisode",
                        movieID: $("#movieId").val()
                    },
                    success: function(data) {
                        if (data.result == 'success') {
                            $('#sub-list-episode-name').empty();
                            $('#sub-episode-id').text($("#movieId").val());
                            listSub = $.parseJSON(data.list);
                            $.each(listSub, function(i, v) {
                                $('#sub-list-episode-name').append($('<option>', {
                                    value: v[0].toFixed(1),
                                    text: v[0].toFixed(1)
                                }));
                            })
                            changeListSub(listSub, listSub[0][0]);
                            
                            $('#submodal').modal('show');
                        } else {
                            swal("Failed!", "Cannot get list episode. Something wrong!", "error");
                        }
                    },
                    error: function() {
                        swal("Failed!", "Cannot get list episode. Something wrong!", "error");
                    }
                })
            }
            $('#sub-list-episode-name').on('change', function() {
                var current = $('#sub-list-episode-name').val();
                
                changeListSub(listSub, current);
            })
            function changeListSub(listEpi,value){
                $.each(listEpi,function(i,v){
                    if(v[0].toFixed(1) == value){
                        tableSub.clear().draw();
                        if(v[1]){
                            var listChild = $.parseJSON(v[1]);
                            $.each(listChild,function (i,v){
                                tableSub.row.add([v.name,v.code,v.lang,'<button name="deleteSubConfirm" class="btn btn-danger" data-toggle="deleteSubConfirm">Delete</button>']).draw()
                            })
                            $('button[name=deleteSubConfirm]').confirmation({
                                onConfirm: function() {
                                    var currentRow = $(this).parent();
                                    $.ajax({
                                        type: 'POST',
                                        url: "adminUploadSubtitle",
                                        data: {
                                            type: "deleteSub",
                                            movieID: $("#movieId").val(),
                                            episodeName:$('#sub-list-episode-name').val(),
                                            fileName:$(this).parent().siblings(":nth-child(1)").text()
                                        },
                                        success: function(data) {
                                            if (data.result == 'success') {
                                                tableSub.row(currentRow).remove().draw();
                                                swal("Success!", "Delete Subtitle success", "success");
                                            } else {
                                                swal("Failed!", data.result, "error");
                                            }
                                        },
                                        error: function() {
                                            swal("Failed!", "Cannot delete subtitle. Something wrong!", "error");
                                        }
                                    })
                                }
                            })
                        }
                        return false;
                    }
                })
                
            }
            function editEpisode(){
                //auto hide confirm when click outside
                $('body,.btn-delete-episode').on('click', function (e) {
                    $('.btn-delete-episode').each(function(){
                        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.btn-delete-episode').has(e.target).length === 0) {
                            $(this).confirmation('hide');
                        }
                    });
                });
                $('button[name=btnreupload]').on('click',function(){
                    $('#file-reupload').fileinput('clear');
                    var id = this.id;
                    var status = $(this).parent().siblings(":nth-child(4)").text();
                    if(status.trim() == 'In Progress'){
                        swal("Warning!", "You can't re-upload the episode in progress. Please wait untill this is completed.", "warning");
                    }else{
                        $('#reID').val(id);
                        $('#re-episode-lang').html($(this).parent().siblings(":nth-child(3)").text());
                        $('#re-episode-name').html($(this).parent().siblings(":nth-child(2)").text());
                        $('#reuploadmodal').modal('show')
                    } 
                })
                $("button[name=btnDeleteEpisode]").confirmation({
                    onConfirm: function() {
                        var currentRow = $(this).parent().parent();
                        var id =$(this).parent().siblings(":nth-child(1)").text();
                        var name = $(this).parent().siblings(":nth-child(2)").text();
                        var status = $(this).parent().siblings(":nth-child(4)").text();
                        if(status.trim() == 'In Progress'){
                            swal("Warning!", "You can't delete the episode in progress. Please wait untill this is completed.", "warning");
                        }else{
                            $.ajax({
                                type: "POST",
                                url: "deleteEpisode",
                                data: {episodeId:id,csrfSalt:$('input[name=csrfSalt]').val(),movieFolder:$("#movieId").val(),episodeName:name},
                                success: function(resultData){
                                    if(resultData =='true'){
                                        table.row(currentRow).remove().draw();
                                        swal("Success!", "Episode ID: <span style='color: red'>"+id+"</span> has been deleted", "success");
                                    }else{
                                        swal("Failed!", "Delete episode failed. Something wrong!", "error"); 
                                    }
                                },
                                error:function () {
                                    swal("Failed!", "Delete episode failed. Something wrong!", "error"); 
                                }
                            });
                        }
//                        
                    }
                })
            }
            editEpisode();
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
                    var info = {"movieDF":$("#movieId").val()};
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
                    var info = {"movieDF":$("#movieId").val()};
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
                    var info = {"movieDF":$("#movieId").val(),"episodeName":$('#episode-name').val(),"lang":$('#episode-lang').val()};
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
                if(data.SUCCESS != ""){
                    table.row.add([data.episodeId,(data.episodeName).toFixed(1),data.lang,"<div id='statusUploadMovie-"+data.episodeId+"'>In Progress</div>",'<button id="'+data.episodeId+'" name="btnreupload" class="btn btn-primary">Re-Upload</button>','<button id="'+data.episodeId+'" name="btnDeleteEpisode" class="btn btn-danger btn-delete-episode" data-toggle="deleteEpisodeConfirm">Delete</button>']).draw()
                    editEpisode();
                }
                swal("Success!", "Your episode have been uploaded success, but you need to wait until process render resolution complete. Please do not edit anything of this episode to avoid errors.", "success");
                $('#episode-name').val(1);
                $('#episode-lang').val("English");
                $('#file-episode').fileinput('clear');
            });
                    
            $("#file-reupload").fileinput({
                'theme': 'explorer-fa',
                'uploadUrl': '${pageContext.request.contextPath}/reuploadMovie',
                overwriteInitial: false,
                autoReplace :true,
                initialPreviewAsData: true,
                uploadAsync: false,
                maxFileCount:1,
                fileActionSettings: {
                    showUpload: false,
                },
                uploadExtraData: function() {
                    var info = {"movieDF":$("#movieId").val(),episodeId:$('#reID').val()};
                    return info;
                }        
            });
            $('#file-reupload').on('filebatchuploadsuccess', function(event, data, previewId, index) {
                var data = data.response;
                if(data.SUCCESS != ""){
                    swal("Success!", "Re-upload episode success.", "success");
                    var name = "statusUploadMovie-" +data.EpisodeID;
                    document.getElementById(name).innerHTML = "In Progress";
                    $('#file-reupload').fileinput('clear')
                }
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
                    var info = {"movieDF":$("#movieId").val(),"episodeName":$('#sub-list-episode-name').val()};
                    return info;
                }        
            });
            $('#file-sub').on('filebatchuploadsuccess', function(event, data, previewId, index) {
                swal("Success!", "Upload subtitle success.", "success");
                $('#file-sub').fileinput('clear');
                addSub();
            })
        </script>
    </body>
</html>
