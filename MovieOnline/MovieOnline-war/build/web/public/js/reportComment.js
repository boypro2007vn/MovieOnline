function actionReportComment(){
    $('#sel1ErrorComment').on('change', function() {
        if ($(this).val() == 5) {
            $('#errorOtherComment').css('display', 'block');
        } else {
            $('#errorOtherComment').css('display', 'none');
        }
    });
    var commentUser = $('#comment-div');
    var commentUserId;
    
    var capchaNum = 0;
    var commentId;
    var canvas = document.getElementById("canvasCapchaComment");
    if(canvas==null){
        return;
    }
    var ctx = canvas.getContext("2d");
    $('#capchaImageComment').on('load', function() {
        canvas.crossOrigin = "Anonymous";
        ctx.drawImage($('#capchaImageComment').get(0), 0, 0);
    });

    function getRandomNum() {
        capchaNum = Math.floor((Math.random() * 8999) + 1000);
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.drawImage($('#capchaImageComment').get(0), 0, 0);
        ctx.fillStyle = "red";
        ctx.font = "20px Arial";
        ctx.fillText(capchaNum, 8, 25);
    }
    
    $('a[name=btnReportComment]').click(function() {
        getRandomNum();
        $('#errorReportComment').html('');
        $('#sel1ErrorComment').val("1");
        $('#errorOtherComment').css('display', 'none');
        $('#errorOtherBodyComment').val("");
        $('#capchaInputComment').val('');
        $('#reportModalComment').modal('show');
        commentId = $(this).attr('id');
        commentUserId = $(this).closest('.media-body').find('[name="commentUserId"]').val();        
    })

    $('#refreshCapchaComment').click(function() {
        getRandomNum();
    })

    $('#reportSubmitComment').click(function() {
        var option = $('#sel1ErrorComment').val();
        $('#errorReportComment').html('');
        if (option == 5) {
            if (removeWhiteSpace($('#errorOtherBodyComment').val()).length < 10) {
                $('#errorReportComment').html("Please enter content greater than 10 characters");
                return;
            }
        }
        if ($('#capchaInputComment').val() != capchaNum) {
            $('#errorReportComment').html("Wrong captcha. Please re-enter");
            getRandomNum();
            return;
        }
       $('#reportFormComment').trigger('submit');

    })
    
    $('#reportFormComment').submit(function(e) {
        e.preventDefault();
        $.ajax({
            type: 'POST',
            url: "ReportComment",
            data: {type: "createReport",commentId: commentId ,commentUserId: commentUserId,typeError: $('#sel1ErrorComment').val(), content: $('#errorOtherBodyComment').val(),title:"REPORT COMMENT"},
            success: function(data) {
                if (data == 'true') {
                    swal("Failed!", "Cannot sent your report. Please try again!", "error");
                    getRandomNum();
                } else {
                    if (data == 'spam') {
                        swal("Warning!", "You only send report every 15 minutes", "warning");
                    } else {
                        swal("Success!", "Thank for your report! We will check it as soon as", "success");
                        $('#reportModalComment').modal('hide');
                    }
                }
            },
            error: function() {
                swal("Failed!", "Cannot sent your report. Something wrong!", "error");
                getRandomNum();
            }
        });
    });
};


