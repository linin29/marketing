<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
         <meta http-equiv="X-UA-Compatible" content="IE=edge">
         <meta name="viewport" content="width=device-width, initial-scale=1">
	<title>图麟科技海量图像/视频搜索识别开放平台</title>
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/bootstrap.css">
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/font-awesome.min.css">
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/iconfont.css">
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/jquery-jvectormap-1.2.2.css">
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/AdminLTE.css">
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/_all-skins.min.css">
	<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.min.js"></script>
	<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.noty.packaged.js" ></script>
	<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/bootstrap.js"></script>
	<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/app.min.js"></script>
	<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.ui.widget.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.form.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.iframe-transport.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.fileupload.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.fileupload-process.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery.fileupload-validate.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery-editable-select.min.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/lodash.min.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/moment.min.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/masonry.pkgd.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/bootstrap-select.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/bootstrap-paginator.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/cropper.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/tunicorn-cloud.js" ></script>
    <link href="${springMacroRequestContext.contextPath}/css/jquery-fileupload.css" rel="stylesheet">
    <link href="${springMacroRequestContext.contextPath}/css/jquery-fileupload-ui.css" rel="stylesheet">
    <link href="${springMacroRequestContext.contextPath}/css/jquery-editable-select.min.css" rel="stylesheet">
    <link href="${springMacroRequestContext.contextPath}/css/bootstrap-select.css" rel="stylesheet">
    <link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/style.css"  type="text/css">
     <link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/cropper.css"  type="text/css">
	<style type="text/css">
		.skin-blue .sidebar-menu>li:hover>a, .skin-blue .sidebar-menu>li.active>a {
			color: #fff;
			background: #1e282c;
			border-left-color: #00a65a;
		}
		.content-wrapper, .right-side {
			min-height: 100%;
			background-color: #fff;
		}
		.navbar a:hover{
			background-color:green
		}
		.light{
			color:#fff;
		}
		.default{
			color:#8aa4af;
		}
	</style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">
	  <section class="content-wrapper" style="margin-left: 0px;">
	   	<div id="content" style="margin-left: -11px;padding-top: 1px;margin-bottom: -20px;">


<style type="text/css">
   body {padding-right:0px !important;}
   img {max-width: 100%;}
