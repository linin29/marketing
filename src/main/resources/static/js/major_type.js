var marketing_url = '/marketing';
var majorType=majorType || {};
majorType=(function(){
	function init(currentPage, totalCount){
		if(totalCount != "0"){
			initPagination(currentPage, totalCount);
		}
		$("#new-type").click(function(){
			$("#majorTypeId").val("");
			$("#new-type-model").modal("show");
		});
		
		$(".deleteMajorType").click(function(){
			$("#deleteAreaModal").attr('majorTypeid', $(this).attr("majortypeid"));
			$("#deleteAreaModal").modal("show");
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
        	$("#deploy_name").removeAttr("disabled");
        	$('#deploy_name').val("");
        	$('#deploy_des').val("");
			$(this).removeData("bs.modal");
        });
		$('#majorType_delete').on('click', function(e){
			 var majorTypeId = $("#deleteAreaModal").attr('majorTypeid');
			 $.ajax({
					type: 'DELETE',
					url: marketing_url + '/admin/majortype/' + majorTypeId,
					dataType: 'json', 
					success: function(data) {
						if (!data.success) {
							noty({text: data.errorMessage, layout: 'topCenter', type: 'error', timeout: 2000});
							return;
						}else{
							noty({text: "删除成功", layout: 'topCenter', type: 'success', timeout: 2000});
							$("#deleteAreaModal").modal('hide');
							$('.tableTr[majorTypeid=' + majorTypeId + ']').remove();
						} 
		        	},
		        	error: function(data) {
		        		noty({text: '删除失败', layout: 'topCenter', type: 'error', timeout: 2000});
		        	}
				});
		 });
	};
	function edit(_this, majorTypeId){
		$('#myModalLabel').text("修改类型");
		var $tr = $(_this).parents('.tableTr');
		var name=$tr.find('.name').text();
		var description=$tr.find('.description').text();
		$('#deploy_name').val(name);
		$('#deploy_name').attr("disabled","disabled"); 
		$('#deploy_des').val(description);
		$("#new-type-model").modal("show");	
		$("#majorTypeId").val(majorTypeId);
	}
	function creatType(){
		var deploy_name=$('#deploy_name').val();
		var deploy_des=$('#deploy_des').val();
		var majorTypeId = $("#majorTypeId").val();
		if (deploy_name == "") {
			$('#errorMsg').text("请输入名称");
			return;
		};
		if (deploy_des == "") {
			$('#errorMsg').text("请输入描述");
			return;
		}
		var url ='';
		if(majorTypeId){
			url = marketing_url + '/admin/majortype/' + majorTypeId + '/update';
		}else{
			url = marketing_url + '/admin/majortype/create';
		}
		var data={'name':deploy_name,'description':deploy_des};		
		$.ajax({
			 type: 'POST',
			 url:url,
			 contentType : 'application/json',
			 data: JSON.stringify(data),
			 dataType: 'json', 
			 success: function(data) {
			 	if (data.success) {
			 		noty({text: '保存成功', layout: 'topCenter', type: 'warning', timeout: 2000});
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
			 		},500)		 		
			 	}else{
			 		noty({text: data.errorMessage, layout: 'topCenter', type: 'warning', timeout: 2000});
			 	} 
			 },
			 error: function(data) {
				 noty({text: '保存失败', layout: 'topCenter', type: 'warning', timeout: 2000});
			 }
		})
	};
	function queryMajorType(pageNum){
		var page = 0;
		if (pageNum) {
			page = pageNum -1;
		}
		$.ajax({
			 type: 'GET',
			 url: marketing_url + '/admin/majortype',
			 data:{pageNum:page},
			 success: function(data) {
			 	$("#content").html(data);
	    	},
	    	error: function(data) {
	    		//返回500错误页面
	    		$("html").html(data.responseText);
	    	}
		});
	};
	function initPagination(currentPage, totalCount) {
		var options = {
			alignment: 'center',
	        currentPage: currentPage,
	        totalPages: Math.ceil(totalCount / dface.constants.PAGINATION_ITEMS_PER_PAGE),
	        numberOfPages: dface.constants.PAGINATION_ITEMS_PER_PAGE,
	        onPageClicked: function (event, originalEvent, type, page) {
	        	doPaginationClicked(page);
	        }
		};
		
		$('#table_paginator').bootstrapPaginator(options);
		$("#table_paginator").show();
	};
	
	function doPaginationClicked(pageNum) {
		queryMajorType(pageNum);
	};
	return {
		_init:init,
		edit:edit
	}
})()
