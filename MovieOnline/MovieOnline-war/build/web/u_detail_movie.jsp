<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="org.json.JSONObject"%>
<%@page import="model.MovieDB"%>
<%@page import="org.json.JSONArray"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<!DOCTYPE html>
<html>
<head>
    <META charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>S&E Online | Movie Detail</title>

    <!-- Bootstrap core CSS -->
    <link href="public/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="public/css/sweetalert.css?ver=1.1">
    <link href="public/css/movie.css" rel="stylesheet">
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
    <% MovieDB movie = (MovieDB)request.getAttribute("detailMovie");%>
    <input id="sessionUser" type="hidden" value="${sessionScope.user.accountId}"/>
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
            <ol class="breadcrumb bg-div" itemscope itemtype="http://schema.org/BreadcrumbList">
                <li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
                    <a itemprop="item" title="S&E Online" href="./" itemprop="url">
                        <span itemprop="name">S&E Online</span>
                        <meta itemprop="position" content="1"/>
                    </a>
                </li>
                <li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
                    <c:choose>
                        <c:when test="${detailMovie.type == false}">
                            <a itemprop="item" title="Single" href="Search?searchType=filter&order=1&type=0" itemprop="url">
                                <span itemprop="name">Movie</span>
                                <meta itemprop="position" content="2"/>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a itemprop="item" title="Television Series" href="Search?searchType=filter&order=1&type=1" itemprop="url">
                                <span itemprop="name">Television Series</span>
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
                <li class="active">${detailMovie.realTitle}</li>
            </ol>
        </div>
    </div>
    <div class="bg-div">
        <div class="row m-info">
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                <input type="hidden" id="movieId" name="movieId" value="${detailMovie.movieId}"/>
                <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
                    <div class="img-movie">
                        <img src="moviesSource/mv_${detailMovie.movieId}/poster.medium.jpg" class="img-thumbnail">
                        <div class="btn-background"></div>
                        <div class="btn-button">
                            <a class="btn btn-primary btn-hover" data-toggle="modal" data-target="#trailerModal">Trailer</a>
                            <c:if test="${detailMovie.numberEpisode >0}">
                                <input id="age-limit" type="hidden" value="${detailMovie.ageLimit}">
                                <a id="a-watch" href="${pageContext.request.contextPath}/watchmovie?id=${detailMovie.movieId}" class="btn btn-danger btn-hover">Watch</a>
                                <a href="${pageContext.request.contextPath}/download?action=2998b3232d29e8dc5a78d97a32ce83f556f3ed31b057077503df05641dd79158&id=${detailMovie.movieId}" class="btn btn-success btn-hover">Download</a>
                            </c:if>
                        </div>

                    </div>
                </div>
                <div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
                    <h2 CLASS="m_title">${detailMovie.title}</h2>
                    <div class="row">
                        <div class="col-xs-9 col-sm-9 col-md-9 col-lg-9">
                            <span style="color: blanchedalmond">${detailMovie.realTitle}</span>
                        </div>
                        <div class="col-xs-3 col-sm-3 col-md-3 col-lg-3" style="text-align: right">
                            <button id="boomarkbtn" class="btn btn-primary btn-xs"><span class="glyphicon glyphicon-plus-sign"></span> Add to Movie Box</button>
                        </div>
                    </div>

                    <hr>
                    <div class="well well-sm padding-text content-movie">
                        <p>Status: <span class="label label-danger" style="color: white">
                            <c:choose>
                                <c:when test="${detailMovie.numberEpisode <= 0}">
                                    Trailer
                                </c:when>
                                <c:when test="${detailMovie.type == false || (detailMovie.type ==true && detailMovie.numberEpisode == (fn:split(detailMovie.duration, ' ')[0]))}">
                                        Completed
                                </c:when>        
                                <c:otherwise>
                                    ${detailMovie.currentEpisode}/${detailMovie.duration}
                                </c:otherwise>
                            </c:choose>
                            </span></p>
                        <p>IMDB: <span class="label label-warning" style="color: white">${detailMovie.imdb}</span></p>
                        <p>Director: <c:forEach items="${fn:split(detailMovie.director, ',')}" var="di">
                                        <a href="Search?searchType=filter&order=1&director=${di}">${di}</a>,
                                    </c:forEach></p>
                        <p>Country: <a href="Search?searchType=filter&order=1&countryName=${detailMovie.countryName}">${detailMovie.countryName}</a></p>
                        <p>Actors: <c:forEach items="${fn:split(detailMovie.actors, ',')}" var="ac">
                                        <a href="Search?searchType=filter&order=1&actor=${ac}">${ac}</a>,
                                    </c:forEach></p>
                        <p>Release of Day: <span>${detailMovie.releaseDay}</span></p>
                        <p>Duration: <span>${detailMovie.duration}</span></p>
                        <p>Quantity: <span>${detailMovie.quantity}</span></p>
                        <p>Genre: <% if(movie.getGenre() !=null){
                                        String genre = "["+movie.getGenre()+"]";
                                        JSONArray arr = new JSONArray(genre);
                                        for(int i = 0;i<arr.length();i++){
                                            JSONObject obj = arr.getJSONObject(i);%>
                                            <a href="Search?searchType=filter&order=1&genreName=<%= obj.getString("genreName")%>"><%= obj.getString("genreName")%></a>,
                                      <%}
                                  }%><c:if test="${detailMovie.type == true}"><a href="Search?searchType=filter&order=1&type=1">Television Series</a></c:if></p>
                        <p>Views: <span>${detailMovie.views}</span></p>
                    </div>
                </div>
            </div>
        </div>
        <p></p>
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
                        <% for(int i=10;i>0;i--){
                            if(movie.getRate()>=i){%>
                                <span id="rate<%=11-i%>" name="rate" style="color: gold" title="<%=i%>/10">★</span>
                            <%}else{%>
                                <span id="rate<%=11-i%>" name="rate" title="<%=i%>/10">☆</span>
                            <%}
                        }%>
                    </div>
                    <div class="rating-title">1/10</div>
                </div>
            </div>
        </div>
        <p></p>
        <div class="row black">
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 ">
                <h3 class="m_rating" style="padding: 0 10px">Movie Content</h3>
                <hr>
                <p style="color: white;padding: 5px">${detailMovie.description}</p>
            </div>
        </div>
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
        <p></p>
    </div>
    <p></p>
    <div class="bg-div">
        <h3 class="m_rating" style="padding: 0 20px">Comment</h3>
        <hr>
        <div class="row black">
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 ">
                <div class="comment-list">
                        <c:forEach items="${commentList}" var="items">
                            <div class="media" style="padding: 10px 0">
                                <div class="media-left">
                                     <c:choose>
                                        <c:when test="${items.accountId.image ==null || items.accountId.image ==''}">
                                            <img src="public/images/avatar/empty_avatar.png" class="media-object" style="width:45px">
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
            <% int indexSingle=0;%>
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
                            <p><span>Genre: </span><% if(list.size()!=0 && list.get(indexSingle).getGenre() !=null){
                                        String genre = "["+list.get(indexSingle).getGenre()+"]";
                                        JSONArray arr = new JSONArray(genre);
                                        for(int i = 0;i<arr.length();i++){
                                            JSONObject obj = arr.getJSONObject(i);%>
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
    

    <!-- Trailer Modal -->
    <div class="modal fade" id="trailerModal" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content trailer-model-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><strong>${detailMovie.title}</strong></h4>
                </div>
                <div class="modal-body">
                    <video width="100%" controls>
                        <c:choose>
                            <c:when test="${fn:contains(detailMovie.trailer,'http')}">
                                <source src="${detailMovie.trailer}" type="video/mp4">
                            </c:when>
                            <c:otherwise>
                                <source src="moviesSource/mv_${detailMovie.movieId}/${detailMovie.trailer}" type="video/mp4">
                            </c:otherwise>
                        </c:choose>
                    </video>
                </div>
            </div>

        </div>
    </div>                
</div><!-- /.container -->
<%@include file="footer.jsp" %>
<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="public/js/jquery.min.js"></script>
<script src="public/js/loginHeader.js"></script>
<script src="public/js/bootstrap.min.js"></script>
<script src="public/js/sweetalert.js"></script>
<script src="public/js/reportComment.js"></script>
<script>
    $(document).ready(function(){
        var userId = $('#sessionUser').val();
        var movieId = $('#movieId').val();
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
        $('span[name="rate"]').click(function(){
            var star = 10-$(this).index();
            if(userId == null || userId == ''){
                swal("Request Failed!", "You need to login first!", "warning");
            }else{
                $.ajax({
                    type: "POST",
                    url: "ratingServlet",
                    data: {movieId:movieId,userId:userId,star:star},
                    success: function(resultData){
                        var result = $.parseJSON(resultData);
                        
                        if(result.result == 'true'){
                            swal("Success!", "Thanks for you rating!", "success");
                            $('.rating_count').html(result.rateCount+' ratings');
                            $('.popover-body').empty();
                            $.each(result.rateList,function(k,v){
                                $('.popover-body').append('<div class="probprogress-label" style="float: right; width: 30%">'+k+'</div>')
                                $('.popover-body').append($('<div class="progress" style="width: 150px">')
                                        .html($('<div class="progress-bar" role="progressbar" aria-valuenow="1" aria-valuemin="0" aria-valuemax="100">')
                                            .css("width",(v*100/result.rateCount)+'%')
                                        .html('<span>'+(v*100/result.rateCount)+'%</span>')))
                            })
                            var i=10;
                            $('span[name="rate"]').each(function() {
                                if(result.ratePoint>=i){
                                    $(this).html("★")
                                    $(this).css("color","gold");
                                }else{
                                    $(this).html("☆")
                                    $(this).css("color","");
                                }
                                i--;
                            });
                        }else{
                            
                            if(result.result == 'exist'){
                                swal("Oops...!", "You have rated","warning");
                            }else{
                                swal("Oops...!", "Something error when post your rating. Try it again!", "error");       
                            }
                        }
                        
                    },
                    error:function () {
                        swal("Oops...!", "Something error when post your rating. Try it again!", "error");       
                    }
                });
            }
            
        })
        $('span[name=rate]').hover(function(){
            var r = 11-this.id.match(/\d+/)[0];
            $('.rating-title').css('display','inline-block')
            $('.rating-title').html(r+'/10')
        })
        $('span[name=rate]').mouseleave(function() {      
            $('.rating-title').css('display','none')
        });
        $('#boomarkbtn').click(function(){
            if(userId == null || userId == ''){
                swal("Request Failed!", "You need to login first!", "warning");
            }else{
                $.ajax({
                    type: "POST",
                    url: "bookmark",
                    data: {action:'add',movieId:movieId},
                    success: function(resultData){
                        if(resultData == 'true'){
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
                        }else{
                            if(resultData == 'exist'){
                                swal("Oops...!", "This movie has already been in your movie box","warning");
                            }else{
                                swal("Oops...!", "Something error when add to movie box. Try it again!", "error");        
                            }
                        }
                    },
                    error:function () {
                        swal("Oops...!", "Something error when add to movie box. Try it again!", "error");
                    }
                });
            }
        })
        $('#a-watch').on('click',function(){
            if($('#age-limit').val() == 'true'){
                swal.queue([{
                    title: "Oh oh!",
                    text:"This movie only for 18+. Are you want to see?",
                    type: 'warning',
                    confirmButtonText: 'Yes! I want',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    preConfirm: () => {
                        window.location.replace($('#a-watch').attr("href"))
                    }
                  }])
            }else{
                return true;
            }
            return false;
        })
        actionReportComment();
    })
</script>
</body>
</html>
