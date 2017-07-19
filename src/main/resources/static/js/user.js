var marketing_url = '/marketing';
var user = user || {};
user = (function(){
	function init(currentPage, totalCount){
		
		$('#search').click(function(){
			querySku(0);
		});
		if(totalCount != "0"){
			initPagination(currentPage, totalCount);
		};
		$(".resetPwdModel").click(function(){
			$("#resetPwdModal").attr('userid', $(this).attr("userid"));
			$("#resetPwdModal").modal("show");
		});
		$("#user_resetPwd").click(function(){
			var userId = $("#resetPwdModal").attr('userid');
			 $.ajax({
					type: 'POST',
					url: marketing_url + '/admin/user/' + userId + '/resetPwd',
					dataType: 'json', 
					success: function(data) {
						if (!data.success) {
							noty({text: data.errorMessage, layout: 'topCenter', type: 'error', timeout: 2000});
							return;
						}else{
							noty({text: "重置密码成功", layout: 'topCenter', type: 'success', timeout: 2000});
							$("#resetPwdModal").modal('hide');
						} 
		        	},
		        	error: function(data) {
		        		noty({text: '重置密码失败', layout: 'topCenter', type: 'error', timeout: 2000});
		        	}
				});
		});
        $("#save").click(function(){
        	updateUser();
        });
	};
	function edit(_this, userId){
		$('#myModalLabel').text('修改信息');
		var $tr = $(_this).parents('.tableTr');
		var email = $tr.find('.email').text();
		$("#email").val(email);
		$("#userId").val(userId);
		$("#new-user-model").modal("show");
	}
	
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
		queryUser(pageNum);
	};
	function resetPwd(){
		
	};
	function updateUser(){
		var userId=$('#userId').val();
		var email=$('#email').val();
		var regex = /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
		if(!email || !regex.test(email)){
			noty({text: "Email格式不正确!", layout: "topCenter", type: "warning", timeout: 2000});
			return false;
		}
		var url = marketing_url + '/admin/user/' + userId + '/update';
		var data={'email':email};		
		$.ajax({
			 type: 'POST',
			 url:url,
			 contentType : 'application/json',
			 data: JSON.stringify(data),
			 dataType: 'json', 
			 success: function(data) {
			 	if (data.success) {
			 		noty({text: '保存成功', layout: 'topCenter', type: 'warning', timeout: 2000});
			 		$('#new-user-model').modal('hide');
			 		setTimeout(function(){
			 			$.ajax({
							 type: 'GET',
							 url:'/marketing/admin/user',
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
		});
	};
	function queryUser(pageNum){
		var skuType = $("#skuType").val();
		var page = 0;
		if (pageNum) {
			page = pageNum -1;
		}
		$.ajax({
			 type: 'GET',
			 url: marketing_url + '/admin/user',
			 data:{
				 pageNum:page
			 },
			 success: function(data) {
			 	$("#content").html(data);
	    	},
	    	error: function(data) {
	    		//返回500错误页面
	    		$("html").html(data.responseText);
	    	}
		});
	};
	return {
		_init:init,
		edit:edit,
		resetPwd:resetPwd
	}
})()