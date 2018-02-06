var m_url='/marketing';
var adminCountList=adminCountList || {};
adminCountList=(function(){
	var PAGINATION_ITEMS_PER_PAGE = 20;
     function init(currentPage, totalCount){
    	 if(totalCount != 0){
    			initPagination(currentPage, totalCount);
    		}else{
    			$("#table_paginator").hide();
    		}
    		initDate();
    		
    		$('#query').click(function(){
    			searchApiCalling(1);
    		});
        	$('#project').change(function(){
        		getMajorType($(this).val());
        	});
    		$("#export").click(function(){
    	 		var projectId = $("#project").val();
    	 		var majorType = $("#majorType").val();
    	 		var startDate = $('#startDate').val();
    	 		var endDate = $('#endDate').val();

    			$.ajax({
    				 type: 'GET',
    				 url: m_url + '/admin/calling/count',
    				 data:{
    					 startTime:startDate,
    					 endTime:endDate,
    					 majorType:majorType,
    					 projectId:projectId
    				 },
    				 success: function(data) {
    				 	if(data && data.success && data.data > 0){
    				 		window.open(m_url +"/admin/calling/exportData?majorType=" + majorType+"&startTime=" + startDate + "&endTime=" + endDate + "&projectId=" + projectId);  
    				 	}else{
    				 		noty({text: '当前无可导出数据', layout: "topCenter", type: "warning", timeout: 2000});
    				 		return;
    				 	}
    		    	},
    		    	error: function(data) {
    		    		//返回500错误页面
    		    		$("html").html(data.responseText);
    		    	}
    			});
    		}); 
     };
     
     function initPagination(currentPage, totalCount) {
  		var options = {
  			alignment: 'center',
  	        currentPage: currentPage,
  	        totalPages: Math.ceil(totalCount / PAGINATION_ITEMS_PER_PAGE),
  	        numberOfPages: PAGINATION_ITEMS_PER_PAGE,
  	        onPageClicked: function (event, originalEvent, type, page) {
  	        	searchApiCalling(page);
  	        }
  		};
  		
  		$('#table_paginator').bootstrapPaginator(options);
  		$("#table_paginator").show();
  	}
      
      function searchApiCalling(pageNum) {
  		if (pageNum) {
  			pageNum = pageNum - 1;
  		}else{
  			pageNum = 0;
  		}
  		var startDate = $('#startDate').val();
  		var endDate = $('#endDate').val();
  		var userName = $('#userName').val();
  		var apiName = $('#apiName').val();
  		var majorType = $('#majorType').val();
  		var projectId = $("#project").val();
  		var data = {
  			perPage: PAGINATION_ITEMS_PER_PAGE,
  			pageNum: pageNum,
  			startDate: startDate,
  			endDate: endDate,
  			userName:userName,
  			apiName:apiName,
  			majorType:majorType,
  			projectId:projectId
  		}
  		$.ajax({
  			 type: 'GET',
  			 data: data,
  			 url: m_url+'/admin/calling',
  			 success: function(data) {
  			 	$("#content").html(data);
  	    	},
  	    	error: function(data) {
  	    		//返回500错误页面
  	    		$("html").html(data.responseText);
  	    	}
  		});
  	};
  	
     function initDate() {
 		var current = moment();
 		var startTime = $("#startTime").val();
 		var endTime = $("#endTime").val();
 		$("#endDate").val(current.format('YYYY-MM-DD'));
 	    $("#startDate").val(current.subtract(5, 'days').format('YYYY-MM-DD'));
 	    if(startTime){
 	    	$("#startDate").val(startTime);
 	    }
 	    if(endTime){
 	    	$("#endDate").val(endTime);
 	    }
 		//时间段显示
 		$('.form_datetime1').datetimepicker({
 		    language: 'zh-CN',
 		    autoclose:true,
 		    endDate : new Date(),
 		    minView : 2
 		}).on('changeDate',function(e){
 			var d=e.date;  
 			$('.form_datetime2').datetimepicker('setStartDate',d);
 		});
 		$('.form_datetime2').datetimepicker({
 		    language: 'zh-CN',
 		    autoclose:true, //选择日期后自动关闭
 		    startDate: $("#startDate").val(),
 		    endDate : new Date(),
 		    minView : 2
 		}).on('changeDate',function(e){
 		    var d = e.date;  
 		    $('.form_datetime1').datetimepicker('setEndDate',d);
 		    var end = d.setDate(d.getDate()-2);
 		    var newdata = moment(d);
 		});
 		
 	};
 	
	function getMajorType(projectId){
		$.ajax({ 
			url : m_url + '/majorType/list?projectId=' + projectId, 
			type : 'GET', 
			success : function(resp) { 
				if(resp.success){
					if(resp.data && resp.data.length > 0){
						var html = "<option value=''>请选择</option>";
						for(var i = 0; i < resp.data.length; i++){
							html += "<option value='"+ resp.data[i].name +"'>"+ resp.data[i].description +"</option>"
						}
						$("#majorType").html(html);
					}
				}
			}, 
			error : function(resp) { 
				 noty({text: '获取品类列表失败', layout: "topCenter", type: "warning", timeout: 2000});
				 return;
			} 
		});
	};
     
     return {
          _init:init
     }

})()
