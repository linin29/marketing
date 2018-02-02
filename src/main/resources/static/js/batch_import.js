var m_url='/marketing/'
var batchImport=batchImport || {};
batchImport=(function(){
	var PASS_TASK_LIST = [];
	var FAIL_TASK_LIST = [];
	var ERROR_TASK_LIST = []
	
	var PASS_STITCH_LIST = [];
	var FAIL_STITCH_LIST = []; 
	var ERROR_STITCH_LIST = [];	
    function init(){
    	$('#barch_import').click(function(){
    		var majorType = $('#majorType').val();
    		var projectId = $('#project').val();
    		if(!projectId || projectId==''){
    			noty({text: '请选择一个项目', layout: "topCenter", type: "warning", timeout: 1000});
    			return;
    		}
    		if(!majorType || majorType==''){
    			noty({text: '请选择一个主类型', layout: "topCenter", type: "warning", timeout: 1000});
    			return;
    		}
    		$('#file_select').click();
    	});
    	
    	$('#waiting .close').click(function(){
    		show_status_text();
    		clear_data();
    	});
    	
    	$('#project').change(function(){
    		getMajorType($(this).val());
    	});
    	
    	$('#file_select').change(function(){
    		var _file = $(this)[0];
    		var files = _file.files;
    		var majorType = $('#majorType').val();
    		var needStitch = !$('#is_need_stitch').is(':checked');
    		var total = files.length;
    		
    		//console.log(files)
    		$('#waiting').modal({keyboard: false, backdrop: 'static'});
    		
    		$.each(files, function(index, file){
    			if(file){
    				var fileName = file.name;
    				var index = file.name.lastIndexOf(".");
    				var fileExt = fileName.substring(index + 1);
    				if(fileExt.toLowerCase() == 'zip'){
    					sendZipfile(file.name, file, function(task_id){
    						var url = m_url+task_id+'/stitcher';
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
    				}else{
    					send_file(file.name, file, function(task_id){
    						var url = m_url+task_id+'/stitcher';
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
    				}
    			}
    		});
    		
    	});
     };

     function send_file(task_label, file, cb){
 		var formData = new FormData();
 		
 		formData.append("images", file);
 		formData.append("taskId", 0);
 		formData.append("taskLabel", task_label);
 		
 		$.ajax({ 
 			url : m_url+'task/create', 
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
 	};
 	
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
	};
	
	function sendZipfile(task_label, file, cb){
		var formData = new FormData();
		
		formData.append("zipFile", file);
		formData.append("taskId", 0);
		formData.append("taskLabel", task_label);
		
		$.ajax({ 
			url : m_url+'zipTask/create', 
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
	};
	
	function make_status_html(list){
		var html = '<ul style="padding:0px;">';
		$.each(list, function(index, item){
			html += '<li>'+item+'</li>';
		});
		return html += '</ul>';
	};
	
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
	};
	
	function getMajorType(projectId){
		$.ajax({ 
			url : m_url + 'majorType/list?projectId=' + projectId, 
			type : 'GET', 
			success : function(resp) { 
				if(resp.success){
					if(resp.data && resp.data.length > 0){
						var html = "<option value=''>请选择一个主类型</option>";
						for(var i = 0; i < resp.data.length; i++){
							html += "<option value='"+ resp.data[i].name +"'>"+ resp.data[i].description +"</option>"
						}
						$("#majorType").html(html);
					}
				}
			}, 
			error : function(resp) { 
				 noty({text: '获取品类列表失败', layout: "topCenter", type: "warning", timeout: 2000});
				 return;
			} 
		});
	}
	
     return {
          _init:init
     }

})()
