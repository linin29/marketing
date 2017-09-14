var m_url='/marketing';
var countList=countList || {};
countList=(function(){
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
    		
    		initPagination(currentPage, totalCount);
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
 		    var d=e.date;  
 		    $('.form_datetime1').datetimepicker('setEndDate',d);
 		    var end=d.setDate(d.getDate()-2);
 		    var newdata=moment(d);
 		});
 		
 	};
 	
 	function searchApiCalling(pageNum) {
 		if (pageNum) {
 			pageNum = pageNum - 1;
 		}else{
 			pageNum = 0;
 		}
 		var startDate = $('#startDate').val();
 		var endDate = $('#endDate').val();
 		var data = {
 			perPage: PAGINATION_ITEMS_PER_PAGE,
 			pageNum: pageNum,
 			startDate: startDate,
 			endDate: endDate
 		}
 		$.ajax({
 			 type: 'GET',
 			 data: data,
 			 url: m_url + '/calling',
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
          _init:init
     }

})()
