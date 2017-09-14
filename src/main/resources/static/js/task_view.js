var m_url='/marketing/';
var taskView=taskView || {};
taskView=(function(){
	 var picPath = '/pic/marketing';
     function init(){
    	 getTaskName();
    	 function showCropList(results){
			html = '<div class="brand-list col-sm-3" >';
			for(var k in results){
				if(results[k].isShow && results[k].num>0){
					html += '<div class="form-group">'+
						    '<span class="icorn-brand"></span>'+
					        '<div class="changeline" produce="'+ k +'"><a href="javascript:void(0);" onclick="taskView.getCrops('+ k +')">'+ results[k].goods_desc + '(' + results[k].num +')</a></div></div>';
				}
			}
			html += '</div>';
			$("#stitch_image .brand-list").remove();
			$("#brandListp").show();
		 	$("#stitch_image").append(html);
		};
		
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
		          				 html+=' <div class="form-group">'+
			               		   ' <img class="icorn-brand"  src="'+m_url+'image/'+ data[i].majorType +'.png">'+
		               		       ' <div class="changeline" produce="'+i+'"><a href="javascript:void(0);" onclick="taskView.getCrops('+ i +')">'+ data[i].description +'</a></div></div>';
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
		};
     };
     
     function getTaskName() {
		var taskName = $("#taskName").val();
		if (!taskName) {
			$("#taskName").val("未命名-" + Date.now());
		}
	};
     
     
	
	function getCrops(produce){
		var taskId = $('#taskId').val();
		$.ajax({
     		 type: 'GET',
     		 url: m_url+taskId+'/crops/'+(produce + 1),
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
          getCrops:getCrops
     }

})()
