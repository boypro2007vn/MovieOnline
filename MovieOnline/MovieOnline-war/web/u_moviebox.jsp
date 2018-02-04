<%-- 
    Document   : u_moviebox
    Created on : Dec 11, 2017, 1:43:30 AM
    Author     : namin
--%>

<%@page import="model.MovieDB"%>
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
    <title>S&E Online | Movie Box</title>

    <!-- Bootstrap core CSS -->
    <link href="public/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="public/css/sweetalert.css?ver=1.1">
    <link href="public/css/homepage.css" rel="stylesheet">
</head>
<body>
<%@include file="header.jsp" %>
<div class="container">
    <% List<MovieDB> movies = (List<MovieDB>)request.getAttribute("bookmarkList");%>
    <div class="col-md-12 tab-list-row">
        <span class="title-list-index" style="margin-bottom: 20px">Movie Box</span>
        <div class="row" style="min-height: 300px">
            <% int index=0;%>
            <c:forEach items="${bookmarkList}" var="detailMovie">
            <div class="col-md-2 grid-item space-float-div">
                <article class="entry-item" onclick="">
                    <div class="entry-thumb">
                        <img width="100%" height="280" src="moviesSource/mv_${detailMovie.movieId}/poster.medium.jpg"
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
                            <a href="movies?id=${detailMovie.movieId}">${detailMovie.realTitle}</a>
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
                            <p><span>Genre: </span><% if(movies.get(index).getGenre() !=null){
                                        String genre = "["+movies.get(index).getGenre()+"]";
                                        JSONArray arr = new JSONArray(genre);
                                        for(int i = 0;i<arr.length();i++){
                                            JSONObject obj = arr.getJSONObject(i);%>
                                            <a href="Search?searchType=filter&order=1&genreName=<%= obj.getString("genreName")%>"><%= obj.getString("genreName")%></a>,
                                      <%}
                                  }%><c:if test="${detailMovie.type == true}"><a href="Search?searchType=filter&order=1&type=1">Television Series</a></c:if></p>
                            <p><span>Duration: </span>${detailMovie.duration}</p>
                            <p><span>View: </span>${detailMovie.views}</p>
                            <p><span>Language: </span><a href="Search?searchType=filter&order=1&countryName=${detailMovie.countryName}">${detailMovie.countryName}</a></p>
                        </div>
                        <a class="rate" href="${pageContext.request.contextPath}/movies?id=${detailMovie.movieId}">
                            <span class="glyphicon glyphicon-play"></span>
                        </a>
                        <div class="follow" style="float: bottom">
                            <a id="${detailMovie.movieId}" class="btn btn-primary btn-xs follow-link" style="margin-right: 8px;font-size: 1.2em">
                                <c:choose>
                                    <c:when test="${detailMovie.follow =='true'}">UnFollow</c:when>
                                    <c:otherwise>
                                        Follow
                                    </c:otherwise>
                                </c:choose>
                            </a><a id="${detailMovie.movieId}" class="btn btn-primary btn-xs del-follow-link" style="font-size: 1.2em">Remove</a>
                        </div>
                        
                    </div>
                </article>
            </div>
            <%index++;%>
            </c:forEach>
        </div>
    </div>
</div>        
<%@include file="footer.jsp" %>
<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="public/js/jquery.min.js"></script>
<script src="public/js/loginHeader.js"></script>
<script src="public/js/bootstrap.min.js"></script>
<script src="public/js/sweetalert.js"></script>
<script>
    $(document).ready(function(){
        $('.follow-link').on('click',function(){
            var btn = $(this);
            var movieId = $(this).attr('id');
            var change = ($(this).text().trim()=='Follow')?true:false;
            var text = '';
            if(change) text = "We will sent you message to your email when this movie has been uploaded the new episode!";;
            swal({
                title: 'Are you sure?',
                text: text,
                type: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes!'
              }).then((result) => {
                    if (result.value) {
                        $.ajax({
                            type: "POST",
                            url: "bookmark",
                            data: {action:'follow',movieId:movieId,change:change},
                            success: function(resultData){
                                
                                
                                if(resultData == 'true'){
                                    var text = '';
                                    var btnText='';
                                    if(change){
                                        text="Follow Success"
                                        btnText = "UnFollow";
                                    }else{
                                        text="UnFollow Success"
                                        btnText = "Follow"
                                    }
                                    swal("Success", text, "success");
                                    btn.text(btnText)
                                }else{
                                    swal("Oops...!", "Cannot sent request. Try it again!", "error"); 
                                }
                            },
                            error:function () {
                                swal("Oops...!", "Cannot sent request. Something wrong!", "error");
                            }
                        });
                    }
              })
            
        })
        $('.del-follow-link').on('click',function(){
            var div = $(this).parent().parent().parent().parent();
            var movieId = $(this).attr('id');
            $.ajax({
                type: "POST",
                url: "bookmark",
                data: {action:'remove',movieId:movieId},
                    success: function(resultData){
                        if(resultData == 'true'){
                            div.remove()
                        }else{
                            swal("Oops...!", "Cannot remove movie. Try it again!", "error");
                        }
                    },
                    error:function () {
                        swal("Oops...!", "Cannot sent request. Something wrong!", "error");
                    }
              });
        })
    })
</script>
</body>
</html>
