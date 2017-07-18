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
	};
	function edit(_this, userId){
		$('#myModalLabel').text('修改信息');
		var $tr = $(_this).parents('.tableTr');
		var email = $tr.find('.email').text();
		$("#email").val(email);
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
	function queryUser(pageNum){
		var skuType = $("#skuType").val();
		var page = 0;
		if (pageNum) {
			page = pageNum -1;
		}
		$.ajax({
			 type: 'GET',
			 url: marketing_url + '/admin/user/user',
			 data:{
				 pageNum:page,
				 majorType:skuType
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