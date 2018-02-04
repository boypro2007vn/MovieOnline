<%@page import="model.MovieDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>S&E Online | Home Page</title>

    <link href="public/css/bootstrap.min.css" rel="stylesheet">
    <link href="public/css/homepage.css" rel="stylesheet">
    <link href="public/css/template.css" rel="stylesheet">
    <link rel="stylesheet" href="public/css/sweetalert.css?ver=1.1">

<body>
<%@include file="header.jsp" %> 
<div class="container">
    <div id="myCarousel" class="carousel slide" data-ride="carousel">
        <!-- Indicators -->
        <ol class="carousel-indicators">
            <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
            <li data-target="#myCarousel" data-slide-to="1"></li>
            <li data-target="#myCarousel" data-slide-to="2"></li>
        </ol>

        <!-- Wrapper for slides -->
        <div class="carousel-inner">
            <div class="item active banner-image">
                <img src="public/images/banner1.jpg" alt="" style="width:100%;">
            </div>

            <div class="item banner-image">
                <img src="public/images/banner2.jpg" alt="" style="width:100%;">
            </div>

            <div class="item banner-image">
                <img src="public/images/banner3.jpg" alt="" style="width:100%;">
            </div>
        </div>

        <!-- Left and right controls -->
        <a class="left carousel-control" href="#myCarousel" data-slide="prev">
            <span class="glyphicon glyphicon-chevron-left"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="right carousel-control" href="#myCarousel" data-slide="next">
            <span class="glyphicon glyphicon-chevron-right"></span>
            <span class="sr-only">Next</span>
        </a>
    </div>

    <div class="col-md-12 tab-list-row" style="padding-left: 20px">
        <div class="row">
            <div class="row">
                <div class="col-md-9">
                    <span class="title-list-index">New Movie Trailer</span>
                </div>
                <div class="col-md-3" style="margin-top: 10px;">
                    <!-- Controls -->
                    <div class="controls pull-right hidden-xs">
                        <a class="left fa fa-chevron-left btn btn" href="#carousel-trailer"data-slide="prev"></a>
                        <a class="right fa fa-chevron-right btn" href="#carousel-trailer" data-slide="next"></a>
                    </div>
                </div>
            </div>
            <div id="carousel-trailer" class="carousel slide hidden-xs" data-ride="carousel">
                <div class="carousel-inner">
                    <% List<MovieDB> trailers = (List<MovieDB>) request.getAttribute("trailerList");%>
                    <div class="item active">
                        <div class="row" style="margin-left: 0px">
                            <% int indexTrailer1 = 0;%>
                            <c:forEach items="${trailerList}" var="trailerItem" varStatus="indexTrailer1">
                                <c:if test="${indexTrailer1.index <5}">
                                    <div class="col-md-2 grid-item space-float-div">
                                        <article class="entry-item" onclick="">
                                            <div class="entry-thumb">
                                                <img width="100%" height="280" src="moviesSource/mv_${trailerItem.movieId}/poster.medium.jpg"
                                                     class="attachment-360x618 size-360x618" alt="" sizes="(max-width: 360px) 100vw, 360px">
                                                <div class="right-info">
                                                    <span class="pg">
                                                        <c:choose>
                                                            <c:when test="${trailerItem.numberEpisode <= 0}">
                                                                Trailer
                                                            </c:when>
                                                            <c:when test="${trailerItem.type == false}">
                                                                ${trailerItem.quantity}
                                                            </c:when>        
                                                            <c:otherwise>
                                                                ${trailerItem.currentEpisode}/
                                                                <c:choose>
                                                                    <c:when test="${(fn:split(trailerItem.duration, ' ')[0]) =='0'}">?</c:when>
                                                                    <c:otherwise>${fn:split(trailerItem.duration, ' ')[0]}</c:otherwise>
                                                                </c:choose>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <div class="entry-time"></div>

                                                </div>
