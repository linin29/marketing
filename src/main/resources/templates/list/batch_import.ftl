<div class="count_list">
    <div class="content_list">
       	<div class='clearfix'>
		    <div class="task_list_header">
		        <h3>批量创建任务</h3> 
		    </div>
		    <div >
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
		        <span style="width:8%;float:left;line-height:34px;text-align: left;margin-right: -1%;">品类：</span>
		    	<div style="width:25%;float:left;">
			    	<select id="majorType"  class="form-control" >
			           <option value="">请选择一个主类型</option>
			            <#if majorTypes?? && (majorTypes?size > 0)>
			             <#list majorTypes as majorType>
			                <option value="${majorType.name}">${majorType.description}${majorType.version!""}</option>
			             </#list>
			             </#if>
					</select>
				</div>
				<div style='float:left;width:70%;line-height: 56px;'>
					<input type="checkbox" id="is_need_stitch"><span>勾选取消去重
					<input type="button" class="btn btn-success" id="barch_import" style='margin-left: 10px;' value="选择批量导入的图片" />
					<input type="file" id="file_select" style="display:none;" multiple />
					<span >注：目前支持单张图片和ZIP包文件创建任务，<a href="${springMacroRequestContext.contextPath}/download">点击下载打包工具</a></span>
	    		</div>
	    	</div>
    	  </div>
	    <div class="content_list2">
			<div class="row">
				 <div class="col-md-4">
				 	<div class="panel panel-success">
					  <div class="panel-heading">创建任务成功<span id="create_pass_num">（0）</span></div>
					  <div class="panel-body" id="create_pass">
					  
					  </div>
					</div>
				 </div>
				 <div class="col-md-4">
				 	<div class="panel panel-warning">
					  <div class="panel-heading">创建任务失败<span id="create_fail_num">（0）</span></div>
					  <div class="panel-body" id="create_fail">
					    
					  </div>
					</div>
				 </div>
				 <div class="col-md-4">
				 	<div class="panel panel-danger">
					  <div class="panel-heading">创建任务错误<span id="create_error_num">（0）</span></div>
					  <div class="panel-body" id="create_error">
					    
					  </div>
					</div>
				 </div>
			</div>
			<div class="row">
				<div class="col-md-4">
				 	<div class="panel panel-success">
					  <div class="panel-heading">拼接任务成功<span id="stitch_pass_num">（0）</span></div>
					  <div class="panel-body" id="stitch_pass">
					    
					  </div>
					</div>
				 </div>
				 <div class="col-md-4">
				 	<div class="panel panel-warning">
					  <div class="panel-heading">拼接任务失败<span id="stitch_fail_num">（0）</span></div>
					  <div class="panel-body" id="stitch_fail">
					    
					  </div>
					</div>
				 </div>
				 <div class="col-md-4">
				 	<div class="panel panel-danger">
					  <div class="panel-heading">拼接任务错误<span id="stitch_error_num">（0）</span></div>
					  <div class="panel-body" id="stitch_error">
					    
					  </div>
					</div>
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
 
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/batch_import.js"></script>
<script type="text/javascript">
	$(function() {	
		batchImport._init();
	});
</script>