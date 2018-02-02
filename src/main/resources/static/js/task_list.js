var m_url='/marketing/';
var taskList=taskList || {};
taskList=(function(){
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
			if(searchTaskFlg == 1){
				searchTaskWithId(pageNum)
			}else if(searchTaskFlg == 2){
				searchTaskWithName(pageNum);
			}else{
				searchTask(pageNum);
			}
		}
		if(totalCount!= 0){
			initPagination(currentPage, totalCount);
		}
     };
     
     function searchTaskWithId(pageNum) {
    		searchTaskFlg = 1;
    		var taskId = $("#taskId").val();
    		var page = 0;
    		if (pageNum) {
    			page = pageNum -1;
    		}
    		$.ajax({
    			 type: 'GET',
    			 url: m_url + 'task/search?pageNum=' + page +"&taskId=" + taskId,
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
    			 url: m_url + 'task/search?pageNum=' + page,
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
    		searchTaskFlg = 2;
    		var taskName = $("#taskName").val();
    		var majorType = $("#majorType").val();
    		var projectId = $("#projectId").val()
    		var page = 0;
    		if (pageNum) {
    			page = pageNum -1;
    		}
    		$.ajax({
    			 type: 'GET',
    			 url: m_url + 'task/search?pageNum=' + page +"&taskName=" +taskName + "&majorType=" + majorType + "&projectId=" + projectId,
    			 success: function(data) {
    			 	$("#content").html(data);
    	    	},
    	    	error: function(data) {
    	    		//返回500错误页面
    	    		$("html").html(data.responseText);
    	    	}
    		});
    	}

    	function getTaskDetail(taskId) {
    		$.ajax({
    			 type: 'GET',
    			 url: m_url + 'showTask/' + taskId,
    			 success: function(data) {
    			 	$("#content").html(data);
    	    	},
    	    	error: function(data) {
    	    		//返回500错误页面
    	    		$("html").html(data.responseText);
    	    	}
    		});
    	}

    	function addTask() {
    		$.ajax({
    			 type: 'GET',
    			 url: m_url + 'showTask/-1',
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
          searchTaskWithName:searchTaskWithName,
          getTaskDetail:getTaskDetail,
          addTask:addTask
     }

})()
