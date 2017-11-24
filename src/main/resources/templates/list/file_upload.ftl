<div class="count_list">
    <div class="content_list" style="margin:8px 0px 20px 10px;">
<!--         <select id="majorType"  class="form-control" style="width:170px;display: inline-block;">
           <option value="">请选择一个主类型</option>
            <#if majorTypes?? && (majorTypes?size > 0)>
             <#list majorTypes as majorType>
                <option value="${majorType.name}">${majorType.description}${majorType.version!""}</option>
             </#list>
             </#if>
		</select> -->
		<div class="task_list_header" style='display:inline-block;'>
        	<h3>上传文件</h3>
    	</div>
    	<div style='display:inline-block;margin-left:30px;'>
			<input type="button" class="btn btn-success" id="zip_import" value="选择上传的文件" />
			<input type="file" id="file_select" style="display:none;"/>
			<span>注：目前支持ZIP包文件上传</span>
		</div>
    </div>  
</div>

<div class="modal fade" id="waiting" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
   <div class="modal-dialog" role="document">
       <div class="modal-content">
           <div class="modal-header model_head">
               <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
               <h4 id="waitingLabel" style="text-align: center" class="modal-title">正在上传，请稍后...</h4>
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
 
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/file_upload.js"></script>
<script type="text/javascript">
	$(function() {	
		fileUpload._init();
	});
</script>