<!--                                                <span class="rate">${trailerItem.imdb}</span>-->
                                            </div>
                                            <div class="entry-content">
                                                <h4 class="entry-title">${trailerItem.title}</h4>
                                                <div class="entry-date">Release: ${trailerItem.releaseDay}</div>

                                            </div>
                                            <div class="pic-caption open-left transform">
                                                <h4 class="entry-title">
                                                    <a href="movies?id=${trailerItem.movieId}">${trailerItem.realTitle}</a>
                                                </h4>
                                                <span class="pg" style="font-size: 15px">
                                                    <c:choose>
                                                        <c:when test="${trailerItem.numberEpisode <= 0}">
                                                            Trailer
                                                        </c:when>
                                                        <c:when test="${trailerItem.type == false}">
                                                            ${trailerItem.quantity}
                                                        </c:when>        
                                                        <c:otherwise>
                                                            ${trailerItem.currentEpisode}/
                                                            <c:choose>
                                                                <c:when test="${(fn:split(trailerItem.duration, ' ')[0]) =='0'}">?</c:when>
                                                                <c:otherwise>${fn:split(trailerItem.duration, ' ')[0]}</c:otherwise>
                                                            </c:choose>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <div class="desc-mv">
                                                    <p><span>Genre: </span><% if (trailers.size() !=0 && trailers.get(indexTrailer1).getGenre() != null) {
                                                            String genre = "[" + trailers.get(indexTrailer1).getGenre() + "]";
                                                            JSONArray arr = new JSONArray(genre);
                                                            for (int i = 0; i < arr.length(); i++) {
                                                                JSONObject obj = arr.getJSONObject(i);%>
                                                        <a href="Search?searchType=filter&order=1&genreName=<%= obj.getString("genreName")%>"><%= obj.getString("genreName")%></a>,
                                                        <%}
                                                                            }%><c:if test="${trailerItem.type == true}"><a href="Search?searchType=filter&order=1&type=1">Television Series</a></c:if></p>
                                                        <p><span>Duration: </span>${trailerItem.duration}</p>
                                                    <p><span>View: </span>${trailerItem.views}</p>
                                                    <p><span>Country: </span><a href="Search?searchType=filter&order=1&countryName=${trailerItem.countryName}">${trailerItem.countryName}</a></p>
                                                </div>
                                                <a class="rate" href="${pageContext.request.contextPath}/movies?id=${trailerItem.movieId}">
                                                    <span class="glyphicon glyphicon-play"></span>
                                                </a>
                                            </div>
                                        </article>
                                    </div>
                                </c:if>
                                <%indexTrailer1++;%>
                            </c:forEach> 
                        </div>
                    </div>
                    <div class="item">
                        <div class="row" style="margin-left: 0px">
                            <% int indexTrailer2 = 0;%>
                            <c:forEach items="${trailerList}" var="trailerItem" varStatus="indexTrailer2">
                                <c:if test="${indexTrailer2.index >=5}">
                                    <div class="col-md-2 grid-item space-float-div">
                                        <article class="entry-item" onclick="">
                                            <div class="entry-thumb">
                                                <img width="100%" height="280" src="moviesSource/mv_${trailerItem.movieId}/poster.medium.jpg"
                                                     class="attachment-360x618 size-360x618" alt="" sizes="(max-width: 360px) 100vw, 360px">
                                                <div class="right-info">
                                                    <span class="pg">
                                                        <c:choose>
                                                            <c:when test="${trailerItem.numberEpisode <= 0}">
                                                                Trailer
                                                            </c:when>
                                                            <c:when test="${trailerItem.type == false}">
                                                                ${trailerItem.quantity}
                                                            </c:when>        
                                                            <c:otherwise>
                                                                ${trailerItem.currentEpisode}/
                                                                <c:choose>
                                                                    <c:when test="${(fn:split(trailerItem.duration, ' ')[0]) =='0'}">?</c:when>
                                                                    <c:otherwise>${fn:split(trailerItem.duration, ' ')[0]}</c:otherwise>
                                                                </c:choose>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <div class="entry-time"></div>

                                                </div>
