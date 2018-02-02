<div class="task_list">
    <div class="content_list">
    	<div class="task_list_header clearfix" >
	       <h3 class="col-sm-3" style="padding:0px;width:15%;">任务列表
	           <small>共<span id="number">${totalCount}</span>个任务</small>
	        </h3>
	        <div  class="col-sm-8" style="margin-top:10px;padding-right:0px;width:85%;text-align: right;">
	            <input id="searchTaskflg" type="hidden" value="0">
	            <input id="taskId" style="width:20%;" onkeyup="if(event.keyCode==13){taskList.searchTaskWithId();}"  class="form-control task_list_input" <#if taskId??> value="${taskId}"</#if> type="text" placeholder="请输入任务ID">
	            
	            <button id="searchTaskById" onclick="taskList.searchTaskWithId(0)" type="button" class="btn btn-success btn_style1">检索任务</button>
	            <select id="projectId" style="height: 34px;width:20%;">
	               	<option value="">请选择项目编码</option>
		            <#if projects?? && (projects?size > 0)>
		               <#list projects as project>
		               	<option value="${project.id}" <#if projectId?? && project.id==projectId> selected</#if>>${project.name}</option>
		           	   </#list>
		          	</#if>
			 	</select>
	            <select id="majorType" style="height: 34px;width:20%;">
	               <option value="">请选择品类</option>
	                 <#if majorTypes?? && (majorTypes?size > 0)>
	                   <#list majorTypes as tempMajorType>
	                   	<option value="${tempMajorType.name}" <#if majorType?? && majorType == tempMajorType.name> selected </#if>>${tempMajorType.description}</option>
	               	   </#list>
	              	 </#if>
			 </select>  
	            <input style="width:17%;" id="taskName" type="text" placeholder="请输入任务名" onkeyup="if(event.keyCode==13){taskList.searchTaskWithName();}"  <#if taskName??> value="${taskName}"</#if> class="form-control task_list_input">
	            <button id="searchTask" type="button"  onclick="taskList.searchTaskWithName(0)" class="btn btn-success btn_style1">检索任务</button>
	            <a href="javascript:void(0)" onclick ="taskList.addTask()" class="ajax-link"><button id="merge" type="button" class="btn btn-success" >新建任务</button></a>
	        </div>    
    	</div>
	    <table class="table table-bordered table-hover ">
	          <thead>
	                <tr class='tableColorSet'>
	                    <th style="width:25%">任务名</th>
	                    <th style="width:20%">任务Id</th>
	                    <th style="width:15%">类型</th>
	                    <th style="width:15%">更新时间</th>
	                    <th style="width:15%">状态</th>
	                    <th style="width:10%">操作</th>
	                </tr>
	          </thead>
	          <tbody>
	          <#list tasks as task>
	               <tr>
	                   <td style="word-break: break-all;">${task.name!""}</td>
	                   <td>${task.id!""}</td>
	                   <td>${task.majorTypeName!""}</td>
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
	                   <td><a href="javascript:void(0);" onclick="taskList.getTaskDetail('${task.id}')" class="ajax-link">查看</a></td>
	               </tr>
	               </#list>
	          </tbody>
	    </table>
    	<div id="table_paginator" style="margin-top: -20px; margin-bottom: -10px; text-align:center; display:block;"></div>
    </div>
</div>

<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/task_list.js"></script>
<script type="text/javascript">
	$(function() {	
		var currentPage="${currentPage}";
		var totalCount="${totalCount?c}";
		taskList._init(currentPage, totalCount);
	});
</script>
