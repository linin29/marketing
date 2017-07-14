var d_url='';
var majorType=majorType || {};
majorType=(function(){
	function init(){
		$("#new-type").click(function(){
			$("#new-type-model").modal("show");
		});
		
		$('#server-type').selectpicker({
        	width:"100%"
        });
        $('#admin-type').selectpicker({
        	width:"100%"
        });
        $("#save").click(function(){
        	creatType();
        });
        $("#new-type-model").on("hidden.bs.modal", function() {
        	$('#deploy_name').val();
        	$('#deploy_des').val();
			$(this).removeData("bs.modal");
        });
	};
	function edit(){
		$('#myModalLabel').text("修改类型");
		var $tr = $(this).parents('.tableTr');
		var name=$tr.find('.name').text();
		var description=$tr.find('.description').text();
		$('#deploy_name').val(name);
		$('#deploy_des').val(description);
		$("#new-type-model").modal("show");			
	}
	function creatType(){
		var deploy_name=$('#deploy_name').val();
		var deploy_des=$('#deploy_des').val();
		if (deploy_name == "") {
			$('#errorMsg').text("请输入名称");
			return;
		};
		if (deploy_des == "") {
			$('#errorMsg').text("请输入描述");
			return;
		}
		var data={'name':deploy_name,'description':deploy_des};		
		$.ajax({
			 type: 'POST',
			 url:'/marketing/admin/majortype/create',
			 contentType : 'application/json',
			 data: JSON.stringify(data),
			 dataType: 'json', 
			 success: function(data) {
			 	if (data.success) {
			 		noty({text: '创建成功', layout: 'topCenter', type: 'warning', timeout: 2000});
			 		$('#new-type-model').modal('hide');
			 		setTimeout(function(){
			 			$.ajax({
							 type: 'GET',
							 url:'/marketing/admin/majortype',
							 success: function(data) {
							 	$("#content").html(data);
				        	},
				        	error: function(data) {
				        		//返回500错误页面
				        		$("html").html(data.responseText);
				        	}
						});
			 		},1000)		 		
			 	} 
			 },
			 error: function(data) {
				 noty({text: '创建失败', layout: 'topCenter', type: 'warning', timeout: 2000});
			 }
		})
	};
	
	
	return {
		_init:init,
		edit:edit
	}
})()
