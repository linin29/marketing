var marketing_url = '/marketing';
var adminService = adminService || {};
adminService = (function(){
	function serviceApplyInit(currentPage, totalCount){
		var serviceApplyUrl =  '/admin/service/apply/search';
		if(totalCount != "0"){
			initPagination(currentPage, totalCount, serviceApplyUrl);
		}
		initDate();
		$("#query").click(function(){
			queryService(serviceApplyUrl);
		});
		$("#new-server").click(function(){
			$("#sure").hide();
			$("#saveService").show();
			$("#cancel").show();
			$("#upload-book-tr").show();
			//$("#upload-book-div").show();
			$("#applyId").val("");
			$("#rejectReasonDiv").hide();
			$("#new-server-model").modal("show");
			$("#new-server-model").find("input").removeAttr("disabled");
			$("#server-type").removeAttr("disabled");
			$('#server-type').selectpicker('refresh');
			$('#server-type').selectpicker('val', "");
			$("#project-id-tr").hide();
			$("#project-type").removeAttr("disabled");
			$("#errorMsg").html("");
		}); 
		$("#saveService").click(function(){
			saveService();
		});
		$(".modify").click(function(){
			$("#sure").hide();
			$("#saveService").show();
			$("#cancel").show();
			$("#upload-book-tr").hide();
			//$("#upload-book-div").hide();
			$("#rejectReasonDiv").hide();
			$("#applyId").val($(this).attr("applyid"));
			detail($(this).attr("applyid"));
			$("#myModalLabel").text("修改申请");	
			$("#new-server-model").modal("show");
			$("#new-server-model").find("input").removeAttr("disabled");
			$("#rejectReason").attr("disabled", "disabled");
			$("#errorMsg").html("");
			$("#server-type").removeAttr("disabled");
			$("#project-type").removeAttr("disabled");
			$("#project-id-tr").hide();
		});
		$(".info").click(function(){
			$("#upload-book-tr").hide();
			//$("#upload-book-div").hide();
			$("#myModalLabel").text("服务申请详情");	
			$("#sure").hide();
			$("#saveService").hide();
			$("#cancel").hide();
			$("#rejectReasonDiv").hide();
			$("#new-server-model").modal("show");
			detail($(this).attr("applyid"));
			$("#new-server-model").find("input").attr("disabled","disabled"); 
			$("#errorMsg").html("");
			$("#server-type").attr("disabled", "disabled"); 
			$("#project-type").attr("disabled", "disabled");
			$("#project-id-tr").show();
		});
		$(".showAgreementModel").click(function(){
			$("#showagreementModel").modal("show");
			view($(this).attr("applyid"), true);
		});
		
		$('#server-type').selectpicker({
        	width:"343px",
        	liveSearch:true
        });
        $('#admin-type').selectpicker({
        	width:"343px",
        	liveSearch:true
        });
        $("#new-server-model").on("hidden.bs.modal", function() {
        	$("#new-server-model").find("input").val("");
			$(this).removeData("bs.modal");
        });
	};
	function serviceManageInit(currentPage, totalCount){
		var serviceManageUrl = '/admin/service/manage/search';
		if(totalCount != "0"){
			initPagination(currentPage, totalCount, serviceManageUrl);
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
			$("#server-type").attr("disabled","disabled");
			$("#project-type").attr("disabled","disabled");
			$("#rejectReason").removeAttr("disabled"); 
			$("#rejectReason").val("");
			$("#errorMsg").html("");
		});
		$('#server-type').selectpicker({
			width:"343px",
        	liveSearch:true
        });
        $('#admin-type').selectpicker({
        	width:"343px",
        	liveSearch:true
        });
		$("#query").click(function(){
			queryService(serviceManageUrl);
		});
		$(".info").click(function(){
			$("#upload-book-tr").hide();
			$("#myModalLabel").text("服务申请详情");	
			$("#sure").show();
			$("#openService").hide();
			$("#sure").hide();
			$("#rejectService").hide();
			$("#server-management-model").modal("show");
			detail($(this).attr("applyid"));
			$("#server-management-model").find("input").attr("disabled","disabled"); 
			$("#server-type").attr("disabled","disabled");
			$("#project-type").attr("disabled","disabled");
			$("#rejectReason").attr("disabled","disabled");
			$("#errorMsg").html("");
		});
		$(".showAgreementModel").click(function(){
			$("#showagreementModel").modal("show");
			viewManage($(this).attr("applyid"));
		});
		$(".deleteService").click(function(){
			$("#deleteServiceModal").attr('applyid', $(this).attr("applyid"));
			$("#deleteServiceModal").modal("show");
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
			 var applyId = $("#deleteServiceModal").attr('applyid');
			 $.ajax({
					type: 'DELETE',
					url: marketing_url + '/admin/service/' + applyId,
					dataType: 'json', 
					success: function(data) {
						if (!data.success) {
							noty({text: data.errorMessage, layout: 'topCenter', type: 'error', timeout: 2000});
							return;
						}else{
							noty({text: "关闭成功", layout: 'topCenter', type: 'success', timeout: 2000});
							$("#deleteServiceModal").modal('hide');
							$("#approve_" + applyId).hide();
							$("#delete_" + applyId).hide();
							//$('.tableTr[applyid=' + applyId + ']').remove();
						} 
		        	},
		        	error: function(data) {
		        		noty({text: '删除失败', layout: 'topCenter', type: 'error', timeout: 2000});
		        	}
				});
		 });
	}
	function saveService(){
		var appBusinessName = $('#ser-name').val();
		var appBusinessAddress = $('#ser-address').val();
		var appBusinessContacts = $('#ser-phone-person').val();
		var appBusinessMobile = $('#ser-phone').val();
		var maxCallNumber = $('#application-number').val();
		var majorTypes = $("#server-type").val();
		var username = $("#ser-user-name").val();
		var email = $("#ser-email").val();
		var applyId = $("#applyId").val();
		var startTime = $("#fromDate").val();
		var endTime = $("#toDate").val();
		var contractedValue = $("#contracted-value").val();
		var contractedNo = $("#contracted-no").val();
		var storeNumber = $("#store-no").val();
		var imageNumber =$("#pic-number").val();
		var threshhold = $("#threshhold").val();
		var projectType = $("#project-type").val();
		debugger;
		if(appBusinessName == "") {
			$('#errorMsg').text("请输入项目名称");
			return;
		};
		if(appBusinessAddress == "") {
			$('#errorMsg').text("请输入项目地址");
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
		if(!majorTypes) {
			$('#errorMsg').text("请选择服务");
			return;
		}
		if(!projectType) {
			$('#errorMsg').text("请选择项目类型");
			return;
		}
		if(projectType && projectType != 'free'){
			if (files.length == 0 && !applyId) {
				$('#errorMsg').text("请选择合同图片");
				return;
			}
			if(!contractedValue) {
				$('#errorMsg').text("请输入项目金额");
				return;
			}
			if(!contractedNo) {
				$('#errorMsg').text("请输入项目编号");
				return;
			}
		}
		if(startTime == "") {
			$('#errorMsg').text("请输入开始时间");
			return;
		}
		if(endTime == "") {
			$('#errorMsg').text("请输入结束时间");
			return;
		}
		if(storeNumber == "") {
			$('#errorMsg').text("请输入门店数");
			return;
		}
		if(imageNumber == "") {
			$('#errorMsg').text("请输入图片数");
			return;
		}
		if(maxCallNumber == "") {
			$('#errorMsg').text("请输入申请次数");
			return;
		}
		if(threshhold == "") {
			$('#errorMsg').text("请输入调用率提醒");
			return;
		}
		if(username == "") {
			$('#errorMsg').text("请输入用户名");
			return;
		};
		var regex = /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
		if(!email || !regex.test(email)){
			noty({text: "Email格式不正确", layout: "topCenter", type: "warning", timeout: 2000});
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
	  				return;
	  			}
	  			formData.append('images', file, file.name);
			}
		}
		formData.append('name', appBusinessName);
		formData.append('address', appBusinessAddress);
		formData.append('contacts', appBusinessContacts);
		formData.append('mobile', appBusinessMobile);
		formData.append('maxCallNumber', maxCallNumber);
		formData.append('majorTypes', majorTypes);
		formData.append('username', username);
		formData.append('email', email);
		formData.append('startTime', startTime);
		formData.append('endTime', endTime);
		formData.append('contractedValue', contractedValue);
		formData.append('contractedNo', contractedNo);
		formData.append('storeNumber', storeNumber);
		formData.append('imageNumber', imageNumber);
		formData.append('threshhold', parseFloat(threshhold)/100);
		formData.append('projectType', projectType);
		tunicorn.utils.postFormData(url, formData, function(err, result){
			if(err){
				noty({text: "服务器异常", layout: "topCenter", type: "error", timeout: 2000});
				return;
			}
			if(result.success){
				noty({text: '保存成功', layout: 'topCenter', type: 'success', timeout: 2000});
		 		$('#new-server-model').modal('hide');
		 		if(!applyId){
		 			formData.append('applyStatus', 'created');
		 			var data ={'applyStatus':'created', 'appBusinessName':appBusinessName,
		 					   'username':username,'majorTypes':majorTypes,'maxCallNumber':maxCallNumber, 'email':email};
		 			sendEmail(data);
		 		}
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
			 		$("#ser-name").val(data.data.project.name).attr('title',data.data.project.name);
			 		$("#ser-address").val(data.data.project.address).attr('title', data.data.project.address);
			 		$("#ser-phone-person").val(data.data.project.contacts).attr('title',data.data.project.contacts);
			 		$("#ser-phone").val(data.data.project.mobile).attr('title',data.data.project.mobile);
			 		$("#application-number").val(data.data.project.callNumber).attr('title',data.data.project.callNumber);
			 		$("#ser-user-name").val(data.data.username).attr('title',data.data.username);
			 		$("#ser-email").val(data.data.email).attr('title',data.data.email);
			 		$("#server-type").val(majorTypeArray);
			 		$('#server-type').selectpicker('val', majorTypeArray);
			 	    $('#server-type').selectpicker('refresh');
			 	    $("#project-id").val(data.data.project.id);
			 	    $("#project-type").val(data.data.project.type);
			 	    $("#fromDate").val(data.data.startTimeStr);
			 	    $("#toDate").val(data.data.endTimeStr);
			 	    $("#store-no").val(data.data.project.storeNumber);
			 	    $("#pic-number").val(data.data.project.imageNumber);
			 	    $("#contracted-value").val(data.data.contractedValue);
			 	    $("#contracted-no").val(data.data.contractedNo);
			 	    $("#threshhold").val(parseFloat(data.data.project.threshhold)*100);
			 	    if(data.data.rejectReason || isRejectReasonShow || data.data.applyStatus == 'rejected'){
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
	
	function viewManage(applyId){
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
		 			'<img style="width: 100%;height: 450px;border: 1px solid #ddd;" src="' + applyAsset_0.realPath + '" alt="">' +
		 			'</div>'
			 		for(var i = 1; i<data.data.length; i++){		 			
			 			var applyAsset = data.data[i];
			 			htmlmore +='<div id="applyAsset_' + applyAsset.id +'" class="item" style="text-align: center;">'+
			 			'<img style="width:100%;height: 450px;border: 1px solid #ddd;" src="' + applyAsset.realPath + '" alt="">' +
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
		var projectName = $("#projectName").val();
		var applyStatus = $("#applyStatus").val();
		var projectType = $("#projectTypeSearch").val();
		var projectId = $("#projectId").val();
		var page = 0;
		if (pageNum) {
			page = pageNum -1;
		}
		$.ajax({
			 type: 'GET',
			 url: marketing_url + url,
			 data:{
				 pageNum:page,
				 projectName:projectName,
				 applyStatus:applyStatus,
				 projectType:projectType,
				 projectId:projectId
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
		var applyStatus = 'opened';
		var username = $("#ser-user-name").val();
		var email = $("#ser-email").val();
		var tempData = {applyStatus:applyStatus, username:username, email:email};
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
						$("#approve_hide_" + applyId).css('display','');
						$("#delete_hide_" + applyId).css('display','');
						tempData.username = data.data.username;
						tempData.appKey = data.data.appKey;
						tempData.appSecret = data.data.appSecret;
						tempData.email = data.data.email;
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
			$('#errorMsg').text("请选择驳回原因");
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
						$("#approve_hide_" + applyId).css('display','');
						$("#delete_hide_" + applyId).css('display','');
						tempData.email = data.data.email;
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
				noty({text: "服务器异常", layout: "topCenter", type: "error", timeout: 2000});
				return;
			}
			if(result.success){
				noty({text: '保存成功', layout: 'topCenter', type: 'success', timeout: 2000});
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
	function sendEmail(data){
		var formData = new FormData();
		formData.append('applyStatus', data.applyStatus);
		formData.append('appBusinessName', data.appBusinessName);
		formData.append('majorTypes', data.majorTypes);
		formData.append('maxCallNumber', data.maxCallNumber);
		formData.append('username', data.username);
		formData.append('rejectReason', data.rejectReason);
		formData.append('appKey', data.appKey);
		formData.append('appSecret', data.appSecret);
		formData.append('email', data.email);
		tunicorn.utils.postFormData(marketing_url + '/admin/service/sendEmail', formData, function(err, result){
			if(err){
				noty({text: "服务器异常", layout: "topCenter", type: "error", timeout: 2000});
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
	function getInitDate() {
		var current = moment();
		return {'startDate': current.format('YYYY-MM-DD HH:mm:ss'), 'endDate': current.add(1, 'M').format('YYYY-MM-DD HH:mm:ss')};
	};
	
	function initDate() {
		$('.datetimepicker').remove();
		var dateData = getInitDate();
		$("#toDate").val(dateData['endDate']);
		$("#fromDate").val(dateData['startDate']);
		
		
		//时间段显示
		$('.form_datetime1').datetimepicker({
			container:"#new-server-model .modal-content",
			format: 'yyyy-mm-dd hh:ii:00',
			language: 'zh-CN',
		    todayBtn : "linked",
		    pickerPosition: "top-right",
		    autoclose:true ,
		    startDate : new Date()
		}).on('changeDate',function(e){
		    var startTime = e.date;
		    $('.form_datetime2').datetimepicker('setStartDate',startTime);
		});
		
		$('.form_datetime2').datetimepicker({
			container:"#new-server-model .modal-content",
			language: 'zh-CN',
		    format: 'yyyy-mm-dd hh:ii:59',
		    todayBtn : "linked",
		    pickerPosition: "top-right",
		    autoclose:true, //选择日期后自动关闭
		    startDate : new Date()
		}).on('changeDate',function(e){
		    var endTime = e.date;
		    $('.form_datetime1').datetimepicker('setEndDate',endTime);
		});
		$('.form_datetime3').datetimepicker({
			format: 'hh:ii:00',
			language: 'zh-CN',
		    todayBtn : "linked",
		    startView:1,
		    autoclose:true ,
		    pickerPosition: "top-right",
		}).on('changeDate',function(e){
		    var startTime = e.date;
		    $('.form_datetime4').datetimepicker('setStartDate',startTime);
		});
		
		$('.form_datetime4').datetimepicker({
		    language: 'zh-CN',
		    format: 'hh:ii:59',
		    todayBtn : "linked",
		    startView: 1,
		    pickerPosition: "top-right",
		    autoclose:true, //选择日期后自动关闭
		    startDate : $(".startTime").val()
		}).on('changeDate',function(e){
		    var endTime = e.date;
		    $('.form_datetime3').datetimepicker('setEndDate',endTime);
		});
	};
	return {
		serviceApplyInit:serviceApplyInit,
		serviceManageInit:serviceManageInit,
		deleteApplyAsset:deleteApplyAsset,
		addAsset:addAsset
	}
})()