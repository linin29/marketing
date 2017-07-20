var marketing_url = '/marketing';
var adminService = adminService || {};
adminService = (function(){
	function serviceApplyInit(currentPage, totalCount){
		if(totalCount != "0"){
			initPagination(currentPage, totalCount, '/admin/service/apply/search');
		} 
		$("#query").click(function(){
			queryService('/admin/service/apply/search');
		});
		$("#new-server").click(function(){
			$("#sure").hide();
			$("#saveService").show();
			$("#upload-book-tr").show();
			$("#upload-book-div").show();
			$("#applyId").val("");
			$("#rejectReasonDiv").hide();
			$("#new-server-model").modal("show");
			$("#new-server-model").find("input").removeAttr("disabled");
			//$("#server-type").removeAttr("disabled");
			$('#server-type').selectpicker('val', "");
		}); 
		$("#saveService").click(function(){
			saveService();
		});
		$(".modify").click(function(){
			$("#sure").hide();
			$("#saveService").show();
			$("#upload-book-tr").hide();
			$("#upload-book-div").hide();
			$("#rejectReasonDiv").hide();
			$("#applyId").val($(this).attr("applyid"));
			detail($(this).attr("applyid"));
			$("#myModalLabel").text("修改申请");	
			$("#new-server-model").modal("show");
			$("#new-server-model").find("input").removeAttr("disabled");
			$("#rejectReason").attr("disabled","disabled");
			//$("#server-type").removeAttr("disabled"); 
		});
		$(".info").click(function(){
			$("#upload-book-tr").hide();
			$("#upload-book-div").hide();
			$("#myModalLabel").text("服务申请详情");	
			$("#sure").show();
			$("#saveService").hide();
			$("#rejectReasonDiv").hide();
			$("#new-server-model").modal("show");
			detail($(this).attr("applyid"));
			$("#new-server-model").find("input").attr("disabled","disabled"); 
			//$("#server-type").attr("disabled", "disabled"); 
		});
		$(".showAgreementModel").click(function(){
			$("#showagreementModel").modal("show");
			view($(this).attr("applyid"), true);
		});
		
		$('#server-type').selectpicker({
        	width:"100%"
        });
        $('#admin-type').selectpicker({
        	width:"100%"
        });
        $("#new-server-model").on("hidden.bs.modal", function() {
        	$("#new-server-model").find("input").val("");
			$(this).removeData("bs.modal");
        });
	};
	function serviceManageInit(currentPage, totalCount){
		if(totalCount != "0"){
			initPagination(currentPage, totalCount, '/admin/service/manage/search');
		}
		$("#server-info").click(function(){
			$("#myModalLabel").text("服务管理详情");	
			$("#server-management-model").modal("show");
		});
		$(".approve").click(function(){
			$("#myModalLabel").text("服务管理审批");
			$("#sure").hide();
			$("#openService").show();
			$("#rejectService").show();
			detail($(this).attr("applyid"), true);
			$("#rejectReasonDiv").show();
			$("#applyId").val($(this).attr("applyid"));
			$("#server-management-model").modal("show");
			$("#server-management-model").find("input").attr("disabled","disabled"); 
			$("#rejectReason").removeAttr("disabled"); 
		});
		$('#server-type').selectpicker({
        	width:"100%"
        });
        $('#admin-type').selectpicker({
        	width:"100%"
        });
		$("#query").click(function(){
			queryService('/admin/service/manage/search');
		});
		$(".info").click(function(){
			$("#upload-book-tr").hide();
			$("#myModalLabel").text("服务申请详情");	
			$("#sure").show();
			$("#openService").hide();
			$("#rejectService").hide();
			$("#server-management-model").modal("show");
			detail($(this).attr("applyid"));
			$("#server-management-model").find("input").attr("disabled","disabled"); 
			$("#server-type").attr("disabled","disabled"); 
		});
		$(".showAgreementModel").click(function(){
			$("#showagreementModel").modal("show");
			viewManage($(this).attr("applyid"));
		});
		$(".deleteService").click(function(){
			$("#deleteAreaModal").attr('applyid', $(this).attr("applyid"));
			$("#deleteAreaModal").modal("show");
		});
		$("#openService").click(function(){
			var applyId = $("#applyId").val();
			openService(applyId);
		});
		$("#rejectService").click(function(){
			var applyId = $("#applyId").val();
			rejectService(applyId);
		});
		
		$('#service_delete').on('click', function(e){
			 var applyId = $("#deleteAreaModal").attr('applyid');
			 $.ajax({
					type: 'DELETE',
					url: marketing_url + '/admin/service/' + applyId,
					dataType: 'json', 
					success: function(data) {
						if (!data.success) {
							noty({text: data.errorMessage, layout: 'topCenter', type: 'error', timeout: 2000});
							return;
						}else{
							noty({text: "删除成功", layout: 'topCenter', type: 'success', timeout: 2000});
							$("#deleteAreaModal").modal('hide');
							$('.tableTr[applyid=' + applyId + ']').remove();
						} 
		        	},
		        	error: function(data) {
		        		noty({text: '删除失败', layout: 'topCenter', type: 'error', timeout: 2000});
		        	}
				});
		 });
	}
	function saveService(){
		var appBusinessName=$('#ser-name').val();
		var appBusinessAddress=$('#ser-address').val();
		var appBusinessContacts=$('#ser-phone-person').val();
		var appBusinessMobile=$('#ser-phone').val();
		var maxCallNumber=$('#application-number').val();
		var majorTypes = $("#server-type").val();
		var username = $("#ser-user-name").val();
		var email = $("#ser-email").val();
		var applyId = $("#applyId").val();
		if(appBusinessName == "") {
			$('#errorMsg').text("请输入应用商名称");
			return;
		};
		if(appBusinessAddress == "") {
			$('#errorMsg').text("请输入应用商地址");
			return;
		}
		if(appBusinessContacts == "") {
			$('#errorMsg').text("请输入联系人");
			return;
		}
		var regex = /^\d{11}$/;
		if(!appBusinessMobile || !regex.test(appBusinessMobile)){
			$('#errorMsg').text("联系方式格式不对");
			return;
		}
		var formData = new FormData();
		var files =  document.getElementById("upload-book").files;
		if (files.length == 0 && !applyId) {
			$('#errorMsg').text("请选择合同图片");
			return;
		}
		if(!majorTypes) {
			$('#errorMsg').text("请选择服务");
			return;
		}
		if(maxCallNumber == "") {
			$('#errorMsg').text("请输入申请次数");
			return;
		}
		if(username == "") {
			$('#errorMsg').text("请输入用户名");
			return;
		};
		var regex = /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
		if(!email || !regex.test(email)){
			noty({text: "Email格式不正确!", layout: "topCenter", type: "warning", timeout: 2000});
			return false;
		}
		var url ='';
		if(applyId){
			url = marketing_url + '/admin/service/' + applyId + '/update';
		}else{
			url = marketing_url + '/admin/service/create';
			for (var i = 0; i < files.length; i++) {
	  			var file = files[i];
	  			if (!checkFile(file)) {
	  			//$('#errorMsg').text("您选择的图片大于5M, 请重新选择小于5M的图片上传");
	  				return;
	  			}
	  			formData.append('images', file, file.name);
			}
		}
		formData.append('appBusinessName', appBusinessName);
		formData.append('appBusinessAddress', appBusinessAddress);
		formData.append('appBusinessContacts', appBusinessContacts);
		formData.append('appBusinessMobile', appBusinessMobile);
		formData.append('maxCallNumber', maxCallNumber);
		formData.append('majorTypes', majorTypes);
		formData.append('username', username);
		formData.append('email', email);
		tunicorn.utils.postFormData(url, formData, function(err, result){
			if(err){
				noty({text: "服务器异常!", layout: "topCenter", type: "error", timeout: 2000});
				return;
			}
			if(result.success){
				noty({text: '保存成功', layout: 'topCenter', type: 'warning', timeout: 2000});
		 		$('#new-server-model').modal('hide');
		 		setTimeout(function(){
		 			$.ajax({
						 type: 'GET',
						 url: marketing_url + '/admin/service/apply',
						 success: function(data) {
						 	$("#content").html(data);
			        	},
			        	error: function(data) {
			        		//返回500错误页面
			        		$("html").html(data.responseText);
			        	}
					});
		 		},500);
		 		if(!applyId){
		 			formData.append('applyStatus', 'created');
		 			sendEmail(formData);
		 		}
			}else{
				noty({text: result.errorMessage, layout: "topCenter", type: "error", timeout: 2000});
				return;
			}
		});
	}
	function detail(applyId, isRejectReasonShow){
		$.ajax({
			 type: 'GET',
			 url: marketing_url + '/admin/service/detail/' + applyId,
			 success: function(data) {
			 	if(data && data.success){
			 		var majorTypes = data.data.majorTypes;
			 		var majorTypeArray = [];
			 		if(majorTypes){
			 			for(var i=0;i<majorTypes.length;i++){
			 				majorTypeArray[i] = majorTypes[i].id;
			 			}
			 		}
			 		$("#ser-name").val(data.data.appBusinessName);
			 		$("#ser-address").val(data.data.appBusinessAddress);
			 		$("#ser-phone-person").val(data.data.appBusinessContacts);
			 		$("#ser-phone").val(data.data.appBusinessMobile);
			 		$("#application-number").val(data.data.maxCallNumber);
			 		$("#ser-user-name").val(data.data.username);
			 		$("#ser-email").val(data.data.email);
			 		$("#server-type").val(majorTypeArray);
			 		$('#server-type').selectpicker('val', majorTypeArray);
			 	    $('#server-type').selectpicker('refresh');
			 	    if(data.data.rejectReason || isRejectReasonShow){
			 	    	$("#rejectReasonDiv").show();
			 	    	$("#rejectReason").val(data.data.rejectReason);
			 	    }else{
			 	    	$("#rejectReasonDiv").hide();
			 	    	$("#rejectReason").val("");
			 	    }
			 	}
	    	},
	    	error: function(data) {
	    		//返回500错误页面
	    		$("html").html(data.responseText);
	    	}
		});
	};
	function view(applyId, isDelete){
		$.ajax({
			 type: 'GET',
			 url: marketing_url + '/admin/service/applyAsset',
			 data:{
				 applyId:applyId
			 },
			 success: function(data) {
			 	if(data && data.success && data.data){
			 		$("#applyId").val(applyId);
			 		var html = '';
			 		for(var i = 0; i<data.data.length; i++){
			 			var applyAsset = data.data[i];
			 			html += '<div id="applyAsset_' + applyAsset.id + '" class="col-sm-3">' +
								'<div class="thumbnail" style="">' + 
								'<div class="pull-right">';
			 			if(isDelete){
			 				html += '<a href="javascript:void(0)" onclick="adminService.deleteApplyAsset(' + applyAsset.id + ');" class=" glyphicon glyphicon-remove" style="color:red"></a>';
			 			}
			 			html += '</div>' + 
								'<img style="width: 200px;height: 200px" src="' + applyAsset.realPath + '" alt="">' +
								'</div>' + 										   
								'</div>';
			 		}
			 		$("#agreement-show").html(html);
			 	}
	    	},
	    	error: function(data) {
	    		//返回500错误页面
	    		$("html").html(data.responseText);
	    	}
		});
	};
	
	function viewManage(applyId, isDelete){
		$.ajax({
			 type: 'GET',
			 url: marketing_url + '/admin/service/applyAsset',
			 data:{
				 applyId:applyId
			 },
			 success: function(data) {
			 	if(data && data.success && data.data){
			 		$("#applyId").val(applyId);
			 		var html = '';
			 		var	htmlmore='';
			 		var  applyAsset_0 = data.data[0];
		 			html='<div id="applyAsset_' + applyAsset_0.id +'" class="item active" style="text-align: center;">'+
		 			'<img style="width: 100%;height: 300px;border: 1px solid #ddd;" src="' + applyAsset_0.realPath + '" alt="">' +
		 			'</div>'
			 		for(var i = 1; i<data.data.length; i++){		 			
			 			var applyAsset = data.data[i];
			 			htmlmore +='<div id="applyAsset_' + applyAsset.id +'" class="item" style="text-align: center;">'+
			 			'<img style="width:100%;height: 300px;border: 1px solid #ddd;" src="' + applyAsset.realPath + '" alt="">' +
			 			'</div>'
			 		}
		 			html+=htmlmore;
			 		$("#agreement-show").html(html);
			 	}
	    	},
	    	error: function(data) {
	    		//返回500错误页面
	    		$("html").html(data.responseText);
	    	}
		});
	};
	
    function checkFile(file) {
        if ((file.size/1024/1024) > 5) {
			$('#errorMsg').text("您选择的图片大于5M, 请重新选择小于5M的图片上传");
			return false;
		}
        return true;
    };
	function queryService(url, pageNum){
		var majorType = $("#majorType").val();
		var appBusinessName = $("#appBusinessName").val();
		var applyStatus = $("#applyStatus").val();
		var page = 0;
		if (pageNum) {
			page = pageNum -1;
		}
		$.ajax({
			 type: 'GET',
			 url: marketing_url + url,
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
	function openService(applyId){
		createUser();
		var applyStatus = 'opened';
		var tempData = {applyStatus:applyStatus};
		 $.ajax({
				type: 'POST',
				url:  marketing_url + '/admin/service/' + applyId + '/approve',
				 contentType : 'application/json',
				 data: JSON.stringify(tempData),
				 dataType: 'json', 
				success: function(data) {
					if (!data.success) {
						noty({text: data.errorMessage, layout: 'topCenter', type: 'error', timeout: 2000});
						return;
					}else{
						noty({text: "开通成功", layout: 'topCenter', type: 'success', timeout: 2000});
						$("#server-management-model").modal('hide');
						$("#service_" + applyId).text("已开通");
						$("#approve_" + applyId).hide();
						$("#delete_" + applyId).hide();
						tempData.username = data.data.username;
			 			sendEmail(tempData);
					} 
	        	},
	        	error: function(data) {
	        		noty({text: '开通失败', layout: 'topCenter', type: 'error', timeout: 2000});
	        	}
			});
	};
	
	function rejectService(applyId){
		var rejectReason = $("#rejectReason").val();
		if(!rejectReason){
			$('#errorMsg').text("请填写驳回原因");
			return;
		}
		var applyStatus = 'rejected';
		var tempData = {applyStatus:applyStatus, rejectReason:rejectReason};
		 $.ajax({
				type: 'POST',
				url: marketing_url + '/admin/service/' + applyId + '/approve',
				 contentType : 'application/json',
				 data: JSON.stringify(tempData),
				 dataType: 'json', 
				success: function(data) {
					if (!data.success) {
						noty({text: data.errorMessage, layout: 'topCenter', type: 'error', timeout: 2000});
						return;
					}else{
						noty({text: "驳回成功", layout: 'topCenter', type: 'success', timeout: 2000});
						$("#server-management-model").modal('hide');
						$("#service_" + applyId).text("已驳回");
						$("#approve_" + applyId).hide();
						$("#delete_" + applyId).hide();
			 			sendEmail(tempData);
					} 
	        	},
	        	error: function(data) {
	        		noty({text: '驳回失败', layout: 'topCenter', type: 'error', timeout: 2000});
	        	}
			});
	};
	
	function addAsset(){
		var formData = new FormData();
		var files =  document.getElementById("addAgreementPic").files;
		for (var i = 0; i < files.length; i++) {
  			var file = files[i];
  			if (!checkFile(file)) {
  			//$('#errorMsg').text("您选择的图片大于5M, 请重新选择小于5M的图片上传");
  				return;
  			}
  			formData.append('images', file, file.name);
		}
		var applyId = $("#applyId").val();
		formData.append('applyId', applyId);
		tunicorn.utils.postFormData(marketing_url + '/admin/service/applyAsset/create', formData, function(err, result){
			if(err){
				noty({text: "服务器异常!", layout: "topCenter", type: "error", timeout: 2000});
				return;
			}
			if(result.success){
				noty({text: '保存成功', layout: 'topCenter', type: 'warning', timeout: 2000});
		 		$('#new-server-model').modal('hide');
		 		view(applyId, true);
			}else{
				noty({text: result.errorMessage, layout: "topCenter", type: "error", timeout: 2000});
				return;
			}
		});
	};
    function deleteApplyAsset(assetId){
    	$.ajax({
			 type: 'PUT',
			 url: marketing_url + '/admin/service/applyAsset/' + assetId,
			 contentType : 'application/json',
			 dataType: 'json', 
			 success: function(data) {
			 	if (data.success) {
			 		$("#applyAsset_" + assetId).remove();
			 	}
        	},
        	error: function(data) {
        		//返回500错误页面
        		$("html").html(data.responseText);
        	}
		});
    };
	function createUser(){
		var username = $("#ser-user-name").val();
		var email = $("#ser-email").val();
		var data = {'userName':username, 'email':email};
		$.ajax({
			type: 'POST',
			url: marketing_url + '/user/create',
			contentType : 'application/json',
			dataType: 'json', 
			data: JSON.stringify(data),
			success: function(data) {
				if (!data.success) {
					noty({text: data.errorMessage, layout: 'topCenter', type: 'warning', timeout: 2000});
					return;
				}
        	},
        	error: function(data) {
        		noty({text: '创建用户失败', layout: 'topCenter', type: 'error', timeout: 2000});
        	}
		});
	};
	function sendEmail(data){
		var formData = new FormData();
		formData.append('applyStatus', data.applyStatus);
		formData.append('username', data.username);
		formData.append('rejectReason', data.rejectReason);
		tunicorn.utils.postFormData(marketing_url + '/admin/service/sendEmail', formData, function(err, result){
			if(err){
				noty({text: "服务器异常!", layout: "topCenter", type: "error", timeout: 2000});
				return;
			}
		});
	}
	function initPagination(currentPage, totalCount, url) {
		var options = {
			alignment: 'center',
	        currentPage: currentPage,
	        totalPages: Math.ceil(totalCount / dface.constants.PAGINATION_ITEMS_PER_PAGE),
	        numberOfPages: dface.constants.PAGINATION_ITEMS_PER_PAGE,
	        onPageClicked: function (event, originalEvent, type, page) {
	        	doPaginationClicked(url, page);
	        }
		};
		
		$('#table_paginator').bootstrapPaginator(options);
		$("#table_paginator").show();
	};
	
	function doPaginationClicked(url, pageNum) {
		queryService(url, pageNum);
	};
	return {
		serviceApplyInit:serviceApplyInit,
		serviceManageInit:serviceManageInit,
		deleteApplyAsset:deleteApplyAsset,
		addAsset:addAsset
	}
})()