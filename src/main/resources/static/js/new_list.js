var m_url='/marketing/';
var newList=newList || {};
newList=(function(){
	var picPath = '/pic/marketing'; 
	function init(){
		$('#preview').click(function() {
		 	var taskId = $('#taskId').val();
			$.ajax({
	      		 type: 'GET',
	      		 url: m_url + taskId+'/images',
	      		 success: function(data) {
	      			 var html='';
	      			 if(data && data.length>0){
	      				 for(var i=0; i<data.length;i++){
	          				 html+=' <li id="li_' + data[i].id + '">'+
	               		           '<img onclick="newList.showCropPage(\''+taskId+'\', \''+data[i].id+'\')"  taskid="'+taskId+'" src="' + picPath + data[i].imagePath+'" title="'+data[i].name+'" class="preview img-thumbnail showCropPage">'+
	                               '<div><p class="gallery-controls">'+
	                               '<button rid="'+data[i].id+'" onclick="newList.deleteImage(\''+data[i].id+'\')" style="font-size: 12px;" class="btn btn-sm btn-danger iconfont delete">删除</button>'+
	                               '</p><label>No</label>'+
	                               '<input name="'+data[i].id+'" value="'+data[i].orderNo+'" class="resourceNo"></div></li>';
	      				 }
	      			 }else{
	      				 html = '<li class="notice"><p>当前没有任何图片，请点击“上传图片”按钮开始上传图片</p></li>';
	      			 }
	      		 	$("#imageList").html(html);
	          	},
	          	error: function(data) {
	          		//返回500错误页面
	          		$("html").html(data.responseText);
	          	}
	      	 }); 
			$('#preview_modal').modal('show');

		});
		$('#merge-pre').click(function() {
			$('#merge-pre_modal').modal('show');
		});
		
		var taskStatus = $('#status').attr('status');
		if(taskStatus == 'task_init'){
			$('#nextTask').hide();
		}else{
			$('#nextTask').show();
		}
		getTaskName();
     	$('#taskPullData').click(function() {
    		var taskId = $('#taskId').val();
    		$.ajax({
         		 type: 'POST',
         		 url:　　m_url+'getStore/' + taskId,
         		 success: function(data) {
         			 if(data && data.success){
         				noty({text: '拉取数据成功', layout: "topCenter", type: "success", timeout: 1000});
         				getTaskResult();
         			 }else{
         				noty({text: '拉取数据失败', layout: "topCenter", type: "warning", timeout: 1000});
         			 }
             	},
             	error: function(data) {
             		//返回500错误页面
             		$("html").html(data.responseText);
             	}
         	 });
    	});

     	$('#nextTask').click(function() {
    		var taskId = $('#taskId').val();
    		$.ajax({
         		 type: 'GET',
         		 url: m_url+'nextTask/' + taskId,
         		 success: function(data) {
         			 if(data){
         				getTaskDetail(data.id);
         			 }else{
         				noty({text: '已是最后一个任务', layout: "topCenter", type: "warning", timeout: 1000});
         				return;
         			 }
             	},
             	error: function(data) {
             		//返回500错误页面
             		$("html").html(data.responseText);
             	}
         	 });
    	});
     	
		$('#image-upload').change(function(e){
			var taskName = $("#taskName").val();
			if (!/\S/.test(taskName)) {
				noty({text: '任务名无效', layout: "topCenter", type: "warning", timeout: 1000});
                return;
			}
            if(this.files.length == 0){
                noty({text: '没有选择图片文件', layout: "topCenter", type: "warning", timeout: 1000});
                return;
            };
            if(this.files.length > 20){
                noty({text: '图片最多上传20张', layout: "topCenter", type: "warning", timeout: 1000});
                return;
            };
        	/* for (var i = 0; i < this.files.length; i++) {
      			var file = this.files[i];
      			if (!checkFile(file)) {
      				return;
      			}
    		} */
            //pre-deal
            var taskId = $('#taskId').val();
            if (taskId=='0'){
                noty({text: '当前任务未结束', layout: "topCenter", type: "warning", timeout: 1000});
                return;
            }else if(taskId=='-1'){
                $('#taskId').val(0);
                var url = m_url+'task/create';
                $('#taskLabel').val($('#taskName').val());
            }else{
                var url = m_url + 'images/upload';
            }
            //send ajax
             $("#image-form").ajaxSubmit({
                type:'post',
                url: url,
                success:function(result){
                    var taskId = $('#taskId').val();
                    if (result.success){
                        if (taskId=='0'){
                            $('#taskId').val(result.data.taskId);
                        }
                        $('#status').attr('status', 'image_uploaded');
                        $('#status').text('(当前状态：image_uploaded)');
                        noty({text: '成功上传图片张数：'+result.data.length, layout: "topCenter", type: "success", timeout: 3000});
                    }else{
                        if (taskId=='0'){
                            $('#taskId').val(-1);
                        }
                        noty({text: result.errmsg, layout: "topCenter", type: "warning", timeout: 3000});
                    }
                    var defaultImage = '<a href="'+m_url+'image/2.png" target="_blank">'+
                                       '<img id="stitched" src="'+m_url+'image/2.png"class="img-thumbnail static_img"></a>';
                    $("#image_default").html(defaultImage);
                    $("#brandListp").hide();
                    $("#stitch_image .brand-list").remove();
                    $("#countInfo").html('<tr><th colspan=2>货架总层数</th><td colspan=1>0</td><th colspan="2">货架总面积</th><td colspan="1">0</td></tr>');
                },
                error:function(XmlHttpRequest,textStatus,errorThrown){
                    var taskId = $('#taskId').val();
                    if (taskId=='0'){
                        $('#taskId').val(-1);
                    }
                    noty({text: '上传图片失败', layout: "topCenter", type: "alert", timeout: 3000});
                }
            }); 
        });
		
          $('#saveOrder').click(function(e){
              var data = $('form.box-body').serialize();
              var dataArr = data.split('&');
              var json = []
              for(var i in dataArr){
            	  var kv = dataArr[i];
             	  if(kv){
                  	  var kvArr = kv.split('=');
                  	  var j  = {};
                  	  j.resourceId = kvArr[0];
                  	  j.resourceOrder = kvArr[1];
                  	  json.push(j);
              	  }
              }
              $.post(m_url + $('#taskId').val() + '/order', JSON.stringify(json)).done(function(data){
                 if(data.success){
                     $('#status').attr('status', 'image_uploaded');
                     $('#status').text('(当前状态：image_uploaded)');
                     noty({text: '保存成功', layout: "topCenter", type: "success", timeout: 2000});
                     $('#preview_modal').modal('hide');
                     var defaultImage = '<a href="'+m_url+'image/2.png" target="_blank">'+
                                        '<img id="stitched" src="'+m_url+'image/2.png"class="img-thumbnail static_img"></a>';
                     $("#image_default").html(defaultImage);
                     $("#brandListp").hide();
                     $("#stitch_image .brand-list").remove();
                     $("#countInfo").html('<tr><th colspan=2>货架总层数</th><td colspan=1>0</td><th colspan="2">货架总面积</th><td colspan="1">0</td></tr>');
                 }else{
                     noty({text: data.errmsg, layout: "topCenter", type: "warning", timeout: 2000});
                 }
              });
          });
          
          $('#taskStatus').click(function(e){
              var taskId = $('#taskId').val();
              if (taskId=='-1' || taskId=='0'){
                  noty({text: "请先上传图片", layout: "topCenter", type: "warning", timeout: 2000});
                  return;
              }
              $('#waiting').modal({keyboard: false, backdrop: 'static'});
              $('#waiting').modal('show');
              $.post(m_url + taskId + '/status').done(function (data) {
                  $('#waiting').modal('hide');
                  $('#stitched').cropper('destroy');
                  if(data.success){
                      var task_status = data.data.task_status;
                      var identifySuccessTimes = data.data.identifySuccessTimes;
                      $('#status').attr('status', task_status);
                      if(task_status=='identify_success' && identifySuccessTimes){
                    	  $('#status').text("(当前状态：" + task_status + identifySuccessTimes + ")");
                      }else{
                    	  $('#status').text("(当前状态：" + task_status + ")"); 
                      }
                      noty({text: "当前状态：" + task_status, layout: "topCenter", type: "warning", timeout: 1000});
                      if (task_status=='stitch_success' || task_status=='stitch_failure'){
                          $('img#stitched').attr('src', data.data.image + '?random=' + Date.now()).css('height', '400px');
                          $('img#stitched').parent().attr('href', data.data.image + '?random=' + Date.now());
                          $("#countInfo").html('<tr><th colspan=2>货架总层数</th><td colspan=1>'+data.data.rows+'</td><th colspan="2">货架总面积</th><td colspan="1">' + data.data.totalArea + '</td></tr>');
                          
                          if(task_status=='stitch_failure'){
	                    	  if(data.data.errorIndices){
	                    		  noty({text: "the failure image No: "+data.data.errorIndices, layout: "topCenter", type: "warning", timeout: 3000});
	                    	  }else{
	                              noty({text: data.data.result.errmsg, layout: "topCenter", type: "warning", timeout: 3000});
	                    	  }
	                      }
                      }else if(task_status=='identify_success'){
              			$.ajax({
           	      		 type: 'GET',
           	      		 url: m_url + 'taskResult/' + taskId,
           	      		 success: function(data) {
                             var results = data.data.goodResults;
                             var crops = data.data.crops;
                             var totalArea = 0;
                             if(data.data.totalArea){
                            	 totalArea = data.data.totalArea;
                             }
                             var html0 = '<tr><th colspan=2>货架总层数</th><td colspan=1>'+data.data.rows+'</td><th colspan="2">货架总面积</th><td colspan="1">' + totalArea + '</td></tr>'+
                                         '<tr><th colspan="2">产品名称</th><th>占比</th><th>牌面数</th><th>货架位置</th><th>sku面积</th></tr>'
                             var html1 = '';
                             for(var k in results){
                           	  if(results[k].isShow){
                           		  var totalOriArea = 0;
                           		  if(crops){
                           			  for(var j in crops){
                           				  if(crops[j].produce == (parseInt(k) + 1)){
                           					  totalOriArea += parseInt(crops[j].ori_area);
                           				  }
                           			  } 
                           		  }
                                     html1 += '<tr><td colspan="2">' + results[k].goods_desc + '</td><td>'+ results[k].ratio +'</td><td>' + results[k].num + '</td>'+
                                     '<td>' + (results[k].rows ==null?"":results[k].rows) + '</td><td>' + totalOriArea + '</td></tr>';
                           	  }
                             }
                             $("#countInfo").html(html0 + html1);
                             //$('#status').attr('status', 'identify_success').text('(当前状态：identify_success)');
                             var majorType = $("#majorType").val();
                             if(!majorType){
                           	  majorType = $("#taskMajorType").val();
                             }
                             showCropList(results);
                             $('#stitched').attr('src', '/pic/marketing/' + data.data.stitchImagePath + '?random='+ $.now()).css('height', '400px');
                             $('#image_default a').attr('href', '/pic/marketing' + data.data.resultsBorder);
           	          	},
           	          	error: function(data) {
           	          		//返回500错误页面
           	          		$("html").html(data.responseText);
           	          	}
           	      	 });
                      }
                  }else{
                      noty({text: data.errmsg, layout: "topCenter", type: "warning", timeout: 3000});
                  }
              });
          });
          
          $("#merge").click(function(e){
              var majorType = $('#majorType').val();
              if(!majorType || majorType.trim() == ''){
                  noty({text: 'goods type should be selected', layout: "topCenter", type: "warning", timeout: 3000});
                  return
              }
              $('#merge-pre_modal').modal('hide');
              var status = $('#ststus').attr('status');
              var taskId = $('#taskId').val();
              var need_stitch = $('#is_need_stitch').is(":checked");
              var postdata = {majorType : majorType};
              if(need_stitch){
                  postdata.needStitch = false;
              }
              if (status=='stitching'){
                  noty({text: 'current process not finished', layout: "topCenter", type: "warning", timeout: 3000});
                  return;
              }else if (taskId=='-1' || taskId=='0'){
                  noty({text: 'please upload image first', layout: "topCenter", type: "warning", timeout: 3000});
                  return;
              }
              $('#waiting').modal({keyboard: false, backdrop: 'static'});
              $('#status').attr('status', 'stitching');
              $('#status').text('(当前状态：stitching)');
               $.post(m_url + taskId + '/stitcher', JSON.stringify(postdata)).done(function (data) {
                  $('#waiting').modal('hide');
                  if(data.success){
                      noty({text: "正在开始合并，请稍后查询状态", layout: "topCenter", type: "warning", timeout: 3000});
                  }else{
                      noty({text: data.errmsg, layout: "topCenter", type: "warning", timeout: 3000});
                      $('#status').attr('status', 'image_uploaded');
              		  $('#status').text('(当前状态：image_uploaded)');
                  }
              }); 
          });
          
          $("#count").click(function(e){
              var status = $('#status').attr('status');
              if (status!='stitch_success' && status!='stitch_failure'){
                  noty({text: 'not ready or is processing', layout: "topCenter", type: "warning", timeout: 3000});
                  return;
              }
              var taskId = $('#taskId').val();
              var postData = {};
              $('#waiting').modal({keyboard: false, backdrop: 'static'});
              $('#waiting').modal('show');
              $.post(m_url + taskId + '/identify', postData).done(function (data) {
                  $('#waiting').modal('hide');
                  if(data.success){
                      var results = data.data;
                      var crops = data.crops;
                      var html0 = '<tr><th colspan=2>货架总层数</th><td colspan=1>' + data.rows + '</td><th colspan="2">货架总面积</th><td colspan="1">' + data.total_area + '</td></tr>'+
                                  '<tr><th colspan="2">产品名称</th><th>占比</th><th>牌面数</th><th>货架位置</th><th>sku面积</th></tr>'
                      var html1 = '';
                      for(var k in results){
                    	  if(results[k].isShow){
                    		  var totalOriArea = 0;
                    		  if(crops){
                    			  for(var j in crops){
                    				  if(crops[j].produce == (parseInt(k) + 1)){
                    					  totalOriArea += parseInt(crops[j].ori_area);
                    				  }
                    			  } 
                    		  }
                              html1 += '<tr><td colspan="2">' + results[k].goods_desc + '</td><td>'+ results[k].ratio +'</td><td>' + results[k].num + '</td>'+
                              '<td>' + (results[k].list_rows).toString() + '</td><td>' + totalOriArea + '</td></tr>';
                    	  }
                      }
                      $("#countInfo").html(html0 + html1);
                      $('#status').attr('status', 'identify_success').text('(当前状态：identify_success)');
                      var majorType = $("#majorType").val();
                      if(!majorType){
                    	  majorType = $("#taskMajorType").val();
                      }
                      showCropList(results);
                      $('#image_default a').attr('href', '/pic/marketing' + data.results_border);
                  }else{
                      noty({text: data.errmsg, layout: "topCenter", type: "warning", timeout: 3000});
                      $('#status').attr('status', 'identify_failure');
                  }
              });
        });
		function getTaskName() {
			var taskName = $("#taskName").val();
			if (!taskName) {
				$("#taskName").val("未命名-" + Date.now());
			}
		}
		function getTaskResult(){
            var taskId = $('#taskId').val();
            if (taskId=='-1' || taskId=='0'){
                noty({text: "请先上传图片", layout: "topCenter", type: "warning", timeout: 2000});
                return;
            }
            $('#waiting').modal({keyboard: false, backdrop: 'static'});
            $('#waiting').modal('show');
            $.post(m_url + taskId + '/status').done(function (data) {
                $('#waiting').modal('hide');
                $('#stitched').cropper('destroy');
                if(data.success){
                    var task_status = data.data.task_status;
                    if (task_status=='stitch_success' || task_status=='stitch_failure'){
                        $('img#stitched').attr('src', data.data.image + '?random=' + Date.now()).css('height', '400px');
                        $('img#stitched').parent().attr('href', data.data.image + '?random=' + Date.now());
                        $("#countInfo").html('<tr><th colspan=2>货架总层数</th><td colspan=1>'+data.data.rows+'</td><th colspan="2">货架总面积</th><td colspan="1">' + data.data.totalArea + '</td></tr>');
                        
                        if(task_status=='stitch_failure'){
	                    	  if(data.data.errorIndices){
	                    		  noty({text: "the failure image No: "+data.data.errorIndices, layout: "topCenter", type: "warning", timeout: 3000});
	                    	  }else{
	                              noty({text: data.data.result.errmsg, layout: "topCenter", type: "warning", timeout: 3000});
	                    	  }
	                      }
                    }else if(task_status=='identify_success'){
            			$.ajax({
         	      		 type: 'GET',
         	      		 url: m_url + taskId,
         	      		 success: function(data) {
                           var results = data.data.goodResults;
                           var crops = data.data.crops;
                           var totalArea = 0;
                           if(data.data.totalArea){
                          	 totalArea = data.data.totalArea;
                           }
                           var html0 = '<tr><th colspan=2>货架总层数</th><td colspan=1>'+data.data.rows+'</td><th colspan="2">货架总面积</th><td colspan="1">' + totalArea + '</td></tr>'+
                                       '<tr><th colspan="2">产品名称</th><th>占比</th><th>牌面数</th><th>货架位置</th><th>sku面积</th></tr>'
                           var html1 = '';
                           for(var k in results){
                         	  if(results[k].isShow){
                         		  var totalOriArea = 0;
                         		  if(crops){
                         			  for(var j in crops){
                         				  if(crops[j].produce == (parseInt(k) + 1)){
                         					  totalOriArea += parseInt(crops[j].ori_area);
                         				  }
                         			  } 
                         		  }
                                   html1 += '<tr><td colspan="2">' + results[k].goods_desc + '</td><td>'+ results[k].ratio +'</td><td>' + results[k].num + '</td>'+
                                   '<td>' + (results[k].rows ==null?"":results[k].rows) + '</td><td>' + totalOriArea + '</td></tr>';
                         	  }
                           }
                           $("#countInfo").html(html0 + html1);
                           //$('#status').attr('status', 'identify_success').text('(当前状态：identify_success)');
                           var majorType = $("#majorType").val();
                           if(!majorType){
                         	  majorType = $("#taskMajorType").val();
                           }
                           showCropList(results);
                           $('#stitched').attr('src', '/pic/marketing/' + taskId + '/results.jpg?random='+ $.now()).css('height', '400px');
                           $('#image_default a').attr('href', '/pic/marketing' + data.data.resultsBorder);
         	          	},
         	          	error: function(data) {
         	          		//返回500错误页面
         	          		$("html").html(data.responseText);
         	          	}
         	      	 });
                    }
                }else{
                    noty({text: data.errmsg, layout: "topCenter", type: "warning", timeout: 3000});
                }
            });
		}
		function showCropList(results){
			html = '<div class="brand-list col-sm-3" >';
			for(var k in results){
				if(results[k].isShow && results[k].num>0){
					html += '<div class="form-group">'+
						    '<span class="icorn-brand"></span>'+
					        '<div class="changeline" produce="'+ k +'"><a href="javascript:void(0);" onclick="newList.getCrops('+ k +')">'+ results[k].goods_desc + '(' + results[k].num +')</a></div></div>';
				}
			}
			html += '</div>';
			$("#stitch_image .brand-list").remove();
  			$("#brandListp").show();
  		 	$("#stitch_image").append(html);
		}
		
		function getGoodsSku(majorType){
			$.ajax({
	      		 type: 'GET',
	      		 url: m_url + 'goodsSkus',
	      		 data:{
	      			 majorType:majorType
	      		 },
	      		 success: function(data) {
	      			 var html='';
	      			 if(data && data.length>0){
	      				html += '<div class="brand-list col-sm-3" >';
	      				 for(var i=0; i<data.length;i++){
	      					 if(data[i].isShow){
		          				 html += ' <div class="form-group">'+
			               		   	     ' <img class="icorn-brand"  src="'+m_url+'image/'+ data[i].majorType +'.png">'+
		               		             ' <div class="changeline" produce="'+i+'"><a href="javascript:void(0);" onclick="newList.getCrops('+ i +')">'+ data[i].description +'</a></div></div>';
	      					 }
	      				 }
	      				 html += '</div>';
	      			 }
	      			$("#stitch_image .brand-list").remove();
	      			$("#brandListp").show();
	      		 	$("#stitch_image").append(html);
	          	},
	          	error: function(data) {
	          		//返回500错误页面
	          		$("html").html(data.responseText);
	          	}
	      	 });
		}
		
		
		
		
		
		
		
	};
	 function deleteImage(imageId){
	        var answer = confirm("删除是不可恢复的，你确认要删除吗？");
	        if (answer){
	            var rid = imageId;
	            var taskId = $('#taskId').val();
	            $.post(m_url + taskId + '/images/' + rid).done(function (data) {
	                if(data.success){
	              	 	$("#li_"+rid).hide();
	              		$("#li_"+rid).remove();
	                    noty({text: '删除成功', layout: "topCenter", type: "success", timeout: 1000});
	                    $('#status').attr('status', 'image_uploaded');
	                    $('#status').text('(当前状态：image_uploaded)');
	                    var defaultImage = '<a href="'+m_url+'image/2.png" target="_blank">'+
	                                       '<img id="stitched" src="'+m_url+'image/2.png"class="img-thumbnail static_img"></a>';
	                    $("#image_default").html(defaultImage);
	                    $("#brandListp").hide();
	                    $("#stitch_image .brand-list").remove();
	                    $("#countInfo").html('<tr><th colspan=2>货架总层数</th><td colspan=2>0</td></tr>');
	                    
	                    var tempData = $('form.box-body').serialize();
	                    var dataArr = tempData.split('&');
	                    var json = []
	                    for(var i in dataArr){
	                  	  var kv = dataArr[i];
	                  	  if(kv){
	                      	  var kvArr = kv.split('=');
	                      	  var j  = {};
	                      	  j.resourceId = kvArr[0];
	                      	  j.resourceOrder = kvArr[1];
	                      	  json.push(j);
	                  	  }
	                    }
	                    if(json.length > 0){
	                        $.post(m_url + $('#taskId').val()+'/order', JSON.stringify(json)).done(function(data){
	                            if(data.success){
	                                /* var defaultImage = '<a href="${springMacroRequestContext.contextPath}/image/2.png" target="_blank">'+
	                                                   '<img id="stitched" src="${springMacroRequestContext.contextPath}/image/2.png"class="img-thumbnail static_img"></a>';
	                                $("#image_default").html(defaultImage);
	                                $("#brandListp").hide();
	                                $("#stitch_image .brand-list").remove(); */
	                            }else{
	                                noty({text: data.errmsg, layout: "topCenter", type: "warning", timeout: 2000});
	                            }
	                         });
	                    }
	                    
	                }else{
	                    noty({text: data.errmsg, layout: "topCenter", type: "warning", timeout: 2000});
	                }
	            });
	        }
	    };
		function checkFile(file) {
	        if ((file.size/1024/1024) > 5) {
	        	noty({text: '您选择的图片大于5M, 请重新选择小于5M的图片上传', layout: "topCenter", type: "warning", timeout: 1000});
				return false;
			}
	        return true;
	    };
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
		};
		function showCropPage(taskId, imageId){
			var status = $('#status').attr('status');
			window.open(m_url + "showCropPage/" + taskId + "?imageId=" + imageId);
		};
		
		function getCrops(produce){
			var taskId = $('#taskId').val();
			$.ajax({
	     		 type: 'GET',
	     		 url: m_url + taskId+'/crops/'+(produce + 1),
	     		 success: function(data) {
	     			$('#stitched').cropper('destroy');
	     			 if(data && data.length > 0){
	      	   	      	$('#stitched').cropper({
	          				responsive : false,
	          				data : {x: 300, y:400, width:100, height:100, rotate:0},
	          				modal : false,
	          				guides : false,
	          				center : false,
	          				highlight : false,
	          				background : false,
	          				autoCrop : false,
	          				autoCropArea : 0.3,
	          				movable : false,
	          				scalable :true,
	          				zoomable :true,
	          				zoomOnWheel :false,
	          				disabled :true,
	          				minContainerWidth : 730,
	          				minContainerHeight : 400,
	          				ready: function () {
	          					var initData = {"x":0,"y":0,"width":0,"height":0,"rotate":0,"scaleX":1,"scaleY":1,"label":"u1", "name" : "21"};
	          					var allData = [];
	          					for(var i = 0;i<data.length;i++){
	          						var resultData = data[i];
	          						var newData = $.extend({},initData,resultData);
	          						allData.push(newData);
	          					}
	          					$(this).cropper('setAllData', allData);
	          					$(this).cropper('disable');
	          				}
	          			});
	     			 }
	         	},
	         	error: function(data) {
	         		//返回500错误页面
	         		$("html").html(data.responseText);
	         	}
	     	}); 
		};
	
     return {
          _init:init,
          getCrops:getCrops,
          showCropPage:showCropPage,
          deleteImage:deleteImage
     }

})()
