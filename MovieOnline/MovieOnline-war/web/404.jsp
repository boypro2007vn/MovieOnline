
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<head>
	<meta charset="utf-8">
	<!-- Set the viewport width to device width for mobile -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Page not found | InVision</title>

	<!-- Meta -->
	<meta name="description" content="InVision lets you transform your designs into beautiful, interactive web &amp; mobile (iOS, Android) mockups and prototypes!">
	<meta name="google-site-verification" content="Nq_Yj3Q_tSPxLPiBNkk_JXHlogQlR6XK7YNWXRlS2T0">

	<!-- typekit -->
	<script type="text/javascript">
		(function(d) {
			var config = {
			kitId: 'tdi5ghm',
			scriptTimeout: 3000
		},
		h=d.documentElement,t=setTimeout(function(){h.className=h.className.replace(/\bwf-loading\b/g,"")+" wf-inactive";},config.scriptTimeout),tk=d.createElement("script"),f=false,s=d.getElementsByTagName("script")[0],a;h.className+=" wf-loading";tk.src='//use.typekit.net/'+config.kitId+'.js';tk.async=true;tk.onload=tk.onreadystatechange=function(){a=this.readyState;if(f||a&&a!="complete"&&a!="loaded")return;f=true;clearTimeout(t);try{Typekit.load(config)}catch(e){}};s.parentNode.insertBefore(tk,s)})(document);
	</script>

<!--	<link href='//fonts.googleapis.com/css?family=Open+Sans:300' rel='stylesheet' type='text/css'>-->

	<!-- Included CSS Files -->
	<link rel="stylesheet" href="public/css/404.css" />
</head>

<body class="error404">

	<div class="error-message-container">

		<a href="/" class="logo"></a>

		<div class="error-message">
                        <c:choose>
                           <c:when test="${errorTitle!=null}">
                               <p class="title">${errorTitle}</p>
                           </c:when>
                           <c:otherwise>
                                <p class="title">Page Not Found</p>
                           </c:otherwise>
                        </c:choose>
                        <c:choose>
                           <c:when test="${errorBody!=null}">
                               <p class="message">${errorBody}</p>
                           </c:when>
                           <c:otherwise>
                                <p class="message">The link you clicked may be broken or the page may have been removed.</p>
                           </c:otherwise>
                        </c:choose>        
                        <p class="small">${alrt}visit the <a href="${pageContext.request.contextPath}/home">homepage</a> or <a href="${pageContext.request.contextPath}/home" title="Learn more about InVision">contact us</a> about the problem</p>
		</div>

	</div>

</body>
</html>


