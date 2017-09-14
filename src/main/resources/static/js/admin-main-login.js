var m_url='/marketing/';
var mp=mp || {};
mp=(function(){
	 var searchTaskFlg = 0;
     function init(indexUrl){
    	var firstMenu = $(".treeview").children("a").get(0);
		if(firstMenu){
			$(firstMenu).css("color","white");
		}
	     var listurl = m_url+indexUrl;
	     tunicorn.utils.get(listurl,function(data){
	    	 $("#content").html(data);
	     });
	    
     };
 
     function changeMenu(obj){
			var intervalId = $('body').data('alert_info_interval_id');
			if(intervalId) {
				clearInterval(intervalId);
				$('body').removeData('alert_info_interval_id');
			}
			var intervalId2 = $('body').data('alert_info_interval_id2');
			if(intervalId2) {
				clearInterval(intervalId2);
				$('body').removeData('alert_info_interval_id2');
			}
			
			var url = $(obj).attr('url');
			var allLinks =$(obj).parents('.sidebar').find('a');
			var center =$(obj).parents('.center').find('a');
			center.css("color", "#b8c7ce");
			allLinks.css("color", "#8aa4af");
			 	$(obj).css("color", "#fff");
		    tunicorn.utils.get(url, function(data){
		    	$("#content").html(data);
		     });
		 }
	 
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
     	
     return {
          _init:init,
          changeMenu:changeMenu,
          checkLogin:checkLogin,
          checkPassword:checkPassword
     }

})()
