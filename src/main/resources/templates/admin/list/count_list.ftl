<style type='text/css'>
	.tdCenter td,.thCenter th{
		text-align:center;
	}
	.col-sm-2,.col-sm-3,.col-sm-4,.col-sm-9{
		padding-right: 0px;
   		padding-left: 0px;
	}
	.lh{
		line-height: 34px;
	}
	.form-group {
	    margin-bottom: 6px;
	}
</style>
<div class="count_list">
	<div class="panel-default">
	  	<div class="panel-heading">调用统计</div>
	  	<div class="panel-body">
	    	<section class="task_list_header" style='margin-top:-20px;'>
	       	   <h3><small>本次查询共<span id="number">${totalCount}</span>条记录，<span id="number">${callingCount}</span>次调用</small>
	       	   </h3>
	   		</section>
	        <section>
				<div class='form-group' style="overflow:hidden;">			
					<div class="col-sm-4">
						<span class="control-label line-height text-center" style="float:left;line-height: 34px;" >时间段：</span>
					 	<input id="startTime" type="hidden" <#if startDate??> value="${startDate}"</#if>>
						<input id="endTime" type="hidden" <#if endDate??> value="${endDate}"</#if>>
					 	 <div style="float:left;width:38%;"  class="form-group input-group date form_datetime1 " data-date="2016-11-1" data-date-format="yyyy-mm-dd" >
					        <input class="form-control" size="16" type="text" value="" id="startDate">
					        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
					    </div>
					    <div  style="float:left;line-height: 34px" class="form-group glyphicon glyphicon-minus "></div>
					     <div style="float:left;width:38%;" class=" input-group date form_datetime2 " data-date="2016-11-1" data-date-format="yyyy-mm-dd" >
					        <input class="form-control" size="16" type="text" value="" id="endDate">
					        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
					    </div>
					</div>
					<div class="col-sm-2">
						<select id="apiName" style="width:100%;height: 34px;">
							<option value="">请选择API</option>
					     	<option value='stitcher' <#if apiName?? && apiName=='stitcher'> selected </#if>>stitcher</option>
					     	<option value='identify' <#if apiName?? && apiName=='identify'> selected </#if>>identify</option>
						</select> 
					</div>
					<div class="col-sm-2">
						<span class="col-sm-3 lh text-center">项目：</span>
			        	<div class="col-sm-9">
				            <select id="project" style="height: 34px;width: 96%;">
				                <option value="">请选择</option>
				                  <#if projects?? && (projects?size > 0)>
				                   	<#list projects as project>
				                       <option value="${project.id}" <#if projectId?? && projectId == project.id> selected </#if>>${project.name}</option>
				                   	</#list>
				                  </#if>
							</select>               
			        	</div>
					</div>
					<div class="col-sm-2">
						<span class="col-sm-3 lh text-center">品类：</span>
		                <div class="col-sm-9">
		                 	<select id="majorType" style="height: 34px;width: 96%;">
		                      	<option value="">请选择</option>
		                      	<#if majorTypes?? && (majorTypes?size > 0)>
		                   	<#list majorTypes as tempMajorType>
		                       	<option value="${tempMajorType.name}" <#if majorType?? && majorType == tempMajorType.name> selected </#if>>${tempMajorType.description}</option>
		                   	</#list>
		                  		</#if>
							</select>               
		                </div>
					</div>
				
					<div class="col-sm-2">
		  				<input id="userName" <#if userName??> value="${userName}"</#if> type="text" class="form-control" placeholder="请输入用户名">
					</div>
				</div>
				<div class="text-right" style='margin-bottom: 5px;;margin-right: 0%;'>
					<button class='btn btn-success' id="query">查询</button>
					<button class='btn btn-success' id="export">导出</button>
				</div>
			</section>
		    <section class="content_list">
		        <table class="table table-bordered table-hover">
		            <thead>
		                <tr class='thCenter' style='background-color:#ddd;'>
                    		<th style='width:15%;'>项目编码</th>
                    		<th style='width:10%;'>项目类型</th>
                    		<th style='width:10%;'>品类</th>
                   		 	<th style='width:15%;'>调用API</th>
                    		<th style='width:10%;'>调用方法</th>
                    		<th style='width:15%;'>用户</th>
                    		<th style='width:10%;'>调用日期</th>
                    		<th style='width:15%;'>调用次数</th>
		                </tr>
		            </thead>
		            <tbody>
		            <#if callings?? && (callings?size > 0)>
		              <#list callings as calling>
		                <tr class='tdCenter'>
		                    <td>${calling.projectId!""}</td>
                    		<td><#if calling.project??>${calling.project.typeStr!""}</#if></td>
                    		<td>${calling.majorTypeDesc!""}</td>
		                    <td>${calling.apiName!""}</td>
		                    <td>${calling.apiMethod!""}</td>
		                    <td>${calling.userName!""}</td>
		                    <td>${calling.callingDay!""}</td>
		                    <td>${calling.callingTimes!""}</td>
		                </tr>
		               </#list>
		             </#if>
		            </tbody>
		        </table>
		        <div id="table_paginator" style="margin-top: -20px; margin-bottom: -10px; text-align:center; display:block;"></div>
		    </section>	    	
	 	</div>
	</div>
</div>

<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/admin-count-list.js"></script>
<script type="text/javascript">
	$(function() {	
		var currentPage="${currentPage}";
		var count="${totalCount?c}";
		adminCountList._init(currentPage,count);
	});
</script>

