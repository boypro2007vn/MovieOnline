$(function() {
    var formloginheader = $('#login-nav');
    if (formloginheader) {
        formloginheader.submit(function(e) {
            e.preventDefault();
            $.ajax({
                type: 'POST',
                url: "loginTemplate",
                data: formloginheader.serialize(),
                success: function(data) {
                    if (data == 'success') {
                        $('#error-login-header').html('')
                        $('#login-username-header').removeClass('has-error')
                        $('#login-password-header').removeClass('has-error')
                        window.location.reload();
                    } else {
                        $('#error-login-header').html(data)
                        $('#login-username-header').addClass('has-error')
                        $('#login-password-header').addClass('has-error')
                    }
                },
                error: function() {
                    swal("Request Failed!", "Cannot send request!", "error");
                }
            });
        });
        $('#btnLoginHeader').on('click', function() {
            if ($('#loginUsername').val() != '' && $('#loginPassword').val() != '') {
                formloginheader.trigger('submit');
            } else {
                $('#error-login-header').html('Please enter username and password');
            }
        })
    }

});

function removeWhiteSpace(text) {
    var textStrim = text.trim();
    return text.trim().replace(/\s+/g, ' ');
}
var pat1 = /^[a-zA-Z0-9 :()ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠ-ỹ]{1,200}$/;
function validateSearch() {
    var searchContent = document.getElementById("searchContent");
    if (!pat1.test(removeWhiteSpace(searchContent.value))){
        swal("Opps!!!", "Please enter at least 1 character and maximum 200 characters to search", "error");
        return false;
    }
    return true;
}


