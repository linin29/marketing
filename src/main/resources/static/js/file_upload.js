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
/*    		var majorType = $('#majorType').val();
    		if(!majorType || majorType==''){
    			noty({text: '请选择一个主类型', layout: "topCenter", type: "warning", timeout: 1000});
    			return;
    		}*/
    		$('#file_select').click();
    	});
    	
    	$('#file_select').change(function(){
    		var _file = $(this)[0];
    		var files = _file.files;
    		var total = files.length;
    		var url = m_url + 'fileUpload';
  /*  		var majorType = $('#majorType').val();
    		if(!majorType || majorType==''){
    			noty({text: '请选择一个主类型', layout: "topCenter", type: "warning", timeout: 1000});
    			return;
    		}*/
    		var formData = new FormData();
    		//formData.append('majorType', majorType);
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
	
     return {
          _init:init
     }

})()
