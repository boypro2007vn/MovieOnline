<%@page import="entity.Movies"%>
<%@page import="model.MovieDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>S&E Online | Search Page</title>
        <link href="public/css/bootstrap.min.css" rel="stylesheet">
        <link href="public/css/homepage.css" rel="stylesheet">
        <link href="public/css/template.css" rel="stylesheet">       
        <link href="public/css/search.css" rel="stylesheet">
        <link href="public/css/jPages.css" rel="stylesheet">
        <link rel="stylesheet" href="public/css/sweetalert.css">
        <link href="public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    </head>
    <body>
        <%@include file="header.jsp" %>        
        <div class="container">
            <div id="myCarousel" class="carousel slide" data-ride="carousel">
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
                <a class="left carousel-control" href="#myCarousel" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="#myCarousel" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right"></span>
                    <span class="sr-only">Next</span>
                </a>
            </div>
            <div class="col-md-12 list-movie-filter" style="margin-bottom: 10px; margin-top: 20px;">
                <div class="col-md-offset-0">
                    <form id="filter-form" action="Search"> 
                        <div class="list-movie-filter-item">
                            <label class="title-filter" for="filter-sort">Order</label>
                            <select id="order-filter" name="order" class="form-control">
                                <option id="uploadDay" value="0">Upload Date</option>
                                <option id="Views" value="1">Views</option>                                
                            </select>
                        </div>
                        <div class="list-movie-filter-item">
                            <label class="title-filter" for="filter-sort">Type</label>
                            <select id="type-filter" name="type" class="form-control">
                                <option id="All" value="-1">All</option>
                                <option id="Movie" value="0">Movie</option>
                                <option id="Series" value="1">TV Series</option>                                
                            </select>
                        </div>
                        <div class="list-movie-filter-item">
                            <label class="title-filter" for="filter-sort">Genre</label>
                            <select id="genre-filter" name="genreName" class="form-control">
                                <option id="All" value="">All</option>
                                <%if (cookies == null) {
                                        for (int i = 0; i < arrGenreL.size(); i++) {%>
                                <option value="<%=arrGenreL.get(i).getGenreName()%>"><%=arrGenreL.get(i).getGenreName()%></option>
                                <%}
                                } else {
                                    for (int i = 0; i < arrGenre.length(); i++) {
                                        JSONObject obj = arrGenre.getJSONObject(i);%>
                                <option value="<%= obj.getString("genreName")%>"><%= obj.getString("genreName")%></option>
                                <%}
                                    }%>                                   
                            </select>
                        </div>
                        <div class="list-movie-filter-item">
                            <label class="title-filter" for="filter-sort">Country</label>
                            <select id="country-filter" name="countryName" class="form-control">
                                <option id="All" value="">All</option>
                                <%if (cookies == null) {
                                        for (int i = 0; i < arrCountryL.size(); i++) {%>
                                <option value="<%=arrCountryL.get(i).getCountryName()%>"><%=arrCountryL.get(i).getCountryName()%></option>
                                <%}
                                } else {
                                    for (int i = 0; i < arrCountry.length(); i++) {
                                        JSONObject obj = arrCountry.getJSONObject(i);%>
                                <option value="<%= obj.getString("countryName")%>"><%= obj.getString("countryName")%></option>
                                <%}
                                    }%>                                   
                            </select>
                        </div>
                        <div class="list-movie-filter-item">
                            <label class="title-filter" for="filter-sort">Year Release</label>
                            <select id="year-filter" name="releaseDay" class="form-control">
                                <option id="All" value="-1">All</option>                                                             
                            </select>
                        </div>
                        <div class="list-movie-filter-item">
                            <input type="hidden" name="searchType" value="filter"/>
                            <input id="filter-button" value="Filter" type="submit" class="form-control btn btn-info" style="margin-top: 32px"/>
                        </div>
                    </form>
                </div>
            </div>
            <div class="col-md-12 tab-list-row" style="padding-left: 20px">
                <a href="#">
                    <span class="title-list-index">${titleSearch}</span>
                </a>
                <c:if test="${fn:length(list) <= 0}">
                    <div class="row" style="min-height: 300px;text-align: center">
                        <h3 style="margin: 100px 0; color: goldenrod">No Movie Found</h3>
                    </div>
                </c:if>
                <c:if test="${fn:length(list) > 0}">
                    <div id="itemContainer" class="row">
                        <% int indexSingle = 0;%>
                        <% List<MovieDB> searchList = (List<MovieDB>) request.getAttribute("list"); %>
                        <c:forEach items="${list}" var="detailMovie">
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
                                            <p><span>Genre: </span><% if (searchList.size() != 0 && searchList.get(indexSingle).getGenre() != null) {
                                                    String genre = "[" + searchList.get(indexSingle).getGenre() + "]";
                                                    JSONArray arr = new JSONArray(genre);
                                    for (int i = 0; i < arr.length(); i++) {
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
                            <%indexSingle++;%>
                        </c:forEach>
                    </div>
                    <div class="holder"></div>
                </c:if>
            </div>
        </div>
        <%@include file="footer.jsp" %>
        <script src="public/js/jquery.min.js"></script>
        <script src="public/js/loginHeader.js"></script>
        <script src="public/js/bootstrap.min.js"></script>
        <script src="public/js/sweetalert.js"></script>
        <script src="public/js/js.cookie.js"></script>
        <script src="public/js/jPages.js"></script>
        <script>
            var max = new Date().getFullYear(),
                    min = max - 10,
                    select = document.getElementById('year-filter');
            for (var i = max; i >= min; i--) {
                var opt = document.createElement('option');
                opt.value = i;
                opt.innerHTML = i;
                select.appendChild(opt);
            }
            $(function() {

                $("div.holder").jPages({
                    containerID: "itemContainer",
                    perPage: 15
                });

            });
        </script>
    </body>
</html>
