<div class="count_list">
    <section class="task_list_header">
        <h3>批量创建任务</h3>
    </section>
    <div class="content_list" style="margin: 20px;">
		<input type="button" class="btn btn-success" id="barch_import" value="选择批量导入的图片" />
		<input type="file" id="file_select" style="display:none;" multiple />
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
   
<script>
$(function() {
	var PASS_TASK_LIST = [];
	var FAIL_TASK_LIST = [];
	var ERROR_TASK_LIST = []
	
	var PASS_STITCH_LIST = [];
	var FAIL_STITCH_LIST = []; 
	var ERROR_STITCH_LIST = [];
	
	function send_file(task_label, file, cb){
		var formData = new FormData();
		
		formData.append("images", file);
		formData.append("taskId", 0);
		formData.append("taskLabel", task_label);
		
		$.ajax({ 
			url : '${springMacroRequestContext.contextPath}/task/create', 
			type : 'POST', 
			data : formData, 
			processData : false, 
			contentType : false,
			success : function(resp) { 
				if(resp.success){
					var task_id = resp.data.taskId;
					console.log('创建任务成功！'+task_label+'_'+task_id);
					PASS_TASK_LIST.push(task_label);
					show_status_num();
					cb(task_id);
				}else{
					console.log('创建任务失败！'+task_label+'_'+resp.errmsg);
					FAIL_TASK_LIST.push(task_label+'_'+resp.errmsg);
					show_status_num();
				}
			}, 
			error : function(resp) { 
				console.log('创建任务异常！'+task_label);
				ERROR_TASK_LIST.push(task_label);
				show_status_num();
			} 
		});
	}
	
	function show_status_num(){
		var modal_html = '<li>创建任务成功数：'+PASS_TASK_LIST.length+'</li><li>创建任务失败数：'+FAIL_TASK_LIST.length+
						'</li><li>创建任务错误数：'+ERROR_TASK_LIST.length+'</li><li>拼接任务成功数：'+PASS_STITCH_LIST.length+
						'</li><li>拼接任务失败数：'+FAIL_STITCH_LIST.length+'</li><li>拼接任务错误数：'+ERROR_STITCH_LIST.length+'</li>';
		$('#waiting .modal-body img').remove();
		$('#waiting .modal-body ul').html(modal_html);
		
		$('#create_pass_num').text('（'+PASS_TASK_LIST.length+'）');
		$('#create_fail_num').text('（'+FAIL_TASK_LIST.length+'）');
		$('#create_error_num').text('（'+ERROR_TASK_LIST.length+'）');
		
		$('#stitch_pass_num').text('（'+PASS_STITCH_LIST.length+'）');
		$('#stitch_fail_num').text('（'+FAIL_STITCH_LIST.length+'）');
		$('#stitch_error_num').text('（'+ERROR_STITCH_LIST.length+'）');
	}
	
	function make_status_html(list){
		var html = '<ul style="padding:0px;">';
		$.each(list, function(index, item){
			html += '<li>'+item+'</li>';
		});
		return html += '</ul>';
	}
	
	function show_status_text(){
		$('#create_pass').html(make_status_html(PASS_TASK_LIST));
		$('#create_fail').html(make_status_html(FAIL_TASK_LIST));
		$('#create_error').html(make_status_html(ERROR_TASK_LIST));
		
		$('#stitch_pass').html(make_status_html(PASS_STITCH_LIST));
		$('#stitch_fail').html(make_status_html(FAIL_STITCH_LIST));
		$('#stitch_error').html(make_status_html(ERROR_STITCH_LIST));
	}
	
	function clear_data(){
		PASS_TASK_LIST = [];
		FAIL_TASK_LIST = [];
		ERROR_TASK_LIST = []
		
		PASS_STITCH_LIST = [];
		FAIL_STITCH_LIST = []; 
		ERROR_STITCH_LIST = [];
	}
	
	function check_finish(total){
		var sum_length = PASS_STITCH_LIST.length + FAIL_STITCH_LIST.length + ERROR_STITCH_LIST.length;
		if(sum_length==total){
			$('#waiting').modal('hide');
			show_status_text();
			clear_data();
		}
	}

	$('#barch_import').click(function(){
		$('#file_select').click();
	});
	
	$('#waiting .close').click(function(){
		show_status_text();
		clear_data();
	});
	
	$('#file_select').change(function(){
		var _file = $(this)[0];
		var files = _file.files;
		var majorType = 'beer';
		var needStitch = true;
		
		var total = files.length;
		
		$('#waiting').modal({keyboard: false, backdrop: 'static'});
		
		$.each(files, function(index, file){
			send_file(file.name, file, function(task_id){
				var url = '${springMacroRequestContext.contextPath}/'+task_id+'/stitcher';
				var data = {
					majorType : majorType,
					needStitch : needStitch
				}
				
				$.ajax({
			        type: "POST",
			        url: url,
			        contentType: "application/json; charset=utf-8",
			        data: JSON.stringify(data),
			        dataType: "json",
			        success: function (resp) {
			            if (resp.success) {
			                console.log('调用拼接任务成功！' + task_id);
			                PASS_STITCH_LIST.push(task_id);
			                show_status_num();
			            }else{
			            	console.log('调用拼接任务失败！' + task_id+'_'+resp.errmsg);
			                FAIL_STITCH_LIST.push(task_id+'_'+resp.errmsg);
			                show_status_num();
			            }
			            check_finish(total);
			        },
			        error: function (message) {
			            console.log('调用拼接任务错误！' + task_id);
			            ERROR_STITCH_LIST.push(task_id);
			            show_status_num();
			            check_finish(total);
			        }
			    });
			});
		});
		
	});
});
</script>