</style>
<div class="create_task max_width">
       <ul>
           <li>
               <h4>
                   <img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
                   <span>任务名</span>
                   <span id="status" status="<#if task??>${task.taskStatus}<#else>task_init</#if>" style="margin-left:30px;">(当前状态：<#if task??>${task.taskStatus}<#else>task_init</#if>)</span>
                   <input id="taskName" type="text" <#if task??> value="${task.name}"  readonly= "true" </#if> placeholder="请输入任务名" class="form-control create_task_input">
                   <input id="taskMajorType" type="hidden" <#if task?? && task.majorType??> value="${task.majorType}" </#if>>
               </h4>
           </li>
           <li>
               <h4>
                   <img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
                   <span>货架拼接照片</span>
                   <div style="clear:both"></div>
                   <#if task?? && task.taskStatus?? && task.taskStatus=='identify_success'>
                     <p id="brandListp" style="font-size:14px;margin-left: 82%;"><strong>品牌列表</strong></p>
                   </#if>
                   <div class="row" id="stitch_image">
	                   <div id="image_default"  align="center"  class="col-sm-8">
		                   <#if task?? && task.taskStatus?? && (task.taskStatus!='stitching' && task.taskStatus!='image_uploaded') && task.stitchImagePath??>
		                     <#if task.taskStatus=='identify_success' && stitchBorderImagePath!=''>
		                     	<a href="/pic/marketing${stitchBorderImagePath}" target="_blank">
		                     <#else>
		                     	<a href="/pic/marketing${stitchImagePath}" target="_blank">
		                     </#if>	
		                           <img style="width:auto; height:400px;padding:0;" id="stitched" src="/pic/marketing${stitchImagePath}" class="img-thumbnail static_img">
		                        </a>
		                   <#else>
		                        <a href="${springMacroRequestContext.contextPath}/image/2.png" target="_blank">
		                           <img id="stitched" src="${springMacroRequestContext.contextPath}/image/2.png"class="img-thumbnail static_img">
		                        </a>
		                   </#if>
	                   </div>
	                   <#if task?? && task.taskStatus?? && task.taskStatus=='identify_success'>
	                   <div class="brand-list col-sm-3 " >
	                     <#if goodResults?? && (goodResults?size > 0)>
	                       <#list goodResults as goodResult>
	                        <#if goodResult.isShow && (goodResult.num?eval >0)>
	               	         <div class="form-group">
		               		   <span class="icorn-brand"></span>
		               		   <div class="changeline" produce="${goodResult_index}"><a href="javascript:void(0);" onclick="getCrops(${goodResult_index})">${goodResult.goods_desc}(${goodResult.num})</a></div>  
	           			     </div>
	           			    </#if>
	           			   </#list>
	           			 </#if>
		               </div>
		               </#if>
	               </div>
               </h4>
               <div style="clear:both;"></div>
           </li>
           <li>
               <h4 style="padding-bottom: 28px;">
                   <img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
                   <span>货架数据</span>
                   <table id="countInfo" class="table table-bordered table-hover table-condensed count_table">
                       <thead>
                            <tr><th colspan="2">货架总层数</th><td colspan="3"><#if rows??>${rows}<#else>0</#if></td></tr>
                       </thead>
                       <tbody>
                         <#if goodResults?? && (goodResults?size > 0)>
                            <tr>
                              <th colspan="2">产品名称</th>
                              <th>占比</th>
                              <th>牌面数</th>
                              <th>货架位置</th>
                            </tr>
                         <#list goodResults as goodResult>
                           <#if goodResult.isShow>
                            <tr>
                              <td colspan="2">${goodResult.goods_desc}</th>
                              <td>${goodResult.ratio}</td>
                              <td>${goodResult.num}</td>
                              <td>${goodResult.rows!""}</td>
                            </tr>
                           </#if>
                         </#list>
                         </#if>
                       </tbody>
                   </table>
               </h4>
           </li>
       </ul>
   </div>
  <div class="modal fade" id="preview_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
       <div class="modal-dialog modal-lg" role="document">
           <div class="modal-content content_width">
               <div class="modal-header model_head">
                   <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
               </div>
               <div class="modal-body preview_box">
                   <div class="box-header">
                       <h3 class="box-title ">
                           <#if images?? && (images?size > 0)><small>共<span>${images?size}</span>张图片</small></#if>  
                       </h3>
                        <div class="pull-right" style="margin-top: 10px;">
                               <button id="saveOrder" type="button" class="btn btn-success">保存顺序</button>
                        </div>
                       <form style="padding:0px;margin-top: 31px;" onsubmit="return false;" class="box-body">
                           <ul id="imageList" class="preview_img">
                     
                           </ul>
                       </form>
                   </div>
               </div>
           </div>
       </div>
   </div>

   <div class="modal fade" id="merge-pre_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
       <div class="modal-dialog" role="document">
           <div class="modal-content">
               <div class="modal-header model_head">
                   <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
               </div>
               <div class="modal-body">
                   <input type="checkbox" id="is_need_stitch">
                   <span>勾选取消去重</span><br><span>货物类型</span>
                   <select id="majorType" name="majorType">
                       <option value="">请选择一个类型</option>
                        <#if majorTypes?? && (majorTypes?size > 0)>
                         <#list majorTypes as majorType>
                            <option value="${majorType.name}">${majorType.description}</option>
                         </#list>
                         </#if>
                   </select><br>
                   <button id="merge" type="button" style="margin: 5px 0px;" class="btn btn-success">继续拼接</button>
               </div>
           </div>
       </div>
   </div>
   
   <div class="modal fade" id="waiting" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
       <div class="modal-dialog" role="document">
           <div class="modal-content">
               <div class="modal-header model_head">
                   <h4 id="waitingLabel" style="text-align: center" class="modal-title">正在进行中，客官请稍后...</h4>
               </div>
               <div class="modal-body">
                   <img src="${springMacroRequestContext.contextPath}/image/searchwait.gif" style="margin:0px 0 0 230px"/>
               </div>
           </div>
       </div>
   </div>
<script type="text/javascript">

    var picPath = '/pic/marketing';
	$(function() {
		getTaskName();
		
		$('#image-upload').change(function(e){
			var taskName = $("#taskName").val();
			if (!/\S/.test(taskName)) {
				noty({text: 'task name is not null!', layout: "topCenter", type: "warning", timeout: 1000});
                return;
			}
            if(this.files.length == 0){
                noty({text: 'no files selected!', layout: "topCenter", type: "warning", timeout: 1000});
                return;
            };
            if(this.files.length > 9){
                noty({text: 'files max num is 9!', layout: "topCenter", type: "warning", timeout: 1000});
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
                noty({text: 'current task not finished!', layout: "topCenter", type: "warning", timeout: 1000});
                return;
            }else if(taskId=='-1'){
                $('#taskId').val(0);
                var url = '${springMacroRequestContext.contextPath}/task/create';
                $('#taskLabel').val($('#taskName').val());
            }else{
                var url = '${springMacroRequestContext.contextPath}/images/upload/';
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
                        noty({text: '成功上传图片张数：'+result.data.length, layout: "topCenter", type: "warning", timeout: 3000});
                    }else{
                        if (taskId=='0'){
                            $('#taskId').val(-1);
                        }
                        noty({text: result.errmsg, layout: "topCenter", type: "warning", timeout: 3000});
                    }
                    var defaultImage = '<a href="${springMacroRequestContext.contextPath}/image/2.png" target="_blank">'+
                                       '<img id="stitched" src="${springMacroRequestContext.contextPath}/image/2.png"class="img-thumbnail static_img"></a>';
                    $("#image_default").html(defaultImage);
                    $("#brandListp").hide();
                    $("#stitch_image .brand-list").remove();
                    $("#countInfo").html('<tr><th colspan=2>货架总层数</th><td colspan=2>0</td></tr>');
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
            	  var kvArr = kv.split('=');
            	  var j  = {};
            	  j.resourceId = kvArr[0];
            	  j.resourceOrder = kvArr[1];
            	  json.push(j);
              }
              $.post('${springMacroRequestContext.contextPath}/'+$('#taskId').val()+'/order', JSON.stringify(json)).done(function(data){
                 if(data.success){
                     $('#status').attr('status', 'image_uploaded');
                     $('#status').text('(当前状态：image_uploaded)');
                     noty({text: '保存成功', layout: "topCenter", type: "warning", timeout: 2000});
                     $('#preview_modal').modal('hide');
                     var defaultImage = '<a href="${springMacroRequestContext.contextPath}/image/2.png" target="_blank">'+
                                        '<img id="stitched" src="${springMacroRequestContext.contextPath}/image/2.png"class="img-thumbnail static_img"></a>';
                     $("#image_default").html(defaultImage);
                     $("#brandListp").hide();
                     $("#stitch_image .brand-list").remove();
                     $("#countInfo").html('<tr><th colspan=2>货架总层数</th><td colspan=2>0</td></tr>');
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
              $.post('${springMacroRequestContext.contextPath}/'+taskId+'/status').done(function (data) {
                  $('#waiting').modal('hide');
                  if(data.success){
                      var task_status = data.data.task_status;
                      $('#status').attr('status', task_status);
                      $('#status').text("(当前状态：" + task_status + ")");
                      noty({text: "当前状态：" + task_status, layout: "topCenter", type: "warning", timeout: 1000});
                      if (task_status=='stitch_success' || task_status=='stitch_failure'){
                          $('img#stitched').attr('src', data.data.image + '?random=' + Date.now()).css('height', '400px');
                          $('img#stitched').parent().attr('href', data.data.image + '?random=' + Date.now());
                          $("#countInfo").html('<tr><th colspan=2>货架总层数</th><td colspan=2>'+data.data.rows+'</td></tr>');
                          
                          if(task_status=='stitch_failure'){
	                    	  if(data.data.errorIndices){
	                    		  noty({text: "the failure image No: "+data.data.errorIndices, layout: "topCenter", type: "warning", timeout: 3000});
	                    	  }else{
	                              noty({text: data.data.result.errmsg, layout: "topCenter", type: "warning", timeout: 3000});
	                    	  }
	                      }
                      }
                  }else{
                      noty({text: data.errmsg, layout: "topCenter", type: "warning", timeout: 3000});
                  }
              });
          });
          
          $("#merge").click(function(e){
              var majorType = $('#majorType').val();
              if(!majorType || majorType.trim()==''){
                  noty({text: 'goods type should be selected!', layout: "topCenter", type: "warning", timeout: 3000});
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
               $.post('${springMacroRequestContext.contextPath}/'+taskId+'/stitcher', JSON.stringify(postdata)).done(function (data) {
                  $('#waiting').modal('hide');
                  if(data.success){
                      noty({text: "正在开始合并，请稍后查询状态!", layout: "topCenter", type: "warning", timeout: 3000});
                      $('#status').attr('status', 'stitch_success');
                  }else{
                      noty({text: data.errmsg, layout: "topCenter", type: "warning", timeout: 3000});
                      $('#status').attr('status', 'image_uploaded');
                  }
              }); 
          });
          
          $("#count").click(function(e){
              var status = $('#status').attr('status');
              if (status!='stitch_success' && status!='stitch_failure'){
                  noty({text: 'not ready or is processing!', layout: "topCenter", type: "warning", timeout: 3000});
                  return;
              }
              var taskId = $('#taskId').val();
              var postData = {};
              $('#waiting').modal({keyboard: false, backdrop: 'static'});
              $('#waiting').modal('show');
              $.post('${springMacroRequestContext.contextPath}/'+taskId+'/identify', postData).done(function (data) {
                  $('#waiting').modal('hide');
                  if(data.success){
                      var results = data.data;
                      var html0 = '<tr><th colspan=2>货架总层数</th><td colspan=3>'+data.rows+'</td></tr>'+
                                  '<tr><th colspan="2">产品名称</th><th>占比</th><th>牌面数</th><th>货架位置</th></tr>'
                      var html1 = '';
                      for(var k in results){
                    	  if(results[k].isShow){
                              html1 += '<tr><td colspan="2">' + results[k].goods_desc + '</td><td>'+ results[k].ratio +'</td><td>' + results[k].num + '</td><td>' + (results[k].list_rows).toString() + '</td></tr>';
                    	  }
                      }
                      $("#countInfo").html(html0+html1);
                      $('#status').attr('status', 'identify_success').text('(当前状态：identify_success)');
                      var majorType = $("#majorType").val();
                      if(!majorType){
                    	  majorType = $("#taskMajorType").val();
                      }
                      showCropList(results);
                      $('#image_default a').attr('href', '/pic/marketing'+data.results_border);
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
		
		function showCropList(results){
			html = '<div class="brand-list col-sm-3" >';
			for(var k in results){
				if(results[k].isShow && results[k].num>0){
					html += '<div class="form-group">'+
						    '<span class="icorn-brand"></span>'+
					        '<div class="changeline" produce="'+ k +'"><a href="javascript:void(0);" onclick="getCrops('+ k +')">'+ results[k].goods_desc + '(' + results[k].num +')</a></div></div>';
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
	      		 url: '${springMacroRequestContext.contextPath}/goodsSkus',
	      		 data:{
	      			 majorType:majorType
	      		 },
	      		 success: function(data) {
	      			 var html='';
	      			 if(data && data.length>0){
	      				html += '<div class="brand-list col-sm-3" >';
	      				 for(var i=0; i<data.length;i++){
	      					 if(data[i].isShow){
		          				 html+=' <div class="form-group">'+
			               		   ' <img class="icorn-brand"  src="${springMacroRequestContext.contextPath}/image/'+ data[i].majorType +'.png">'+
		               		       ' <div class="changeline" produce="'+i+'"><a href="javascript:void(0);" onclick="getCrops('+ i +')">'+ data[i].description +'</a></div></div>';
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
	});
	$('#preview').click(function() {
	 	 var taskId = $('#taskId').val();
		$.ajax({
      		 type: 'GET',
      		 url: '${springMacroRequestContext.contextPath}/'+taskId+'/images',
      		 success: function(data) {
      			 var html='';
      			 if(data && data.length>0){
      				 for(var i=0; i<data.length;i++){
          				 html+=' <li id="li_'+data[i].id+'">'+
               		           '<img src="' + picPath + data[i].imagePath+'" title="'+data[i].name+'" class="preview img-thumbnail">'+
                               '<div><p class="gallery-controls">'+
                               '<button rid="'+data[i].id+'" onclick="deleteImage(\''+data[i].id+'\')" style="font-size: 12px;" class="btn btn-sm btn-danger iconfont delete">删除</button>'+
                               '</p><label>No</label>'+
                               '<input name="'+data[i].id+'" value="'+data[i].orderNo+'" class="resourceNo"></div></li>';
      				 }
      			 }else{
      				 html = '<li class="notice"><p>当前没有任何图片，请点击右上角的“上传图片”开始上传图片！</p></li>';
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
    function deleteImage(imageId){
        var answer = confirm("删除是不可恢复的，你确认要删除吗？");
        if (answer){
            var rid = imageId;
            var taskId = $('#taskId').val();
            $.post('${springMacroRequestContext.contextPath}/'+taskId+'/images/'+rid).done(function (data) {
                if(data.success){
              	  $("#li_"+rid).hide();
                    noty({text: '删除成功', layout: "topCenter", type: "warning", timeout: 1000});
                    $('#status').attr('status', 'image_uploaded');
                    $('#status').text('(当前状态：image_uploaded)');
                    var defaultImage = '<a href="${springMacroRequestContext.contextPath}/image/2.png" target="_blank">'+
                                       '<img id="stitched" src="${springMacroRequestContext.contextPath}/image/2.png"class="img-thumbnail static_img"></a>';
                    $("#image_default").html(defaultImage);
                    $("#brandListp").hide();
                    $("#stitch_image .brand-list").remove();
                    $("#countInfo").html('<tr><th colspan=2>货架总层数</th><td colspan=2>0</td></tr>');
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
    }
	
	
	function getCrops(produce){
		var taskId = $('#taskId').val();
		$.ajax({
     		 type: 'GET',
     		 url: '${springMacroRequestContext.contextPath}/'+taskId+'/crops/'+(produce + 1),
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
		}
</script>

	   	</div>		
	</section>
	</div>
</body>
</html>