var marketing_url = '/marketing';
var adminService = adminService || {};
adminService = (function(){
	function serviceApplyInit(currentPage, totalCount){
		if(totalCount != "0"){
			initPagination(currentPage, totalCount);
		}
		$("#query").click(function(){
			queryService();
		});
		$("#new-server").click(function(){
			$("#upload-book-tr").show();
			$("#new-server-model").modal("show");
		}); 
		$("#saveService").click(function(){
			saveService();
		});
		$("#modify").click(function(){
			$("#upload-book-tr").show();
			$("#myModalLabel").text("修改申请");	
			$("#new-server-model").modal("show");
		});
		$(".info").click(function(){
			$("#upload-book-tr").hide();
			$("#myModalLabel").text("服务申请详情");	
			$("#new-server-model").modal("show");
			detail($(this).attr("applyid"));
		});
		$('#server-type').selectpicker({
        	width:"100%"
        });
        $('#admin-type').selectpicker({
        	width:"100%"
        });
	};
	function serviceManageInit(currentPage, totalCount){
		if(totalCount != "0"){
			initPagination(currentPage, totalCount);
		}
		$("#server-info").click(function(){
			$("#myModalLabel").text("服务管理详情");	
			$("#server-management-model").modal("show");
		});
		$("#approval").click(function(){
			$("#myModalLabel").text("服务管理审批");
			$("#server-management-model").modal("show");
		});
		$('#server-type').selectpicker({
        	width:"100%"
        });
        $('#admin-type').selectpicker({
        	width:"100%"
        });
	}
	function saveService(){
		
	}
	function detail(applyId){
		$.ajax({
			 type: 'GET',
			 url: marketing_url + '/admin/service/detail/' + applyId,
			 success: function(data) {
			 	if(data && data.success){
			 		$("#ser-name").val(data.data.appBusinessName);
			 		$("#ser-address").val(data.data.appBusinessAddress);
			 		$("#ser-phone-person").val(data.data.appBusinessContacts);
			 		$("#ser-phone").val(data.data.appBusinessMobile);
			 		$("#application-number").val(data.data.maxCallNumber);
			 		$("#ser-user-name").val(data.data.appBusinessName);
			 		$("#ser-email").val(data.data.appBusinessName);
			 	}
	    	},
	    	error: function(data) {
	    		//返回500错误页面
	    		$("html").html(data.responseText);
	    	}
		});
	}
	function queryService(pageNum){
		var majorType = $("#majorType").val();
		var appBusinessName = $("#appBusinessName").val();
		var applyStatus = $("#applyStatus").val();
		var page = 0;
		if (pageNum) {
			page = pageNum -1;
		}
		$.ajax({
			 type: 'GET',
			 url: marketing_url + '/admin/service/apply/search',
			 data:{
				 pageNum:page,
				 appBusinessName:appBusinessName,
				 applyStatus:applyStatus
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
		queryService(pageNum);
	};
	return {
		serviceApplyInit:serviceApplyInit,
		serviceManageInit:serviceManageInit
	}
})()