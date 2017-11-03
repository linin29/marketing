var m_url='/marketing/';
var taskListTemp=taskListTemp || {};
taskListTemp=(function(){
     function init(currentPage, totalCount){
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
    		}
    		
    		function doPaginationClicked(pageNum) {
    			var taskId = $("#taskId").val();
    			var taskName = $("#taskName").val();
    			if(taskId){
    				searchTaskWithId(pageNum)
    			}else if(taskName){
    				searchTaskWithName(pageNum);
    			}else{
    				searchTask(pageNum);
    			}
    		}
    		if(totalCount != 0){
    			initPagination(currentPage, totalCount);
    		}
     };
     
     function searchTaskWithId(pageNum) {
    		var taskId = $("#taskId").val();
    		var page = 0;
    		if (pageNum) {
    			page = pageNum -1;
    		}
    		$.ajax({
    			 type: 'GET',
    			 url: m_url + 'showView/task/search?pageNum=' + page +"&taskId=" + taskId,
    			 success: function(data) {
    			 	$("#content").html(data);
    	    	},
    	    	error: function(data) {
    	    		//返回500错误页面
    	    		$("html").html(data.responseText);
    	    	}
    		});
    	}

    	function searchTask(pageNum) {
    		var page = 0;
    		if (pageNum) {
    			page = pageNum -1;
    		}
    		$.ajax({
    			 type: 'GET',
    			 url: m_url + 'showView/task/search?pageNum=' + page,
    			 success: function(data) {
    			 	$("#content").html(data);
    	    	},
    	    	error: function(data) {
    	    		//返回500错误页面
    	    		$("html").html(data.responseText);
    	    	}
    		});
    	}

    	function searchTaskWithName(pageNum) {
    		var taskName = $("#taskName").val();
    		var page = 0;
    		if (pageNum) {
    			page = pageNum -1;
    		}
    		$.ajax({
    			 type: 'GET',
    			 url: m_url + 'showView/task/search?pageNum=' + page +"&taskName=" +taskName,
    			 success: function(data) {
    			 	$("#content").html(data);
    	    	},
    	    	error: function(data) {
    	    		//返回500错误页面
    	    		$("html").html(data.responseText);
    	    	}
    		});
    	}
     return {
          _init:init,
          searchTaskWithId:searchTaskWithId,
          searchTaskWithName,searchTaskWithName
     }

})()
