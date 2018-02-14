var marketing_url = '/marketing';
var adminService = adminService || {};
adminService = (function(){
	var formatArray = ['doc', 'docx', 'pdf', 'png', 'jpeg', 'jpg', 'bmp'];
	function serviceApplyInit(currentPage, totalCount){
		var serviceApplyUrl =  '/admin/service/apply/search';
		if(totalCount != "0"){
			initPagination(currentPage, totalCount, serviceApplyUrl);
		}
		initDate();
		serviceDataValidator();
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
			var applyStatus =$(this).attr("applyStatus");
			if(applyStatus=="opened"||applyStatus=="closed"){
				view($(this).attr("applyid"), false);
			}else{
				view($(this).attr("applyid"), true);
			}
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
        	//$("#new-server-model").find("input").val("");
        	$('#service-form')[0].reset();
        	initDate();
        	$("#project-type").find("option[value='']").prop("selected", true);
			$(this).removeData("bs.modal");
			$("#service-form").data("bootstrapValidator").destroy();
			$('#service-form').data('bootstrapValidator', null);
			serviceDataValidator();
        });
        
        $("#uploadBtn").on("click",function(){
        	$("#addAgreementPic").click();
        })
        
       $("#addAgreementPic").on('change', function(e){
    	 addAsset();
    	   
       })
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
			var applyStatus = $(this).attr("applyStatus");
			var projectType = $("#project-type").val();
			console.log(projectType);
			if(projectType=="free"){
//				$("#server-type").removeAttr("disabled");
				$('#server-type').prop('disabled', false);
				$('#server-type').selectpicker('refresh');
			}else{
//				$("#server-type").attr("disabled","disabled");
  				$('#server-type').prop('disabled', true);
  				$('#server-type').selectpicker('refresh');
			}
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
			var majorType = $("#server-type").val();
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
		
		var formData = new FormData();
		var files =  document.getElementById("upload-book").files;
		if(projectType && projectType != 'free'){
			if (files.length == 0 && !applyId) {
				$('#errorMsg').text("请选择合同图片");
				return;
			}
			if(!contractedValue && contractedValue != "0") {
				$('#errorMsg').text("请输入项目金额");
				return;
			}
			if(!contractedNo) {
				$('#errorMsg').text("请输入合同编号");
				return;
			}
		}
		if(projectType == 'free' && maxCallNumber > 100) {
			$('#errorMsg').text("免费测试调用次数不能大于100");
			return;
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
		
		$("#service-form").data("bootstrapValidator").validate();
		if($("#service-form").data('bootstrapValidator').isValid()){
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
		 			var data ={'applyStatus':'created', 'name':appBusinessName,
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
	}
	function detail(applyId, isRejectReasonShow){
		$.ajax({
			 type: 'GET',
			 async: false,
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
								'<div class="thumbnail newline">' + 
								'<div class="pull-right">';
			 			if(isDelete){
			 				html += '<a href="javascript:void(0)" onclick="adminService.deleteApplyAsset(' + applyAsset.id + ');" class=" glyphicon glyphicon-remove" style="color:red"></a>';
			 				$("#upload_div").show();
			 			}else{
			 				$("#upload_div").hide();
			 			}
			 			html += '</div style="width:120px;">' + 
								/*'<img style="width: 200px;height: 200px" src="' + applyAsset.realPath + '" alt="">' +*/
								'<a href="' + applyAsset.realPath + '" download="'+applyAsset.displayName+'" title="'+applyAsset.displayName+'" >'+applyAsset.displayName+'</a>' +
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
			 		for(var i = 0; i<data.data.length; i++){
			 			var applyAsset = data.data[i];
			 			html += '<div id="applyAsset_' + applyAsset.id + '" class="col-sm-3">' +
								'<div class="thumbnail newline">' + 
								'<div class="pull-right">';
			 			html += '</div style="width:120px;">' + 
								/*'<img style="width: 200px;height: 200px" src="' + applyAsset.realPath + '" alt="">' +*/
								'<a href="' + applyAsset.realPath + '" download="'+applyAsset.displayName+'" title="'+applyAsset.displayName+'" >'+applyAsset.displayName+'</a>' +
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
    	
		if(file){
			var index = file.name.lastIndexOf(".");
			var fileExt = file.name.substring(index + 1, file.name.length).toLowerCase();
			if($.inArray(fileExt, formatArray) == -1){
				noty({text: "文件格式不支持!", layout: "topCenter", type: "warning", timeout: 2000});
				return;
			}
		}
        if ((file.size/1024/1024) > 5) {
        	noty({text: "您选择的文件大于5M, 请重新选择小于5M的文件上传", layout: "topCenter", type: "warning", timeout: 2000});
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
		var majorType = $("#server-type").val();
		var mt = [];
		for(i=0;i<majorType.length;i++){
			mt[i]={"id":majorType[i]};
		}
		var tempData = {"applyStatus":applyStatus, "username":username, "email":email, "majorTypes":mt};
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
		formData.append('name', data.name);
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
		}).on('hide', function(e) {  
            $('#service-form').data('bootstrapValidator')  
            .updateStatus('fromDate', 'NOT_VALIDATED', null)  
            .validateField('fromDate');
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
		}).on('hide', function(e) {  
            $('#service-form').data('bootstrapValidator')  
            .updateStatus('toDate', 'NOT_VALIDATED', null)  
            .validateField('toDate');
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
	function serviceDataValidator(){
    	$('#service-form').bootstrapValidator({
		message: 'This value is not valid',
		feedbackIcons: {
			valid: 'glyphicon glyphicon-ok',
			invalid: 'glyphicon glyphicon-remove',
			validating: 'glyphicon glyphicon-refresh'
		},
		fields: {
			name: {
				message: 'The name is not valid',
				validators: {
					notEmpty: {
						message: '项目名称不能为空'
					},
					stringLength: {
						min: 1,
						max: 40,
						message: '项目名称长度在1-40个字符之内'
					},
					regexp: {
						regexp: /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/,
						message: '项目名称只能是中文、英文、数字和下划线组合'
					}
				}
			},
			address:{
				message: 'The address is not valid',
				validators: {
					notEmpty: {
						message: '地址不能为空'
					},
					stringLength: {
						min: 1,
						max: 200,
						message: '地址长度在1-200个字符之内'
					},
				}
			},
			contacts: {
				message: 'The contacts is not valid',
				validators: {
					notEmpty: {
						message: '联系人不能为空'
					},
					stringLength: {
						min: 1,
						max: 80,
						message: '联系人长度在1-80个字符之内'
					},
					regexp: {
						regexp: /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/,
						message: '联系人只能是中文、英文、数字和下划线组合'
					}
				}
			}, 
			mobile: {
				message: 'The mobile is not valid',
				validators: {
        			notEmpty: {
        				message: '联系方式不能为空'
        			},
        			regexp: {
						regexp: /^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\d{8}$/,
						message: '联系方式格式不正确'
					}
				}
			},
			serverType: {
				message: 'The serverType is not valid',
				validators: {
        			notEmpty: {
        				message: '服务不能为空'
        			}
				}
			},
			projectType: {
				message: 'The projectType is not valid',
				validators: {
        			notEmpty: {
        				message: '项目类型不能为空'
        			}
				}
			},
			fromDate:{
				message: 'The fromDate is not valid',
				validators: {
					notEmpty: {
						message: '项目开始时间不能为空'
					},
					date: {
                        format: 'YYYY-MM-DD hh:mm:ss',
                        message: '项目开始时间格式不正确'
                    }
				}
			},
			toDate:{
				message: 'The toDate is not valid',
				validators: {
					notEmpty: {
						message: '项目结束时间不能为空'
					},
					date: {
                        format: 'YYYY-MM-DD hh:mm:ss',
                        message: '项目结束时间格式不正确'
                    }
				}
			},
			storeNumber: {
				message: 'The storeNumber is not valid',
				validators: {
					callback: {
				        message: '门店数是1-999999999之间的正整数',
				        callback: function(value, validator) {
				        	var flag = false;
				        	if(!(/(^[1-9]\d*$)/.test(value))){
				        		return false;
				        	}
				            if (0 < parseInt(value) &&  parseInt(value) <= 999999999) {
				                flag = true;
				            }
				            return flag;
				        }
				    }
				}

			},
			imageNumber: {
				message: 'The imageNumber is not valid',
				validators: {
					callback: {
				        message: '图片数是1-999999999之间的正整数',
				        callback: function(value, validator) {
				        	var flag = false;
				        	if(!(/(^[1-9]\d*$)/.test(value))){
				        		return false;
				        	}
				            if (0 < parseInt(value) &&  parseInt(value) <= 999999999) {
				                flag = true;
				            }
				            return flag;
				        }
				    }
				}
			},
			callNumber: {
				message: 'The callNumber is not valid',
				validators: {
					callback: {
				        message: '调用数是1-999999999之间的正整数',
				        callback: function(value, validator) {
				        	var flag = false;
				        	if(!(/(^[1-9]\d*$)/.test(value))){
				        		return false;
				        	}
				            if (0 < parseInt(value) &&  parseInt(value) <= 999999999) {
				                flag = true;
				            }
				            return flag;
				        }
				    }
				}
			},
			threshhold: {
				message: 'The threshhold is not valid',
				validators: {
					notEmpty: {
						message: '调用率提醒不能为空'
					},
					regexp: {
						regexp: /^(([1-9]\d?)|100)$/,
						message: '调用率提醒只能输入1-100之间的正整数'
					}
				}
			},
			username: {
				message: 'The username is not valid',
				validators: {
					notEmpty: {
						message: '用户名不能为空'
					},
					stringLength: {
						min: 1,
						max: 80,
						message: '用户名长度在1-80个字符之内'
					},
					regexp: {
						regexp: /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/,
						message: '用户名只能是中文、英文、数字和下划线组合'
					}
				}
			},
			email: {
				message: 'The email is not valid',
				validators: {
					notEmpty: {
						message: '邮箱不能为空'
					},
					 emailAddress: {
	                    message: '邮箱格式有误'
	                }
				}
			}
			
		}
	});
  };
	return {
		serviceApplyInit:serviceApplyInit,
		serviceManageInit:serviceManageInit,
		deleteApplyAsset:deleteApplyAsset
	}
})()