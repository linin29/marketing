<div class="count_list">
    <section class="task_list_header">
        <h3>上传文件</h3>
    </section>
    <div class="content_list" style="margin: 20px;">
		<input type="button" class="btn btn-success" id="zip_import" value="选择上传的文件" />
		<input type="file" id="file_select" style="display:none;"/>
		<span>注：目前支持ZIP包文件上传</span>
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