<div class="count_list">
    <section class="task_list_header">
        <h3>统计列表
            <small>本次查询共<span id="number">${totalCount}</span>条记录，<span id="number">${callingCount}</span>次调用</small>
        </h3>
    </section>
    <section>
		<div class='form-group col-sm-6'>
			<span class="control-label line-height col-sm-2 text-center">时间段：</span>
			<div class='col-sm-10'>
			 	<input id="startTime" type="hidden" <#if startDate??> value="${startDate}"</#if>>
				<input id="endTime" type="hidden" <#if endDate??> value="${endDate}"</#if>>
			 	 <div style="float: left; width: 48%;" class="form-group input-group date form_datetime1" data-date="2016-11-1" data-date-format="yyyy-mm-dd" >
			        <input class="form-control" size="16" type="text" value="" id="startDate">
			        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
			    </div>
			    <div  style="float: left;line-height: 34px" class="form-group glyphicon glyphicon-minus"></div>
			     <div style="float: left;  width: 48%;" class=" input-group date form_datetime2" data-date="2016-11-1" data-date-format="yyyy-mm-dd" >
			        <input class="form-control" size="16" type="text" value="" id="endDate">
			        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
			    </div>
			</div>
		</div>	
		<div class="text-right" style='margin-right:35px;'>
			<button class='btn btn-success' id="query">查询</button>
		</div>
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
var PAGINATION_ITEMS_PER_PAGE = 20;
$(function() {
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
	
	if(${totalCount} != 0){
		initPagination(${currentPage}, ${totalCount?c});
	}else{
		$("#table_paginator").hide();
	}
	initDate();
	
	$('#query').click(function(){
		searchApiCalling(1);
	});
});
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
		 url: '${springMacroRequestContext.contextPath}/calling',
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