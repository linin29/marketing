var marketing_url = '/marketing';
var sku = sku || {};
sku=(function(){
	function init(currentPage, totalCount){
		
		$('#search').click(function(){
			querySku(0);
		});
		if(totalCount != "0"){
			initPagination(currentPage, totalCount);
		};
	};
	function edit(_this,skuId){
		$('#myModalLabel').text('修改信息');
		var $tr = $(_this).parents('.tableTr');
		var name=$tr.find('.name').text();
		var description=$tr.find('.description').text();
		var majorType = $tr.find('.type').text();
		var skuOrNot = $tr.find('.showOrNot').attr("isshow");
		
		$('#sku_name').val(name);
		$('#sku_description').val(description);
		$("#sku_select").val(majorType);
		$("#new-SKU-model").modal("show");	
		$("#skuId").val(skuId);
		$("#sku_or_not").val(skuOrNot);
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
	function queryUser(pageNum){
		var skuType = $("#skuType").val();
		var page = 0;
		if (pageNum) {
			page = pageNum -1;
		}
		$.ajax({
			 type: 'GET',
			 url: marketing_url + '/admin/sku/search',
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
		edit:edit
	}
})()