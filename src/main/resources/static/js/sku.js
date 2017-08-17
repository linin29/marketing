var marketing_url = '/marketing';
var sku = sku || {};
sku = (function(){
	function init(currentPage, totalCount){
		$("#new-sku").click(function(){
			$("#skuId").val("");
			$('#myModalLabel').text('新建信息');
			$("#new-sku-model").modal("show");
			$("#errorMsg").html("");
		}); 
		
		$("#new-sku-model").on("hidden.bs.modal", function() {
        	$('#sku_select').val("");
        	$('#sku_name').val("");
        	$('#sku_description').val("");
        	$('#sku_or_not').val("");
			$(this).removeData("bs.modal");
        });
		
		$('#save').click(function(){
			createSku();
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
							$('.tableTr[skuid=' + skuid + ']').remove();
						} 
		        	},
		        	error: function(data) {
		        		noty({text: '删除失败', layout: 'topCenter', type: 'error', timeout: 2000});
		        	}
				});
		 });
	};
	function createSku(){
		var name = $('#sku_name').val();
		var skuSelect = $('#sku_select').val();
		var skuDescription = $('#sku_description').val();
		var skuOrNot = $('#sku_or_not').val();
		var skuId = $('#skuId').val();
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
		
		var data={'name':name, 'majorType':skuSelect, 'description':skuDescription, 'isShow':skuOrNot};		
		$.ajax({
			 type: 'POST',
			 url:url,
			 contentType : 'application/json',
			 data: JSON.stringify(data),
			 dataType: 'json', 
			 success: function(data) {
			 	if (data.success) {
			 		noty({text: '保存成功', layout: 'topCenter', type: 'success', timeout: 2000});
			 		$('#new-sku-model').modal('hide');
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
			 	}else{
			 		noty({text: data.errorMessage, layout: 'topCenter', type: 'error', timeout: 2000});
					return;
			 	} 
			 },
			 error: function(data) {
				 noty({text: '保存失败', layout: 'topCenter', type: 'warning', timeout: 2000});
			 }
		})
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
		$("#new-sku-model").modal("show");	
		$("#skuId").val(skuId);
		$("#sku_or_not").val(skuOrNot);
		$("#errorMsg").html("");
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