<!--                                                <span class="rate">${trailerItem.imdb}</span>-->
                                            </div>
                                            <div class="entry-content">
                                                <h4 class="entry-title">${trailerItem.title}</h4>
                                                <div class="entry-date">Release: ${trailerItem.releaseDay}</div>
                                            </div>
                                            <div class="pic-caption open-left transform">
                                                <h4 class="entry-title">
                                                    <a href="movies?id=${trailerItem.movieId}">${trailerItem.realTitle}</a>
                                                </h4>
                                                <span class="pg" style="font-size: 15px">
                                                    <c:choose>
                                                        <c:when test="${trailerItem.numberEpisode <= 0}">
                                                            Trailer
                                                        </c:when>
                                                        <c:when test="${trailerItem.type == false}">
                                                            ${trailerItem.quantity}
                                                        </c:when>        
                                                        <c:otherwise>
                                                            ${trailerItem.currentEpisode}/
                                                            <c:choose>
                                                                <c:when test="${(fn:split(trailerItem.duration, ' ')[0]) =='0'}">?</c:when>
                                                                <c:otherwise>${fn:split(trailerItem.duration, ' ')[0]}</c:otherwise>
                                                            </c:choose>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <div class="desc-mv">
                                                    <p><span>Genre: </span><% if (trailers.size() !=0 && trailers.get(indexTrailer2).getGenre() != null) {
                                                            String genre = "[" + trailers.get(indexTrailer2).getGenre() + "]";
                                                            JSONArray arr = new JSONArray(genre);
                                                            for (int i = 0; i < arr.length(); i++) {
                                                                JSONObject obj = arr.getJSONObject(i);%>
                                                        <a href="Search?searchType=filter&order=1&genreName=<%= obj.getString("genreName")%>"><%= obj.getString("genreName")%></a>,
                                                        <%}
                                                                            }%><c:if test="${trailerItem.type == true}"><a href="Search?searchType=filter&order=1&type=1">Television Series</a></c:if></p>
                                                        <p><span>Duration: </span>${trailerItem.duration}</p>
                                                    <p><span>View: </span>${trailerItem.views}</p>
                                                    <p><span>Country: </span><a href="Search?searchType=filter&order=1&countryName=${trailerItem.countryName}">${trailerItem.countryName}</a></p>
                                                </div>
                                                <a class="rate" href="${pageContext.request.contextPath}/movies?id=${trailerItem.movieId}">
                                                    <span class="glyphicon glyphicon-play"></span>
                                                </a>
                                            </div>
                                        </article>
                                    </div>
                                </c:if>
                                <%indexTrailer2++;%>
                            </c:forEach> 
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-12 tab-list-row">
        <a href="#">
            <span class="title-list-index">New Movie</span>
        </a>
        <a href="Search?searchType=filter&order=1&type=0&searchname=movie"><button class="category-text pull-right">Show More</button></a>
        <% List<MovieDB> singleL = (List<MovieDB>) request.getAttribute("singleList");%>
        <div class="row" style="min-height: 300px">
            <% int indexSingle=0;%>
            <c:forEach items="${singleList}" var="detailMovie">
            <div class="col-md-2 grid-item space-float-div" style="margin-bottom: 20px">
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
                            <p><span>Genre: </span><% if(singleL.size()!=0 && singleL.get(indexSingle).getGenre() !=null){
                                        String genre = "["+singleL.get(indexSingle).getGenre()+"]";
                                        JSONArray arr = new JSONArray(genre);
                                        for(int i = 0;i<arr.length();i++){
                                            JSONObject obj = arr.getJSONObject(i);%>
                                            <a href="Search?searchType=filter&order=1&genreName=<%= obj.getString("genreName")%>"><%= obj.getString("genreName")%></a>,
                                      <%}
                                  }%></p>
                            <p><span>Duration: </span>${detailMovie.duration}</p>
                            <p><span>View: </span>${detailMovie.views}</p>
                            <p><span>Country: </span><a href="Search?searchType=filter&order=1&countryName=${detailMovie.countryName}">${detailMovie.countryName}</a></p>
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
    <div class="col-md-12 tab-list-row">
        <a href="#">
            <span class="title-list-index">New Television Series</span>
        </a>
        <a href="Search?searchType=filter&order=1&type=1&searchname=tv"><button class="category-text pull-right">Show More</button></a>
        <% List<MovieDB> multiL = (List<MovieDB>) request.getAttribute("multiList");%>
        <div class="row" style="min-height: 300px">
            <% int indexMulti=0;%>
            <c:forEach items="${multiList}" var="detailMovie">
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
                            <p><span>Genre: </span><% if(multiL.size() !=0 && multiL.get(indexMulti).getGenre() !=null){
                                        String genre = "["+multiL.get(indexMulti).getGenre()+"]";
                                        JSONArray arr = new JSONArray(genre);
                                        for(int i = 0;i<arr.length();i++){
                                            JSONObject obj = arr.getJSONObject(i);%>
                                            <a href="Search?searchType=filter&order=1&genreName=<%= obj.getString("genreName")%>"><%= obj.getString("genreName")%></a>,
                                      <%}
                                  }%><c:if test="${detailMovie.type == true}"><a href="Search?searchType=filter&order=1&type=1">Television Series</a></c:if></p>
                            <p><span>Duration: </span>${detailMovie.duration}</p>
                            <p><span>View: </span>${detailMovie.views}</p>
                            <p><span>Country: </span><a href="Search?searchType=filter&order=1&countryName=${detailMovie.countryName}">${detailMovie.countryName}</a></p>
                        </div>
                            <a class="rate" href="${pageContext.request.contextPath}/movies?id=${detailMovie.movieId}">
                            <span class="glyphicon glyphicon-play"></span>
                        </a>
                    </div>
                </article>
            </div>
            <%indexMulti++;%>
            </c:forEach>
        </div>

    </div>


</div>
<%@include file="footer.jsp" %>
<script src="public/js/jquery.min.js"></script>
<script src="public/js/loginHeader.js"></script>
<script src="public/js/bootstrap.min.js"></script>
<script src="public/js/sweetalert.js"></script>

<script>
    $(document).ready(function () {
        $("#pLatest").on('click', function () {
            $("#Latest").show();
            $("#Action, #Comedy, #Family, #Romantic").hide();
        });
        $("#pAction").on('click', function () {
            $("#Action").show();
            $("#Latest, #Comedy, #Family, #Romantic").hide();
        });
        $("#pComedy").on('click', function () {
            $("#Comedy").show();
            $("#Latest, #Action, #Family, #Romantic").hide();
        });
        $("#pFamily").on('click', function () {
            $("#Family").show();
            $("#Latest, #Action, #Comedy, #Romantic").hide();
        });
        $("#pRomantic").on('click', function () {
            $("#Romantic").show();
            $("#Latest, #Action, #Family, #Comedy").hide();
        });
    })

</script>
</body>
</html>
