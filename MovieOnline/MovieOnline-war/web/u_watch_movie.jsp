<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="entity.Episode"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="model.MovieDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>S&E Online | Watch Movie</title>

    <!-- Bootstrap core CSS  -->
    <link href="public/css/bootstrap.min.css" rel="stylesheet">
    <link href="public/css/movie.css" rel="stylesheet">
    <link href="public/videojs/video-js.css?ver=1.1" rel="stylesheet">
    <link href="public/videojs/ad-markers.css" rel="stylesheet">
    <link rel="stylesheet" media="screen" href="public/videojs/vsg-skin.css">
    <link href="public/videojs-resolution-switcher/videojs-resolution-switcher.css" rel="stylesheet">
    <link rel="stylesheet" href="public/css/sweetalert.css?ver=1.1">
    <link href="public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="public/css/homepage.css" rel="stylesheet">
    <style type="text/css">
        .popover {background-color: #252525;width: 60%;}
        .popover.bottom .arrow::after {border-bottom-color: tomato; }
        .popover-content {background-image: url("public/images/texture.png");background-repeat: repeat;}
        .popover-title{background-color:goldenrod;}
    </style>
</head>
<body>
    <%@include file="header.jsp" %>
    <div class="container">
        <% MovieDB movie = (MovieDB) request.getAttribute("detailMovie");%>
        <% Episode firstEpisode = (Episode) request.getAttribute("firstEpisode");%>
        <input id="sessionUser" type="hidden" value="${sessionScope.user.accountId}"/>
        <input id="sessionUserRole" type="hidden" value="${sessionScope.user.role.name}"/>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                <ol class="breadcrumb bg-div" itemscope itemtype="http://schema.org/BreadcrumbList">
                    <li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
                        <a itemprop="item" title="JAV Online" href="./" itemprop="url">
                            <span itemprop="name">S&E Online</span>
                            <meta itemprop="position" content="1"/>
                        </a>
                    </li>
                    <li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
                        <c:choose>
                            <c:when test="${detailMovie.type == false}">
                                <a itemprop="item" title="Single" href="Search?searchType=filter&order=1&type=0" itemprop="url">
                                    <span itemprop="name">
                                        Movie
                                    </span>
                                    <meta itemprop="position" content="2"/>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a itemprop="item" title="Television Series" href="Search?searchType=filter&order=1&type=1" itemprop="url">
                                    <span itemprop="name">
                                        Television Series
                                    </span>
                                    <meta itemprop="position" content="2"/>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                    <li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
                        <a itemprop="item" title="USA" href="Search?searchType=filter&order=1&countryName=${detailMovie.countryName}" itemprop="url">
                            <span itemprop="name">${detailMovie.countryName}</span>
                            <meta itemprop="position" content="3"/>
                        </a>
                    </li>
                    <li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
                        <a itemprop="item" title="${detailMovie.realTitle}"
                           href="movies?id=${detailMovie.movieId}" itemprop="url">
                            <span itemprop="name">${detailMovie.realTitle}</span>
                            <meta itemprop="position" content="4"/>
                        </a>
                    </li>
                    <li class="active">Watch Movie</li>
                </ol>
            </div>
        </div>

        <div class="bg-div video-region">
            <div class="row featured-media">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div id="featured-media" class="videoWrapper">
                        <input type="hidden" id="movieId" name="movieId" value="${detailMovie.movieId}"/>
                        <video id="ads-container" class="video-js vjs-16-9" preload="none" controls>
                            <source src="#" type="video/mp4">
                            <p class="vjs-no-js">
                                To view this video please enable JavaScript, and consider upgrading to a web browser that
                                <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a>
                            </p>
                        </video>
                        <video id="featured-video" class="video-js vjs-16-9" preload="auto" controls data-setup='{ "playbackRates": [0.5, 1, 1.5, 2] }' poster="public/images/video-poster.jpg">
                            <c:if test="${firstEpisode.res360 != null && firstEpisode.res360 !=''}">
                                <source src="moviesSource/mv_${detailMovie.movieId}/${firstEpisode.episodeName}/sd/${firstEpisode.res360}" type='video/mp4' label='360p' res='360'/>
                            </c:if>
                            <c:if test="${firstEpisode.res480 != null && firstEpisode.res480 !=''}">
                                <source src="moviesSource/mv_${detailMovie.movieId}/${firstEpisode.episodeName}/sd/${firstEpisode.res480}" type='video/mp4' label='480p' res='480'/>
                            </c:if>
                            <c:if test="${sessionScope.user.role.name =='ROLE_ADMIN' || sessionScope.user.role.name =='ROLE_UPLOADER' || sessionScope.user.role.name =='ROLE_VIP'}">
                                <c:if test="${firstEpisode.res720 != null && firstEpisode.res720 !=''}">
                                    <source src="moviesSource/mv_${detailMovie.movieId}/${firstEpisode.episodeName}/hd/${firstEpisode.res720}" type='application/x-mpegURL' label='720p' res='720'/>
                                </c:if>
                                <c:if test="${firstEpisode.res1080 != null && firstEpisode.res1080 !=''}">
                                    <source src="moviesSource/mv_${detailMovie.movieId}/${firstEpisode.episodeName}/hd/${firstEpisode.res1080}" type='application/x-mpegURL' label='1080p' res='1080'/>
                                </c:if>
                            </c:if>
                            <c:if test="${firstEpisode.subtitle != null && firstEpisode.subtitle !='' && firstEpisode.subtitle != '[]'}">
                                <%
                                    JSONArray arr = new JSONArray(firstEpisode.getSubtitle());
                                    for (int i = 0; i < arr.length(); i++) {
                                        JSONObject obj = arr.getJSONObject(i);%>
                                <track kind='captions' src='moviesSource/mv_${detailMovie.movieId}/${firstEpisode.episodeName}/sub/<%=obj.getString("name")%>' srclang='<%=obj.getString("code")%>' label='<%=obj.getString("lang")%>'/>
                                <%}
                                %>
                            </c:if>
                            <div>Your browser doesn't support html5 video. <a>Upgrade Chrome</a></div>
                            
                        </video>
                    </div>
                </div>
            </div>
            <p></p>
            <div class="row" id="btnTool">
                <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6" style="height: 55px">
                    <c:if test="${sessionScope.user.role.roleId != 1 && sessionScope.user.role.roleId != 2 && sessionScope.user.role.roleId != 3}">
                        <h4 class="msg-vip">Only <span style="color: goldenrod">VIP</span> can see HD resolution. Upgrade your
                            account <a>here</a>. Or <a>Login</a></h4>
                    </c:if>
                </div>
                <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6" style="text-align: right;padding-right: 3%;margin-top: 5px">
                    <button id="isnext" value="1" class="btn btn-tran btn-primary">Auto Change: <strong style='color: red'>ON</strong>
                    </button>
                    <button id="light" class="btn btn-tran btn-primary">Light <strong style="color: red">OFF</strong></button>
                    <button id ="boomarkbtn" class="btn btn-primary btn-tran">Movie Box</button>
                    <a href="${pageContext.request.contextPath}/download?action=2998b3232d29e8dc5a78d97a32ce83f556f3ed31b057077503df05641dd79158&id=${detailMovie.movieId}" class="btn btn-primary btn-tran">Download</a>
                    <button id="btnReport" class="btn btn-danger">Report</button>
                    <!-- Modal -->
                    <div class="modal fade" id="reportModal" role="dialog">
                        <div class="modal-dialog">

                            <!-- Modal content-->
                            <div class="modal-content">
                                <div class="modal-header" style="background: goldenrod">
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    <h4 class="modal-title white" style="text-align: center">Report Movie Error</h4>
                                </div>
                                <div class="modal-body" style="background: #252525">
                                    <form id="reportForm" class="form-horizontal">
                                        <div class="form-group">
                                            <label class="control-label col-sm-2"></label>
                                            <div id="errorReport" class="col-sm-10" style="color: red;text-align: center"></div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label col-sm-2 white" for="email">Type:</label>
                                            <div class="col-sm-10">
                                                <select class="form-control" id="sel1Error" name="sel1Error">
                                                    <option value="1">Cannot watching movie</option>
                                                    <option value="2">Don't have subtitle</option>
                                                    <option value="3">Other</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label col-sm-2 white" for="pwd">Minutes:</label>
                                            <div class="col-sm-10">          
                                                <input type="number" class="form-control" value="0" name="min">
                                            </div>
                                        </div>
                                        <div id="errorOther" class="form-group" style="display: none">        
                                            <label class="control-label col-sm-2 white" for="pwd">Content:</label>
                                            <div class="col-sm-10">
                                                <textarea id="errorOtherBody" class="form-control" rows="5" name="errorContent"></textarea>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label col-sm-2 white">Capcha:</label>
                                            <div class="col-md-3">
                                                <input type="text" class="form-control" placeholder="" id="capchaInput" style="display: inline-block">
                                            </div>
                                            <div class="col-md-1" style="margin-right: 20px">
                                                <img id="capchaImage" style="display:none" src="public/images/capcha.png"  crossorigin="anonymous"/>
                                                <canvas id="canvasCapcha" width="60" height="34"></canvas>
                                            </div>
                                            <div class="col-md-offset-0 col-md-1">
                                                <i id="refreshCapcha" class="fa fa-refresh fa-fw fa-2x white" style="display: inline-block"></i>
                                            </div>
                                        </div>
                                        <div class="form-group">        
                                            <div class="col-sm-4">
                                                <button id="reportSubmit" type="button" class="btn btn-warning">Submit</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <p></p>

        <div class="bg-div">
            <div class="row black">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div class="rating-main">
                       <h3 class="m_rating">Movie Rating <span class="view-count">(<a class="rating_count" tabindex="0" data-toggle="popover" data-popover-content="#rating_detail" data-placement="right" title="Rating Detail">${detailMovie.ratecount} ratings</a>)</span></h3>
                        <!-- Content for Popover #rating_detail -->       
                        <div id="rating_detail" class="hidden">
                            <div class="popover-body">
                                <c:forEach items="${ratingList}" var="entry">
                                    <div class="probprogress-label" style="float: left;margin-right: 1em; width: 30%">${entry.key}</div>
                                    <div class="progress" style="width: 150px">
                                        <div class="progress-bar" role="progressbar" aria-valuenow="${entry.value}"
                                        aria-valuemin="0" aria-valuemax="100" style="width:${entry.value*100/detailMovie.ratecount}%">
                                            <span>${entry.value*100/detailMovie.ratecount} %</span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        <div class="rating" id="rating">
                            <% for (int i = 10; i > 0; i--) {
                                    if (movie.getRate() >= i) {%>
                            <span id="rate<%=11 - i%>" name="rate" style="color: gold" title="<%=i%>/10">★</span>
                            <%} else {%>
                            <span id="rate<%=11 - i%>" name="rate" title="<%=i%>/10">☆</span>
                            <%}
                                }%>
                        </div>
                        <div class="rating-title">1/10</div>
                    </div>
                </div>
            </div>
            <p></p>
            <c:if test="${fn:length(episode) >0}">
                <div class="row black">
                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                        <div class="rating-main">
                            <c:forEach items="${episode}" var="entry">
                                <h5 style="color: goldenrod" id="language">${entry.key}</h5>
                                <div id="episode" name="episode" class="episode">
                                    <c:forEach items="${entry.value}" var="items" varStatus="loop">
                                        <div style="margin-bottom: 10px">
                                            <c:forEach items="${items}" var="child" varStatus="loopChild">
                                                <c:choose>
                                                    <c:when test="${entry.key == firstEpisode.language && loop.index==0 && loopChild.index==0}">
                                                        <a name="${child.episodeId}" type="button" class="btn btn-danger">
                                                            <fmt:formatNumber type = "number" minIntegerDigits="2" value = "${child.episodeName}"/>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a name="${child.episodeId}" type="button" class="btn btn-default">
                                                            <fmt:formatNumber type = "number" minIntegerDigits="2" value = "${child.episodeName}"/>
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>    
                                    </c:forEach>
                                </div>
                            </c:forEach>
                            <div id="changeEpisode-modal" class="modal fade">
                                <div class="modal-dialog">
                                    <div class="modal-content changeEpisode-modal-conent">
                                        <div class="modal-body">
                                            <p>Episode will change to <span id="modal-time-left-episode"
                                                                            style="color: red"></span> in <span
                                                                            id="modal-time-left"></span> seconds</p>
                                        </div>
                                        <div class="modal-footer">
                                            <button id="modal-changeEpisode" type="button" class="btn btn-success"
                                                    data-dismiss="modal">Change Episode
                                            </button>
                                            <button id="modal-cancelEpisode" type="button" class="btn btn-danger"
                                                    data-dismiss="modal">Cancel
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <div class="row key">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 ">
                    <h3 class="m_rating" style="padding: 0 10px">Keyword:</h3>
                    <span>
                        <c:forEach items="${fn:split(detailMovie.titleTag, ',')}" var="tag">
                            <a href="Search?searchType=filter&order=1&title=${tag}">${tag}</a> , 
                        </c:forEach>
                    </span>
                </div>
            </div>
        </div>
        <p></p>
        <div class="bg-div">
            <h3 class="m_rating" style="padding: 0 20px">Comment</h3>
            <hr>
            <div class="row black">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 ">
                    <div class="media" style="padding-top: 10px">
                        <input id="userID" type="hidden" value="userID"/>
                        <div class="media-left">
                            <c:choose>
                                <c:when test="${sessionScope.user.image ==null || sessionScope.user.image ==''}">
                                    <img src="public/images/avatar/empty_avatar.png" class="media-object" style="width:45px">
                                </c:when>
                                <c:otherwise>
                                    <img src="public/images/avatar/${sessionScope.user.image}" class="media-object" style="width:45px">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="media-body">
                            <div class="form-group" style="padding: 0 20px">
                                <textarea id="post-comment-text" name="post-comment-text" class="form-control comment-area" rows="4"
                                          placeholder="Add a comment..."></textarea>
                                <div class="cm-btn" style="display: none">
                                    <button id="post-comment" class="btn btn-xs" style="float: right" disabled>Post</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row black">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12"> 
                    <div class="comment-list" id="comment-div">
                        <c:forEach items="${commentList}" var="items">
                            <div class="media" style="padding: 10px 0">
                                <div class="media-left">
                                    <c:choose>
                                        <c:when test="${items.accountId.image ==null || items.accountId.image ==''}">
                                            <img src="public/images/avatar/empty_avatar.png" class="media-object" style="width:45px;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="public/images/avatar/${items.accountId.image}" class="media-object" style="width:45px">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="media-body">               
                                    <input type="hidden" id="commentUserId" name="commentUserId" value="${items.accountId.accountId}"/>
                                    <h4 id="commentUsername" class="media-heading">${items.accountId.userName}
                                        <small><i>Posted on ${items.time}</i></small>
                                    </h4>
                                    <p id="show-comment">${items.content}</p>                                    
                                    <c:if test="${sessionScope.user.userName!=items.accountId.userName && sessionScope.user.role.roleId != 1}"><a id="${items.commentId}" name="btnReportComment" class="btn btn-report" style="margin-right: 10px">                                        
                                        Report
                                    </a></c:if>
                                    <div class="modal fade" id="reportModalComment" role="dialog">
                                        <div class="modal-dialog">
                                            <!-- Modal content-->
                                            <div class="modal-content">
                                                <div class="modal-header" style="background: goldenrod">
                                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                    <h4 class="modal-title white" style="text-align: center">Report Comment</h4>
                                                </div>
                                                <div class="modal-body" style="background: #252525">
                                                    <form id="reportFormComment" class="form-horizontal">
                                                        <div class="form-group">
                                                            <label class="control-label col-sm-2"></label>
                                                            <div id="errorReportComment" class="col-sm-10" style="color: red;text-align: center"></div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label class="control-label col-sm-2 white" for="email">Type:</label>
                                                            <div class="col-sm-10">
                                                                <select class="form-control" id="sel1ErrorComment" name="sel1ErrorComment">
                                                                    <option value="1">It's harassing me or someone I know</option>
                                                                    <option value="2">It's threatening, violent or suicidal</option>
                                                                    <option value="3">It's hate speech</option>
                                                                    <option value="4">It's offense against the policy of our country</option>
                                                                    <option value="5">Other</option>
                                                                </select>
                                                            </div>
                                                        </div>                                                        
                                                        <div id="errorOtherComment" class="form-group" style="display: none">        
                                                            <label class="control-label col-sm-2 white" for="pwd">Content:</label>
                                                            <div class="col-sm-10">
                                                                <textarea id="errorOtherBodyComment" class="form-control" rows="5" name="errorContentComment"></textarea>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label class="control-label col-sm-2 white">Captcha:</label>
                                                            <div class="col-md-3">
                                                                <input type="text" class="form-control" placeholder="" id="capchaInputComment" style="display: inline-block">
                                                            </div>
                                                            <div class="col-md-1" style="margin-right: 20px">
                                                                <img id="capchaImageComment" style="display:none" src="public/images/capcha.png" crossorigin="anonymous"/>
                                                                <canvas id="canvasCapchaComment" width="60" height="34"></canvas>
                                                            </div>
                                                            <div class="col-md-offset-0 col-md-1">
                                                                <i id="refreshCapchaComment" class="fa fa-refresh fa-fw fa-2x white" style="display: inline-block"></i>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">        
                                                            <div class="col-sm-4">
                                                                <button id="reportSubmitComment" type="button" class="btn btn-warning">Submit</button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <c:if test="${sessionScope.user.userName==items.accountId.userName || sessionScope.user.role.roleId == 1}"><a id="${items.commentId}" name="btnDeleteComment" class="btn btn-delete" rel="2">Delete</a></c:if>
                                </div> 
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-12 tab-list-row" style="margin-top: 20px">
            <h3 class="m_title">Related Movies</h3>
            <hr>
            <% List<MovieDB> list = (List<MovieDB>) request.getAttribute("recomenderList");%>
            <div class="row" style="min-height: 300px">
                <% int indexSingle = 0;%>
                <c:forEach items="${recomenderList}" var="detailMovie">
                    <div class="col-md-2 grid-item space-float-div" style="margin-bottom: 20px">
                        <article class="entry-item" onclick="">
                            <div class="entry-thumb">
                                <img width="100%" height="auto" src="moviesSource/mv_${detailMovie.movieId}/poster.medium.jpg"
                                     class="attachment-360x618 size-360x618" alt="" sizes="(max-width: 360px) 100vw, 360px">
                                <div class="right-info">
                                    <span class="pg">
                                        <c:choose>
                                            <c:when test="${detailMovie.numberEpisode <= 0}">
                                                Trailer
                                            </c:when>
                                            <c:when test="${detailMovie.type == false}">
                                                ${detailMovie.quantity}
                                            </c:when>        
                                            <c:otherwise>
                                                ${detailMovie.currentEpisode}/
                                                <c:choose>
                                                    <c:when test="${(fn:split(detailMovie.duration, ' ')[0]) =='0'}">?</c:when>
                                                    <c:otherwise>${fn:split(detailMovie.duration, ' ')[0]}</c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    <div class="entry-time"></div>

                                </div>
                                <span class="rate">${detailMovie.imdb}</span>
                            </div>
                            <div class="entry-content">
                                <h4 class="entry-title">${detailMovie.title}</h4>
                                <div class="entry-date">Release: ${detailMovie.releaseDay}</div>

                            </div>
                            <div class="pic-caption open-left transform">
                                <h4 class="entry-title">
                                    <a href="#">${detailMovie.title}</a>
                                </h4>
                                <span class="pg" style="font-size: 15px">
                                    <c:choose>
                                        <c:when test="${detailMovie.numberEpisode <= 0}">
                                            Trailer
                                        </c:when>
                                        <c:when test="${detailMovie.type == false}">
                                            ${detailMovie.quantity}
                                        </c:when>        
                                        <c:otherwise>
                                            ${detailMovie.currentEpisode}/
                                            <c:choose>
                                                <c:when test="${(fn:split(detailMovie.duration, ' ')[0]) =='0'}">?</c:when>
                                                <c:otherwise>${fn:split(detailMovie.duration, ' ')[0]}</c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                                <div class="desc-mv">
                                    <p><span>Genre: </span><% if (list.size() != 0 && list.get(indexSingle).getGenre() != null) {
                                            String genre = "[" + list.get(indexSingle).getGenre() + "]";
                                            JSONArray arrR = new JSONArray(genre);
                                    for (int i = 0; i < arrR.length(); i++) {
                                        JSONObject obj = arrR.getJSONObject(i);%>
                                        <a href="<%= obj.getInt("genreId")%>"><%= obj.getString("genreName")%></a>,
                                        <%}
                                          }%><c:if test="${detailMovie.type == true}"><a href="#">Television Series</a></c:if></p>
                                        <p><span>Duration: </span>${detailMovie.duration}</p>
                                    <p><span>View: </span>${detailMovie.views}</p>
                                    <p><span>Country: </span><a href="#">${detailMovie.countryName}</a></p>
                                </div>
                                <a class="rate" href="${pageContext.request.contextPath}/movies?id=${detailMovie.movieId}">
                                    <span class="glyphicon glyphicon-play"></span>
                                </a>
                            </div>
                        </article>
                    </div>
                    <%indexSingle++;%>
                </c:forEach>
            </div>
        </div>
        <div id="continueEpisode-modal" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Choose episodes</h4>
                    </div>
                    <div class="modal-body continueEpisode-body">
                        
                    </div>
                    <div class="modal-footer continueEpisode-footer">
                        <button id="modal-changeEpisode" type="button" class="btn btn-success"
                                data-dismiss="modal">Change Episode
                        </button>
                        <button id="modal-cancelEpisode" type="button" class="btn btn-danger"
                                data-dismiss="modal">Cancel
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div><!-- /.container -->
    <%@include file="footer.jsp" %>
<script src="public/js/jquery.min.js"></script>
<script src="public/js/loginHeader.js"></script>
<script src="public/js/bootstrap.min.js"></script>
<script type="text/javascript" src="public/videojs/video.js"></script>
<script src="public/videojs-resolution-switcher/videojs-resolution-switcher.js"></script>
<script src="public/videojs/ad-markers.js"></script>
<script src="public/js/videojs-contrib-hls.min.js"></script>
<script type="text/javascript" src="public/js/movie_script.js"></script>
<script src="public/js/sweetalert.js"></script>
<script src="public/js/reportComment.js"></script>
<!--<script src="https://cdnjs.cloudflare.com/ajax/libs/core-js/2.4.1/core.js"></script>-->
<script src="public/js/js.cookie.js"></script>
<script type="text/javascript">
    function readCookie(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
        return null;
    }
    $(document).ready(function() {
        var movieId = $('#movieId').val();
        var userId = $('#sessionUser').val();
        var per = $('#sessionUserRole').val();
        var startTime = 0;
        var player = videojs('featured-video', {}, function() {
            player.on('resolutionchange', function() {
                var cur = player.currentTime();
                player.currentTime(cur);
            });
            if (per == null || per == '' || per == 'ROLE_MEMBER') {
                player.adMarkers(getMarkersContent());
            }
            player.on('timeupdate', setTimeElapsed);
        });
      
        var adsPlayer = videojs('ads-container',{
            controlBar: {
                fullscreenToggle:false
            }
            
        });
        $('#ads-container').css("display","none")
        adsPlayer.on('ended', function() {
            player.play();
            $('#featured-video').css("display","")
            $('#ads-container').css("display","none")
            player.adMarkers.adPlaying = false; // whenever an ad ends, you must set this flag to false
            if(!adsPlayer.skipButton.classList.contains('enabled')){
                adsPlayer.skipButton.classList.remove("enabled");
            }
        });
        var arrAds = $.parseJSON(readCookie("ads-video").substr(1).slice(0, -1).replace(/\\/g,'')); 
        function getMarkersContent(){
            var markersContent = {
                markers: arrAds,
                prepareNextAd: function(nextMarker) {
                    if(!adsPlayer.skipButton.classList.contains('enabled')){
                        adsPlayer.skipButton.classList.remove("enabled");
                    }
                    adsPlayer.src(nextMarker.ad);
                    adsPlayer.load();
                },
                playAd: function(marker) {
                    player.pause();
                    $('#featured-video').css("display","none")
                    $('#ads-container').css("display","")
                    adsPlayer.el().appendChild(skipButton);
                    if(adsPlayer.skipButton.classList.contains('enabled')){
                        adsPlayer.skipButton.classList.remove("enabled");
                    }
                    adsPlayer.on('timeupdate', function(){
                        if(player.adMarkers.adPlaying){
                            player.pause();
                        }
                        var timeLeft = 6- Math.ceil(adsPlayer.currentTime())
                        if(timeLeft > 0){
                            adsPlayer.skipButton.innerHTML ="You can skip this ad in " + timeLeft +" s";
                        }else{
                            if(!adsPlayer.skipButton.classList.contains('enabled')){
                                adsPlayer.skipButton.classList.add("enabled");
                                adsPlayer.skipButton.innerHTML = "Skip this ADS >>";
                            }
                        }
                        timeLeft --;
                    });
                    adsPlayer.currentTime(0);
                    adsPlayer.play();
                }
            }
            return markersContent;
        }
        
        var skipButton = document.createElement('div');
        skipButton.className = 'preroll-skip-button';
        skipButton.onclick = function(e) {
            var Event = Event || window.Event;
            if(adsPlayer.skipButton.classList.contains('enabled')) {
                player.play();
                $('#featured-video').css("display","")
                $('#ads-container').css("display","none")
                player.adMarkers.adPlaying = false;
            }
            if(Event.prototype.stopPropagation !== undefined) {
                e.stopPropagation();
            } else {
                return false;
            }
        };
        adsPlayer.skipButton = skipButton;
        
        autoContinueEpisode();
        
        function resetAds(){
            if(per == null || per == '' || per == 'ROLE_MEMBER'){
                if(adsPlayer.skipButton.classList.contains('enabled')) {
                    adsPlayer.skipButton.classList.remove('enabled')
                }
                player.adMarkers.destroy();
                player.adMarkers(getMarkersContent());
            }
        }
        
        function removeWhiteSpace(text) {
            var textStrim = text.trim();
            return text.trim().replace(/\s+/g, ' ');
        }
                          
        function autoContinueEpisode(){
            var ck = Cookies.get("time-elapsed");
            if(ck){
                var arr = $.parseJSON(ck)
                for( var k = 0; k < arr.length; ++k ) {
                    if(arr[k]["movieID"] == movieId && arr[k]["time"] != 0) {
                        var preEpi =  $('#episode a[name='+arr[k]["epi"]+']').prev('a');
                        var curEpi =  $('#episode a[name='+arr[k]["epi"]+']');
                        var nextEpi = $('#episode a[name='+arr[k]["epi"]+']').next('a')
                        if(nextEpi.html() || preEpi.html()){
                            var bodyText = 'It seems that you were watching episode '+curEpi.html()+'. Do you want to continue watching ep '+curEpi.html();
                            var footerText =  '<button name="continueEpiMulti" class="btn">Continue</button>';
                            if(nextEpi.html()){
                                bodyText +=' or change to ep '+nextEpi.html()
                                footerText+='<button class="btn" name="nextEpi">Next Episode</button><button class="btn btn-danger" data-dismiss="modal">Cancel</button>'
                            }else{
                                footerText+='<button class="btn btn-danger" data-dismiss="modal">Cancel</button>'
                            }
                            $('.continueEpisode-body').html(bodyText)
                            $('.continueEpisode-footer').html(footerText)
                            $('button[name=continueEpiMulti]').on('click',function(){
                                $('#continueEpisode-modal').modal('hide')
                                curEpi.click();    
                            })
                            $('button[name=nextEpi]').on('click',function(){
                                $('#continueEpisode-modal').modal('hide')
                                nextEpi.click();
                            })  
                            $('#continueEpisode-modal').modal('show')
                        }
//                        else{
//                            if(arr[k]["time"] != 0 && arr[k]["time"] != '0'){
//                                $('.continueEpisode-body').html('It seems that you were watching in the '+(arr[k]["time"]/60).toFixed(1)+' minute. Do you want to continue watching or watch from beginning')
//                                $('.continueEpisode-footer').html('<button name="continueEpiSingle" class="btn">Continue</button><button class="btn" data-dismiss="modal">From start</button><button class="btn btn-danger" data-dismiss="modal">Cancel</button>')
//                                $('button[name=continueEpiSingle]').on('click',function(){
//                                    $('#continueEpisode-modal').modal('hide')
//                                    startTime = parseInt(arr[k]["time"]);
//                                    player.currentTime(startTime);
//                                    player.play();
//                                    return;
//                                })
//                                $('#continueEpisode-modal').modal('show')
//                            }
//                        }
                        break;
                    }
                }
            }
        }
        
        //set timeElapsed video
        function setTimeElapsed(){
            if(!$("#episode a[class*='btn-danger']").html()){
                return;
            }
            var ck = Cookies.get("time-elapsed");
            var arr =[];
            if(ck){
                arr = $.parseJSON(ck)
                var flag=false;
                for( var k = 0; k < arr.length; ++k ) {
                    if(arr[k]["movieID"] == movieId) {
                        flag=true;
                        break;
                    }
                }
                if(flag){
                    if(player.currentTime() !=0){
                        arr[k]["epi"] = $("#episode a[class*='btn-danger']").attr("name") ;
                        arr[k]["time"] = player.currentTime();
                        Cookies.set('time-elapsed', JSON.stringify(arr), { expires: 1 });
                    }    
                }else{
                    if(player.currentTime() !=0){
                        var mv={};
                        mv.movieID =movieId
                        mv.epi = $("#episode a[class*='btn-danger']").attr("name")
                        mv.time =player.currentTime()
                        arr.push(mv)
                        Cookies.set('time-elapsed', JSON.stringify(arr), { expires: 1 });
                    }
                }
                
            }else{
                var mv={};
                mv.movieID =movieId
                mv.epi = $("#episode a[class*='btn-danger']").attr("name")
                mv.time =player.currentTime()
                arr.push(mv)
                Cookies.set('time-elapsed', JSON.stringify(arr), { expires: 1 });
            }
        }
        
        //view rate detail
        $("[data-toggle=popover]").popover({
            html : true,
            trigger : 'hover',
            content: function() {
              var content = $(this).attr("data-popover-content");
              return $(content).children(".popover-body").html();
            },
            title: function() {
              var title = $(this).attr("data-popover-content");
              return $(title).children(".popover-heading").html();
            }
        })
        
        //coutnview
        var flagCountView = false;
        $('.vjs-big-play-button').on('click', function() { 
            if(!flagCountView){
                setTimeout(function() {
                    
                    $.ajax({
                        type: "POST",
                        url: "countview",
                        data: {
                            movieId: movieId
                        },
                        success: function(resultData) {}
                    });
                }, 10000);
                flagCountView =true;
            }
        })
        
        //rateting
        $('span[name=rate]').hover(function(){
            var r = 11-this.id.match(/\d+/)[0];
            $('.rating-title').css('display','inline-block')
            $('.rating-title').html(r+'/10')
        })
        $('span[name=rate]').mouseleave(function() {      
            $('.rating-title').css('display','none')
        });
        $('span[name="rate"]').click(function() {
            var star = 10 - $(this).index();
            if (userId == null || userId == '') {
                swal("Request Failed!", "You need to login first!", "warning");
            } else {
                $.ajax({
                    type: "POST",
                    url: "ratingServlet",
                    data: {
                        movieId: movieId,
                        userId: userId,
                        star: star
                    },
                    success: function(resultData) {
                        var result = $.parseJSON(resultData);

                        if (result.result == 'true') {
                            swal("Success!", "Thanks for you rating!", "success");
                            $('.rating_count').html(result.rateCount+' ratings');
                            $('.popover-body').empty();
                            $.each(result.rateList,function(k,v){
                                $('.popover-body').append('<div class="probprogress-label" style="float: left;margin-right: 1em; width: 30%">'+k+'</div>')
                                $('.popover-body').append($('<div class="progress" style="width: 150px">')
                                        .html($('<div class="progress-bar" role="progressbar" aria-valuenow="1" aria-valuemin="0" aria-valuemax="100">')
                                            .css("width",(v*100/result.rateCount)+'%')
                                        .html('<span>'+(v*100/result.rateCount)+'%</span>')))
                            })
                            var i = 10;
                            $('span[name="rate"]').each(function() {
                                if (result.ratePoint >= i) {
                                    $(this).html("★")
                                    $(this).css("color", "gold");
                                } else {
                                    $(this).html("☆")
                                    $(this).css("color", "");
                                }
                                i--;
                            });
                        } else {

                            if (result.result == 'exist') {
                                swal("Oops...!", "You have rated","warning");
                            } else {
                                swal("Oops...!", "Something error when post your rating. Try it again!", "error");
                            }
                        }

                    },
                    error: function() {
                        swal("Oops...!", "Something error when post your rating. Try it again!", "error");
                    }
                });
            }

        })
        
        //change episode
        $("#episode a").click(function() {
            resetAds();
            $('#featured-video').css("display","")
            $('#ads-container').css("display","none")
            var episodeBtn = $(this);
            var episode = $(this).attr('name');;
            var cusEpisode = $("#episode a[class*='btn-danger']");
            $.ajax({
                type: "POST",
                url: "changeepisode",
                data: {
                    episodeId: episode
                },
                success: function(resultData) {
                    var result = $.parseJSON(resultData);
                    if (result.result == 'true') {
                        if (!episodeBtn.hasClass("btn-danger")) {
                            episodeBtn.removeClass("btn-default")
                            episodeBtn.addClass("btn-danger");
                            cusEpisode.removeClass("btn-danger");
                            cusEpisode.addClass("btn-default");
                        }
                        var role = $('#sessionUserRole').val();
                        var oldTracks = player.remoteTextTracks();
                        var i = oldTracks.length;
                        while (i--) {
                            player.removeRemoteTextTrack(oldTracks[i]);
                        }
                        if (result.episode.subtitle != null && result.episode.subtitle != '[]' && result.episode.subtitle != '') {
                            var arr = $.parseJSON(result.episode.subtitle)
                            arr.forEach(value => {
                                player.addRemoteTextTrack({
                                    kind: 'captions',
                                    src: 'moviesSource/' + 'mv_' + movieId + '/' + result.episode.episodeName.toFixed(1) + '/sub/' + value.name,
                                    srclang: value.code,
                                    label: value.lang
                                });
                            })
                        }
                        var res360 = {
                            src: 'moviesSource/mv_' + movieId + '/' + result.episode.episodeName.toFixed(1) + '/sd/' + result.episode.res360 + '?360',
                            type: 'video/mp4',
                            label: '360p'
                        };
                        var res480 = {
                            src: 'moviesSource/mv_' + movieId + '/' + result.episode.episodeName.toFixed(1) + '/sd/' + result.episode.res480 + '?480',
                            type: 'video/mp4',
                            label: '480p'
                        }
                        var res720 = {
                            src: 'moviesSource/mv_' + movieId + '/' + result.episode.episodeName.toFixed(1) + '/hd/' + result.episode.res720 + '?720',
                            type: 'application/x-mpegURL',
                            label: '720p'
                        }
                        var res1080 = {
                            src: 'moviesSource/mv_' + movieId + '/' + result.episode.episodeName.toFixed(1) + '/hd/' + result.episode.res1080 + '?1080',
                            type: 'application/x-mpegURL',
                            label: '1080p'
                        }
                        var epiArrVip = [];
                        var epiArr = [];
                        if (result.episode.res1080 != '' && result.episode.res1080 != null) {
                            epiArrVip.push(res1080);
                        }
                        if (result.episode.res720 != '' && result.episode.res720 != null) {
                            epiArrVip.push(res720);
                        }
                        if (result.episode.res480 != '' && result.episode.res480 != null) {
                            epiArrVip.push(res480);
                            epiArr.push(res480);
                        }
                        if (result.episode.res360 != '' && result.episode.res360 != null) {
                            epiArrVip.push(res360);
                            epiArr.push(res360);
                        }

                        if (role == "ROLE_ADMIN" || role == "ROLE_UPLOADER" || role == "ROLE_VIP") {
                            player.updateSrc(epiArrVip)
                        } else {
                            player.updateSrc(epiArr)
                        }
                        player.currentResolution('480p');
                    } else {
                        swal("Oops...!", "Something error. Try it again!", "error");
                    }
                    player.bigPlayButton.show();
                },
                error: function() {
                    swal("Oops...!", "Something error. Try it again!", "error");
                }
            });
        });

        //lightoff
        var lightoff = 0;
        $('#light').click(function() {
            $('.breadcrumb').css('position', 'absolute');
            $('body').attr("class", "persoff");
            $('.featured-media').nextAll().css('display', 'none');
            $('.video-region').nextAll().css('display', 'none');
        })
        $('body').click(function() {
            lightoff += 1;
            if (lightoff == 2) {
                $('.breadcrumb').css('position', '');
                $('body').removeClass('persoff');
                $('.featured-media').nextAll().css('display', '');
                $('.video-region').nextAll().css('display', '');
                lightoff = 0;
            }
        })
        
        //autochange episode
        $('#isnext').click(function() {
            if ($("#isnext").val() == "1") {
                $("#isnext").val("0");
                $('#isnext').html("Auto Change: <strong style='color: red'>OFF</strong>");
            } else {
                $("#isnext").val("1");
                $('#isnext').html("Auto Change: <strong style='color: red'>ON</strong>");
            }
        })

        //auto change epsido

        player.on("ended", function() {
            var cusEpisode = $("#episode a[class*='btn-danger']");
            var nextMode = $("#isnext").val();
            var nextEpisode = cusEpisode.next('a');
            if (nextMode == "1" && nextEpisode.length > 0) {
                $('#changeEpisode-modal').modal('show');
                var time = 3000;
                $('#modal-time-left-episode').html(nextEpisode.html())
                $('#modal-time-left').html(time / 1000);

                var tid = setInterval(function() {
                    $('#modal-time-left').html(time / 1000);
                    if (time == 0) {
                        clearInterval(tid);
                        $('#modal-changeEpisode').click()
                        return
                    }
                    $('#modal-cancelEpisode').click(function() {
                        clearInterval(tid);
                        return
                    })
                    time -= 100;
                }, 100)
                $('#modal-changeEpisode').click(function() {
                    nextEpisode.click();
                })
            }
        })

        //comment Tri
        $('#post-comment-text').keyup(function() {
            if (removeWhiteSpace($(this).val()).length > 6) {
                $(".cm-btn button[id=post-comment]").removeAttr('disabled');
            } else {
                $(".cm-btn button[id=post-comment]").prop("disabled", true);
            }
        })
        
        function checkDeletebtn(){
            if (userId == null || userId == ''){
                $('a[name=btnDeleteComment]').css("display", "none");
            }
        }
        $('.comment-area').focus(function() {
            $('.cm-btn').css('display', "block")
        })
        checkDeletebtn();
        //sent comment Tri
        $('#post-comment').click(function() {
            var sessionUser = $('#sessionUser').val();
            
            if (userId == null || userId == '') {
                swal("Request Failed!", "You need to login first!", "warning");
            } else {
                $.ajax({
                    type: "POST",
                    url: "UserComment",
                    data: {
                        movieId: movieId,
                        userId: userId,
                        commentContent: $('#post-comment-text').val()
                    },
                    success: function(resultData){
                        if(resultData == 'false'){
                            swal("Error!", "Cannot post comment. Something wrong.", "error");
                        }else{
                            $('#comment-div').load(" #comment-div > *", function(){
                                deleteComment();
                                actionReportComment();
                            });                                         
                        }                        
                    }
                });
            }            
        })
        deleteComment();
        actionReportComment();
        function deleteComment(){
            $('a[name=btnDeleteComment]').click(function(){
            var commentId = $(this).attr('id');
            var currentRow = $(this).parent().parent();
            
            if (userId == null || userId == '') {
                swal("Request Failed!", "You need to login first!", "warning");
            } else {                                
                swal({
                                title: "Are you sure?",
                                text: "Once deleted, you will not be able to recover this comment!",
                                type: "warning",
                                showCancelButton: true,
                                confirmButtonClass: "btn-primary",
                                confirmButtonText: "Yes, delete it",
                                cancelButtonText: "Cancel",
                                
                              }).then( function (result){
                                  if(result.value){
                                      $.ajax({
                                      type: "POST",
                                      url: "UserDeleteComment",
                                      data:{commentId: commentId},
                                      success: function(resultData){
                                          swal("Done!","Your comment has been deleted!", "success");
                                          currentRow.remove()
                                      },
                                      error: function (xhr, ajaxOptions, thrownError) {
                                            swal("Error deleting!", "Please try again", "error");
                                        }
                                  })
                                  }
                              })
                      }
        })
        }
        //bookmark
        $('#boomarkbtn').click(function() {
            if (userId == null || userId == '') {
                swal("Request Failed!", "You need to login first!", "warning");
            } else {
                $.ajax({
                    type: "POST",
                    url: "bookmark",
                    data: {
                        action: 'add',
                        movieId: movieId
                    },
                    success: function(resultData) {
                        if (resultData == 'true') {
                            swal({
                                //title:"Success!",
                                text:"This movie has already been in your movie box",
                                type:"success",
                                showCancelButton: true,
                                confirmButtonClass: "btn-primary",
                                confirmButtonText: "Movie Box",
                            }).then((result) => {
                                if (result.value) {
                                  window.location.replace(`${pageContext.request.contextPath}/bookmark?action=get`);
                                }
                            })
                        } else {
                            if (resultData == 'exist') {
                                swal("Oops...!", "This movie has already been your movie box","warning");
                            } else {
                                swal("Oops...!", "Something error when add to movie box. Try it again!", "error");
                            }
                        }
                    },
                    error: function() {
                        swal("Oops...!", "Something error when add to movie box. Try it again!", "error");
                    }
                });
            }
        })
        //select error
        $('#sel1Error').on('change', function() {
            if ($(this).val() == 3) {
                $('#errorOther').css('display', 'block');
            } else {
                $('#errorOther').css('display', 'none');
            }
        })
        var capchaNum = 0;
        var canvas = document.getElementById("canvasCapcha");
        var ctx = canvas.getContext("2d");
        $('#capchaImage').on('load', function() {
            canvas.crossOrigin = "Anonymous";
            ctx.drawImage($('#capchaImage').get(0), 0, 0);
        })

        function getRandomNum() {
            capchaNum = Math.floor((Math.random() * 8999) + 1000);
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.drawImage($('#capchaImage').get(0), 0, 0);
            ctx.fillStyle = "red";
            ctx.font = "20px Arial";
            ctx.fillText(capchaNum, 8, 25);
        }
        $('#btnReport').click(function() {
            getRandomNum();
            $('#errorReport').html('');
            $('#sel1Error').val("1");
            $('#errorOther').css('display', 'none');
            $('#errorOtherBody').val("");
            $("input[name=min]").val(0);
            $('#capchaInput').val('');
            $('#reportModal').modal('show')
        })

        $('#refreshCapcha').click(function() {
            getRandomNum();
        })

        $('#reportSubmit').click(function() {
            var option = $('#sel1Error').val();
            var timeS = $("input[name=min]").val();
            $('#errorReport').html('')
            if (option == 3) {
                if (removeWhiteSpace($('#errorOtherBody').val()).length < 10) {
                    $('#errorReport').html("Please enter content greaster than 10 characters")
                    return
                }
            }
            try {
                var time = parseFloat(timeS);
                if(time < 0 || timeS ==""){
                    $('#errorReport').html("Please enter time. Must be greaster than 0")
                    return
                 }
            }
            catch(err) {
                $('#errorReport').html("Please enter a number")
                return
            }
            if ($('#capchaInput').val() != capchaNum) {
                $('#errorReport').html("Wrong capcha. Please re-enter")
                getRandomNum();
                return
            }
            $('#reportForm').trigger('submit');
            swal({
                title: 'Sending...',
                text: '',
                timer: 4800,
                onOpen: function(){
                  swal.showLoading()
                }
            })
        })
        $('#reportForm').submit(function(e){
            e.preventDefault();
            $.ajax({
                type: 'POST',
                url: "notificationServlet",
                data: {type:"report-error",movieID:movieId,typeError:$('#sel1Error').val(),time:$("input[name=min]").val(),errorContent:$('#errorOtherBody').val(),title:"ERROR REPORT"},
                success: function (data) {
                    if(data == 'true'){
                        swal("Failed!", "Cannot sent your report. Please try again!", "error");
                        getRandomNum();
                    }else{
                        if(data == 'spam'){
                            swal("Warning!", "You only send report every 15 minutes", "warning");
                        }else{
                            swal("Success!", "Thank for your report! We will check it as soon as", "success");
                            $('#reportModal').modal('hide');
                        }
                    }
                },
                error: function () {
                    swal("Failed!", "Cannot sent your report. Something wrong!", "error");
                    getRandomNum();
                }
            });
        })
    })
</script>

</body>
</html>

