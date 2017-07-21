<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
         <meta http-equiv="X-UA-Compatible" content="IE=edge">
         <meta name="viewport" content="width=device-width, initial-scale=1">
	<title>图麟科技海量图像/视频搜索识别开放平台</title>
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/bootstrap.css">
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/font-awesome.min.css">
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/iconfont.css">
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/jquery-jvectormap-1.2.2.css">
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/AdminLTE.css">
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/_all-skins.min.css">
	<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.min.js"></script>
	<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.noty.packaged.js" ></script>
	<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/bootstrap.js"></script>
	<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/app.min.js"></script>
	<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.ui.widget.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.form.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.iframe-transport.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.fileupload.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.fileupload-process.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.fileupload-validate.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery-editable-select.min.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/lodash.min.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/moment.min.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/masonry.pkgd.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/bootstrap-select.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/bootstrap-paginator.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/cropper.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/tunicorn-cloud.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/bootstrap-datetimepicker.min.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/bootstrap-datetimepicker.zh-CN1.js" ></script>
    <link href="${springMacroRequestContext.contextPath}/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
    <link href="${springMacroRequestContext.contextPath}/css/jquery-fileupload.css" rel="stylesheet">
    <link href="${springMacroRequestContext.contextPath}/css/jquery-fileupload-ui.css" rel="stylesheet">
    <link href="${springMacroRequestContext.contextPath}/css/jquery-editable-select.min.css" rel="stylesheet">
    <link href="${springMacroRequestContext.contextPath}/css/bootstrap-select.css" rel="stylesheet">
    <link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/admin-style.css"  type="text/css">
     <link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/cropper.css"  type="text/css">
	<style type="text/css">
		.skin-blue .sidebar-menu>li:hover>a, .skin-blue .sidebar-menu>li.active>a {
			color: #fff;
			background: #1e282c;
			border-left-color: #00a65a;
		}
		.content-wrapper, .right-side {
			min-height: 100%;
			background-color: #fff;
		}
		.navbar a:hover{
			background-color:green
		}
		.light{
			color:#fff;
		}
		.default{
			color:#8aa4af;
		}
	</style>
	<script type="text/javascript">
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
		$(function(){
			var firstMenu = $(".treeview").children("a").get(0);
			if(firstMenu){
				$(firstMenu).css("color","white");
			}
		     var listurl = "${springMacroRequestContext.contextPath}/${indexUrl}";
	         tunicorn.utils.get(listurl,function(data){
	        	 $("#content").html(data);
	         });
	     });
		var searchTaskFlg = 0;
</script>
</head>
<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">
	  <header class="main-header">
		<!- - Logo - ->
		<a href="javascript:void(0)" class="logo" style="background-color: #000;">
		  <span class="logo-lg">
			  <div>
				  <!-- <p><img src="${springMacroRequestContext.contextPath}/image/logo.png" alt="" style="height: 40px;height: 40px;float: left;width: 155px;margin-left: 47px;margin-top: -4px;"></p>
				  <p style=""></p> -->
			  </div>
		  </span>
		</a> 
		<!- - Header Navbar - ->
		<nav class="navbar navbar-static-top" role="navigation" style="background-color: #000; height: 50px;">
			<a href="#" class="glyphicon glyphicon-align-justify" data-toggle="offcanvas" role="button" style="padding:0px 15px;color:#fff;line-height: 50px;margin-top: -1px;">
				<span class="sr-only">Toggle navigation</span>
		 	</a>
		   <div class="navbar-custom-menu">
			  <ul class="nav navbar-nav" style="line-height: 50px;margin-right: 57px;">
				  <li class="dropdown " style="cursor: pointer">
					  <p style="color: #fff" class="dropdown-toggle " type="button" id="dropdownMenu1" data-toggle="dropdown">
					  	<span style="width:200px;height:25px;padding-right: 10px;">欢迎${user.userName} !</span>
					  	<img src="${springMacroRequestContext.contextPath}/image/avatar5.png" style="width:20px;height:20px;border-radius: 8px;">
					  </p>
					  <ul class="center dropdown-menu dropdown-menu-left" role="menu" aria-labelledby="dropdownMenu1" style="margin-right: -72px;text-align: center;background-color:#222d32;border: 1px #222d32 solid;margin-top:-10px">
						  <li role="presentation">
						 	<a style="color:#b8c7ce" class="menu" role="menuitem" tabindex="-1" href="javascript:void(0)" url="${springMacroRequestContext.contextPath}/admin/user/personcenter" onclick="changeMenu(this)">个人中心</a>
						 </li>
					  </ul>
				  </li>
				  <li style="margin-right: -8px;margin-left: 8px;color: #fff">|</li>
				  <li style="color: #fff"><a href="${springMacroRequestContext.contextPath}/admin/logout">注销</a></li>
			  </ul>
		   </div>
		</nav>
	  </header>
	  <aside class="main-sidebar" style="width: 230px;">
		<section class="sidebar">
		<ul class="sidebar-menu">
			<#list menus as item>
	          	<#if item.subMenus?size gt 0>
					<li class="treeview">
						<#if (item.url)??>
							<a url="${springMacroRequestContext.contextPath}${item.url}" href="javascript:void(0)" data-title="${item.name}">
						  
						   		<span >${item.name}</span><i class="fa fa-angle-left pull-right"></i>
							</a>
						<#else>	
							<a href="javascript:void(0)" data-title="${item.name}">
						   		
						   		<span >${item.name}</span><i class="fa fa-angle-left pull-right"></i>
							</a>
						</#if>
						<ul class="treeview-menu">
							<#list item.subMenus as sub>
							   <li>
								  <a style="margin-left: 15px;" url="${springMacroRequestContext.contextPath}${sub.url}" href="javascript:void(0)" data-title="${sub.name}" menu="${item.name}" submenu="${sub.name}" class="menu" onclick="changeMenu(this)">
									${sub.name}
								  </a>
							   </li>
							</#list>
						</ul>
					</li>
				<#else>
					<li class="treeview">
	            	<#if (item.url)??>
						<a url="${springMacroRequestContext.contextPath}${item.url}" href="javascript:void(0)" data-title="${item.name}" class="menu" onclick="changeMenu(this)">
					   		
					   		<span>${item.name}</span><i class="fa"></i>
						</a>
					<#else>
						<a href="javascript:void(0)" data-title="${item.name}" class="menu">
					   		
					   		<span>${item.name}</span><i class="fa"></i>
						</a>
					</#if>
					</li>
				</#if>
			</#list>
		</ul>
		</section>
	  </aside>
	  <section class="content-wrapper" >
	   	<div id="content" style="margin-left: -11px;padding-top: 1px;">
	   	</div>		
	</section>
	</div>
</body>
</html>
