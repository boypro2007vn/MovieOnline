<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>Title</title>

        <link href="./public/css/bootstrap.min.css" rel="stylesheet">
        <link href="./public/css/metisMenu.min.css" rel="stylesheet">
        <link href="./public/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">
        <link href="./public/datatables-responsive/dataTables.responsive.css" rel="stylesheet">
        <link href="./public/css/sb-admin-2.css" rel="stylesheet">
        <link href="public/css/sweetalert.css" rel="stylesheet">
        <link href="./public/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <body>

        <div id="wrapper">

            <!-- Navigation -->
            <%@include file="admin_header.jsp" %>

            <div id="page-wrapper">
                <div class="row page-header">
                    <div>
                        <strong class="title-header"><i class="fa fa-home fa-title"></i> <a class="text-black" href="${pageContext.request.contextPath}/admin">Dashboard</a></strong><span style="color: gray"> / Insert VIP Package</span>
                    </div>
                </div>


                <!--Noi dung-->
                <div class="row" style="margin-top: 150px">
                    <form class="form-horizontal" id="insertVipForm">
                        <fieldset>
                            <!-- Form Name -->
                            <!-- Text input-->
                            <div class="form-group" id="viptype-div">
                                <label class="col-md-4 control-label" for="viptype">VIP Package Name</label>  
                                <div class="col-md-4">
                                    <input id="viptype" name="viptype" type="text" required="" onkeyup="validateKeyUp(this)" placeholder="Input VIP Type Name" class="form-control input-md">
                                    <span id="error-msg-viptype" class="text-danger" style="margin: 5px;display: none">Package Name is required. Must be 4 to 100 characters long</span>
                                </div>
                            </div>

                            <!-- Text input-->
                            <div class="form-group" id="duration-div">
                                <label class="col-md-4 control-label" for="Duration">Duration</label>  
                                <div class="col-md-4">
                                    <input name="duration" id="duration" type="number" required="" onkeyup="validateKeyUp(this)" class="form-control" style="width: 50%;float: left" value="0">
                                    <label for="durationType" style="margin: 7px 12px;font-weight: normal">Days</label>                                    
                                    <span id="error-msg-duration" class="text-danger" style="margin: 5px;display: none">Please enter duration. Must be positive number</span>
                                </div>
                            </div>

                            <!-- Text input-->
                            <div class="form-group" id="price-div">
                                <label class="col-md-4 control-label" for="price">Price</label>  
                                <div class="col-md-4">
                                    <input id="price" name="price" type="text" required="" onkeyup="validateKeyUp(this)" style="width: 50%;float: left" placeholder="Input Price" class="form-control">
                                    <label for="priceType" style="margin: 7px 12px;font-weight: normal">VND</label>  
                                    <span id="error-msg-price" class="text-danger" style="margin: 5px;display: none">Please enter price. Must be positive number and lower than 10000000</span>                                                                      
                                </div>
                            </div>

                            <!-- Button -->
                            <div class="form-group">
                                <label class="col-md-4 control-label" for="Submit"></label>
                                <div class="col-md-4">
                                    <button name="action" value="insert" type="button" class="btn btn-primary insert-vip">Submit</button>
                                    <input style="margin-left: 20px" name="reset" type="reset" class="btn btn-primary" value="Reset"/>                                    
                                </div>
                            </div>

                        </fieldset>
                    </form>

                </div>
                
                
                <!--Noi dung-->


            </div>
        </div>
        <!-- /#wrapper -->

        <script src="./public/js/jquery.min.js"></script>
        <script src="./public/js/jquery.priceformat.min.js"></script>
        <script src="./public/js/bootstrap.min.js"></script>
        <script src="./public/js/metisMenu.min.js"></script>
        <script src="./public/js/raphael.min.js"></script>
        <script src="./public/datatables/js/jquery.dataTables.min.js"></script>
        <script src="./public/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="./public/datatables-responsive/dataTables.responsive.js"></script>
        <script src="./public/js/sb-admin-2.js"></script>
        <script src="./public/js/insert-vip-validate.js"></script>
        <script src="public/js/sweetalert.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
            
            $('#price').priceFormat({
                prefix: '',
                thousandsSeparator: ',',
                centsSeparator: '.',
                centsLimit: 0
            });
            var frm = $('#insertVipForm');
            frm.submit(function (e) {
                e.preventDefault();
                $.ajax({
                    type: 'POST',
                    url: "AdminInsertVip",
                    data: frm.serialize(),
                    success: function (data) {                        
                            if (data == 'true'){
                                swal("Failed", "Create new VIP package failed. Something wrong","error");
                            } else{
                                if (data == 'false'){
                                    $('input[name=reset]').click();
                                    swal("Success", "You have been create new VIP package success.","success")                                            
                                }else if(data == 'duplicate'){
                                    swal('Duplicate Package Name', 'The Package name is already existed. Try it again',"error");
                                }else{
                                    swal('An error occurred while processing the request', 'Something error when create new VIP package. Try it again',"error");
                                    }
                                    }
                                    },
                                    error: function () {
                                    swal('An error occurred while processing the request', 'Something error when create new VIP package. Try it again',"error");
                                    }    
                    });
                });
                    $(".insert-vip").click(function (e) {
                            validateUpload();
                            if(!$('div[class*="has-error"]').html()){
                               frm.trigger('submit');
                            }
                        });
                    });
        </script>
    </body>
</html>
