<div class="count_list">
    <div class="content_list">
	    <div class="task_list_header clearfix">
	        <h3 class="col-sm-4" style="padding-left:0px;">统计列表<small>本次查询共<span id="number">${totalCount}</span>条记录，<span id="number">${callingCount}</span>次调用</small></h3>
	    	<div class="col-sm-8" style="margin-top:10px;padding-right:0px;text-align: right;">
	    		<input id="startTime" type="hidden" <#if startDate??> value="${startDate}"</#if>>
				<input id="endTime" type="hidden" <#if endDate??> value="${endDate}"</#if>>
				<span style="width:8%;float:left;line-height:34px;text-align: left;margin-right: -1%;">项目：</span>
		        <div style="width:25%;float:left;margin-left: -1%;">
		            <select id="project" style="height: 34px;width: 96%;">
		                <option value="">请选择</option>
		                  <#if projects?? && (projects?size > 0)>
		                   	<#list projects as project>
		                       <option value="${project.id}" <#if projectId?? && projectId == project.id> selected </#if>>${project.name}</option>
		                   	</#list>
		                  </#if>
					</select>               
		        </div>
       	 		<span style="width:8%;float:left;line-height:34px;text-align: center;">品类：</span>
                <div style="width:27%;float:left;">
                 	<select id="majorType" style="height: 34px;width: 96%;">
                      	<option value="">请选择</option>
                      	<#if majorTypes?? && (majorTypes?size > 0)>
                   	<#list majorTypes as tempMajorType>
                       	<option value="${tempMajorType.name}" <#if majorType?? && majorType == tempMajorType.name> selected </#if>>${tempMajorType.description}</option>
                   	</#list>
                  		</#if>
					</select>               
                </div>
			 	<div style="float: left; width: 10%;line-height:34px;">时间段：</div>
			 	<div style="float: left; width: 35%;" class="form-group input-group date form_datetime1" data-date="2016-11-1" data-date-format="yyyy-mm-dd" >
			        <input class="form-control" size="16" type="text" value="" id="startDate">
			        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
			    </div>
			    <div  style="float: left;line-height: 34px;width:2%;" class="form-group glyphicon glyphicon-minus"></div>
			     <div style="float: left;width: 35%;" class=" input-group date form_datetime2" data-date="2016-11-1" data-date-format="yyyy-mm-dd" >
			        <input class="form-control" size="16" type="text" value="" id="endDate">
			        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
			    </div>
			    <div  style="float: left;width: 10%;margin-left:8%;"><button class='btn btn-success' id="query">查询</button></div>
	    	</div>
	    </div>
        <table class="table table-bordered table-hover">
            <thead>
                <tr class='tableColorSet'>
                    <th>调用API</th>
                    <th>调用方法</th>
                    <th>用户</th>
                    <th>调用日期</th>
                    <th>调用次数</th>
                </tr>
            </thead>
            <tbody>
              <#list callings as calling>
                <tr>
                    <td>${calling.apiName!""}</td>
                    <td>${calling.apiMethod!""}</td>
                    <td>${calling.userName!""}</td>
                    <td>${calling.callingDay!""}</td>
                    <td>${calling.callingTimes!""}</td>
                </tr>
                </#list>
            </tbody>
        </table>
        <div id="table_paginator" style="margin-top: -20px; margin-bottom: -10px; text-align:center; display:block;"></div>
    </div>
</div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/count_list.js"></script>
<script type="text/javascript">
	$(function() {	
		var currentPage="${currentPage}";
		var count="${totalCount?c}";
		countList._init(currentPage,count);
	});
</script>