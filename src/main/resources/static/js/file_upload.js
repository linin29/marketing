var m_url = '/marketing/'
var fileUpload = fileUpload || {};
fileUpload = (function(){
	var PASS_TASK_LIST = [];
	var FAIL_TASK_LIST = [];
	var ERROR_TASK_LIST = []
	
	var PASS_STITCH_LIST = [];
	var FAIL_STITCH_LIST = []; 
	var ERROR_STITCH_LIST = [];	
    function init(){
    	$('#zip_import').click(function(){
    		$('#file_select').click();
    	});
    	
    	$('#file_select').change(function(){
    		var _file = $(this)[0];
    		var files = _file.files;
    		var total = files.length;
    		var url = m_url + 'fileUpload';
    		var formData = new FormData();
    		for (var i = 0; i < files.length; i++) {
      			var file = files[i];
      			formData.append('zipFiles', file, file.name);
    		}
    		$('#waiting').modal({keyboard: false, backdrop: 'static'});
    		$('#waiting').modal('show');
    		$.ajax({
		        type: "POST",
		        url: url,
				data : formData, 
				processData : false, 
				contentType : false,
		        success: function (resp) {
		        	$('#waiting').modal('hide');
		        	noty({text: "上传文件成功", layout: "topCenter", type: "success", timeout: 1000});
		        },
		        error: function (message) {
		        	$('#waiting').modal('hide');
		        	noty({text: "上传文件失败", layout: "topCenter", type: "error", timeout: 1000});
		        }
		    });
    		
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
	
     return {
          _init:init
     }

})()
