<div class="task_list">
    <section class="task_list_header">
        <h3>任务列表
            <small>共<span id="number">${totalCount}</span>个任务</small>
            <div class="pull-right">
                <input id="searchTaskflg" type="hidden" value="0">
            
                <input id="taskId" style="width:220px;" onkeyup="if(event.keyCode==13){searchTaskWithId();}"  class="form-control task_list_input" <#if taskId??> value="${taskId}"</#if> type="text" placeholder="请输入任务ID">
                <button id="searchTaskById" onclick="searchTaskWithId(0)" type="button" class="btn btn-success btn_style1">检索任务</button> 
                <input id="taskName" type="text" placeholder="请输入任务名" onkeyup="if(event.keyCode==13){searchTaskWithName();}"  <#if taskName??> value="${taskName}"</#if> class="form-control task_list_input">
                <button id="searchTask" type="button" onclick="searchTaskWithName(0)" class="btn btn-success btn_style1">检索任务</button>
                <a href="javascript:void(0)" onclick ="addTask()" class="ajax-link"><button id="merge" type="button" class="btn btn-success">新建任务</button></a>
            </div>
        </h3>
    </section>
    <section class="content_list">
        <table class="table table-bordered table-hover table-condensed">
              <thead>
                    <tr>
                        <th>任务名</th>
                        <th>任务Id</th>
                        <th>类型</th>
                        <th>创建时间</th>
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
                       <td>${task.createTime!""}</td>
                       <td>${task.taskStatus!""}</td>
                       <td><a href="javascript:void(0);" onclick="getTaskDetail('${task.id}')" class="ajax-link">查看</a></td>
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
		if(searchTaskFlg == 1){
			searchTaskWithId(pageNum)
		}else if(searchTaskFlg == 2){
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
	searchTaskFlg = 1;
	var taskId = $("#taskId").val();
	var page = 0;
	if (pageNum) {
		page = pageNum -1;
	}
	$.ajax({
		 type: 'GET',
		 url: '${springMacroRequestContext.contextPath}/task/search?pageNum=' + page +"&taskId=" + taskId,
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
		 url: '${springMacroRequestContext.contextPath}/task/search?pageNum=' + page,
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
	searchTaskFlg = 2;
	var taskName = $("#taskName").val();
	var page = 0;
	if (pageNum) {
		page = pageNum -1;
	}
	$.ajax({
		 type: 'GET',
		 url: '${springMacroRequestContext.contextPath}/task/search?pageNum=' + page +"&taskName=" +taskName,
		 success: function(data) {
		 	$("#content").html(data);
    	},
    	error: function(data) {
    		//返回500错误页面
    		$("html").html(data.responseText);
    	}
	});
}

function getTaskDetail(taskId) {
	$.ajax({
		 type: 'GET',
		 url: '${springMacroRequestContext.contextPath}/showTask/' + taskId,
		 success: function(data) {
		 	$("#content").html(data);
    	},
    	error: function(data) {
    		//返回500错误页面
    		$("html").html(data.responseText);
    	}
	});
}

function addTask() {
	$.ajax({
		 type: 'GET',
		 url: '${springMacroRequestContext.contextPath}/showTask/-1',
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