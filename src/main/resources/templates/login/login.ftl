<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>海量图像/视频搜索识别开放平台管理中心 | 登录</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/bootstrap.css">
    <link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/AdminLTE.css">
  </head>
  <style type='text/css'>
  	.form-control{
  		border-radius: 17px;
  	}
  	.login-page{
  		background-image:url(/marketing/image/background.jpg);
  		background-position:center;
  		background-repeat:no-repeat;
  		background-size: 100% auto;
  	}
  	.form-group{
  		margin-bottom:25px;
  	}
  </style>
  <body class="hold-transition login-page" >
    <div class="login-box" style='margin:15% 52%;width:420px;'>   
      <div class="login-box-body" style='border-radius: 33px;background-color:#ffffff57;'>
        <p class="login-box-msg" style='color:#eeeeee;font-size:17px;'>请登录海量图像/视频搜索识别开放平台</p>
          <div class="form-group has-feedback">
            <input type="text" id="userName" name="userName" placeholder="用户名" class="form-control"><span class="iconfont icon-user form-control-feedback"></span>
          </div>
          <div class="form-group has-feedback">
            <input type="password"  id="password" name="password" placeholder="密码" class="form-control" onkeydown="checkPassword()"><span class="iconfont icon-unlock form-control-feedback"></span>
          </div>
          <div class="form-group has-feedback"><font color="red" id="errorMsg"></font></div>
          <div class="row">
            <div class="col-xs-8">
            </div>
            <div class="col-xs-4">
              <button id="button" type="submit" class="btn btn-success btn-block btn-md btn-flat"  onclick="checkLogin()">登录</button>
            </div>
          </div>
      </div>
    </div>
  </body>
  <script src="${springMacroRequestContext.contextPath}/js/jquery.min.js"></script>
  <script type="text/javascript">
	function login(){
		var userName = $("#userName").val();
		var password = $("#password").val();
		var data = {"userName":userName, "password":password};
		$.ajax({
			 type: 'POST',
			 url: 'login',
			 contentType : 'application/json',
			 data: JSON.stringify(data),
			 dataType: 'json', 
			 success: function(data) {
			 	if (data.success) {
			 		location.href="dashboard/index";
			 	} else {
			 		$('#errorMsg').text(data.errorMessage);
            	} 
        	},
        	error: function(data) {
        		//返回500错误页面
        		$("html").html(data.responseText);
        	}
		});
	}
	function checkLogin(){
		if($("#userName").val().trim()==""){
        	$('#errorMsg').text('请输入用户名');
        	return false;
        } else if ($("#password").val().trim()==""){
        	$('#errorMsg').text('请输入密码');
    		return false;
        } else {
        	login();
       }
	}
	function checkPassword(){
		var event=arguments.callee.caller.arguments[0]||window.event;
        if(event.keyCode==13){
		    $("#button").click();
		}
	}
</script>
</html>