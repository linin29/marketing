var marketing_url = '/marketing';
var dataExport=dataExport || {};
dataExport=(function(){
	function init(currentPage, totalCount){
		initDate();
		if(totalCount != "0"){
			initPagination(currentPage, totalCount);
		}
		$("#query").click(function(){
			queryTask();
		});
		$("#export").click(function(){
			var majorType = $("#majorType").val();
			var startTime = $("#fromDate").val();
			var endTime = $("#toDate").val();
			if(!majorType){
				 noty({text: '请选择品类', layout: "topCenter", type: "warning", timeout: 2000});
				 return;
			}
			 window.open(marketing_url +"/exportData?majorType=" + majorType+"&startTime=" + startTime + "&endTime=" + endTime);  
		}); 
	};
	function initDate() {
		var current = moment();
		var startTime = $("#startTime").val();
		var endTime = $("#endTime").val();
		$("#toDate").val(current.format('YYYY-MM-DD HH:mm:ss'));
	    $("#fromDate").val(current.subtract(2, 'days').format('YYYY-MM-DD HH:mm:ss'));
	    if(startTime){
	    	$("#fromDate").val(startTime);
	    }
	    if(endTime){
	    	$("#toDate").val(endTime);
	    }
		//时间段显示
		$('.form_datetime1').datetimepicker({
		    language: 'zh-CN',
		    autoclose:true ,
		    endDate : new Date()
		}).on('changeDate',function(e){
		    var d=e.date;  
		    $('.form_datetime2').datetimepicker('setStartDate',d);
/*        	var end=d.setDate(d.getDate()+2);
        	var end1=new Date();
        	if(end>end1){
        		$('.form_datetime2').datetimepicker('setEndDate',end1);
        	}else{
        		var newdata=moment(d);
        		$("#toDate").val(newdata.format('YYYY-MM-DD HH:mm:ss'));
        		$('.form_datetime2').datetimepicker('setEndDate',d);
        	} */
		});
		$('.form_datetime2').datetimepicker({
		    language: 'zh-CN',
		    autoclose:true, //选择日期后自动关闭
		    startDate:$("#fromDate").val(),
		    endDate : new Date()
		}).on('changeDate',function(e){
		    var d=e.date;  
		    $('.form_datetime1').datetimepicker('setEndDate',d);
		    var end=d.setDate(d.getDate()-2);
		    var newdata=moment(d);
    		//$("#fromDate").val(newdata.format('YYYY-MM-DD HH:mm:ss'));
		});
		
	};
	
	function queryTask(pageNum){
		var majorType = $("#majorType").val();
		var startTime = $("#fromDate").val();
		var endTime = $("#toDate").val();
		var taskStatus = '';
		$('input:checkbox[name=taskStatus]:checked').each(function(i){
			taskStatus = $(this).val();
		});
		var page = 0;
		if (pageNum) {
			page = pageNum -1;
		}
		$.ajax({
			 type: 'GET',
			 url: marketing_url + '/export/search',
			 data:{
				 pageNum:page,
				 startTime:startTime,
				 endTime:endTime,
				 taskStatus:taskStatus,
				 majorType:majorType
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
		queryTask(pageNum);
	};
	return {
		_init:init
	}
})()