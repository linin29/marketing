<style type='text/css'>
	.tdCenter td,.thCenter th{
		text-align:center;
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
				<div class='form-group'>			
					<div style="float:left;width:43%;">
						<span class="control-label line-height text-center" style="float:left;width:22%;line-height: 34px;" >时间段：</span>
					 	<input id="startTime" type="hidden" <#if startDate??> value="${startDate}"</#if>>
						<input id="endTime" type="hidden" <#if endDate??> value="${endDate}"</#if>>
					 	 <div style="float:left;width:36%;"  class="form-group input-group date form_datetime1 " data-date="2016-11-1" data-date-format="yyyy-mm-dd" >
					        <input class="form-control" size="16" type="text" value="" id="startDate">
					        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
					    </div>
					    <div  style="float:left;line-height: 34px" class="form-group glyphicon glyphicon-minus "></div>
					     <div style="float:left;width:36%;" class=" input-group date form_datetime2 " data-date="2016-11-1" data-date-format="yyyy-mm-dd" >
					        <input class="form-control" size="16" type="text" value="" id="endDate">
					        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
					    </div>
					</div>
					<div style="float:left;width:15%;margin-right:1%;">
						<select id="apiName" style="width:100%;height: 34px;">
							<option value="">请选择API</option>
					     	<option value='stitcher' <#if apiName?? && apiName=='stitcher'> selected </#if>>stitcher</option>
					     	<option value='identify' <#if apiName?? && apiName=='identify'> selected </#if>>identify</option>
						</select> 
					</div>
					<div style="float:left;width:15%;margin-right:1%;">
						<select id="skuType" style="width:70%;height: 34px;">
							<option value="">请选择类型</option>
							<#if majorTypes?? && (majorTypes?size > 0)>
			       			  <#list majorTypes as majorType>
			     		 		<option value='${majorType.name}' <#if initMajorType??&&  majorType.name=='${initMajorType}'> selected </#if>>${majorType.description}</option>
			    			  </#list>
		   					</#if>
						</select> 
					</div>
					<div style="float:left;width:15%;margin-right:1%;">
		  				<input id="userName" <#if userName??> value="${userName}"</#if> type="text" class="form-control" placeholder="请输入用户名">
					</div>
				</div>
				<div class="text-right" style='margin-right:35px;margin-right: 0%;'>
					<button class='btn btn-success' id="query">查询</button>
				</div>
			</section>
		    <section class="content_list">
		        <table class="table table-bordered table-hover">
		            <thead>
		                <tr class='thCenter' style='background-color:#ddd;'>
		                    <th style='width:17%;'>调用API</th>
		                    <th style='width:17%;'>调用方法</th>
		                    <th style='width:17%;'>用户</th>
		                    <th style='width:15%;'>类型</th>
		                    <th style='width:15%;'>调用日期</th>
		                    <th style='width:16%;'>调用次数</th>
		                </tr>
		            </thead>
		            <tbody>
		            <#if callings?? && (callings?size > 0)>
		              <#list callings as calling>
		                <tr class='tdCenter'>
		                    <td>${calling.apiName!""}</td>
		                    <td>${calling.apiMethod!""}</td>
		                    <td>${calling.userName!""}</td>
		                    <td>${calling.majorType!""}</td>
		                    <td>${calling.callingDay!""}</td>
		                    <td>${calling.callingTimes!""}</td>
		                </tr>
		               </#list>
		             </#if>
		            </tbody>
		        </table>
		        <div id="table_paginator" style="margin-top: -10px; margin-bottom: -10px; text-align:center; display:block;"></div>
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

