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
		body {padding-right:0px !important;}
		img {max-width: 100%;}
	</style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">
	  <section class="content-wrapper" style="margin-left: 0px;">
	   	<div id="content" style="margin-left: -11px;padding-top: 1px;margin-bottom: -20px;">
		<div class="create_task max_width">
	       <ul>
	           <li>
	               <h4>
	                   <img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
	                   <span>任务名</span>
	                   <span id="status" status="<#if task??>${task.taskStatus}<#else>task_init</#if>" style="margin-left:30px;">(当前状态：
		                   	<#if task?? && task.taskStatus=='identify_success' && task.identifySuccessTimes gt 0>
               					${task.taskStatus}${task.identifySuccessTimes}
               			   	<#elseif task?? && (task.taskStatus !='identify_success' || task.identifySuccessTimes == 0)>
               					${task.taskStatus}
               				<#else>
               					task_init
               				</#if>)
	                   </span>
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
			               		   <div class="changeline" produce="${goodResult_index}"><a href="javascript:void(0);" onclick="taskView.getCrops(${goodResult_index})">${goodResult.goods_desc}(${goodResult.num})</a></div>  
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
	                            <tr>
	                            	<th colspan="2">货架总层数</th><td colspan="1"><#if rows??>${rows}<#else>0</#if></td>
	                            	<th colspan="2">货架总面积</th><td colspan="1"><#if totalArea??>${totalArea}<#else>0</#if></td>
	                            </tr>
	                       </thead>
	                       <tbody>
	                         <#if goodResults?? && (goodResults?size > 0)>
	                            <tr>
	                              <th colspan="2">产品名称</th>
	                              <th>占比</th>
	                              <th>牌面数</th>
	                              <th>货架位置</th>
	                              <th>sku面积</th>
	                            </tr>
	                         <#list goodResults as goodResult>
	                           <#if goodResult.isShow>
	                            <tr>
	                              <td colspan="2">${goodResult.goods_desc}</th>
	                              <td>${goodResult.ratio}</td>
	                              <td>${goodResult.num}</td>
	                              <td>${goodResult.rows!""}</td>
	                               <td>${goodResult.ori_area!""}</td>
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
	   	</div>		
	</section>
 </div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/task_view.js"></script>
<script type="text/javascript">
	$(function() {	
		taskView._init();
	});
</script>
</body>
</html>