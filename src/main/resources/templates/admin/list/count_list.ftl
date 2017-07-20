<style type='text/css'>
	.tdCenter td,.thCenter th{
		text-align:center;
	}
</style>
<div class="count_list">
	<div class="panel-default">
	  	<div class="panel-heading">调用统计</div>
	  	<div class="panel-body">
	    	<section class="task_list_header" style='margin-top:-8px;'>
	       	   <h3>统计列表
	           	 <small>本次查询共<span id="number">${totalCount}</span>条记录，<span id="number">${callingCount}</span>次调用</small>
	       	   </h3>
	   		</section>
	        <section>
				<div class='form-group'>			
					<div style="float:left;width:43%;">
						<span class="control-label line-height text-center" style="float:left;width:22%;line-height: 34px;" >时间段：</span>
					 	<input id="startTime" type="hidden" <#if startDate??> value="${startDate}"</#if>>
						<input id="endTime" type="hidden" <#if endDate??> value="${endDate}"</#if>>
					 	 <div style="float:left;width:36%;"  class="form-group input-group date form_datetime1 " data-date="2016-11-1" data-date-format="yyyy-mm-dd" >
					        <input class="form-control" size="16" type="text" value="" id="startDate">
					        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
					    </div>
					    <div  style="float:left;line-height: 34px" class="form-group glyphicon glyphicon-minus "></div>
					     <div style="float:left;width:36%;" class=" input-group date form_datetime2 " data-date="2016-11-1" data-date-format="yyyy-mm-dd" >
					        <input class="form-control" size="16" type="text" value="" id="endDate">
					        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
					    </div>
					</div>
					<div style="float:left;width:15%;margin-right:1%;">
						<select id="apiName" style="width:100%;height: 34px;">
							<option value="">请选择API</option>
					     	<option value='stitcher' <#if apiName?? && apiName=='stitcher'> selected </#if>>stitcher</option>
					     	<option value='identify' <#if apiName?? && apiName=='identify'> selected </#if>>identify</option>
						</select> 
					</div>
					<div style="float:left;width:15%;margin-right:1%;">
						<select id="apiMethod" style="width:100%;height: 34px;">
							<option value="" >请选择调用方法</option>
					     	<option value='POST' <#if apiMethod?? && apiMethod=='POST'> selected </#if>>POST</option>
					     	<option value='GET' <#if apiMethod?? && apiMethod=='GET'> selected </#if>>GET</option>
						</select> 
					</div>
					<div style="float:left;width:15%;margin-right:1%;">
		  				<input id="userName" <#if userName??> value="${userName}"</#if> type="text" class="form-control" placeholder="请输入用户名">
					</div>
				</div>
				<div class="text-right" style='margin-right:35px;margin-right: 0%;'>
					<button class='btn btn-success' id="query">查询</button>
				</div>
			</section>
		    <section class="content_list">
		        <table class="table table-bordered table-hover">
		            <thead>
		                <tr class='thCenter' style='background-color:#ddd;'>
		                    <th style='width:20%;'>调用API</th>
		                    <th style='width:20%;'>调用方法</th>
		                    <th style='width:20%;'>用户</th>
		                    <th style='width:20%;'>调用日期</th>
		                    <th style='width:20%;'>调用次数</th>
		                </tr>
		            </thead>
		            <tbody>
		              <#list callings as calling>
		                <tr class='tdCenter'>
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
	</div>
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
	var userName = $('#userName').val();
	var apiName = $('#apiName').val();
	var apiMethod = $('#apiMethod').val();
	var data = {
		perPage: PAGINATION_ITEMS_PER_PAGE,
		pageNum: pageNum,
		startDate: startDate,
		endDate: endDate,
		userName:userName,
		apiName:apiName,
		apiMethod:apiMethod
	}
	$.ajax({
		 type: 'GET',
		 data: data,
		 url: '${springMacroRequestContext.contextPath}/admin/service/calling',
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