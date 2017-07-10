var d_url='/dface';
var dataExport=dataExport || {};
dataExport=(function(){
	function init(){
		initDate();
	};
	function initDate() {
		var current = moment();
		$("#toDate").val(current.format('YYYY-MM-DD HH:mm:ss'));
	    $("#fromDate").val(current.subtract(2, 'days').format('YYYY-MM-DD HH:mm:ss'));

		//时间段显示
		$('.form_datetime1').datetimepicker({
		    language: 'zh-CN',
		    autoclose:true ,
		    endDate : new Date()
		}).on('changeDate',function(e){
		    var d=e.date;  
		    $('.form_datetime2').datetimepicker('setStartDate',d);
        	var end=d.setDate(d.getDate()+2);
        	var end1=new Date();
        	if(end>end1){
        		$('.form_datetime2').datetimepicker('setEndDate',end1);
        	}else{
        		var newdata=moment(d);
        		$("#toDate").val(newdata.format('YYYY-MM-DD HH:mm:ss'));
        		$('.form_datetime2').datetimepicker('setEndDate',d);
        	} 
		});
		$('.form_datetime2').datetimepicker({
		    language: 'zh-CN',
		    autoclose:true, //选择日期后自动关闭
		    startDate:$("#fromDate").val(),
		    endDate : new Date()
		}).on('changeDate',function(e){
		    var d=e.date;  
		    $('.form_datetime1').datetimepicker('setEndDate',d);
		    var end=d.setDate(d.getDate()-2);
		    var newdata=moment(d);
    		$("#fromDate").val(newdata.format('YYYY-MM-DD HH:mm:ss'));
		});
		
	};
	return {
		_init:init
	}
})()