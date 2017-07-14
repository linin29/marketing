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
			$("#new-server-model").modal("show");
		}); 
		$("#modify").click(function(){
			$("#myModalLabel").text("修改申请");	
			$("#new-server-model").modal("show");
		})
		$("#info").click(function(){					
		 var cont=$('#application-company').text(); 
		 $("#myModalLabel").text("服务申请详情");	
			$("#new-server-model").modal("show");
			$("#ser-name").val(cont);
		})
		$('#server-type').selectpicker({
        	width:"100%"
        });
        $('#admin-type').selectpicker({
        	width:"100%"
        });
	};
	
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
		serviceApplyInit:serviceApplyInit
	}
})()