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
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery-editable-select.min.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/lodash.min.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/moment.min.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/masonry.pkgd.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/bootstrap-select.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/cropper1.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/tunicorn-cloud.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/jquery-ui.js" ></script>
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/select2.full.js" ></script>
    <link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/jquery-editable-select.min.css">
    <link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/bootstrap-select.css">
    <link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/style.css"  type="text/css">
    <link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/cropper.css"  type="text/css">
    <link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/select2.min.css"  type="text/css">
	<link rel="stylesheet" href="${springMacroRequestContext.contextPath}/css/jquery-ui.min.css">
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
   		.img_icorn {max-width: 100%;}
   		.cl{clear:both;}
   		.page{
   			margin-bottom:25px;
   		}
   		.select2-container .select2-selection--single {  
		  height: 36px;  
		  line-height: 36px;  
		}  
	</style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">
	  <section class="content-wrapper" style="margin-left: 0px;">
	   	<div id="content" style="padding-top: 1px;">
			<div class="create_task max_width row">
				<div  style="width:100%;">
					<ul style="margin-top:10px;margin-right:10px;">						
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
			                   <input id="majorType" type="hidden" value="<#if task?? && task.majorType??>${task.majorType}</#if>" />
			                   <input id="order" type="hidden" value="<#if image??>${image.orderNo}</#if>" />
		               		</h4>								
					    </li>
					    <div class='cl'></div>					    
					    <li>
							<h4>
			                   <img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
			                   <span>货架照片</span>
			                   <div style="clear:both"></div>
               				</h4>              				                			               			 
							 <div id="image_default" align="center" class="col-sm-7">
			                   	  <img id="imageCrop" src="/pic/marketing${image.imagePath}" imageid="${image.id}"  class="img-thumbnail"> 
				                  <!-- <img id="imageCrop"  src="${springMacroRequestContext.contextPath}/image/3.jpeg"  class="img-thumbnail"> -->
			                 </div>
			                 <div class="col-sm-5">
				                 <div class='page' >
									<input type="button" class="btn btn-default" value="上一张" onclick="getPre()">
									<input type="button" class="btn btn-default" value="下一张" onclick="getNext()">
									<input id="save" type="button" class="btn btn-primary" value="保存">			           
								 </div>
								 <div class='hidden_show' >
								   <div id="labelPanel" class="panel panel-default" style="display:none;max-height: 460px;">
							          <div class="panel-heading">SKU选择</div>
							          <div class="panel-body">
							              <input id="currentPid" type="hidden">
							              <input id="labelTxt" type="hidden" class="form-control" style="margin:0 0 5px 0;" placeholder="请输入标签">
							              <ul id="labelList" class="list-group" style="max-height: 340px;">
											<select id="skuType" style="width:100%;height: 45px;" class="js-example-basic-single">
												<option value="" style="height:45px;">请选择类型</option>
													 <#if goodsSkus?? && (goodsSkus?size > 0)>
						       							<#list goodsSkus as goodsSku>
						     		 					<option value='${goodsSku.name}' skuorder="${goodsSku.order}">${goodsSku.order + 1} ${goodsSku.description}</option>
						    							</#list>
					   								</#if> 
											</select>
							              </ul>
							              <input type="button" class="btn btn-success" id="labelBtn" value="确定">
							              <input type="button" class="btn btn-danger" id="cancelBtn" value="删除">
							          </div>
							       </div>
								</div>
							</div>			        									
						</li>
					</ul>						
				</div>
			</div>
	   </div>		
	</section>
</div>
<script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/task_mark.js"></script>
<script type="text/javascript">
	$(function() {	
		taskMark._init();
	});
</script>
</body>
</html>