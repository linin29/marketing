<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>图麟科技</title>
		<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
		<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/bootstrap.css">
		<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/bootstrap-select.css">
		<link rel="stylesheet" type="text/css" href="${springMacroRequestContext.contextPath}/css/admin-style.css"/>
		<script src="${springMacroRequestContext.contextPath}/js/jquery.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="${springMacroRequestContext.contextPath}/js/bootstrap.js" type="text/javascript" charset="utf-8"></script>
		<script src="${springMacroRequestContext.contextPath}/js/bootstrap-select.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body style="background-color: #d2d6de;">
		<div id="loginBox">
			<div class="form-group">
                <h3 style="margin-bottom: 35px;text-align: center;">请登录海量图像/视频搜索识别后台</h3>
            </div>
            <div class="form-group">
                <input type="text" id="userName" name="userName"  class="form-control" value=""placeholder="请输入用户名" />
            </div>
            <div class="form-group">
                <input type="password" id="password" name="password" onkeydown="checkPassword()"  class="form-control"  value="" placeholder="请输入密码" />
            </div>
            <div><font color="red" id="errorMsg"></font></div>
			<button id="button" class="btn btn-success pull-right" onclick="checkLogin()"> 登录</button>
		</div>	
	</body>
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