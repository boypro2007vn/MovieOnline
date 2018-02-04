<footer  id="footer-Section" style="margin-top: 50px; border: 2px; border-top-color: #f15f24">
    <div class="footer-top-layout">
        <div class="container">
            <div class="row">

                <div class=" col-lg-12 col-lg-offset-0">
                    <div class="OurBlog col-sm-4">
                        <h4>S&E ONLINE</h4>
                        <p>Current time</p>
                        <div class="post-blog-date" id="post-blog-date">

                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="footer-col-item">
                            <h4>Address</h4>
                            <address>
                                <span style="color: gray">590 Cach Mang Thang Tam</span><br>
                                <span style="color: gray">Ward 11, District 3, VN</span>
                            </address>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="footer-col-item">
                            <h4>Contact Us</h4>
                            <div class="item-contact"> <a href="tel:+84983393839"><span class="link-id">P</span>:<span>+84983.39.38.39</span></a>  <a href="mailto:info@brandcatmedia.com"><span class="link-id">E</span>:<span>contact@seonline.com</span></a> </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <div class="footer-bottom-layout">        
        <div class="copyright-tag">Copyright � 2017 S&E Online. All Rights Reserved.</div>
    </div>
</footer>
<script>
                                function startTime() {
                                    var today = new Date();
                                    var h = today.getHours();
                                    var m = today.getMinutes();
                                    var s = today.getSeconds();
                                    m = checkTime(m);
                                    s = checkTime(s);
                                    document.getElementById("post-blog-date").innerHTML =
                                            h + ":" + m + ":" + s;
                                    var t = setTimeout(startTime, 500);
                                }
                                function checkTime(i) {
                                    if (i < 10) {
                                        i = "0" + i;
                                    }  // add zero in front of numbers < 10
                                    return i;
                                }
                                startTime();
</script>