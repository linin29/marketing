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
    <link href="${springMacroRequestContext.contextPath}/css/jquery-fileupload.css" rel="stylesheet">
    <link href="${springMacroRequestContext.contextPath}/css/jquery-fileupload-ui.css" rel="stylesheet">
    <link href="${springMacroRequestContext.contextPath}/css/jquery-editable-select.min.css" rel="stylesheet">
    <link href="${springMacroRequestContext.contextPath}/css/bootstrap-select.css" rel="stylesheet">
    <link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/style.css"  type="text/css">
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
</head>
<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">
	  <section class="content-wrapper" style="margin-left: 0px;">
	   	<div id="content" style="margin-left: -11px;padding-top: 1px;margin-bottom: -20px;">


<style type="text/css">
   body {padding-right:0px !important;}
   img {max-width: 100%;}
</style>
<div class="task_list">
    <section class="content_list">
        <h3>任务列表
            <small>共<span id="number">${totalCount}</span>个任务</small>
            <div class="pull-right">
                <input id="taskId" style="width:220px;" onkeyup="if(event.keyCode==13){searchTaskWithId();}"  class="form-control task_list_input" <#if taskId??> value="${taskId}"</#if> type="text" placeholder="请输入任务ID">
                <button id="searchTaskById" onclick="searchTaskWithId(0)" type="button" class="btn btn-success btn_style1">检索任务</button> 
                <input id="taskName" type="text" placeholder="请输入任务名" onkeyup="if(event.keyCode==13){searchTaskWithName();}"  <#if taskName??> value="${taskName}"</#if> class="form-control task_list_input">
                <button id="searchTask" type="button" onclick="searchTaskWithName(0)" class="btn btn-success btn_style1">检索任务</button>
            </div>
        </h3>
    </section>
    <section class="content_list">
        <table class="table table-bordered table-hover table-condensed">
              <thead>
                    <tr style="background-color:#ddd;">
                        <th>任务名</th>
                        <th>任务Id</th>
                        <th>类型</th>
                        <th>更新时间</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
              </thead>
              <tbody>
              <#list tasks as task>
                   <tr>
                       <td>${task.name!""}</td>
                       <td>${task.id!""}</td>
                       <td>${task.majorType!""}</td>
                       <td>${task.lastUpdateTime?string('yyyy-MM-dd HH:mm:ss')!""}</td>
                       <td>
                       <#if task?? && task.taskStatus=='identify_success' && task.identifySuccessTimes gt 0>
                   			${task.taskStatus}${task.identifySuccessTimes}
                   	   <#elseif task?? && (task.taskStatus !='identify_success' || task.identifySuccessTimes == 0)>
                   			${task.taskStatus}
                   	   <#else>
                   			task_init
                   		</#if>
                       </td>
                       <td><a href="${springMacroRequestContext.contextPath}/showView/${task.id}" target="_blank" class="ajax-link">查看</a></td>
                   </tr>
                   </#list>
              </tbody>
        </table>
         <div id="table_paginator" style="margin-top: -10px; margin-bottom: -10px; text-align:center; display:block;"></div>
    </section>
</div>
<script>
$(function() {
	function initPagination(currentPage, totalCount) {
		var options = {
			alignment: 'center',
	        currentPage: currentPage,
	        totalPages: Math.ceil(totalCount / dface.constants.PAGINATION_ITEMS_PER_PAGE),
	        numberOfPages: dface.constants.PAGINATION_ITEMS_PER_PAGE,
	        onPageClicked: function (event, originalEvent, type, page) {
	        	doPaginationClicked(page);
	        }
		};
		
		$('#table_paginator').bootstrapPaginator(options);
		$("#table_paginator").show();
	}
	
	function doPaginationClicked(pageNum) {
		var taskId = $("#taskId").val();
		var taskName = $("#taskName").val();
		if(taskId){
			searchTaskWithId(pageNum)
		}else if(taskName){
			searchTaskWithName(pageNum);
		}else{
			searchTask(pageNum);
		}
	}
	if(${totalCount} != 0){
		initPagination(${currentPage}, ${totalCount?c});
	}
});

function searchTaskWithId(pageNum) {
	var taskId = $("#taskId").val();
	var page = 0;
	if (pageNum) {
		page = pageNum -1;
	}
	$.ajax({
		 type: 'GET',
		 url: '${springMacroRequestContext.contextPath}/showView/task/search?pageNum=' + page +"&taskId=" + taskId,
		 success: function(data) {
		 	$("#content").html(data);
    	},
    	error: function(data) {
    		//返回500错误页面
    		$("html").html(data.responseText);
    	}
	});
}

function searchTask(pageNum) {
	var page = 0;
	if (pageNum) {
		page = pageNum -1;
	}
	$.ajax({
		 type: 'GET',
		 url: '${springMacroRequestContext.contextPath}/showView/task/search?pageNum=' + page,
		 success: function(data) {
		 	$("#content").html(data);
    	},
    	error: function(data) {
    		//返回500错误页面
    		$("html").html(data.responseText);
    	}
	});
}

function searchTaskWithName(pageNum) {
	var taskName = $("#taskName").val();
	var page = 0;
	if (pageNum) {
		page = pageNum -1;
	}
	$.ajax({
		 type: 'GET',
		 url: '${springMacroRequestContext.contextPath}/showView/task/search?pageNum=' + page +"&taskName=" +taskName,
		 success: function(data) {
		 	$("#content").html(data);
    	},
    	error: function(data) {
    		//返回500错误页面
    		$("html").html(data.responseText);
    	}
	});
}
</script>
</body>
</html>