var m_url = '/marketing/'
var priceIdentify = priceIdentify || {};
priceIdentify = (function(){
    function init(){
    	$('#upload_file').click(function(){
    		$('#file_select').click();
    	});
    	
    	$('#file_select').change(function(){
    		$("#priceIdentifyResult").html("");
    		
    		var _file = $(this)[0];
    		var files = _file.files;
    		var total = files.length;
    		var url = m_url + 'priceIdentify';
    		
    		var formData = new FormData();
    		for (var i = 0; i < files.length; i++) {
      			var file = files[i];
      			formData.append('image', file, file.name);
    		}
    		var imageUrl = window.URL.createObjectURL($('#file_select')[0].files.item(0));
			$('#preview').attr('src', imageUrl);
			
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
		        	var name ='';
		        	var price = '';
		        	if(resp.name){
		        		name = resp.name;
		        	}
		        	if(resp.price){
		        		price = resp.price;
		        	}
		        	if(!name && !price){
		        		noty({text: "识别价格失败", layout: "topCenter", type: "warning", timeout: 1000});
		        		return;
		        	}
		        	noty({text: "识别价格成功", layout: "topCenter", type: "success", timeout: 1000});
		        	var html = '<td colspan="2">' + name + '</td><td colspan="2">' + price + '</td>';
		        	$("#priceIdentifyResult").html(html);
		        },
		        error: function (message) {
		        	$('#waiting').modal('hide');
		        	noty({text: "识别价格失败", layout: "topCenter", type: "error", timeout: 1000});
		        }
		    });
    		
    	});
     };
	
     return {
          _init:init
     }

})()