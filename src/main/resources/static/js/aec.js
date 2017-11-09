var marketing_url = '/marketing';
var aec = aec || {};
aec = (function(){
	var checkedIds = [];
	function init(currentPage, totalCount){
		initDate();
		initTableCheckbox();
		if(totalCount != "0"){
			initPagination(currentPage, totalCount);
		}
		$("#query").click(function(){
			$('table thead tr').find("input").prop('checked', false);
			checkedIds = [];
			queryTask();
		});
	 	$('#zip_import').click(function(){
	 		 $('#file_select').click();
	 	});
	 	$('#file_select').change(function(){
	 		 var _file = $(this)[0];
	 		 var files = _file.files;
	 		 var total = files.length;
	 		 var url = marketing_url + '/aec/upload';

	 		 var formData = new FormData();
	 		 
	 		 for (var i = 0; i < files.length; i++) {
	 		      var file = files[i];
	 		      formData.append('zipFile', file, file.name);
	 		 }
	 		 $('#waiting').modal({keyboard: false, backdrop: 'static'});
	 		 $('#waiting').modal('show');
	 		 $.ajax({
	 			type: "POST",
	 			url: url,
	 			data : formData, 
	 			processData : false, 
	 			contentType : false,
	 			success: function (resp) {
	 				 $('#waiting').modal('hide');
	 				 if(resp && resp.success){
	 					noty({text: "纠错成功", layout: "topCenter", type: "success", timeout: 1000}); 
	 				 }else{
	 					noty({text: "纠错失败", layout: "topCenter", type: "warning", timeout: 1000}); 
	 				 }
	 			},
	 			error: function (message) {
	 				 $('#waiting').modal('hide');
	 				 noty({text: "纠错失败", layout: "topCenter", type: "error", timeout: 1000});
	 			}
	 		 });
	 	});
		$("#download").click(function(){
			if(checkedIds && checkedIds.length > 0){
				$("#downloadForm").find("#taskIds").val(checkedIds.toString());
				 $('#downloadForm').form('submit', {
	                 type:'get',
	                 url: marketing_url  + '/aec/download',
	                 success:function(result){
	        	 		noty({text: "下载成功", layout: "topCenter", type: "success", timeout: 1000});
	                 },
	                 error:function(message){
	                	 noty({text: "下载失败", layout: "topCenter", type: "error", timeout: 1000});
	                 }
	             }); 
			}else{
				noty({text: '请选择任务进行下载', layout: "topCenter", type: "warning", timeout: 2000});
		 		return;
			}
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
		    var d = e.date;  
		    $('.form_datetime2').datetimepicker('setStartDate', d);
		});
		$('.form_datetime2').datetimepicker({
		    language: 'zh-CN',
		    autoclose:true,
		    startDate:$("#fromDate").val(),
		    endDate : new Date()
		}).on('changeDate',function(e){
		    var d = e.date;  
		    $('.form_datetime1').datetimepicker('setEndDate', d);
		    var end = d.setDate(d.getDate() - 2);
		    var newdata = moment(d);
		});
		
	};
	
	function queryTask(pageNum){
		var majorType = $("#majorType").val();
		var startTime = $("#fromDate").val();
		var endTime = $("#toDate").val();
		var page = 0;
		if (pageNum) {
			page = pageNum -1;
		}
		var data = {pageNum:page, startTime:startTime, endTime:endTime, majorType:majorType};
		$.ajax({
			 type: 'POST',
			 url: marketing_url + '/aec/search',
			 data: JSON.stringify(data),
			 contentType: 'application/json',
			 success: function(resp) {
					if(!resp.success) {
						noty({text: resp.errorMessage, layout: 'topCenter', type: 'error', timeout: 2000});
						return;
					}
					var tasks = resp.data.tasks;
					if(tasks.length == 0){
						$('#track-table').find('tbody').html("");
						$("#table_paginator").hide();
						return;
					}
					var html = '';
					$.each(tasks, function(index, item) {
						html += '<tr class="tabelCenter data">'+
									'<td><input id="' + item.id + '" type="checkbox" name="checkItem" /></td>'+
            						'<td>' + item.name + '</td>'+
            						'<td>' + item.id + '</td>'+
            						'<td>' + item.majorTypeName + '</td>'+
            						'<td>' + item.lastUpdateTimeStr + '</td>'+
            						'<td>'+
            							'<a href="javascript:void(0);" onclick="getTaskDetail(\'' + item.id + '\')" class="ajax-link">查看</a>'+
            						'</td>'+
            					'</tr>';
					});
					$('#track-table').find('tbody').html(html);
					var totalCount = resp.data.totalCount;
					if(totalCount == 0){
						$("#track-table").hide();
						$("#table_paginator").hide();
					}else{
						$("#track-table").show();
						$('table thead tr').find("input").prop('checked', false);
						$('table thead tr').find("input").unbind("click");
						initTableCheckbox();
						checkedIds = [];
						//setChecked();
						initPagination(pageNum || 1, totalCount);
					}
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
	
	  function initTableCheckbox() {  
          var thr = $('table thead tr'); 
          var tbr = $('table tbody tr'); 
          var checkAll = thr.find('input');  
          checkAll.click(function(event){
              tbr.find('input').prop('checked', $(this).prop('checked'));
              if($(this).is(":checked")){
                  for(var i = 0; i < tbr.find('input').length; i++){
                	 checkedIds.push(tbr.find('input').eq(i).attr("id"));
      	         }  
              }else{
                  for(var i = 0; i < tbr.find('input').length; i++){
                	  for(var j = 0; j < checkedIds.length; j++){
            	          if(tbr.find('input').eq(i).attr("id") == checkedIds[j]){
            	             checkedIds.splice(j, 1);  
            	          }
            	      }
       	         }  
              }
              event.stopPropagation();  
          });  
          tbr.find('input').click(function(event){
        	  if($(this).is(":checked")){
        	         checkedIds.push($(this).attr("id"));
        	   }else{
        	         for(var i = 0; i < tbr.find('input').length; i++){
        	             if($(this).attr("id") == checkedIds[i]){
        	             checkedIds.splice(i, 1);  
        	             }
        	         }
        	  }
              checkAll.prop('checked', tbr.find('input:checked').length == tbr.length ? true : false);
              console.log(checkedIds.length);
              event.stopPropagation(); 
          });  
      };
      
      function setChecked(){
          var boxes = $('table tbody tr').find("input");
          for(var i = 0; i < boxes.length; i++){
              var id = boxes[i].id;
              if(checkedIds.indexOf(id, 0) != -1){
                  boxes[i].checked = true;
              }else{
                  boxes[i].checked = false;
              }
          }
       };
	return {
		_init:init
	}
})()