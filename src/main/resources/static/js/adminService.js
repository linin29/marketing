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
			$("#sure").hide();
			$("#saveService").show();
			$("#upload-book-tr").show();
			$("#new-server-model").modal("show");
		}); 
		$("#saveService").click(function(){
			saveService();
		});
		$("#modify").click(function(){
			$("#sure").hide();
			$("#saveService").show();
			$("#upload-book-tr").show();
			$("#myModalLabel").text("修改申请");	
			$("#new-server-model").modal("show");
		});
		$(".info").click(function(){
			$("#upload-book-tr").hide();
			$("#myModalLabel").text("服务申请详情");	
			$("#sure").show();
			$("#saveService").hide();
			$("#new-server-model").modal("show");
			detail($(this).attr("applyid"));
		});
		$(".showAgreementModel").click(function(){
			$("#showagreementModel").modal("show");
			view($(this).attr("applyid"));
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
		if(appBusinessContacts == "") {
			$('#errorMsg').text("请输入联系人");
			return;
		}
		var formData = new FormData();
		var files =  document.getElementById("upload-book").files;
		if (files.length == 0) {
			$('#errorMsg').text("请选择人员图片");
			return;
		}
		if(majorTypes == "") {
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
		for (var i = 0; i < files.length; i++) {
  			var file = files[i];
  			if (!checkFile(file)) {
  			//$('#errorMsg').text("您选择的图片大于5M, 请重新选择小于5M的图片上传");
  				return;
  			}
  			formData.append('images', file, file.name);
		}
		var url ='';
		if(applyId){
			url = marketing_url + '/admin/service/' + applyId + '/update';
		}else{
			url = marketing_url + '/admin/service/create';
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
		 		},500)
			}else{
				noty({text: result.errorMessage, layout: "topCenter", type: "error", timeout: 2000});
				return;
			}
		});
	}
	function detail(applyId){
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
			 	    $("#new-server-model").find("input").attr("disabled","disabled"); 
			 	}
	    	},
	    	error: function(data) {
	    		//返回500错误页面
	    		$("html").html(data.responseText);
	    	}
		});
	};
	function view(applyId){
		$.ajax({
			 type: 'GET',
			 url: marketing_url + '/admin/service/applyAsset',
			 data:{
				 applyId:applyId
			 },
			 success: function(data) {
			 	if(data && data.success && data.data){
			 		var html = '';
			 		for(var i = 0; i<data.data.length; i++){
			 			var applyAsset = data.data[i];
			 			html += '<div class="col-sm-3">' +
								'<div class="thumbnail" style="">' + 
								'<div class="pull-right">' +
								'</div>' + 
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
    function checkFile(file) {
        if ((file.size/1024/1024) > 5) {
			$('#errorMsg').text("您选择的图片大于5M, 请重新选择小于5M的图片上传");
			return false;
		}
        return true;
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
		serviceApplyInit:serviceApplyInit,
		serviceManageInit:serviceManageInit
	}
})()