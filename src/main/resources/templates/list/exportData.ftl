<style type="text/css">
    .captureTable th,.captureTable td{text-align: center;}
    .newline{width:200px; white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
</style>
<div class="exportDataContainer">
    <div class="panel-default" style="margin-bottom:0px">
         <div class="data_list_header" style="margin-left: 2%;">
       	 	<h3>数据导出
            	<small>本次查询共<span id="number">${totalCount}</span>数据</small>
        	</h3>
    	</div>
        <div class="panel-body">
            <div class="condition row">
            	<div class="form-group col-sm-4">
                     <span class="control-label line-height col-sm-3 text-center" >品类：</span>
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
                 
                 <div class='form-group col-sm-6'>
                 	<span class="control-label line-height col-sm-2 text-center">时间段：</span>
                 	 <div class='col-sm-10'>
                 	 	<input id="startTime" type="hidden" <#if startTime??> value="${startTime}"</#if>>
                 	 	<input id="endTime" type="hidden" <#if endTime??> value="${endTime}"</#if>>
                 	 	 <div style="float: left; width: 48%;" class="form-group input-group date form_datetime1" data-date="2016-11-1T05:25:07Z" data-date-format="yyyy-mm-dd hh:ii:ss" >
		                    <input class="form-control" size="16" type="text" value="" id="fromDate">
		                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
		                </div>
		                <div  style="float: left;line-height: 34px" class="form-group glyphicon glyphicon-minus"></div>
		                 <div style="float: left;  width: 48%;" class=" input-group date form_datetime2" data-date="2016-11-1T05:25:07Z" data-date-format="yyyy-mm-dd hh:ii:ss" >
		                    <input class="form-control" size="16" type="text" value="" id="toDate">
		                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
		                </div>
                 	 </div>
                 </div>
                 <div class="form-group col-sm-4" style = "margin-top:20px;">
                     <span class="control-label line-height col-sm-3 text-center" >状态：</span>
                     <div class="col-sm-9">
                         <p><input id="taskStatus" type="checkbox" <#if taskStatus??>checked</#if> name="taskStatus" value="identify_success" />&nbsp;&nbsp;identify_success</p>               
                     </div>
                 </div>
                 <div class="text-right" style='margin-right:35px;'>
                     <button class='btn btn-success' id="query">查询</button>
                     <button class='btn btn-success' id="export">导出</button>
                 </div>
            </div>
            
			<div class="leftTable " style="margin-top: 15px;">
                <table id="track-table" class="table table-hover table-bordered" style="margin-top: 5px">
                    <tbody>
	                    <tr class='tabelCenter' style="background-color: #ccc">
	                    	<th style='width:20%;'>任务名</th>	                
	                    	<th style='width:20%;'>任务ID</th>
	                    	<th style='width:20%;'>创建时间</th>
	                    	<th style='width:20%;'>更新时间</th>
	                    	<th style='width:10%;'>状态</th>
	                    	<th style='width:10%;'>操作</th>
	                    </tr>
	                    <#if tasks?? && (tasks?size > 0)>
		                   <#list tasks as task>
	                    		<tr class='tabelCenter data'>
	                    			<td>${task.name!""}</td>
                       				<td>${task.id!""}</td>
                      				<td>${task.createTime!""}</td>
                      				<td>${task.lastUpdateTime?string('yyyy-MM-dd HH:mm:ss')!""}</td>
                      				<td>${task.taskStatus!""}</td>
	                    			<td>
	                    				<a href="javascript:void(0);" onclick="getTaskDetail('${task.id}')" class="ajax-link">查看</a>
	                    			</td>
	                   			</tr>
	                   		</#list>
	                   	</#if>
                    </tbody>
                </table>               
                <div id="table_paginator" style="margin-top: -10px; margin-bottom: -10px; text-align:center; display:block;"></div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/dataExport.js"></script>
<script type="text/javascript">
	var currentPage = "${currentPage}";
	var totalCount = "${totalCount?c}";
	dataExport._init(currentPage, totalCount);
</script>