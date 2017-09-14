var m_url = '/marketing/';
var taskMark = taskMark || {};
taskMark = (function(){
	 var picPath = '/pic/marketing';
	 var isCrop = true;
	 var imageIds = [];
     function init(){
 		$("#skuType").select2();
		var order = $("#order").val();
		var imagePath = $("#imageCrop").attr("src");
		initCropper();
		getPictureCrop(imagePath);
        $('#labelBtn').click(function(){
            var skuType = $('#skuType').val();
            if (skuType){
            	imageIds.push($('#imageCrop').attr("imageid"));
            	saveLabelLocally();
            	isCrop = true;
            }else{
                noty({text: "你还没有选择SKU类型", layout: "topCenter", type: "warning", timeout: 3000});
            }
        });
        $('#cancelBtn').click(function(){
        	isCrop = true;
            $('#imageCrop').cropper('deleteCrop');
            $('#imageCrop').cropper('enable');
            $('#labelPanel').hide();
        });
        $('#save').on('click', function(){
        	if(!isCrop){
        		noty({text: '请先进行标注或删除标注', layout: "topCenter", type: "warning", timeout: 1000});
        		return;
        	}
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
            $.ajax({
                url: m_url + 'taskImageCrop/save/' + taskId,
                data: JSON.stringify(data),
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json',
                success: function(json){
                    if(json.success){
                        noty({text: "保存标注数据成功", layout: "topCenter", type: "success", timeout: 3000});
                    }else{
                    	noty({text: "保存标注数据失败", layout: "topCenter", type: "warning", timeout: 3000});
                    }
                },error: function(){
                    noty({text: "请求后台错误", layout: "topCenter", type: "warning", timeout: 3000});
                    return;
                }
            });
        });
     };
     
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
             },
             cropmove: function (e) {
             },
             crop: function (e) {
             }
         });
     };
     
 	function getPre(){
 		if(!isCrop){
     		noty({text: '请先进行标注或删除标注', layout: "topCenter", type: "warning", timeout: 1000});
     		return;
     	}
 		$('#save').click();
 		var taskId = $('#taskId').val();
 		var order = $("#order").val();
 		$.ajax({
      		 type: 'GET',
      		 url: m_url + 'preOrderTaskImage/' + taskId + '/' + order,
      		 success: function(data) {
      			 if(data){
      				$("#initCropImage").attr("src", picPath + "/" + taskId + "/results_" + (order - 2) + ".jpg?random=" + new Date().getTime());
      				$('#imageCrop').attr("imageid", data.id);
      				$("#order").val(data.orderNo);
      				getPictureCrop(picPath + data.imagePath);
      			 }else{
      				noty({text: '当前已经是第一张图片', layout: "topCenter", type: "warning", timeout: 1000});
      			 }
          	},
          	error: function(data) {
          		//返回500错误页面
          		$("html").html(data.responseText);
          	}
      	 });
 	};
 	
 	function getNext(){
 		if(!isCrop){
     		noty({text: '请先进行标注或删除标注', layout: "topCenter", type: "warning", timeout: 1000});
     		return;
     	}
 		$('#save').click();
 		var taskId = $('#taskId').val();
 		var order = $("#order").val();
 		$.ajax({
      		 type: 'GET',
      		 url: m_url + taskId + '/' + order,
      		 success: function(data) {
      			 if(data){
      				$("#initCropImage").attr("src", picPath + "/" + taskId + "/results_" + order + ".jpg?random=" + new Date().getTime());
      				$('#imageCrop').attr("imageid", data.id);
      				$("#order").val(data.orderNo);
      				getPictureCrop(picPath + data.imagePath);
      			 }else{
      				noty({text: '当前已经是最后一张图片', layout: "topCenter", type: "warning", timeout: 1000});
      			 }
          	},
          	error: function(data) {
          		//返回500错误页面
          		$("html").html(data.responseText);
          	}
      	 });
 	};
 	
 	function generateFile(){
 		var imageId = $('#imageCrop').attr("imageid");
 		var cropDatas = $('#imageCrop').cropper('getAllData');
 		var majorType = $("#majorType").val();
 		var taskId = $('#taskId').val();
 		var data ={imageId:imageId, imageCrop:cropDatas, majorType:majorType, taskId:taskId};
 		$.ajax({
      		 url: m_url + 'generateFile',
              data: JSON.stringify(data),
              type: 'POST',
              dataType: 'json',
              contentType: 'application/json',
      		 success: function(data) {
          	},
          	error: function(data) {
          		//返回500错误页面
          		$("html").html(data.responseText);
          	}
      	 });
 	};
 	
 	function getPictureCrop(imagePath){
 		var taskId = $('#taskId').val();
 		var order = $("#order").val();
 		$.ajax({
     		 type: 'GET',
     		 url: m_url + 'taskImageCrops/' + taskId + '/' + order,
     		 success: function(data) {
     			 if(data){
     	     	      $('#imageCrop').off("ready");
     	     	      $('#imageCrop').cropper('replace', imagePath).on("ready", function(){
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
 	};

     function cropEnd(e) {
     	isCrop = false;
     	$(".cropper-view-box").css("cssText", "outline: 2px solid #ea230a !important; outline-color: #ea230a !important;")
         clearLabel();
         var data = $(this).cropper('getCropBoxData');
         $('#skuType').val($("#skuType option[skuorder=" + (parseInt(data.label) - 1) + "]").val()).select2();
         var cropBox = $('.cropper-crop-box[name=' + data.annotationId + ']');
         cropBox.find(".cropper-view-box").css("cssText", "outline: 2px solid #0aeadd !important; outline-color: #0aeadd !important;");
         if($(this).cropper('hasLabel')){
             var label = data.label;
             fillLabel(label);
             $('#labelTxt').val(label.name);
         }else{
             $('#labelTxt').val('');
         }
         $('#labelPanel').show();
     };
     
     function clearLabel(){
         $('#labelList input[type="checkbox"]').prop('checked', false);
         $('#labelList input[type="radio"]').prop('checked', false);
         $('#labelList input[type="text"]').val('');
         $('#labelList .label-item').addClass('closed');
     };
     
     function fillLabel(label){
         $('#label_'+label.id).removeClass('closed');
     };
     
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
     
     return {
          _init:init,
          getPre:getPre,
          getNext:getNext
     }
})()
