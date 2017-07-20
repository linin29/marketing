<!DOCTYPE html>
<html>
	<head>
		<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.min.js" ></script>
		<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/bootstrap.css">
		<meta http-equiv="cache-control" content="no-cache">
		<title>图麟云平台</title>
	</head>
	<body>
		请求资源不存在，3秒后将自动返回<a href="
		<#if springMacroRequestContext.requestUri?index_of('/admin')==-1>
			${springMacroRequestContext.contextPath}/dashboard/index
		<#else>
			${springMacroRequestContext.contextPath}/admin/dashboard/index
		</#if>" class="text-center">主页</a>
	</body>
</html> 
<script>  
	function jump(){  
	  location= "<#if springMacroRequestContext.requestUri?index_of('/admin')==-1>${springMacroRequestContext.contextPath}/dashboard/index<#else>${springMacroRequestContext.contextPath}/admin/dashboard/index</#if>";  
	}  
	setTimeout('jump()',3000);  
</script>    