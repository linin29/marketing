<style type="text/css">
    .captureTable th,.captureTable td{text-align: center;}
    .newline{width:200px; white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
    .col-sm-3,.col-sm-9,.col-sm-4,.col-sm-2,.col-sm-10{
	   padding-right: 0px;
	   padding-left: 0px;
	}
	.lh{
		line-height: 34px;
	}
</style>
<div class="exportDataContainer">
    <div class="panel-default" style="margin-bottom:0px">      
        <div class="panel-body" style="padding:0px;">  
			<div class="leftTable " style="margin-top: 15px;">
			  <div class="content_list" style="margin: -14px 12px 20px 24px;">
				  <div class="data_list_header" style=''>
		       	 	<div style="margin-top:21px;margin-bottom:10px;padding-left:0px;overflow: hidden;width:100%;">
		       	 		<div class="col-sm-3">
		       	 			<span class="col-sm-3 text-center lh">项目：</span>
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
		       	 		<div class="col-sm-3">
		       	 			<span class="col-sm-3 text-center lh">品类：</span>
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
		       	 		<div class="col-sm-5">
		       	 			<span class="col-sm-2 lh text-center" style="width:15%;">时间段：</span>
			              	<div class="col-sm-10" style="width:85%;">
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
		       	 		<div class="col-sm-1 text-right"><button class='btn btn-success' id="query">查询</button></div>
		       	 	</div>
		       	 	
	    		</div>
	    		<div style="clear:both;"></div>
		         <div class=" text-right" style="padding-bottom: 10px;padding-right: 0px;">
		         	 <form id="downloadForm" action='' method="get">
       					 <input type="hidden" id="taskIds" name="taskIds" />
					 </form>		            
		             <button type="submit" class='btn btn-success' id="download" style="margin-left: 20px;">下载</button>
		             <input type="button" class="btn btn-success" id="zip_import" value="上传文件" />
					 <input type="file" id="file_select" style="display:none;"/>
		         </div>
                <table id="track-table" class="table table-hover table-bordered" style="margin-top: 5px">
              		<thead>
                    	<tr class='tableColorSet'>
                    		<th style='width:5%;'><input type="checkbox" id="checkAll" name="checkAll" /></th>
	                    	<th style='width:25%;'>任务名</th>	                
	                    	<th style='width:20%;'>任务ID</th>
	                    	<th style='width:20%;'>类型</th>
	                    	<th style='width:20%;'>更新时间</th>
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
                      				<td>${task.majorTypeName!""}</td>
                      				<td>${task.lastUpdateTime?string('yyyy-MM-dd HH:mm:ss')!""}</td>
	                    			<td>
	                    				<a taskid="${task.id}" href="javascript:void(0);" class="ajax-link taskDetail">查看</a>
	                    			</td>
	                   			</tr>
	                   		</#list>
	                   	</#if>
                    </tbody>
                </table>               
               <div id="table_paginator" style="margin-top: -20px; margin-bottom: -10px; text-align:center; display:block;"></div>
              </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="waiting" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
   <div class="modal-dialog" role="document">
       <div class="modal-content">
           <div class="modal-header model_head">
               <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
               <h4 id="waitingLabel" style="text-align: center" class="modal-title">正在上传文件并进行纠错，请稍后...</h4>
           </div>
           <div class="modal-body">
               <img src="${springMacroRequestContext.contextPath}/image/searchwait.gif" style="margin:0px 0 0 230px"/>
               <ul style="text-align: center;"></ul>
           </div>
           <div class="modal-foot">
           </div>
       </div>
   </div>
</div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/aec.js"></script>
<script type="text/javascript">
	var currentPage = "${currentPage}";
	var totalCount = "${totalCount?c}";
	aec._init(currentPage, totalCount);
</script>