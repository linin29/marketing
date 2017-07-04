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
                   <input id="taskId" type="hidden" value="<#if task??>${task.id}</#if>" />
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