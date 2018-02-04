<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>S&E Online | Download Movie</title>

    <!-- Bootstrap core CSS -->
    <link href="public/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="public/css/sweetalert.css?ver=1.1">
    <link href="public/css/movie.css" rel="stylesheet">
    <link href="public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
</head>
<body>
<%@include file="header.jsp" %>
<div class="container">
    <input id="sessionUser" type="hidden" value="${sessionScope.user.accountId}"/>
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
            <ol class="breadcrumb bg-div" itemscope itemtype="http://schema.org/BreadcrumbList">
                <li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
                    <a itemprop="item" title="S&E Online" href="./" itemprop="url">
                        <span itemprop="name">S&E Online</span>
                        <meta itemprop="position" content="1" />
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
                    <a itemprop="item" title="USA" href="Search?searchType=filter&order=1&countryName=${detailMovie.countryId.countryName}" itemprop="url">
                        <span itemprop="name">${detailMovie.countryId.countryName}</span>
                        <meta itemprop="position" content="3" />
                    </a>
                </li>
                <li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
                    <a itemprop="item" title="${detailMovie.realTitle}" href="movies?id=${detailMovie.movieId}" itemprop="url">
                        <span itemprop="name">${detailMovie.realTitle}</span>
                        <meta itemprop="position" content="4" />
                    </a>
                </li>
                <li class="active">Download</li>
            </ol>
        </div>
    </div>

    <div class="bg-div">
        <div class="row down-title">
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                <input type="hidden" id="movieId" name="movieId" value="${detailMovie.movieId}"/>
                <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
                    <div class="img-movie">
                        <img src="moviesSource/mv_${detailMovie.movieId}/poster.medium.jpg" class="img-thumbnail">
                        <div class="btn-background"></div>
                        <div class="btn-button" style="margin: 0 auto;width: 50%; bottom: 10%">
                            <a href="${pageContext.request.contextPath}/watchmovie?id=${detailMovie.movieId}" class="btn btn-danger">Watch Movie</a>
                        </div>

                    </div>
                </div>
                <div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
                    <h2 CLASS="m_title">${detailMovie.title}</h2>
                    <div class="row">
                        <div class="col-xs-9 col-sm-9 col-md-9 col-lg-9">
                            <span style="color: blanchedalmond">${detailMovie.realTitle}</span>
                        </div>
                        <div class="col-xs-3 col-sm-3 col-md-3 col-lg-3" style="text-align: right">
                            <button id="boomarkbtn" class="btn btn-primary btn-xs"><span class="glyphicon glyphicon-plus-sign"></span>Add to Movie Box</button>
                        </div>
                    </div>


                    <hr>
                    <div style="background-color: black">
                        <input type="checkbox" class="read-more-state" id="post-1" />
                        <p class="read-more-wrap">${fn:substring(detailMovie.description, 0, 300)}
                            <span class="read-more-target">${fn:substring(detailMovie.description, 300,detailMovie.description.length())}</span>
                            <label for="post-1" class="read-more-trigger">Show</label></p>

                    </div>

                </div>
            </div>
        </div>
        <div class="row down-title black">
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                <h2 CLASS="m_rating" style="margin: 1%">DOWNLOAD LINK</h2>
                <hr>
                <p class="white">To download movie to computer, you need to enter verify code then press "Get link download". Link of movie will show to you. But only you can download SD version</p>
                <p></p>
                <div class="row" id="link-content">
                    <div class="col-xs-11 col-sm-11 col-md-11 col-lg-11">
                        <table id="table-content" class="table table-bordered white" style="display:none">
                            <thead>
                                <tr>
                                  <th>Language</th>
                                  <th>Episode</th>
                                  <th>Link download</th>
                                </tr>
                            </thead>
                            <tbody id="table-content">
                                <c:forEach items="${episode}" var="item">
                                    <tr>
                                        <td>${item.language}</td>
                                        <td>${item.episodeName}</td>
                                        <td><a href="${pageContext.request.contextPath}/download?action=68ff63fb82e0e5dfec2a8496bf9afef608ad639ed552e740268eb537fa52067f&id=${item.episodeId}&res=360">SD-360p</a> | 
                                            <a href="${pageContext.request.contextPath}/download?action=68ff63fb82e0e5dfec2a8496bf9afef608ad639ed552e740268eb537fa52067f&id=${item.episodeId}&res=480">SD-480p</a></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="row" style="padding: 2%">
                    <div id="validateCapcha" class="form-group">
                        <label class="white">Capcha: <span id="errorText" style="color: red"></span></label>
                        <div class="row">
                            <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
                                <input id="txtCapcha" type="text" class="form-control"/>
                            </div>
                            <div class="col-xs-1 col-sm-1 col-md-1 col-lg-1">
                                <img id="capchaImage" style="display:none" src="public/images/capcha.png" crossorigin="anonymous"/>
                                <canvas id="canvasCapcha" width="60" height="34"></canvas>
                            </div>
                            <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
                                <button id="btnGetLink" class="btn btn-primary" style="float: right">Get link download</button>
                            </div>
                        </div>
                    </div>
                </div>
                <p></p>
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
</div><!-- /.container -->
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
        var userId = $('#sessionUser').val();
        var movieId = $('#movieId').val();
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
        var capchaNum=0;
        var canvas = document.getElementById("canvasCapcha");
        var ctx = canvas.getContext("2d");
        $('#capchaImage').on('load',function(){
            canvas.crossOrigin = "Anonymous";
            ctx.drawImage($('#capchaImage').get(0),0,0);
        })
        function getRandomNum(){
            capchaNum = Math.floor((Math.random() * 8999) + 1000);
            ctx.clearRect(0,0,canvas.width,canvas.height);
            ctx.drawImage($('#capchaImage').get(0), 0, 0);
            ctx.fillStyle = "red";
            ctx.font="20px Arial";
            ctx.fillText(capchaNum,8,25);
        }
        getRandomNum();
        $('#refreshCapcha').click(function(){
            getRandomNum();
        })
        $('#btnGetLink').click(function(){
            $('#errorText').html('');
            if($('#txtCapcha').val() != capchaNum){
                $('#errorText').html("Wrong capcha, Please re-enter")
                getRandomNum();
            }else{
                $('#validateCapcha').css("display","none")
                $('#table-content').css("display","")
            }
        })
    })
</script>
</body>
</html>

