var marketing_url = '/marketing';
var sku = sku || {};
sku=(function(){
	function init(currentPage, totalCount){
		$("#new-SKU").click(function(){
			$("#skuId").val("");
			var name=$('#sku_name').val("");
			var skuSelect=$('#sku_select').attr("selected", "");
			var skuDescription=$('#sku_description').val("");
			var skuOrNot=$('#sku_or_not').attr("selected", "");
			$('#myModalLabel').text('新建信息');
			$("#new-SKU-model").modal("show");
		});
		
		$('#save').click(function(){
			createType();
		});
		
		$('#search').click(function(){
			querySku(0);
		});
		if(totalCount != "0"){
			initPagination(currentPage, totalCount);
		};
		
		$(".deleteSkuModel").click(function(){
			$("#deleteSkuModal").attr('skuid', $(this).attr("skuid"));
			$("#deleteSkuModal").modal("show");
		});
		
		$('#sku_delete').on('click', function(e){
			 var skuid = $("#deleteSkuModal").attr('skuid');
			
			 $.ajax({
					type: 'DELETE',
					url: marketing_url + '/admin/sku/' + skuid,
					dataType: 'json', 
					success: function(data) {
						if (!data.success) {
							noty({text: data.errorMessage, layout: 'topCenter', type: 'error', timeout: 2000});
							return;
						}else{
							noty({text: "删除成功", layout: 'topCenter', type: 'success', timeout: 2000});
							$("#deleteSkuModal").modal('hide');
							$('.tdstyle_'+ skuid).remove();
						} 
		        	},
		        	error: function(data) {
		        		noty({text: '删除失败', layout: 'topCenter', type: 'error', timeout: 2000});
		        	}
				});
		 });
	};
	function createType(){
		var name=$('#sku_name').val();
		var skuSelect=$('#sku_select').val();
		var skuDescription=$('#sku_description').val();
		var skuOrNot=$('#sku_or_not').val();
		var skuId=$('#skuId').val();
		if (name == "") {
			$('#errorMsg').text("请输入名称");
			return;
		};
		if (skuSelect == "") {
			$('#errorMsg').text("请选择类型");
			return;
		};
		if (skuDescription == "") {
			$('#errorMsg').text("请输入描述");
			return;
		};
		if (skuOrNot == "") {
			$('#errorMsg').text("请选择是否显示");
			return;
		};
		
		var url ='';
		if(skuId){
			url = marketing_url + '/admin/sku/' + skuId + '/update';
		}else{
			url = marketing_url + '/admin/sku/create';
		}
		
		var data={'name':name,'majorType':skuSelect,'description':skuDescription,'isShow':skuOrNot};		
		$.ajax({
			 type: 'POST',
			 url:url,
			 contentType : 'application/json',
			 data: JSON.stringify(data),
			 dataType: 'json', 
			 success: function(data) {
			 	if (data.success) {
			 		noty({text: '创建成功', layout: 'topCenter', type: 'warning', timeout: 2000});
			 		$('#new-SKU-model').modal('hide');
			 		setTimeout(function(){
			 			$.ajax({
							 type: 'GET',
							 url:'/marketing/admin/sku',
							 success: function(data) {
							 	$("#content").html(data);
				        	},
				        	error: function(data) {
				        		//返回500错误页面
				        		$("html").html(data.responseText);
				        	}
						});
			 		},500)		 		
			 	} 
			 },
			 error: function(data) {
				 noty({text: '创建失败', layout: 'topCenter', type: 'warning', timeout: 2000});
			 }
		})
	};
	function edit(_this,skuId){
		$('#myModalLabel').text('修改信息');
		var $tr = $(_this).parents('.tdstyle');
		var name=$tr.find('.name').text();
		var description=$tr.find('.description').text();
		
		
		$('#sku_name').val(name);
		$('#sku_description').val(description);
		
		$("#new-SKU-model").modal("show");	
		$("#skuId").val(skuId);
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
		querySku(pageNum);
	};
	function querySku(pageNum){
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
				 skuType:skuType
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