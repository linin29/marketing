<style type="text/css">
    .captureTable th,.captureTable td{text-align: center;}
    .newline{width:200px; white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
</style>
<div class="exportDataContainer">
    <div class="panel-default" style="margin-bottom:0px">
         <div class="data_list_header" style="text-align:center;">
       	 	<div class="col-sm-9" style="margin-top:21px;margin-bottom:10px;margin-left:14px;">
       	 		<span style="width:8%;float:left;line-height:34px;">品类：</span>
                <div style="width:25%;float:left;">
                 	<select id="majorType" style="height: 34px;width: 96%;">
                      	<option value="">请选择</option>
                      	<#if majorTypes?? && (majorTypes?size > 0)>
                   	<#list majorTypes as tempMajorType>
                       	<option value="${tempMajorType.name}" <#if majorType?? && majorType == tempMajorType.name> selected </#if>>${tempMajorType.description}</option>
                   	</#list>
                  		</#if>
					</select>               
                </div>
                <span style="width:8%;float:left;line-height:34px;margin-left:1%">时间段：</span>
              	<div style="width:55%;float:left;">
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
    	</div>
         <div style="display:inline-block;margin-top:10px;margin-left:109px;">
             <button class='btn btn-success' id="query">查询</button>
             <button class='btn btn-success' id="download" style="margin-left: 8px;">下载</button>
         </div>
        <div class="panel-body" style="padding:0px;">  
			<div class="leftTable " style="margin-top: 15px;">
			  <section class="content_list">
                <table id="track-table" class="table table-hover table-bordered" style="margin-top: 5px">
              		<thead>
                    	<tr style="background-color:#ddd;">
                    		<th><input type="checkbox" id="checkAll" name="checkAll" /></th>
	                    	<th style='width:20%;'>任务名</th>	                
	                    	<th style='width:20%;'>任务ID</th>
	                    	<th style='width:20%;'>类型</th>
	                    	<th style='width:20%;'>更新时间</th>
	                    	<!-- <th style='width:10%;'>状态</th> -->
	                    	<th style='width:10%;'>操作</th>
                   	 	</tr>
              		</thead>
                	<tbody>
	                    <#if tasks?? && (tasks?size > 0)>
		                   <#list tasks as task>
	                    		<tr class='tabelCenter data'>
	                    			<td><input id="${task.id}" type="checkbox" name="checkItem" /></td>
	                    			<td>${task.name!""}</td>
                       				<td>${task.id!""}</td>
                      				<td>${task.majorType!""}</td>
                      				<td>${task.lastUpdateTime?string('yyyy-MM-dd HH:mm:ss')!""}</td>
                      				<!-- <td>${task.taskStatus!""}</td> -->
	                    			<td>
	                    				<a href="javascript:void(0);" onclick="getTaskDetail('${task.id}')" class="ajax-link">查看</a>
	                    			</td>
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
</div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/aec.js"></script>
<script type="text/javascript">
	var currentPage = "${currentPage}";
	var totalCount = "${totalCount?c}";
	aec._init(currentPage, totalCount);
</script>