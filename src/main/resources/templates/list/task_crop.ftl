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
    <script type="text/javascript" src="${springMacroRequestContext.contextPath}/js/cropper1.js" ></script>
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
   		.cl{clear:both;}
   		.page{
   			margin-bottom:25px;
   		}
	</style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">
	  <section class="content-wrapper" style="margin-left: 0px;">
	   	<div id="content" style="padding-top: 1px;">
			<div class="create_task max_width row">
				<div class="col-sm-8" style='overflow: hidden;width:70%;'>
					<ul>						
						<li>
							<h4>
			                   <img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
			                   <span>任务名</span>
			                   <span id="status" status="<#if task??>${task.taskStatus}<#else>task_init</#if>" style="margin-left:30px;">(当前状态：<#if task??>${task.taskStatus}<#else>task_init</#if>)</span>
			                   <input id="taskName" type="text" <#if task??> value="${task.name}"  readonly= "true" </#if> placeholder="请输入任务名" class="form-control create_task_input">
			                   <input id="taskMajorType" type="hidden" <#if task?? && task.majorType??> value="${task.majorType}" </#if>>
			                   <input id="taskId" type="hidden" value="<#if task??>${task.id}</#if>" />
			                   <input id="order" type="hidden" value="<#if image??>${image.orderNo}</#if>" />
		               		</h4>						
					    </li>
					    <li>
							<h4>
			                   <img class="img_icorn"  src="${springMacroRequestContext.contextPath}/image/icon.png" alt="">
			                   <span>货架照片</span>
			                   <div style="clear:both"></div>
			                   <div class="row" >
				                   <div id="image_default" align="center" class="col-sm-10">
				                   	  <img id="imageCrop" src="/pic/marketing${image.imagePath}"  class="img-thumbnail">
					                  <!-- <img id="imageCrop" src="${springMacroRequestContext.contextPath}/image/3.png"  class="img-thumbnail"> -->
				                   </div>
		               			</div>
               				</h4>								
						</li>
					</ul>						
				</div>
				<div class='col-sm-4' style='margin-top:120px;margin-left:2%;width:27%;'>
					<div class='page'>
						<input type="button" class="btn btn-default" value="上一张" onclick="getPre()">
						<input type="button" class="btn btn-default" value="下一张" onclick="getNext()">
						<input id="save" type="button" class="btn btn-primary" value="保存">			           
					</div>
					<div class='hidden_show'>
					   <div id="labelPanel" class="panel panel-default" style="display:none;max-height: 460px;">
				          <div class="panel-heading">SKU选择</div>
				          <div class="panel-body">
				              <input id="currentPid" type="hidden">
				              <input id="labelTxt" type="hidden" class="form-control" style="margin:0 0 5px 0;" placeholder="请输入标签">
				              <ul id="labelList" class="list-group" style="overflow-y: auto;max-height: 340px;">
								<select id="skuType" style="width:100%;height: 34px;">
									<option value="">请选择类型</option>
										<#if goodsSkus?? && (goodsSkus?size > 0)>
			       							<#list goodsSkus as goodsSku>
			     		 					<option value='${goodsSku.name}' skuorder="${goodsSku.order}">${goodsSku.description}</option>
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
			</div>
	   </div>		
	</section>
</div>
<script type="text/javascript">
    var picPath = '/pic/marketing';
    var wholeCropData;
	$(function() {
		var order = $("#order").val();
		var imagePath = $("#imageCrop").attr("src");
		initCropper();
		getPictureCrop(imagePath);
        $('#labelBtn').click(function(){
            var skuType = $('#skuType').val().trim();
            if (skuType){
            	saveLabelLocally();
            }else{
                noty({text: "你还没有选择SKU类型!", layout: "topCenter", type: "warning", timeout: 3000});
            }
        });
        $('#cancelBtn').click(function(){
            $('#imageCrop').cropper('deleteCrop');
            $('#imageCrop').cropper('enable');
            $('#labelPanel').hide();
        });
        $('#save').on('click', function(){
            var cropDatas = $('#imageCrop').cropper('getAllData');
            var taskId = $('#taskId').val();
            var order = $("#order").val();
            if(cropDatas.length == 0){
                return;
            }
            var data = {
                order : order,
                imageCrop : cropDatas
            }
            console.log(JSON.stringify(data));
            $.ajax({
                url: '${springMacroRequestContext.contextPath}/taskImageCrop/save/' + taskId,
                data: JSON.stringify(data),
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json',
                success: function(json){
                    if(json.success){
                        noty({text: "保存标注数据成功!", layout: "topCenter", type: "success", timeout: 3000});
                    }
                },error: function(){
                    noty({text: "请求后台错误!", layout: "topCenter", type: "warning", timeout: 3000});
                    return;
                }
            });
        });
	});
	
    function initCropper(){
        $('#imageCrop').cropper({
            responsive : false,
            data : {x: 300, y:400, width:100, height:100, rotate:0},
            modal : false,
            guides : false,
            center : false,
            highlight : false,
            background : false,
            autoCrop : false,
            autoCropArea : 0.3,
            movable : true,
            scalable :false,
            zoomable :false,
            zoomOnWheel :false,
            minContainerWidth : 300,
            minContainerHeight : 300,
            cropend: cropEnd
        }).on({
            cropstart: function (e) {
              console.log(e.type, e.action);
            },
            cropmove: function (e) {
              console.log(e.type, e.action);
            },
            crop: function (e) {
              console.log(e.type, e.x, e.y, e.width, e.height, e.rotate, e.scaleX, e.scaleY);
            }
        });
    }
	function getPre(){
		$('#save').click();
		var taskId = $('#taskId').val();
		var order = $("#order").val();
		$.ajax({
     		 type: 'GET',
     		 url: '${springMacroRequestContext.contextPath}/preOrderTaskImage/' + taskId + '/' + order,
     		 success: function(data) {
     			 if(data){
     				$("#order").val(data.orderNo);
     				getPictureCrop(picPath + data.imagePath);
     			 }
         	},
         	error: function(data) {
         		//返回500错误页面
         		$("html").html(data.responseText);
         	}
     	 });
	}
	function getNext(){
		$('#save').click();
		var taskId = $('#taskId').val();
		var order = $("#order").val();
		$.ajax({
     		 type: 'GET',
     		 url: '${springMacroRequestContext.contextPath}/nextOrderTaskImage/' + taskId + '/' + order,
     		 success: function(data) {
     			 if(data){
     				$("#order").val(data.orderNo);
     				getPictureCrop(picPath + data.imagePath);
     			 }
         	},
         	error: function(data) {
         		//返回500错误页面
         		$("html").html(data.responseText);
         	}
     	 });
	}
	function getPictureCrop(imagePath){
		var taskId = $('#taskId').val();
		var order = $("#order").val();
		$.ajax({
    		 type: 'GET',
    		 url: '${springMacroRequestContext.contextPath}/taskImageCrops/' + taskId + '/' + order,
    		 success: function(data) {
    			 if(data){
    	     	        $('#imageCrop').off("ready");
    	     	        $('#imageCrop').cropper('replace', imagePath).on("ready", function(){
    	     	            console.log('replace ready');
    	     	            if(data && data.length > 0){
    	     	                $('#imageCrop').cropper('setAllData', data);
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
    function cropEnd(e) {
        clearLabel();
        var data = $(this).cropper('getCropBoxData');
        wholeCropData = data;
        $('#skuType').val($("#skuType option[skuorder=" + (parseInt(data.label) -1) + "]").val());
        
        if($(this).cropper('hasLabel')){
            var label = data.label;
            fillLabel(label);
            $('#labelTxt').val(label.name);
        }else{
            $('#labelTxt').val('');
        }
        
        $('#labelPanel').show();
    }
    function clearLabel(){
        $('#labelList input[type="checkbox"]').prop('checked', false);
        $('#labelList input[type="radio"]').prop('checked', false);
        $('#labelList input[type="text"]').val('');
        $('#labelList .label-item').addClass('closed');
    }
    function fillLabel(label){
        $('#label_'+label.id).removeClass('closed');
    }
    function saveLabelLocally(){
        getOpenedLabelItem(function(){
            var label = $('#skuType option:checked').attr("skuorder");
            $('#imageCrop').cropper('setLabel', parseInt(label) + 1);
            $('#labelPanel').hide();
            $('#imageCrop').cropper('enable');
        });
    };
    function getOpenedLabelItem(cb){
    	cb();
    };
</script>
</body>
</html>