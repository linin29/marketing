<div class="count_list">
    <section class="task_list_header">
        <h3>统计列表
            <small>本次查询共<span id="number">${callingCount}</span>次调用</small>
        </h3>
    </section>
    <section class="content_list">
        <table class="table table-bordered table-hover table-condensed">
            <thead>
                <tr>
                    <th>调用API</th>
                    <th>调用方法</th>
                    <th>用户</th>
                    <th>调用日期</th>
                    <th>调用次数</th>
                </tr>
            </thead>
            <tbody>
              <#list callings as calling>
                <tr>
                    <td>${calling.apiName!""}</td>
                    <td>${calling.apiMethod!""}</td>
                    <td>${calling.userName!""}</td>
                    <td>${calling.callingDay!""}</td>
                    <td>${calling.callingTimes!""}</td>
                </tr>
                </#list>
            </tbody>
        </table>
        <div id="table_paginator" style="margin-top: -10px; margin-bottom: -10px; text-align:center; display:block;"></div>
    </section>
</div>
<script>
$(function() {
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
		searchApiCalling(pageNum);
	}
	if(${totalCount} != 0){
		initPagination(${currentPage}, ${totalCount?c});
	}
});

function searchApiCalling(pageNum) {
	var page = 0;
	if (pageNum) {
		page = pageNum -1;
	}
	$.ajax({
		 type: 'GET',
		 url: '${springMacroRequestContext.contextPath}/calling/search?pageNum=' + page,
		 success: function(data) {
		 	$("#content").html(data);
    	},
    	error: function(data) {
    		//返回500错误页面
    		$("html").html(data.responseText);
    	}
	});
}
</script>